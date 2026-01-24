package models

import "time"

// StatusDTO untuk request pembuatan & response story
type StatusDTO struct {
	// Input Fields
	MediaUrl string `json:"mediaUrl,omitempty"`
	Content  string `json:"content,omitempty" binding:"max=500"`
	Color    string `json:"color,omitempty"`
	Caption  string `json:"caption,omitempty" binding:"max=200"`
	Type     string `json:"type" binding:"omitempty,oneof=IMAGE VIDEO TEXT DOCUMENT"` // required only for input, handling varies

	// Response Fields
	ID          string       `json:"id,omitempty"`
	UserID      string       `json:"userId,omitempty"`
	User        UserResponse `json:"user,omitempty"`
	Timestamp   time.Time    `json:"timestamp,omitempty"`
	ExpiresAt   time.Time    `json:"expiresAt,omitempty"`
	LikeCount   int          `json:"likeCount"`
	ViewerCount int          `json:"viewerCount"`
	IsLiked     bool         `json:"isLiked"`
	IsViewed    bool         `json:"isViewed"`
}

// OTPVerifyDTO untuk request verifikasi kode OTP
type OTPVerifyDTO struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code" binding:"required,len=6,numeric"`
}

// ForgetPasswordDTO untuk request kirim OTP lupa password
type ForgetPasswordDTO struct {
	Email string `json:"email" binding:"required,email"`
}

// ResetPasswordDTO untuk reset password dengan OTP
type ResetPasswordDTO struct {
	Email       string `json:"email" binding:"required,email"`
	Code        string `json:"code" binding:"required,len=6,numeric"`
	NewPassword string `json:"newPassword" binding:"required,min=6"`
}

// TokenResponse untuk response login/refresh yang menyertakan kedua token
type TokenResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}
