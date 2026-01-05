package models

// StatusDTO untuk request pembuatan story baru
type StatusDTO struct {
	MediaUrl string `json:"mediaUrl" binding:"required,url"`
	Caption  string `json:"caption" binding:"max=200"`
	Type     string `json:"type" binding:"required,oneof=IMAGE VIDEO"` // IMAGE, VIDEO
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
