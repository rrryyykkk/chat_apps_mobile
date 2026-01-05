package controllers

import (
	"chat-app-be/models"
	"chat-app-be/prisma/db"
	"chat-app-be/repositories"
	"chat-app-be/utils"

	"github.com/gin-gonic/gin"
)

type StatusController struct {
	Repo *repositories.StatusRepository
	WS   *WSController
}

func NewStatusController(repo *repositories.StatusRepository, ws *WSController) *StatusController {
	return &StatusController{
		Repo: repo,
		WS:   ws,
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

	status, err := c.Repo.CreateStatus(ctx.Request.Context(), userId, input.MediaUrl, input.Caption, db.MediaType(input.Type))
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
	oldest := ctx.Query("oldest") == "true"
	statuses, err := c.Repo.GetStatusesWithFilter(ctx.Request.Context(), oldest)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil daftar status", err)
		return
	}
	utils.SuccessResponse(ctx, "Daftar status ditemukan", statuses)
}

// ToggleLike untuk like/unlike status dan memberi notifikasi ke pemilik status.
func (c *StatusController) ToggleLike(ctx *gin.Context) {
	statusId := ctx.Param("id")
	userId := ctx.GetString("userID")
	userName := ctx.GetString("userName")

	liked, err := c.Repo.ToggleLike(ctx.Request.Context(), statusId, userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal memproses like", err)
		return
	}

	// Jika di-like, beri tahu pemilik status secara real-time
	if liked && c.WS != nil {
		// Ambil data status untuk tahu siapa pemiliknya
		status, _ := c.Repo.Client.Status.FindUnique(
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

	err := c.Repo.AddView(ctx.Request.Context(), statusId, userId)
	if err != nil {
		// Just log or ignore if duplicate
	}
	utils.SuccessResponse(ctx, "Status dilihat", nil)
}

// GetViewers mengambil daftar viewers status
func (c *StatusController) GetViewers(ctx *gin.Context) {
	statusId := ctx.Param("id")
	viewers, err := c.Repo.GetStatusViewers(ctx.Request.Context(), statusId)
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
	status, _ := c.Repo.Client.Status.FindUnique(
		db.Status.ID.Equals(statusId),
	).Exec(ctx.Request.Context())

	if status == nil {
		utils.BadRequest(ctx, "Status tidak ditemukan", nil)
		return
	}

	// 2. Kirim notifikasi real-time ke pemilik status
	if c.WS != nil && status.UserID != userId {
		msg := userName + " membalas status Anda: " + input.Content
		go c.WS.NotifyUser(status.UserID, "reply", msg, map[string]interface{}{
			"statusId": statusId,
			"content":  input.Content,
		})
	}

	utils.SuccessResponse(ctx, "Reply berhasil dikirim", nil)
}
