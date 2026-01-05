package controllers

import (
	"chat-app-be/config"
	"chat-app-be/utils"

	"github.com/gin-gonic/gin"
)

type MediaController struct{}

func NewMediaController() *MediaController {
	return &MediaController{}
}

// Upload menangani upload file tunggal ke Cloudinary
func (c *MediaController) Upload(ctx *gin.Context) {
	file, err := ctx.FormFile("file")
	if err != nil {
		utils.BadRequest(ctx, "File tidak ditemukan", err)
		return
	}

	// Buka file
	src, err := file.Open()
	if err != nil {
		utils.InternalError(ctx, "Gagal membuka file", err)
		return
	}
	defer src.Close()

	// Upload ke Cloudinary (config.UploadFile sudah support auto-detect type)
	url, err := config.UploadFile(ctx.Request.Context(), src)
	if err != nil {
		utils.InternalError(ctx, "Gagal upload ke cloud", err)
		return
	}

	utils.SuccessResponse(ctx, "Upload berhasil", gin.H{"url": url})
}
