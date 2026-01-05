package utils

import (
	"errors"
	"fmt"
	"strings"

	"github.com/go-playground/validator/v10"
)

// FormatValidationError merubah error validator yang rumit jadi map sederhana
// Contoh: {"email": "email is a required field"}
func FormatValidationError(err error) map[string]string {
	var ve validator.ValidationErrors
	out := make(map[string]string)

	if errors.As(err, &ve) {
		for _, fe := range ve {
			out[strings.ToLower(fe.Field())] = getErrorMsg(fe)
		}
	} else {
		out["error"] = err.Error()
	}

	return out
}

// getErrorMsg merubah tag validator jadi bahasa yang manusiawi
func getErrorMsg(fe validator.FieldError) string {
	switch fe.Tag() {
	case "required":
		return "Field ini wajib diisi"
	case "email":
		return "Format email tidak valid"
	case "min":
		return fmt.Sprintf("Minimal %s karakter", fe.Param())
	case "max":
		return fmt.Sprintf("Maksimal %s karakter", fe.Param())
	case "url":
		return "Harus berupa URL valid"
	case "oneof":
		return fmt.Sprintf("Harus salah satu dari: %s", fe.Param())
	case "numeric":
		return "Harus berupa angka"
	case "len":
		return fmt.Sprintf("Panjang harus tepat %s karakter", fe.Param())
	}
	return "Input tidak valid"
}
