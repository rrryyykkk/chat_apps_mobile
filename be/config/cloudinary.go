package config

import (
	"context"
	"log"
	"os"

	"github.com/cloudinary/cloudinary-go/v2"
	"github.com/cloudinary/cloudinary-go/v2/api/uploader"
)

var CloudinaryInstance *cloudinary.Cloudinary

// InitCloudinary inisialisasi koneksi ke Cloudinary via .env
func InitCloudinary() {
	cld, err := cloudinary.NewFromParams(
		os.Getenv("CLOUDINARY_CLOUD_NAME"),
		os.Getenv("CLOUDINARY_API_KEY"),
		os.Getenv("CLOUDINARY_API_SECRET"),
	)
	if err != nil {
		log.Println("Gagal inisialisasi Cloudinary:", err)
		return
	}
	CloudinaryInstance = cld
}

// UploadFile mengunggah file (Gambar/Video/Dokumen) ke Cloudinary dan mengembalikan URL-nya
func UploadFile(ctx context.Context, input interface{}) (string, error) {
	if CloudinaryInstance == nil {
		return "", nil
	}

	result, err := CloudinaryInstance.Upload.Upload(ctx, input, uploader.UploadParams{
		Folder:       os.Getenv("CLOUDINARY_UPLOAD_FOLDER"),
		ResourceType: "auto", // Otomatis mendeteksi apakah itu image, video, atau raw (doc)
	})
	if err != nil {
		return "", err
	}

	return result.SecureURL, nil
}
