package controllers

import (
	"chat-app-be/prisma/db"
	"chat-app-be/repositories"
	"chat-app-be/utils"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/gorilla/websocket"
)

// Upgrader digunakan untuk mengubah koneksi HTTP menjadi WebSocket.
// CheckOrigin diset true untuk memudahkan development.
var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

// Client mewakili satu user yang sedang terhubung via WebSocket.
type Client struct {
	UserID string
	Conn   *websocket.Conn
	Send   chan []byte
}

// WSMessage adalah struktur pesan yang dikirim/diterima via WebSocket.
type WSMessage struct {
	Type    string      `json:"type"`    // Jenis pesan: "chat", "status_update", dll.
	ChatID  string      `json:"chatId"`  // ID tujuan (untuk chat)
	Content string      `json:"content"` // Isi pesan
	Data    interface{} `json:"data"`    // Data tambahan (opsional)
}

// WSController mengelola semua koneksi WebSocket yang aktif dan integrasi database.
type WSController struct {
	Clients  map[string]*Client
	ChatRepo *repositories.ChatRepository
	mu       sync.Mutex
}

// NewWSController inisialisasi controller dengan repository chat.
func NewWSController(chatRepo *repositories.ChatRepository) *WSController {
	return &WSController{
		Clients:  make(map[string]*Client),
		ChatRepo: chatRepo,
	}
}

// HandleWS adalah endpoint utama untuk upgrade koneksi ke WebSocket dengan validasi token.
func (ctrl *WSController) HandleWS(ctx *gin.Context) {
	userId := ctx.Query("userId")
	tokenString := ctx.Query("token")

	if userId == "" || tokenString == "" {
		utils.BadRequest(ctx, "userId dan token wajib ada untuk koneksi WebSocket", nil)
		return
	}

	// 1. Validasi Token JWT secara manual (karena WebSocket handshake sering di luar middleware standar)
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("metode signing tidak valid")
		}
		return []byte(os.Getenv("JWT_SECRET")), nil
	})

	if err != nil || !token.Valid {
		utils.Unauthorized(ctx, "Token tidak valid")
		return
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || claims["sub"] != userId {
		utils.Unauthorized(ctx, "Token tidak sesuai dengan UserID")
		return
	}

	// 2. Upgrade ke WebSocket
	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		log.Println("Gagal upgrade ke WS:", err)
		return
	}

	client := &Client{
		UserID: userId,
		Conn:   conn,
		Send:   make(chan []byte, 256),
	}

	ctrl.mu.Lock()
	ctrl.Clients[userId] = client
	ctrl.mu.Unlock()

	log.Printf("[WS] User %s terhubung dengan aman", userId)

	// Jalankan goroutine untuk baca dan tulis pesan secara konkuren
	go client.writePump()
	go client.readPump(ctrl)
}

// readPump mendengarkan pesan masuk dari client.
func (c *Client) readPump(ctrl *WSController) {
	defer func() {
		ctrl.mu.Lock()
		delete(ctrl.Clients, c.UserID)
		ctrl.mu.Unlock()
		c.Conn.Close()
		log.Printf("[WS] User %s terputus", c.UserID)
	}()

	for {
		_, rawMsg, err := c.Conn.ReadMessage()
		if err != nil {
			break
		}

		var msg WSMessage
		if err := json.Unmarshal(rawMsg, &msg); err != nil {
			log.Println("[WS] Format pesan tidak valid:", err)
			continue
		}

		// Routing logika berdasarkan tipe pesan
		switch msg.Type {
		case "chat":
			ctrl.handleChatMessage(c.UserID, msg)
		case "read_receipt":
			ctrl.handleReadReceipt(c.UserID, msg)
		default:
			log.Printf("[WS] Tipe pesan tidak dikenal: %s", msg.Type)
		}
	}
}

// writePump mengirim pesan dari channel 'Send' ke koneksi WebSocket fisik.
func (c *Client) writePump() {
	defer c.Conn.Close()
	for message := range c.Send {
		err := c.Conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			break
		}
	}
}

// handleChatMessage menyimpan pesan ke DB dan mengirimkannya ke peserta lain yang online.
func (ctrl *WSController) handleChatMessage(senderID string, msg WSMessage) {
	// 1. Simpan pesan ke database secara permanen
	newMsg, err := ctrl.ChatRepo.CreateMessage(context.Background(), senderID, msg.ChatID, msg.Content, db.MessageTypeText)
	if err != nil {
		log.Println("[WS] Gagal simpan pesan ke DB:", err)
		return
	}

	// 2. Siapkan payload untuk dikirim ke peserta chat (Event Real-time Chat)
	payloadChat, _ := json.Marshal(WSMessage{
		Type:    "chat",
		ChatID:  msg.ChatID,
		Content: msg.Content,
		Data:    newMsg,
	})

	// 3. Siapkan payload untuk Notifikasi Real-time
	payloadNotif, _ := json.Marshal(WSMessage{
		Type:    "notification",
		ChatID:  msg.ChatID,
		Content: "Pesan baru: " + msg.Content,
		Data:    newMsg,
	})

	// 4. Ambil daftar peserta chat dari DB
	participants, _ := ctrl.ChatRepo.Client.Participant.FindMany(
		db.Participant.ChatID.Equals(msg.ChatID),
	).Exec(context.Background())

	// 5. Kirim ke semua peserta yang online
	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	for _, p := range participants {
		if client, ok := ctrl.Clients[p.UserID]; ok {
			// Kirim data chat utama
			client.Send <- payloadChat
			
			// Jika bukan pengirim, kirim juga notifikasi
			if p.UserID != senderID {
				client.Send <- payloadNotif
			}
		}
	}
}

// handleReadReceipt memproses status pesan yang telah dibaca oleh penerima.
func (ctrl *WSController) handleReadReceipt(_ string, msg WSMessage) {
	messageID, ok := msg.Data.(string)
	if !ok {
		log.Println("[WS] ID pesan tidak valid dalam read_receipt")
		return
	}

	// 1. Update status di database menjadi READ
	updatedMsg, err := ctrl.ChatRepo.UpdateMessageStatus(context.Background(), messageID, db.MessageStatusRead)
	if err != nil {
		log.Println("[WS] Gagal update status READ di DB:", err)
		return
	}

	// 2. Beritahu pengirim pesan bahwa pesan mereka sudah dibaca (Centang Biru)
	payload, _ := json.Marshal(WSMessage{
		Type:    "status_update",
		ChatID:  msg.ChatID,
		Content: "Pesan telah dibaca",
		Data:    updatedMsg,
	})

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	if client, ok := ctrl.Clients[updatedMsg.SenderID]; ok {
		client.Send <- payload
	}
}

// NotifyStatusUpdate memberitahu semua user yang online tentang status baru (Global Notification).
func (ctrl *WSController) NotifyStatusUpdate(ownerName string, statusData interface{}) {
	payload, _ := json.Marshal(WSMessage{
		Type:    "status_update",
		Content: ownerName + " baru saja mengunggah status baru!",
		Data:    statusData,
	})

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	for _, client := range ctrl.Clients {
		select {
		case client.Send <- payload:
		default:
			log.Printf("[WS] Gagal kirim notif status ke %s (buf penuh)", client.UserID)
		}
	}
}

// NotifyUser mengirimkan notifikasi spesifik ke satu user (User-to-User Notification).
func (ctrl *WSController) NotifyUser(targetUserID string, subType string, message string, data interface{}) {
	payload, _ := json.Marshal(WSMessage{
		Type:    "notification",
		Content: message,
		Data:    data,
	})

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	if client, ok := ctrl.Clients[targetUserID]; ok {
		select {
		case client.Send <- payload:
		default:
			log.Printf("[WS] Gagal kirim notif ke %s (buf penuh)", targetUserID)
		}
	}
}

// NotifyGroup memberitahu semua anggota grup kecuali pengirim (Group Event Notification).
func (ctrl *WSController) NotifyGroup(chatID string, excludeUserID string, message string, data interface{}) {
	// Ambil daftar peserta chat dari DB
	participants, _ := ctrl.ChatRepo.Client.Participant.FindMany(
		db.Participant.ChatID.Equals(chatID),
	).Exec(context.Background())

	payload, _ := json.Marshal(WSMessage{
		Type:    "notification",
		Content: message,
		Data:    data,
	})

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	for _, p := range participants {
		// Jangan kirim ke diri sendiri jika sedang aktif di thread ini
		if p.UserID == excludeUserID {
			continue
		}
		if client, ok := ctrl.Clients[p.UserID]; ok {
			select {
			case client.Send <- payload:
			default:
			}
		}
	}
}
