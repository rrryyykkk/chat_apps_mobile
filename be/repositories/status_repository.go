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

// CreateStatus membuat story baru
func (r *StatusRepository) CreateStatus(ctx context.Context, userId, mediaUrl, caption string, mediaType db.MediaType) (*db.StatusModel, error) {
	return r.Client.Status.CreateOne(
		db.Status.MediaURL.Set(mediaUrl),
		db.Status.ExpiresAt.Set(time.Now().Add(24 * time.Hour)), // Berlaku 24 jam
		db.Status.User.Link(db.User.ID.Equals(userId)),
		db.Status.Type.Set(mediaType),
		db.Status.Caption.Set(caption),
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

// GetActiveStatuses mengambil status teman yang masih berlaku (Updated with relations)
func (r *StatusRepository) GetActiveStatuses(ctx context.Context) ([]db.StatusModel, error) {
	return r.Client.Status.FindMany(
		db.Status.ExpiresAt.After(time.Now()),
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
