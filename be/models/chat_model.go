package models

import "time"

// MessageDTO merepresentasikan struktur satu pesan chat
type MessageDTO struct {
	ID        string    `json:"id"`
	SenderID  string    `json:"senderId"`
	ChatID    string    `json:"chatId"`
	Content   string    `json:"content"`
	Timestamp time.Time `json:"timestamp"`
	Type      string    `json:"type"`   // TEXT, IMAGE, INFO
	Status    string    `json:"status"` // SENDING, SENT, DELIVERED, READ
}

// ChatDTO merepresentasikan satu room chat
type ChatDTO struct {
	ID      string `json:"id"`
	Name    string `json:"name"` // Nama user lain atau nama grup
	IsGroup bool   `json:"isGroup"`
}
