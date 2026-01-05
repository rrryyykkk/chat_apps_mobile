package controllers

import (
	"chat-app-be/repositories"
	"chat-app-be/utils"

	"github.com/gin-gonic/gin"
)

// ChatController mengatur request terkait percakapan
type ChatController struct {
	ChatRepo *repositories.ChatRepository
	WS       *WSController
}

// NewChatController inisialisasi controller chat dengan integrasi WebSocket
func NewChatController(repo *repositories.ChatRepository, ws *WSController) *ChatController {
	return &ChatController{
		ChatRepo: repo,
		WS:       ws,
	}
}

// GetMessages mengambil list pesan berdasarkan ID chat room secara standar HTTP.
func (c *ChatController) GetMessages(ctx *gin.Context) {
	chatId := ctx.Param("id")
	messages, err := c.ChatRepo.GetChatMessages(ctx.Request.Context(), chatId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil pesan", err)
		return
	}
	utils.SuccessResponse(ctx, "Pesan ditemukan", messages)
}

// GetUserChats mengambil daftar chat room user secara standar HTTP.
func (c *ChatController) GetUserChats(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	chats, err := c.ChatRepo.GetUserChats(ctx.Request.Context(), userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil daftar chat", err)
		return
	}

	// ... (kode transformasi data tetap sama)
	type ChatResponse struct {
		ID            string      `json:"id"`
		Name          string      `json:"name"`
		IsGroup       bool        `json:"isGroup"`
		LastMessage   interface{} `json:"lastMessage"`
		UnreadCount   int         `json:"unreadCount"`
		Participants  interface{} `json:"participants,omitempty"`
	}

	res := make([]ChatResponse, len(chats))
	for i, chat := range chats {
		var lastMsg interface{}
		messages := chat.Messages()
		if len(messages) > 0 {
			m := messages[0]
			sender := m.Sender()
			lastMsg = gin.H{
				"content":   m.Content,
				"timestamp": m.Timestamp,
				"sender":    sender.Name,
			}
		}

		name := ""
		if n, ok := chat.Name(); ok {
			name = n
		}

		res[i] = ChatResponse{
			ID:          chat.ID,
			Name:        name,
			IsGroup:     chat.IsGroup,
			LastMessage: lastMsg,
			UnreadCount: 0,
		}
	}

	utils.SuccessResponse(ctx, "Daftar chat berhasil diambil", res)
}

// CreateGroup membuat grup baru dan memberitahu semua anggota secara real-time.
func (c *ChatController) CreateGroup(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	var input struct {
		Name    string   `json:"name" binding:"required"`
		UserIDs []string `json:"userIds" binding:"required"`
	}

	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// Sertakan pembuat grup ke dalam UserIDs jika belum ada
	found := false
	for _, id := range input.UserIDs {
		if id == userId {
			found = true
			break
		}
	}
	if !found {
		input.UserIDs = append(input.UserIDs, userId)
	}

	group, err := c.ChatRepo.CreateGroup(ctx.Request.Context(), input.Name, input.UserIDs)
	if err != nil {
		utils.InternalError(ctx, "Gagal membuat grup", err)
		return
	}

	// Beritahu anggota grup yang sedang online via WebSocket
	if c.WS != nil {
		go c.WS.NotifyGroup(group.ID, userId, "Anda ditambahkan ke grup baru: "+input.Name, group)
	}

	utils.CreatedResponse(ctx, "Grup berhasil dibuat", group)
}
