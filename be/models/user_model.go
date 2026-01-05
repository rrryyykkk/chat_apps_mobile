package models

// UserDTO (Data Transfer Object) digunakan untuk menangkap data dari request body (JSON)
// saat user melakukan registrasi atau update profil.
type UserDTO struct {
	Email    string `json:"email" binding:"required,email"` // Harus format email
	Password string `json:"password" binding:"required,min=6"` // Minimal 6 karakter
	Name     string `json:"name" binding:"required"`
	Color    string `json:"color"` // Kode warna hex untuk UI fe
}

// LoginDTO dgunakan untuk validasi login
type LoginDTO struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// UserResponse adalah struktur data yang dikembalikan ke Frontend.
// Kita tidak menyertakan Password di sini demi keamanan.
type UserResponse struct {
	ID        string `json:"id"`
	Email     string `json:"email"`
	Name      string `json:"name"`
	AvatarUrl string `json:"avatarUrl"`
	Color     string `json:"color"`
}
