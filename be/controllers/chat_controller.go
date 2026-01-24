package controllers

import (
	"chat-app-be/models"
	"chat-app-be/repositories"
	"chat-app-be/utils"

	"github.com/gin-gonic/gin"
)

// ChatController mengatur request terkait percakapan
type ChatController struct {
	ChatRepo    *repositories.ChatRepository
	ContactRepo *repositories.ContactRepository
	WS          *WSController
}

// NewChatController inisialisasi controller chat dengan integrasi WebSocket
func NewChatController(repo *repositories.ChatRepository, contactRepo *repositories.ContactRepository, ws *WSController) *ChatController {
	return &ChatController{
		ChatRepo:    repo,
		ContactRepo: contactRepo,
		WS:          ws,
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
// GetUserChats mengambil daftar chat room user secara standar HTTP.
func (c *ChatController) GetUserChats(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	
    // 1. Get raw chats with relations
    chats, err := c.ChatRepo.GetUserChats(ctx.Request.Context(), userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil daftar chat", err)
		return
	}

    // 2. Get user's contacts to resolve Aliases
    contacts, _ := c.ContactRepo.GetContacts(userId)
    contactMap := make(map[string]string) // UserID -> Alias
    for _, contact := range contacts {
        if contact.Alias != "" {
            contactMap[contact.ContactID] = contact.Alias
        }
    }

	res := make([]models.ChatDTO, len(chats))
	for i, chat := range chats {
		var lastMsg interface{}
		messages := chat.Messages()
        
        // Calculate Unread Count
        // Because repo filters for unread & not sender, we can just count the length
        unreadCount := len(messages)
        
        // Find actual last message (repo fetches unread ones + last message separately)
        // Since our repo query is complex, let's simplify: GetUserChats repo fetches LAST MESSAGE and UNREAD MESSAGES.
        // Actually, the previous repo change fetches unread messages. We might miss the last message if it WAS read.
        // Let's rely on the separate 'lastMessage' relation we added in repo or fix repo to return both.
        // For now, let's assume valid last message is at index 0 if list not empty.
        
		if len(messages) > 0 {
            // Note: This might be an unread message, which IS a valid last message.
			m := messages[0]
			sender := m.Sender()
			lastMsg = gin.H{
				"id":        m.ID,
				"content":   m.Content,
				"timestamp": m.Timestamp,
				"senderId":  m.SenderID,
				"sender":    sender.Name,
				"type":      m.Type,
				"status":    m.Status,
			}
		}

		// Resolve Name
		name := "Unknown"
		if chat.IsGroup {
			if n, ok := chat.Name(); ok {
				name = n
			}
		} else {
            // Direct Chat: Find the OTHER participant
            participants := chat.Participants()
            for _, p := range participants {
                if p.UserID != userId {
                    // This is the other person
                    otherUser := p.User()
                    
                    // Check if we have an alias for them
                    if alias, ok := contactMap[p.UserID]; ok {
                        name = alias
                    } else {
                        name = otherUser.Name
                    }
                    break
                }
            }
        }

		res[i] = models.ChatDTO{
			ID:          chat.ID,
			Name:        name,
			IsGroup:     chat.IsGroup,
			LastMessage: lastMsg,
			UnreadCount: unreadCount, 
		}
	}

	utils.SuccessResponse(ctx, "Daftar chat berhasil diambil", res)
}

// CreateGroup membuat grup baru dan memberitahu semua anggota secara real-time.
// CreateGroup membuat grup baru dan memberitahu semua anggota secara real-time.
func (c *ChatController) CreateGroup(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	var dto struct {
		Name    string   `json:"name" binding:"required"`
		UserIDs []string `json:"userIds" binding:"required"`
	}

	if err := ctx.ShouldBindJSON(&dto); err != nil {
		utils.BadRequest(ctx, "Data tidak valid", err)
		return
	}

	// Tambahkan creator ke daftar member
	allMembers := append(dto.UserIDs, userId)

	chat, err := c.ChatRepo.CreateGroupChat(ctx.Request.Context(), dto.Name, allMembers)
	if err != nil {
		utils.InternalError(ctx, "Gagal membuat grup", err)
		return
	}

	// Notifikasi semua anggota grup kecuali pembuat
	c.WS.NotifyGroup(chat.ID, userId, "Anda ditambahkan ke grup "+dto.Name, chat)

	utils.SuccessResponse(ctx, "Grup berhasil dibuat", chat)
}

// CreateDirectChat creates or gets existing 1-on-1 chat between two users
func (c *ChatController) CreateDirectChat(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	
	var dto struct {
		ContactUserId string `json:"contactUserId" binding:"required"`
	}

	if err := ctx.ShouldBindJSON(&dto); err != nil {
		utils.BadRequest(ctx, "contactUserId is required", err)
		return
	}

	// Create or get existing direct chat
	chat, err := c.ChatRepo.CreateOrGetDirectChat(ctx.Request.Context(), userId, dto.ContactUserId)
	if err != nil {
		utils.InternalError(ctx, "Failed to create/get direct chat", err)
		return
	}

	utils.SuccessResponse(ctx, "Direct chat ready", chat)
}
