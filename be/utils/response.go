package utils

import (
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

// Response adalah struktur standar untuk API response
type Response struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
}

// SuccessResponse mengirim response sukses (200 OK)
func SuccessResponse(ctx *gin.Context, message string, data interface{}) {
	ctx.JSON(http.StatusOK, Response{
		Success: true,
		Message: message,
		Data:    data,
	})
}

// CreatedResponse mengirim response sukses pembuatan resource (201 Created)
func CreatedResponse(ctx *gin.Context, message string, data interface{}) {
	ctx.JSON(http.StatusCreated, Response{
		Success: true,
		Message: message,
		Data:    data,
	})
}

// ErrorResponse mengirim response error (Modular & Gampang dikelola)
func ErrorResponse(ctx *gin.Context, code int, message string, err error) {
	errStr := ""
	if err != nil {
		// Log error lengkap di server (Internal)
		log.Printf("[API ERROR] %s: %v", message, err)
		
		// Jika mode Release, sembunyikan detail teknis
		// ATAU jika pesan error terlihat mengandung rahasia database/ORM
		lowErr := strings.ToLower(err.Error())
		if os.Getenv("GIN_MODE") == "release" || 
		   strings.Contains(lowErr, "prisma") || 
		   strings.Contains(lowErr, "connector") || 
		   strings.Contains(lowErr, "record") || 
		   strings.Contains(lowErr, "relation") {
			errStr = "Terjadi kesalahan server"
		} else {
			errStr = err.Error()
		}
	}

	ctx.AbortWithStatusJSON(code, Response{
		Success: false,
		Message: message,
		Error:   errStr,
	})
}

// BadRequest helper untuk error input
func BadRequest(ctx *gin.Context, message string, err error) {
	ErrorResponse(ctx, http.StatusBadRequest, message, err)
}

// InternalError helper untuk error server/database
func InternalError(ctx *gin.Context, message string, err error) {
	ErrorResponse(ctx, http.StatusInternalServerError, message, err)
}

// Unauthorized helper untuk error auth
func Unauthorized(ctx *gin.Context, message string) {
	ErrorResponse(ctx, http.StatusUnauthorized, message, nil)
}

// ValidationErrorResponse mengirim list error per field (Sangat Modular)
func ValidationErrorResponse(ctx *gin.Context, errors interface{}) {
	ctx.AbortWithStatusJSON(http.StatusBadRequest, Response{
		Success: false,
		Message: "Validasi gagal",
		Data:    errors,
	})
}

// Conflict helper untuk error data duplikat (409)
func Conflict(ctx *gin.Context, message string, err error) {
	ErrorResponse(ctx, http.StatusConflict, message, err)
}
