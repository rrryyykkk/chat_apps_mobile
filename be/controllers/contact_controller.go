package controllers

import (
	"chat-app-be/models"
	"chat-app-be/repositories"
	"chat-app-be/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ContactController struct {
	contactRepo *repositories.ContactRepository
}

func NewContactController(contactRepo *repositories.ContactRepository) *ContactController {
	return &ContactController{contactRepo: contactRepo}
}

func (c *ContactController) AddContact(ctx *gin.Context) {
	userId := ctx.GetString("userID") // Dari Middleware Auth
	var dto models.AddContactDTO

	if err := ctx.ShouldBindJSON(&dto); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	contact, err := c.contactRepo.AddContact(userId, dto.Email, dto.Alias)
	if err != nil {
		utils.InternalError(ctx, "Gagal menambahkan kontak", err)
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"message": "Kontak berhasil ditambahkan",
		"data":    contact,
	})
}

func (c *ContactController) GetContacts(ctx *gin.Context) {
	userId := ctx.GetString("userID")

	contacts, err := c.contactRepo.GetContacts(userId)
	if err != nil {
		utils.InternalError(ctx, "Gagal mengambil kontak", err)
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"data": contacts,
	})
}
