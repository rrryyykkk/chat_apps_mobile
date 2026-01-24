package main

import (
	"chat-app-be/config"
	"chat-app-be/controllers"
	"chat-app-be/middleware"
	"chat-app-be/repositories"
	"chat-app-be/routes"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// 1. Load Configurations
	if err := godotenv.Load(); err != nil {
		log.Println("Peringatan: File .env tidak ditemukan")
	}

	// 2. Connect to Database & Cloudinary
	config.InitDB()
	defer config.CloseDB()
	config.InitCloudinary()

	// 3. Initialize Engine with Security Middlewares
	r := gin.New() // Kita pakai New() agar kita kontrol penuh middleware-nya
	
	// Tambahkan Global Try-Catch (Recovery) paling atas
	r.Use(middleware.GlobalTryCatch())
	r.Use(gin.Logger()) // Logger standar untuk pantau request masuk
	
	// Tambahkan middleware standar keamanan
	r.Use(middleware.RateLimiter())
	r.Use(middleware.CORSMiddleware())
	r.Use(middleware.SecurityHeaders())

	// 4. Repositories
	userRepo := repositories.NewUserRepository(config.PkgClient)
	chatRepo := repositories.NewChatRepository(config.PkgClient)
	statusRepo := repositories.NewStatusRepository(config.PkgClient)
	searchRepo := repositories.NewSearchRepository(config.PkgClient)
	contactRepo := repositories.NewContactRepository(config.PkgClient)

	// 5. Controllers
	wsCtrl := controllers.NewWSController(chatRepo)
	authCtrl := controllers.NewAuthController(userRepo)
	chatCtrl := controllers.NewChatController(chatRepo, contactRepo, wsCtrl)
	statusCtrl := controllers.NewStatusController(statusRepo, chatRepo, wsCtrl)
	mediaCtrl := controllers.NewMediaController()
	searchCtrl := controllers.NewSearchController(searchRepo)

	// 6. API Routes
	api := r.Group("/api")
	{
		// Public Routes
		routes.AuthRoutes(api, authCtrl)

		// Protected Routes (Butuh Token)
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware())
		{
			routes.ChatRoutes(protected, chatCtrl)
			routes.StatusRoutes(protected, statusCtrl)
			routes.MediaRoutes(protected, mediaCtrl)
			
			// Global Search Route
			protected.GET("/search", searchCtrl.HandleSearch)
			
			// Contact Routes (New)
			routes.RegisterContactRoutes(protected, contactRepo)
		}
	}

	// WebSocket Endpoint (Real-time)
	r.GET("/ws", wsCtrl.HandleWS)

	port := os.Getenv("PORT")
	if port == "" {
		port = "9000"
	}

	log.Printf("==== Backend Chat App Aman & Optimal Berjalan di Port %s ====", port)
	r.Run(":" + port)
}
