package routes

import (
	"chat-app-be/controllers"

	"github.com/gin-gonic/gin"
)

// StatusRoutes untuk fitur Story/Status
func StatusRoutes(r *gin.RouterGroup, ctrl *controllers.StatusController) {
	status := r.Group("/status")
	{
		status.GET("/", ctrl.GetStatuses)
		status.POST("/", ctrl.CreateStatus)

		status.POST("/:id/like", ctrl.ToggleLike)
		status.POST("/:id/view", ctrl.ViewStatus)
		status.GET("/:id/viewers", ctrl.GetViewers)
		status.POST("/:id/reply", ctrl.ReplyStatus)
	}
}
