package repositories

import (
	"chat-app-be/prisma/db"
	"context"
	"time"
)

type StatusRepository struct {
	Client *db.PrismaClient
}

func NewStatusRepository(client *db.PrismaClient) *StatusRepository {
	return &StatusRepository{Client: client}
}

// CreateStatus membuat story baru (Updated with new fields)
func (r *StatusRepository) CreateStatus(ctx context.Context, userId, mediaUrl, caption, content, bgColor string, mediaType db.MediaType) (*db.StatusModel, error) {
	ops := []db.StatusSetParam{
		db.Status.Type.Set(mediaType),
	}

	if mediaUrl != "" {
		ops = append(ops, db.Status.MediaURL.Set(mediaUrl))
	}
	if caption != "" {
		ops = append(ops, db.Status.Caption.Set(caption))
	}
	if content != "" {
		ops = append(ops, db.Status.Content.Set(content))
	}
	if bgColor != "" {
		ops = append(ops, db.Status.BackgroundColor.Set(bgColor))
	}

	return r.Client.Status.CreateOne(
		db.Status.ExpiresAt.Set(time.Now().Add(24 * time.Hour)),
		db.Status.User.Link(db.User.ID.Equals(userId)),
		ops...,
	).Exec(ctx)
}

// AddView mencatat user melihat status
func (r *StatusRepository) AddView(ctx context.Context, statusId, userId string) error {
	_, err := r.Client.StatusViewer.CreateOne(
		db.StatusViewer.Status.Link(db.Status.ID.Equals(statusId)),
		db.StatusViewer.User.Link(db.User.ID.Equals(userId)),
	).Exec(ctx)
	// If unique constraint violation (already viewed), ignore
	return err
}

// ToggleLike like/unlike status
func (r *StatusRepository) ToggleLike(ctx context.Context, statusId, userId string) (bool, error) {
	// Check if exists
	like, err := r.Client.StatusLike.FindUnique(
		db.StatusLike.StatusIDUserID(
			db.StatusLike.StatusID.Equals(statusId),
			db.StatusLike.UserID.Equals(userId),
		),
	).Exec(ctx)

	if err == nil && like != nil {
		// Unlike
		_, err = r.Client.StatusLike.FindUnique(
			db.StatusLike.StatusIDUserID(
				db.StatusLike.StatusID.Equals(statusId),
				db.StatusLike.UserID.Equals(userId),
			),
		).Delete().Exec(ctx)
		return false, err
	}

	// Like
	_, err = r.Client.StatusLike.CreateOne(
		db.StatusLike.Status.Link(db.Status.ID.Equals(statusId)),
		db.StatusLike.User.Link(db.User.ID.Equals(userId)),
	).Exec(ctx)
	return true, err
}

// GetStatusViewers mengambil daftar viewers
func (r *StatusRepository) GetStatusViewers(ctx context.Context, statusId string) ([]db.StatusViewerModel, error) {
	return r.Client.StatusViewer.FindMany(
		db.StatusViewer.StatusID.Equals(statusId),
	).With(
		db.StatusViewer.User.Fetch(),
	).OrderBy(
		db.StatusViewer.ViewedAt.Order(db.SortOrderDesc),
	).Exec(ctx)
}

// GetActiveStatuses mengambil status teman yang masih berlaku (Updated with relations & privacy)
func (r *StatusRepository) GetActiveStatuses(ctx context.Context, userId string) ([]db.StatusModel, error) {
    // 1. Get List of Contact User IDs that the current user has saved
    contacts, err := r.Client.Contact.FindMany(
        db.Contact.UserID.Equals(userId),
    ).Exec(ctx)

    if err != nil {
        return nil, err
    }

	// Build ID list: My ID + My Contacts' IDs
	allowedUserIds := []string{userId}
	for _, c := range contacts {
        // Access via relation method
		allowedUserIds = append(allowedUserIds, c.ContactUser().ID)
	}

	return r.Client.Status.FindMany(
		db.Status.ExpiresAt.After(time.Now()),
        db.Status.UserID.In(allowedUserIds),
	).With(
		db.Status.User.Fetch(),
		db.Status.Likes.Fetch(),
		db.Status.Viewers.Fetch(),
	).OrderBy(
		db.Status.CreatedAt.Order(db.SortOrderDesc),
	).Exec(ctx)
}

// GetStatusesWithFilter filtering statuses
func (r *StatusRepository) GetStatusesWithFilter(ctx context.Context, oldest bool) ([]db.StatusModel, error) {
	query := r.Client.Status.FindMany(
		db.Status.ExpiresAt.After(time.Now()),
	).With(
		db.Status.User.Fetch(),
		db.Status.Likes.Fetch(),
		db.Status.Viewers.Fetch(),
	)

	if oldest {
		query = query.OrderBy(db.Status.CreatedAt.Order(db.SortOrderAsc))
	} else {
		query = query.OrderBy(db.Status.CreatedAt.Order(db.SortOrderDesc))
	}

	return query.Exec(ctx)
}
