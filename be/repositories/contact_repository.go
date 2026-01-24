package repositories

import (
	"chat-app-be/models"
	"chat-app-be/prisma/db"
	"context"
	"fmt"
)

type ContactRepository struct {
	client *db.PrismaClient
}

func NewContactRepository(client *db.PrismaClient) *ContactRepository {
	return &ContactRepository{client: client}
}

// AddContact menambahkan user lain sebagai kontak
func (r *ContactRepository) AddContact(userId string, contactEmail string, alias string) (*models.ContactResponse, error) {
	ctx := context.Background()

	// 1. Verify requesting user exists
	requestingUser, err := r.client.User.FindUnique(
		db.User.ID.Equals(userId),
	).Exec(ctx)
	
	if err != nil {
		return nil, fmt.Errorf("Requesting user not found. Please make sure you are registered.")
	}

	// 2. Find target user by email
	targetUser, err := r.client.User.FindUnique(
		db.User.Email.Equals(contactEmail),
	).Exec(ctx)

	if err != nil {
		return nil, fmt.Errorf("User with email %s not found. Please make sure they are registered.", contactEmail)
	}

	// 3. Check if contact already exists
	existingContact, _ := r.client.Contact.FindFirst(
		db.Contact.UserID.Equals(requestingUser.ID),
		db.Contact.ContactUser.Where(db.User.ID.Equals(targetUser.ID)),
	).Exec(ctx)

	if existingContact != nil {
		return nil, fmt.Errorf("Contact already exists")
	}

	// 4. Create contact relation
	contact, err := r.client.Contact.CreateOne(
		db.Contact.User.Link(db.User.ID.Equals(requestingUser.ID)),
		db.Contact.ContactUser.Link(db.User.ID.Equals(targetUser.ID)),
		db.Contact.Alias.Set(alias),
	).Exec(ctx)

	if err != nil {
		return nil, err
	}

	// 5. Return response with complete user data
	aliasVal := ""
	if v, ok := contact.Alias(); ok {
		aliasVal = v
	}

	avatarUrl := ""
	if v, ok := targetUser.AvatarURL(); ok {
		avatarUrl = v
	}
	
	color := ""
	if v, ok := targetUser.Color(); ok {
		color = v
	}

	return &models.ContactResponse{
		ID:        contact.ID,
		ContactID: targetUser.ID,
		Name:      targetUser.Name,
		Email:     targetUser.Email,
		AvatarUrl: avatarUrl,
		Color:     color,
		Alias:     aliasVal,
	}, nil
}

// GetContacts mengambil semua kontak milik user
func (r *ContactRepository) GetContacts(userId string) ([]models.ContactResponse, error) {
	ctx := context.Background()

	contacts, err := r.client.Contact.FindMany(
		db.Contact.UserID.Equals(userId),
	).With(
		db.Contact.ContactUser.Fetch(),
	).Exec(ctx)

	if err != nil {
		return nil, err
	}

	var contactResponses []models.ContactResponse
	for _, c := range contacts {
		targetUser := c.ContactUser() // Get relation
		
		aliasVal := ""
		if v, ok := c.Alias(); ok {
			aliasVal = v
		}

		avatarUrl := ""
		if v, ok := targetUser.AvatarURL(); ok {
			avatarUrl = v
		}
		
		color := ""
		if v, ok := targetUser.Color(); ok {
			color = v
		}

		contactResponses = append(contactResponses, models.ContactResponse{
			ID:        c.ID,
			ContactID: targetUser.ID,
			Name:      targetUser.Name,
			Email:     targetUser.Email,
			AvatarUrl: avatarUrl,
			Color:     color,
			Alias:     aliasVal,
		})
	}

	return contactResponses, nil
}
