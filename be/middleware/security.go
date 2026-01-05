package middleware

import (
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// RateLimiter membatasi jumlah request per menit (Basic protection)
func RateLimiter() gin.HandlerFunc {
	type client struct {
		lastSeen time.Time
		hits     int
	}
	var (
		mu      sync.Mutex
		clients = make(map[string]*client)
	)

	return func(c *gin.Context) {
		ip := c.ClientIP()
		mu.Lock()
		defer mu.Unlock()

		if _, found := clients[ip]; !found {
			clients[ip] = &client{lastSeen: time.Now(), hits: 1}
		} else {
			if time.Since(clients[ip].lastSeen) > time.Minute {
				clients[ip].hits = 1
				clients[ip].lastSeen = time.Now()
			} else {
				clients[ip].hits++
			}
		}

		if clients[ip].hits > 60 { // Limit 60 hits per menit
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"success": false,
				"message": "Terlalu banyak permintaan, coba lagi nanti",
			})
			return
		}
		c.Next()
	}
}

// AuthMiddleware memvalidasi token JWT dari header Authorization atau Cookie
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		var tokenString string

		if authHeader != "" && strings.HasPrefix(authHeader, "Bearer ") {
			tokenString = strings.TrimPrefix(authHeader, "Bearer ")
		} else {
			// Jika di web, bisa cek cookie http-only
			cookie, err := c.Cookie("access_token")
			if err == nil {
				tokenString = cookie
			}
		}

		if tokenString == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized: Token tidak ditemukan"})
			return
		}

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("metode signing tidak valid: %v", token.Header["alg"])
			}
			return []byte(os.Getenv("JWT_SECRET")), nil
		})

		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized: Token tidak valid"})
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized: Claims tidak valid"})
			return
		}

		// Simpan userID dan userName ke context supaya bisa dipakai di controller
		c.Set("userID", claims["sub"])
		c.Set("userName", claims["name"])
		c.Next()
	}
}

// CORSMiddleware mengatur izin akses dari frontend (Cross-Origin Resource Sharing)
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

// SecurityHeaders menambahkan header keamanan standar (mengikuti CVE mitigation)
func SecurityHeaders() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("X-Content-Type-Options", "nosniff")
		c.Writer.Header().Set("X-Frame-Options", "DENY")
		c.Writer.Header().Set("X-XSS-Protection", "1; mode=block")
		c.Next()
	}
}

// GlobalTryCatch (Recovery) menangkap error fatal (panic) agar server tidak mati
func GlobalTryCatch() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// Log error fatal ke terminal secara mendalam
				fmt.Printf("[PANIC RECOVERED] Critical Error: %v\n", err)
				
				errStr := fmt.Sprint(err)
				// Jika mode Release, sembunyikan detail panic dari client
				if os.Getenv("GIN_MODE") == "release" {
					errStr = "Internal Server Error"
				}

				// Kirim response error 500 secara otomatis (Global Catch)
				c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
					"success": false,
					"message": "Terjadi kesalahan fatal pada server",
					"error":   errStr,
				})
			}
		}()
		c.Next()
	}
}
