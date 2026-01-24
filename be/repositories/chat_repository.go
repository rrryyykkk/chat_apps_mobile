package repositories

import (
	"chat-app-be/prisma/db"
	"context"
)

// ChatRepository menangani query database untuk pesan dan room chat.
type ChatRepository struct {
	Client *db.PrismaClient
}

// NewChatRepository inisialisasi repo chat
func NewChatRepository(client *db.PrismaClient) *ChatRepository {
	return &ChatRepository{Client: client}
}

// CreateMessage menyimpan pesan baru yang dikirim user via WebSocket atau API
func (r *ChatRepository) CreateMessage(ctx context.Context, senderId, chatId, content string, msgType db.MessageType) (*db.MessageModel, error) {
	return r.Client.Message.CreateOne(
		db.Message.Content.Set(content),
		db.Message.Sender.Link(db.User.ID.Equals(senderId)),
		db.Message.Chat.Link(db.Chat.ID.Equals(chatId)),
		db.Message.Type.Set(msgType),
	).Exec(ctx)
}

// GetChatMessages mengambil riwayat pesan dalam satu chat room
func (r *ChatRepository) GetChatMessages(ctx context.Context, chatId string) ([]db.MessageModel, error) {
	return r.Client.Message.FindMany(
		db.Message.ChatID.Equals(chatId),
	).OrderBy(
		db.Message.Timestamp.Order(db.SortOrderDesc),
	).Exec(ctx)
}

// GetUserChats mengambil daftar chat yang diikuti oleh user tertentu
// GetUserChats mengambil daftar chat yang diikuti oleh user tertentu
func (r *ChatRepository) GetUserChats(ctx context.Context, userId string) ([]db.ChatModel, error) {
	// Kita ambil chat yang diikuti user, sekalian load:
    // 1. Pesan terakhir
    // 2. Participants (untuk nama direct chat)
    // 3. Unread Messages (untuk badge count)
	participants, err := r.Client.Participant.FindMany(
		db.Participant.UserID.Equals(userId),
	).With(
		db.Participant.Chat.Fetch().With(
            // Last Message
			db.Chat.Messages.Fetch().OrderBy(db.Message.Timestamp.Order(db.SortOrderDesc)).Take(1).With(
				db.Message.Sender.Fetch(),
			),
            // Participants & User Info (for naming)
            db.Chat.Participants.Fetch().With(
                db.Participant.User.Fetch(),
            ),
            // Unread Messages (Filter: Not READ AND Not Sender)
            db.Chat.Messages.Fetch(
                db.Message.Status.Not(db.MessageStatusRead),
                db.Message.SenderID.Not(userId),
            ),
		),
	).Exec(ctx)

	if err != nil {
		return nil, err
	}

	chats := make([]db.ChatModel, len(participants))
	for i, p := range participants {
		chats[i] = *p.Chat()
	}
	return chats, nil
}

// CreateGroupChat membuat chat room baru untuk banyak orang
func (r *ChatRepository) CreateGroupChat(ctx context.Context, name string, userIds []string) (*db.ChatModel, error) {
	// 1. Buat Chat Room
	chat, err := r.Client.Chat.CreateOne(
		db.Chat.Name.Set(name),
		db.Chat.IsGroup.Set(true),
	).Exec(ctx)
	if err != nil {
		return nil, err
	}

	// 2. Tambahkan semua Participant (Sequential)
	for _, uid := range userIds {
		_, err = r.Client.Participant.CreateOne(
			db.Participant.User.Link(db.User.ID.Equals(uid)),
			db.Participant.Chat.Link(db.Chat.ID.Equals(chat.ID)),
		).Exec(ctx)
		// Jika salah satu gagal, kita tetap lanjut (atau bisa di-handle sesuai bisnis logik)
	}

	return chat, nil
}

// CreateOrGetDirectChat membuat atau mengambil chat private antara dua user
func (r *ChatRepository) CreateOrGetDirectChat(ctx context.Context, userId1, userId2 string) (*db.ChatModel, error) {
    // 1. Cari apakah sudah ada chat private antara kedua user ini
    // Query: Cari chat yang bukan grup, yang memiliki participant userId1 DAN userId2
    
    // Karena keterbatasan query ORM untuk intersection relation yang kompleks, 
    // kita bisa approach dgn: Ambil semua chat direct userId1, lalu filter di code apakah userId2 ada di dalamnya.
    
    // Ambil chat dimana user1 adalah participant
    user1Chats, err := r.Client.Chat.FindMany(
        db.Chat.IsGroup.Equals(false),
        db.Chat.Participants.Some(
            db.Participant.UserID.Equals(userId1),
        ),
    ).With(
        db.Chat.Participants.Fetch(),
    ).Exec(ctx)

    if err != nil {
        return nil, err
    }

    // Check filtered chats
    for _, chat := range user1Chats {
        participants := chat.Participants()
        // Harusnya direct chat cuma 2 orang. Kita cari yang ada userId2.
        for _, p := range participants {
            if p.UserID == userId2 {
                return &chat, nil
            }
        }
    }

    // 2. Jika belum ada, buat baru
    chat, err := r.Client.Chat.CreateOne(
        db.Chat.IsGroup.Set(false),
        // Nama optional untuk direct chat, biasanya kosong atau bisa diisi string kombinasi
    ).Exec(ctx)
    if err != nil {
        return nil, err
    }

    // Add participants
    _, err = r.Client.Participant.CreateOne(
        db.Participant.User.Link(db.User.ID.Equals(userId1)),
        db.Participant.Chat.Link(db.Chat.ID.Equals(chat.ID)),
    ).Exec(ctx)
    if err != nil { return nil, err }

    _, err = r.Client.Participant.CreateOne(
        db.Participant.User.Link(db.User.ID.Equals(userId2)),
        db.Participant.Chat.Link(db.Chat.ID.Equals(chat.ID)),
    ).Exec(ctx)
    if err != nil { return nil, err }

    return chat, nil
}
// UpdateMessageStatus memperbarui status pesan (SENT, DELIVERED, READ)
func (r *ChatRepository) UpdateMessageStatus(ctx context.Context, messageId string, status db.MessageStatus) (*db.MessageModel, error) {
	return r.Client.Message.FindUnique(
		db.Message.ID.Equals(messageId),
	).Update(
		db.Message.Status.Set(status),
	).Exec(ctx)
}
