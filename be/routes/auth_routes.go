package routes

import (
	"chat-app-be/controllers"

	"github.com/gin-gonic/gin"
)

// AuthRoutes memisahkan jalur API khusus untuk Autentikasi
func AuthRoutes(r *gin.RouterGroup, authCtrl *controllers.AuthController) {
	authGroup := r.Group("/auth")
	{
		authGroup.POST("/register", authCtrl.Register)
		authGroup.POST("/login", authCtrl.Login)
		authGroup.POST("/forgot-password", authCtrl.ForgotPassword)
		authGroup.POST("/reset-password", authCtrl.ResetPassword)
	}
}
