package routes

import (
	"chat-app-be/controllers"

	"github.com/gin-gonic/gin"
)

// MediaRoutes untuk fitur Upload File
func MediaRoutes(r *gin.RouterGroup, ctrl *controllers.MediaController) {
	media := r.Group("/media")
	{
		media.POST("/upload", ctrl.Upload)
	}
}
