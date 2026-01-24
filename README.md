# Chat-Apps

Aplikasi pesan instan modern dengan Flutter (Frontend) dan Go (Backend).

## 🚀 Quick Start

### Backend
```bash
cd be
go mod download
go run github.com/steebchen/prisma-client-go generate
go run main.go
```

### Frontend
```bash
cd fe
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 📖 Dokumentasi Lengkap

Lihat [DOCUMENTATION.md](DOCUMENTATION.md) untuk:
- Setup lengkap backend dan frontend
- Konfigurasi environment variables
- Troubleshooting
- API endpoints
- Dan lainnya

## ⚙️ Environment Variables

Copy `be/.env.example` menjadi `be/.env` dan sesuaikan dengan konfigurasi Anda.

## 🔑 Key Technologies

- **Backend**: Go 1.24, Gin, PostgreSQL, Prisma, WebSocket
- **Frontend**: Flutter 3.8+, Isar, Dio, WebSocket
- **Cloud**: Cloudinary (media storage)

## ✨ Features

- ✅ Real-time chat dengan WebSocket
- ✅ Status/Story 24 jam
- ✅ Grup chat
- ✅ Offline-first dengan Isar
- ✅ Dark mode & multi-language
- ⚠️ Grup chat (dalam pengembangan)

## 📝 License

MIT License
