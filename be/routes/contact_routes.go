package routes

import (
	"chat-app-be/controllers"
	"chat-app-be/middleware"
	"chat-app-be/repositories"

	"github.com/gin-gonic/gin"
)

func RegisterContactRoutes(router *gin.RouterGroup, contactRepo *repositories.ContactRepository) {
	contactController := controllers.NewContactController(contactRepo)

	contactGroup := router.Group("/contacts")
	contactGroup.Use(middleware.AuthMiddleware()) // Wajib Login
	{
		contactGroup.POST("/add", contactController.AddContact)
		contactGroup.GET("/", contactController.GetContacts)
	}
}
