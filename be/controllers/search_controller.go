package controllers

import (
	"chat-app-be/repositories"
	"chat-app-be/utils"

	"github.com/gin-gonic/gin"
)

type SearchController struct {
	Repo *repositories.SearchRepository
}

func NewSearchController(repo *repositories.SearchRepository) *SearchController {
	return &SearchController{Repo: repo}
}

// HandleSearch menangani pencarian global
func (c *SearchController) HandleSearch(ctx *gin.Context) {
	query := ctx.Query("q")
	if query == "" {
		utils.BadRequest(ctx, "Query pencarian tidak boleh kosong", nil)
		return
	}

	results, err := c.Repo.GlobalSearch(ctx.Request.Context(), query)
	if err != nil {
		utils.InternalError(ctx, "Gagal melakukan pencarian", err)
		return
	}

	utils.SuccessResponse(ctx, "Pencarian berhasil", results)
}
