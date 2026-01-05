package repositories

import (
	"chat-app-be/prisma/db"
	"context"
)

type SearchRepository struct {
	Client *db.PrismaClient
}

func NewSearchRepository(client *db.PrismaClient) *SearchRepository {
	return &SearchRepository{Client: client}
}

// GlobalSearch mencari user, grup, dan file berdasarkan query string
func (r *SearchRepository) GlobalSearch(ctx context.Context, query string) (map[string]interface{}, error) {
	// 1. Cari Users (Priority 1)
	users, err := r.Client.User.FindMany(
		db.User.Or(
			db.User.Name.Contains(query),
			db.User.Email.Contains(query),
		),
	).Take(10).Exec(ctx)
	if err != nil {
		return nil, err
	}

	// 2. Cari Groups (Priority 2)
	groups, err := r.Client.Chat.FindMany(
		db.Chat.And(
			db.Chat.IsGroup.Equals(true),
			db.Chat.Name.Contains(query),
		),
	).Take(10).Exec(ctx)
	if err != nil {
		return nil, err
	}

	// 3. Cari Files/Media (Priority 3)
	files, err := r.Client.Message.FindMany(
		db.Message.And(
			db.Message.Content.Contains(query),
			db.Message.Or(
				db.Message.Type.Equals(db.MessageType("IMAGE")),
				db.Message.Type.Equals(db.MessageType("VIDEO")),
				db.Message.Type.Equals(db.MessageType("DOCUMENT")),
			),
		),
	).Take(10).With(
		db.Message.Sender.Fetch(),
	).Exec(ctx)
	if err != nil {
		return nil, err
	}

	return map[string]interface{}{
		"contacts": users,
		"groups":   groups,
		"files":    files,
	}, nil
}
