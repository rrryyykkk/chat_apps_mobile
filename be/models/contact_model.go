package models

type AddContactDTO struct {
	Email string `json:"email" binding:"required,email"`
	Alias string `json:"alias"`
}

type ContactResponse struct {
	ID        string `json:"id"`        // ID unik record kontak (bukan ID user)
	ContactID string `json:"contactId"` // ID user teman
	Name      string `json:"name"`      // Nama asli user
	Email     string `json:"email"`
	AvatarUrl string `json:"avatarUrl"`
	Color     string `json:"color"`
	Alias     string `json:"alias"`     // Nama panggilan lokal
}
