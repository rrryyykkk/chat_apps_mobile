# Dokumentasi Aplikasi Chat-Apps

## 📱 Tentang Aplikasi

**Chat-Apps** adalah aplikasi pesan instan modern yang dibangun dengan teknologi **Flutter** (Frontend) dan **Go/Golang** (Backend). Aplikasi ini menyediakan fitur komunikasi real-time dengan dukungan multimedia, status/story, grup chat, dan penyimpanan offline-first.

### ✨ Fitur Utama

- 🔐 **Autentikasi Aman**: Login/Register dengan JWT dan OTP verification
- 💬 **Chat Real-time**: Pesan instan menggunakan WebSocket dengan status read receipt
- 👥 **Grup Chat**: Komunikasi grup dengan multiple participants
- 📸 **Status/Story**: Konten sementara 24 jam dengan viewer tracking
- 🔍 **Pencarian Global**: Cari kontak, grup, dan media
- 📱 **Offline-First**: Data tersimpan lokal dengan Isar database
- 🌐 **Multi-bahasa**: Dukungan Bahasa Indonesia dan Inggris
- 🌙 **Dark Mode**: Tema gelap dan terang

---

## � Cara Clone Repository

### Clone dari GitHub

```bash
# Clone repository
git clone https://github.com/rrryyykkk/chat_apps_mobile.git

# Masuk ke folder project
cd chat_apps_mobile
```

> **💡 Tips**: Jika belum punya Git, download di [git-scm.com](https://git-scm.com/downloads)

---

## �🚀 Cara Menjalankan Aplikasi

### Prasyarat

Pastikan sudah terinstal:

- **Go** (v1.24 atau lebih baru) - [Download](https://go.dev/dl/)
- **Flutter** (v3.8.1 atau lebih baru) - [Download](https://flutter.dev/docs/get-started/install)
- **PostgreSQL** (v14 atau lebih baru) - [Download](https://www.postgresql.org/download/)
- **Git** - [Download](https://git-scm.com/downloads)

---

## ⚙️ Setup Backend (Go)

### 1️⃣ Masuk ke Direktori Backend

```bash
cd be
```

### 2️⃣ Konfigurasi Environment Variables

Buat file `.env` di folder `be/` dengan isi berikut:

```env
# Database Configuration
DATABASE_URL=postgresql://postgres:PASSWORD_ANDA@localhost:PORT_ANDA/chat_app?schema=public

# JWT Configuration
JWT_SECRET=SECRET_ANDA
JWT_EXPIRATION_HOURS=24

# Server Port
PORT=9000

# Cloudinary Configuration (untuk upload media)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_FOLDER=chat_app_gallery
```

> **⚠️ PENTING**:
>
> - Ganti `PASSWORD_ANDA` dengan password PostgreSQL Anda
> - Ganti kredensial Cloudinary dengan akun Anda (daftar gratis di [cloudinary.com](https://cloudinary.com))
> - `JWT_SECRET` bisa diganti dengan string random 64 karakter untuk keamanan lebih baik

### 3️⃣ Setup Database PostgreSQL

```bash
# Buat database baru
createdb chat_app

# Atau via psql:
psql -U postgres
CREATE DATABASE chat_app;
\q
```

### 4️⃣ Generate Prisma Client & Migrasi Database

```bash
# Install dependencies
go mod download

# Generate Prisma Client untuk Go
go run github.com/steebchen/prisma-client-go generate

# Jalankan migrasi database (buat tabel-tabel)
go run github.com/steebchen/prisma-client-go migrate deploy
```

### 5️⃣ Jalankan Backend Server

```bash
# Development mode
go run main.go

# Atau build executable terlebih dahulu
go build -o chat-app-be.exe
./chat-app-be.exe
```

✅ **Backend berjalan di**: `http://localhost:9000`

---

## 📱 Setup Frontend (Flutter)

### 1️⃣ Masuk ke Direktori Frontend

```bash
cd fe
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Generate Isar Database Schema

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4️⃣ Konfigurasi API Endpoint

Buka file `fe/lib/core/network/api_client.dart` dan pastikan `baseUrl` sesuai:

```dart
static const String baseUrl = "http://localhost:9000/api";
```

> **📌 Catatan untuk Physical Device**:
>
> - **Android**: Jalankan `adb reverse tcp:9000 tcp:9000` di terminal
> - **iOS**: Ganti `localhost` dengan IP komputer Anda (misal: `http://192.168.1.100:9000/api`)

### 5️⃣ Jalankan Aplikasi Flutter

```bash
# Untuk Android/iOS Emulator atau Physical Device
flutter run

# Untuk platform spesifik:
flutter run -d chrome        # Web
flutter run -d windows       # Windows Desktop
flutter run -d android       # Android
flutter run -d ios           # iOS (hanya di macOS)
```

---

## 🔑 Konfigurasi Environment Variables (Detail)

### Backend `.env` Variables

| Variable                   | Deskripsi                           | Contoh                                                         | Wajib?      |
| -------------------------- | ----------------------------------- | -------------------------------------------------------------- | ----------- |
| `DATABASE_URL`             | Connection string PostgreSQL        | `postgresql://user:pass@localhost:5432/chat_app?schema=public` | ✅ Ya       |
| `JWT_SECRET`               | Secret key untuk enkripsi JWT token | String random 64 karakter                                      | ✅ Ya       |
| `JWT_EXPIRATION_HOURS`     | Durasi token valid (jam)            | `24`                                                           | ✅ Ya       |
| `PORT`                     | Port server backend                 | `9000`                                                         | ✅ Ya       |
| `CLOUDINARY_CLOUD_NAME`    | Nama cloud Cloudinary               | ✅ Ya                                                          |
| `CLOUDINARY_API_KEY`       | API Key Cloudinary                  | ✅ Ya                                                          |
| `CLOUDINARY_API_SECRET`    | API Secret Cloudinary               | ✅ Ya                                                          |
| `CLOUDINARY_UPLOAD_FOLDER` | Folder upload di Cloudinary         | `chat_app_gallery`                                             | ⚠️ Opsional |

### Cara Mendapatkan Cloudinary Credentials

1. Daftar gratis di [cloudinary.com](https://cloudinary.com)
2. Setelah login, buka **Dashboard**
3. Salin **Cloud Name**, **API Key**, dan **API Secret**
4. Masukkan ke file `.env`

> **💡 Tips**: Untuk development, Anda bisa menggunakan kredensial yang sudah ada di `.env` contoh, namun untuk production sebaiknya gunakan akun sendiri.

---

## 🗂️ Struktur Proyek

```
Chat-apps/
├── be/                          # Backend (Go)
│   ├── config/                  # Konfigurasi DB & Cloudinary
│   ├── controllers/             # Logic handler API
│   ├── middleware/              # Auth, CORS, Security
│   ├── models/                  # Data models
│   ├── repositories/            # Database operations
│   ├── routes/                  # API routes
│   ├── utils/                   # Helper functions
│   ├── prisma/                  # Prisma schema & migrations
│   ├── .env                     # ⚠️ Environment variables (JANGAN COMMIT!)
│   ├── main.go                  # Entry point backend
│   └── go.mod                   # Go dependencies
│
├── fe/                          # Frontend (Flutter)
│   ├── lib/
│   │   ├── core/                # Network, constants, themes
│   │   ├── data/                # Data sources & repositories
│   │   ├── domain/              # Models & entities
│   │   ├── presentation/        # UI pages & widgets
│   │   └── services/            # WebSocket, storage, localization
│   ├── assets/                  # Images, animations, translations
│   ├── pubspec.yaml             # Flutter dependencies
│   └── main.dart                # Entry point frontend
│
└── DOCUMENTATION.md             # File ini
```

---

## 🔧 Troubleshooting

### ❌ Backend tidak bisa connect ke database

```
Error: Can't reach database server at `localhost:5432`
```

**Solusi**:

- Pastikan PostgreSQL sudah running: `pg_ctl status`
- Cek username/password di `DATABASE_URL` sudah benar
- Cek port PostgreSQL (default 5432)

### ❌ Frontend tidak bisa connect ke backend

```
DioException: Connection refused
```

**Solusi**:

- Pastikan backend sudah running di `http://localhost:9000`
- Untuk physical device Android, jalankan: `adb reverse tcp:9000 tcp:9000`
- Untuk iOS/Web, ganti `localhost` dengan IP komputer

### ❌ Error saat generate Prisma

```
Error: Prisma schema not found
```

**Solusi**:

```bash
cd be
go run github.com/steebchen/prisma-client-go generate
```

### ❌ Error upload media (Cloudinary)

```
Error: Invalid Cloudinary credentials
```

**Solusi**:

- Pastikan kredensial Cloudinary di `.env` sudah benar
- Cek koneksi internet (Cloudinary butuh akses internet)

---

## 📚 API Endpoints

### Authentication

- `POST /api/auth/register` - Registrasi user baru
- `POST /api/auth/login` - Login user
- `POST /api/auth/forgot-password` - Request OTP reset password
- `POST /api/auth/reset-password` - Reset password dengan OTP

### Chat

- `GET /api/chats` - Ambil daftar chat user
- `GET /api/chats/:chatId/messages` - Ambil pesan dalam chat
- `POST /api/chats/group` - Buat grup baru
- `WS /ws?userId=xxx` - WebSocket connection untuk real-time chat

### Status

- `GET /api/status` - Ambil semua status (< 24 jam)
- `POST /api/status` - Upload status baru
- `POST /api/status/:id/view` - Tandai status sebagai dilihat
- `POST /api/status/:id/like` - Like status
- `POST /api/status/:id/reply` - Reply status

### Media

- `POST /api/media/upload` - Upload gambar/video ke Cloudinary

### Search

- `GET /api/search?q=keyword` - Pencarian global

### Contact

- `GET /api/contacts` - Ambil daftar kontak
- `POST /api/contacts` - Tambah kontak baru

---

## 🧪 Testing

### Test Backend API

Gunakan **Postman** atau **Thunder Client** (VS Code extension):

1. Import collection dari `be/postman_collection.json` (jika ada)
2. Atau test manual:

```bash
# Test health check
curl http://localhost:9000/api/health

# Test register
curl -X POST http://localhost:9000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User","password":"password123"}'
```

### Test Frontend

```bash
cd fe
flutter test
```

---

## 📝 Catatan Penting

### Keamanan

- ⚠️ **JANGAN** commit file `.env` ke Git (sudah ada di `.gitignore`)
- 🔐 Ganti `JWT_SECRET` dengan string random untuk production
- 🔒 Gunakan HTTPS untuk production deployment

### Development Tips

- Backend auto-reload: Gunakan `air` (Go hot reload tool)
- Frontend hot reload: Otomatis aktif saat `flutter run`
- Database GUI: Gunakan **pgAdmin** atau **DBeaver** untuk manage PostgreSQL

### Production Deployment

- Backend: Deploy ke **Railway**, **Render**, atau **Google Cloud Run**
- Frontend: Build APK/IPA atau deploy ke **Firebase App Distribution**
- Database: Gunakan **Supabase**, **Neon**, atau **Railway PostgreSQL**

---

## 👥 Kontributor

Proyek ini dikembangkan sebagai tugas akhir mata kuliah **Mobile Programming** Semester 7.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

---

## 🆘 Butuh Bantuan?

Jika mengalami masalah:

1. Cek bagian **Troubleshooting** di atas
2. Pastikan semua prasyarat sudah terinstal
3. Periksa log error di terminal backend dan frontend
4. Hubungi tim pengembang

---

---

**Selamat mencoba! 🚀**
