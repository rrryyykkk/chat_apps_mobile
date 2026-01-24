package controllers

import (
	"chat-app-be/models"
	"chat-app-be/repositories"
	"chat-app-be/utils"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type AuthController struct {
	UserRepo *repositories.UserRepository
}

func NewAuthController(repo *repositories.UserRepository) *AuthController {
	return &AuthController{UserRepo: repo}
}

// GenerateToken membuat token JWT untuk user yang berhasil login/register
func (c *AuthController) GenerateToken(userID, name string) (string, error) {
	expHours, _ := strconv.Atoi(os.Getenv("JWT_EXPIRATION_HOURS"))
	if expHours == 0 {
		expHours = 720 // Default 30 days
	}

	claims := jwt.MapClaims{
		"sub":  userID,
		"name": name, // Tambahkan nama ke claims agar tidak perlu query DB berulang kali
		"exp":  time.Now().Add(time.Hour * time.Duration(expHours)).Unix(),
		"iat":  time.Now().Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(os.Getenv("JWT_SECRET")))
}

// Register menangani pembuatan user baru dengan password hashing
func (c *AuthController) Register(ctx *gin.Context) {
	var input models.UserDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// 1. Hash password menggunakan bcrypt (standar keamanan tinggi)
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		utils.InternalError(ctx, "Gagal memproses password", err)
		return
	}

	// 2. Simpan user ke database
	user, err := c.UserRepo.CreateUser(ctx.Request.Context(), input.Email, input.Name, string(hashedPassword), input.Color)
	if err != nil {
		// Prisma P2002 is Unique constraint failed
		if strings.Contains(err.Error(), "P2002") {
			utils.Conflict(ctx, "Email sudah terdaftar", err)
			return
		}
		utils.InternalError(ctx, "Gagal registrasi user", err)
		return
	}

	// 3. Generate Token
	token, _ := c.GenerateToken(user.ID, user.Name)

	// 4. Set Cookie HTTP-Only jika dibutuhkan (untuk Web Security)
	ctx.SetCookie("access_token", token, 3600*24, "/", "", false, true)

	color, _ := user.Color()
	avatar, _ := user.AvatarURL()

	utils.CreatedResponse(ctx, "Registrasi berhasil!", gin.H{
		"token": token,
		"user": models.UserResponse{
			ID:        user.ID,
			Email:     user.Email,
			Name:      user.Name,
			AvatarUrl: avatar,
			Color:     color,
		},
	})
}

// Login verifikasi user dan password
func (c *AuthController) Login(ctx *gin.Context) {
	var input models.LoginDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// 1. Cari user berdasarkan email
	user, err := c.UserRepo.FindByEmail(ctx.Request.Context(), input.Email)
	if err != nil || user == nil {
		utils.Unauthorized(ctx, "Email atau Password salah")
		return
	}

	// 2. Bandingkan password (plain vs hashed)
	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password))
	if err != nil {
		utils.Unauthorized(ctx, "Email atau Password salah")
		return
	}

	// 3. Generate Token
	token, _ := c.GenerateToken(user.ID, user.Name)

	// 4. Generate OTP Simulation for Login
	otpCode := fmt.Sprintf("%06d", rand.Intn(1000000))
	_, _ = c.UserRepo.CreateOTP(ctx.Request.Context(), user.ID, otpCode)
	log.Printf("==== [SIMULASI EMAIL LOGIN] OTP untuk %s adalah %s ====", input.Email, otpCode)

	color, _ := user.Color()
	avatar, _ := user.AvatarURL()

	utils.SuccessResponse(ctx, "Login berhasil, silakan verifikasi OTP!", gin.H{
		"token": token,
		"user": models.UserResponse{
			ID:        user.ID,
			Email:     user.Email,
			Name:      user.Name,
			AvatarUrl: avatar,
			Color:     color,
		},
	})
}

// ForgotPassword mengirim simulasi OTP ke email
func (c *AuthController) ForgotPassword(ctx *gin.Context) {
	var input models.ForgetPasswordDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// 1. Cek apakah user ada
	user, err := c.UserRepo.FindByEmail(ctx.Request.Context(), input.Email)
	if err != nil {
		utils.ErrorResponse(ctx, http.StatusNotFound, "User tidak ditemukan", nil)
		return
	}

	// 2. Generate OTP 6 angka secara acak
	otpCode := fmt.Sprintf("%06d", rand.Intn(1000000))
	_, err = c.UserRepo.CreateOTP(ctx.Request.Context(), user.ID, otpCode)
	if err != nil {
		utils.InternalError(ctx, "Gagal membuat OTP", err)
		return
	}

	// 3. (Optional) Kirim email beneran di sini
	log.Printf("==== [SIMULASI EMAIL] OTP untuk %s adalah %s ====", input.Email, otpCode)

	utils.SuccessResponse(ctx, "Kode OTP berhasil dikirim ke email", nil)
}

// ResendOTP mengirim ulang OTP (sama seperti forgot password tapi untuk alur login/registrasi)
func (c *AuthController) ResendOTP(ctx *gin.Context) {
	var input models.ForgetPasswordDTO // Kita pakai struct yang sama karena isinya cuma Email
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	user, err := c.UserRepo.FindByEmail(ctx.Request.Context(), input.Email)
	if err != nil {
		utils.ErrorResponse(ctx, http.StatusNotFound, "User tidak ditemukan", nil)
		return
	}

	otpCode := fmt.Sprintf("%06d", rand.Intn(1000000))
	_, err = c.UserRepo.CreateOTP(ctx.Request.Context(), user.ID, otpCode)
	if err != nil {
		utils.InternalError(ctx, "Gagal membuat OTP baru", err)
		return
	}

	log.Printf("==== [RESEND OTP] OTP untuk %s adalah %s ====", input.Email, otpCode)
	utils.SuccessResponse(ctx, "Kode OTP baru telah dikirim!", nil)
}

// ResetPassword merubah password menggunakan OTP
func (c *AuthController) ResetPassword(ctx *gin.Context) {
	var input models.ResetPasswordDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// 1. Cek user
	user, err := c.UserRepo.FindByEmail(ctx.Request.Context(), input.Email)
	if err != nil {
		utils.ErrorResponse(ctx, http.StatusNotFound, "User tidak ditemukan", nil)
		return
	}

	// 2. Verifikasi OTP
	_, err = c.UserRepo.FindOTP(ctx.Request.Context(), user.ID, input.Code)
	if err != nil {
		utils.BadRequest(ctx, "Kode OTP salah atau sudah kadaluarsa", err)
		return
	}

	// 3. Hash password baru
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		utils.InternalError(ctx, "Gagal memproses password baru", err)
		return
	}

	// 4. Update Password
	_, err = c.UserRepo.UpdatePassword(ctx.Request.Context(), input.Email, string(hashedPassword))
	if err != nil {
		utils.InternalError(ctx, "Gagal merubah password", err)
		return
	}

	utils.SuccessResponse(ctx, "Password berhasil diperbarui, silakan login ulang", nil)
}

// UpdateProfile memperbarui profil user (Nama & Avatar)
func (c *AuthController) UpdateProfile(ctx *gin.Context) {
	var input models.UpdateProfileDTO
	if err := ctx.ShouldBindJSON(&input); err != nil {
		utils.ValidationErrorResponse(ctx, utils.FormatValidationError(err))
		return
	}

	// Ambil userID dari context (set oleh JWT Middleware jika ada)
	// Untuk saat ini, kita akan mencari user berdasarkan Email yang dikirim di body
	// ATAU jika kita belum punya middleware yang kuat, kita minta userID di body.
	// Namun, agar konsisten dengan schema, kita butuh userID.
	// Mari kita tambahkan Email ke UpdateProfileDTO jika perlu, atau asumsikan ada userID.
	
	// Skenario aman: Gunakan ID dari params atau body sementara
	userID := ctx.Query("id") 
	if userID == "" {
		utils.BadRequest(ctx, "User ID dibutuhkan", nil)
		return
	}

	user, err := c.UserRepo.UpdateUser(ctx.Request.Context(), userID, input.Name, input.AvatarUrl)
	if err != nil {
		utils.InternalError(ctx, "Gagal memperbarui profil", err)
		return
	}

	color, _ := user.Color()
	avatar, _ := user.AvatarURL()

	utils.SuccessResponse(ctx, "Profil berhasil diperbarui", models.UserResponse{
		ID:        user.ID,
		Email:     user.Email,
		Name:      user.Name,
		AvatarUrl: avatar,
		Color:     color,
	})
}
