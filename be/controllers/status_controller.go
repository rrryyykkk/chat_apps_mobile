package controllers

import (
	"chat-app-be/models"
	"chat-app-be/prisma/db"
	"chat-app-be/repositories"
	"chat-app-be/utils"
	"fmt"

	"github.com/gin-gonic/gin"
)

// StatusController menangani logic status/story
type StatusController struct {
	StatusRepo *repositories.StatusRepository
    ChatRepo   *repositories.ChatRepository
	WS         *WSController
}

// NewStatusController inisialisasi status controller
func NewStatusController(repo *repositories.StatusRepository, chatRepo *repositories.ChatRepository, ws *WSController) *StatusController {
	return &StatusController{
		StatusRepo: repo,
        ChatRepo:   chatRepo,
		WS:         ws,
	}
}

// CreateStatus mengunggah status baru dan memberitahu kawan secara real-time.
func (c *StatusController) CreateStatus(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	userName := ctx.GetString("userName") // Ambil nama dari context (diset oleh middleware)
	
	var input models.StatusDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	status, err := c.StatusRepo.CreateStatus(ctx.Request.Context(), userId, input.MediaUrl, input.Caption, input.Content, input.Color, db.MediaType(input.Type))
	if err != nil {
		utils.InternalError(ctx, "Gagal membuat status", err)
		return
	}

	// Kirim notifikasi real-time via WebSocket jika tersedia
	if c.WS != nil {
		go c.WS.NotifyStatusUpdate(userName, status)
	}

	utils.SuccessResponse(ctx, "Status berhasil dibuat", status)
}

// GetStatuses mengambil semua status aktif teman (Updated for filters)
func (c *StatusController) GetStatuses(ctx *gin.Context) {
	userId := ctx.GetString("userID")
	statuses, err := c.StatusRepo.GetActiveStatuses(ctx.Request.Context(), userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil status", err)
		return
	}
	
	// Transform ke DTO
	var res []models.StatusDTO
	for _, s := range statuses {
		var userResp models.UserResponse
		statusOwner := s.User()
		userResp = models.UserResponse{
			ID:        statusOwner.ID,
			Name:      statusOwner.Name,
			Email:     statusOwner.Email,
		}
		if v, ok := statusOwner.AvatarURL(); ok {
			userResp.AvatarUrl = v
		}

		// Hitung likes & viewers
		likes := s.Likes()
		viewers := s.Viewers()

		isLiked := false
		for _, l := range likes {
			if l.UserID == userId {
				isLiked = true
				break
			}
		}

		res = append(res, models.StatusDTO{
			ID:              s.ID,
			UserID:          s.UserID,
			User:            userResp,
			Type:            string(s.Type),
			MediaUrl:        getOptionalString(s.MediaURL),
			Caption:         getOptionalString(s.Caption),
			Content:         getOptionalString(s.Content),
			Color:           getOptionalString(s.BackgroundColor),
			Timestamp:       s.CreatedAt,
			ExpiresAt:       s.ExpiresAt,
			LikeCount:       len(likes),
			ViewerCount:     len(viewers),
			IsLiked:         isLiked,
			IsViewed:        false, // Simplifikasi
		})
	}
	utils.SuccessResponse(ctx, "Daftar status ditemukan", res)
}

func getOptionalString(val (func() (string, bool))) string {
	if v, ok := val(); ok {
		return v
	}
	return ""
}


// ToggleLike untuk like/unlike status dan memberi notifikasi ke pemilik status.
func (c *StatusController) ToggleLike(ctx *gin.Context) {
	statusId := ctx.Param("id")
	userId := ctx.GetString("userID")
	userName := ctx.GetString("userName")

	liked, err := c.StatusRepo.ToggleLike(ctx.Request.Context(), statusId, userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal memproses like", err)
		return
	}

	// Jika di-like, beri tahu pemilik status secara real-time
	if liked && c.WS != nil {
		// Ambil data status untuk tahu siapa pemiliknya
		status, _ := c.StatusRepo.Client.Status.FindUnique(
			db.Status.ID.Equals(statusId),
		).Exec(ctx.Request.Context())

		if status != nil && status.UserID != userId {
			msg := userName + " menyukai status Anda"
			go c.WS.NotifyUser(status.UserID, "like", msg, status)
		}
	}

	msg := "Berhasil like status"
	if !liked {
		msg = "Berhasil unlike status"
	}
	utils.SuccessResponse(ctx, msg, map[string]bool{"liked": liked})
}

// ViewStatus mencatat user melihat status
func (c *StatusController) ViewStatus(ctx *gin.Context) {
	statusId := ctx.Param("id")
	userId := ctx.GetString("userID")

	err := c.StatusRepo.AddView(ctx.Request.Context(), statusId, userId)
	if err != nil {
		// Just log or ignore if duplicate
	}
	utils.SuccessResponse(ctx, "Status dilihat", nil)
}

// GetViewers mengambil daftar viewers status
func (c *StatusController) GetViewers(ctx *gin.Context) {
	statusId := ctx.Param("id")
	viewers, err := c.StatusRepo.GetStatusViewers(ctx.Request.Context(), statusId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil viewers", err)
		return
	}
	utils.SuccessResponse(ctx, "Daftar viewers", viewers)
}

// ReplyStatus menangani balasan status secara real-time.
func (c *StatusController) ReplyStatus(ctx *gin.Context) {
	statusId := ctx.Param("id")
	userId := ctx.GetString("userID")
	userName := ctx.GetString("userName")

	var input struct {
		Content string `json:"content" binding:"required"`
	}
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// 1. Dapatkan data status target
	status, _ := c.StatusRepo.Client.Status.FindUnique(
		db.Status.ID.Equals(statusId),
	).Exec(ctx.Request.Context())

	if status == nil {
		utils.BadRequest(ctx, "Status tidak ditemukan", nil)
		return
	}

    if status.UserID == userId {
        utils.BadRequest(ctx, "Tidak bisa membalas status sendiri", nil)
        return
    }

    // 2. Buat/Dapatkan Chat Direct antara Pengirim (userId) dan Pemilik Status (status.UserID)
    chat, err := c.ChatRepo.CreateOrGetDirectChat(ctx.Request.Context(), userId, status.UserID)
    if err != nil {
        utils.InternalError(ctx, "Gagal membuat chat", err)
        return
    }

    // 3. Buat Pesan di Chat tersebut dengan format reply
    replyContent := fmt.Sprintf("Replying to your status: %s", input.Content)
    
    msg, err := c.ChatRepo.CreateMessage(ctx.Request.Context(), userId, chat.ID, replyContent, db.MessageTypeText)
    if err != nil {
        utils.InternalError(ctx, "Gagal mengirim pesan", err)
        return
    }

	// 4. Kirim notifikasi real-time CHAT
	if c.WS != nil {
		c.WS.NotifyUser(status.UserID, "chat", "New message from "+userName, msg)
        c.WS.NotifyUser(userId, "chat", "", msg)
	}

	utils.SuccessResponse(ctx, "Reply berhasil dikirim", msg)
}
