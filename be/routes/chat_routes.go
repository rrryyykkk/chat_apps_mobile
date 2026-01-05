package routes

import (
	"chat-app-be/controllers"

	"github.com/gin-gonic/gin"
)

// ChatRoutes memisahkan jalur API khusus untuk fitur Chat
func ChatRoutes(r *gin.RouterGroup, chatCtrl *controllers.ChatController) {
	chatGroup := r.Group("/chats")
	{
		chatGroup.GET("/", chatCtrl.GetUserChats)
		chatGroup.GET("/:id/messages", chatCtrl.GetMessages)
		chatGroup.POST("/groups", chatCtrl.CreateGroup)
	}
}
