package config

import (
	"chat-app-be/prisma/db" // Import generated Prisma client
	"log"
)

// PkgClient adalah instance global dari Prisma Client
// Ini supaya kita bisa pakai koneksi DB di mana saja
var PkgClient *db.PrismaClient

// InitDB berfungsi untuk membuka koneksi ke database Postgres via Prisma
func InitDB() {
	PkgClient = db.NewClient()
	if err := PkgClient.Connect(); err != nil {
		log.Fatal("Gagal koneksi ke database:", err)
	}
	log.Println("Database terkoneksi dengan sukses!")
}

// CloseDB berfungsi untuk menutup koneksi jika aplikasi dimatikan (graceful shutdown)
func CloseDB() {
	if err := PkgClient.Disconnect(); err != nil {
		log.Print("Error saat memutus koneksi database:", err)
	}
}
