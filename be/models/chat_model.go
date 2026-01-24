package models

import "time"

// MessageDTO merepresentasikan struktur satu pesan chat
type MessageDTO struct {
	ID        string    `json:"id"`
	SenderID  string    `json:"senderId"`
	ChatID    string    `json:"chatId"`
	Content   string    `json:"content"`
	Timestamp time.Time `json:"timestamp"`
	Type      string    `json:"type"`      // TEXT, IMAGE, VIDEO, DOCUMENT, INFO
	Status    string    `json:"status"`    // SENDING, SENT, DELIVERED, READ
	IsDeleted bool      `json:"isDeleted"`
	ReplyToID string    `json:"replyToId,omitempty"`
}

// ChatDTO merepresentasikan satu room chat
type ChatDTO struct {
	ID          string      `json:"id"`
	Name        string      `json:"name,omitempty"`
	IsGroup     bool        `json:"isGroup"`
	LastMessage interface{} `json:"lastMessage,omitempty"`
	UnreadCount int         `json:"unreadCount"`
}
