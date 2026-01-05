package repositories

import (
	"chat-app-be/prisma/db"
	"context"
	"time"
)

// UserRepository adalah jembatan antara Controller dan Database Prisma untuk tabel User.
type UserRepository struct {
	Client *db.PrismaClient
}

// NewUserRepository inisialisasi repository baru
func NewUserRepository(client *db.PrismaClient) *UserRepository {
	return &UserRepository{Client: client}
}

// CreateUser menyimpan user baru ke database
func (r *UserRepository) CreateUser(ctx context.Context, email, name, password, color string) (*db.UserModel, error) {
	return r.Client.User.CreateOne(
		db.User.Email.Set(email),
		db.User.Name.Set(name),
		db.User.Password.Set(password),
		db.User.Color.Set(color),
	).Exec(ctx)
}

// FindByEmail mencari user berdasarkan email (penting untuk Login)
func (r *UserRepository) FindByEmail(ctx context.Context, email string) (*db.UserModel, error) {
	return r.Client.User.FindUnique(
		db.User.Email.Equals(email),
	).Exec(ctx)
}

// CreateOTP menyimpan kode OTP untuk user
func (r *UserRepository) CreateOTP(ctx context.Context, userId, code string) (*db.OtpModel, error) {
	return r.Client.Otp.CreateOne(
		db.Otp.Code.Set(code),
		db.Otp.ExpiresAt.Set(time.Now().Add(10 * time.Minute)), // Berlaku 10 menit
		db.Otp.User.Link(db.User.ID.Equals(userId)),
	).Exec(ctx)
}

// SaveRefreshToken menyimpan token untuk session jangka panjang (30 hari)
func (r *UserRepository) SaveRefreshToken(ctx context.Context, userId, token string) (*db.RefreshTokenModel, error) {
	return r.Client.RefreshToken.CreateOne(
		db.RefreshToken.Token.Set(token),
		db.RefreshToken.ExpiresAt.Set(time.Now().AddDate(0, 1, 0)), // 1 Bulan
		db.RefreshToken.User.Link(db.User.ID.Equals(userId)),
	).Exec(ctx)
}

// FindByRefreshToken mencari token untuk perpanjangan sesi
func (r *UserRepository) FindByRefreshToken(ctx context.Context, token string) (*db.RefreshTokenModel, error) {
	return r.Client.RefreshToken.FindUnique(
		db.RefreshToken.Token.Equals(token),
	).With(
		db.RefreshToken.User.Fetch(),
	).Exec(ctx)
}

// FindOTP mencari OTP yang masih aktif berdasarkan email dan kode
func (r *UserRepository) FindOTP(ctx context.Context, userId, code string) (*db.OtpModel, error) {
	// Karena kita tidak mendefinisikan @@unique([userId, code]) dengan nama spesifik di schema,
	// biasanya Prisma Go tidak men-generate FindUnique dengan multi-params kecuali dinamai.
	// Kita gunakan FindMany + First() sebagai alternatif aman.
	otp, err := r.Client.Otp.FindMany(
		db.Otp.UserID.Equals(userId),
		db.Otp.Code.Equals(code),
		db.Otp.ExpiresAt.After(time.Now()),
	).OrderBy(
		db.Otp.CreatedAt.Order(db.SortOrderDesc),
	).Exec(ctx)

	if err != nil || len(otp) == 0 {
		return nil, err
	}
	return &otp[0], nil
}

// UpdatePassword memperbarui password user
func (r *UserRepository) UpdatePassword(ctx context.Context, email, newPassword string) (*db.UserModel, error) {
	return r.Client.User.FindUnique(
		db.User.Email.Equals(email),
	).Update(
		db.User.Password.Set(newPassword),
	).Exec(ctx)
}
