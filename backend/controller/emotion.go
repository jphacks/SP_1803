package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/rdb"
)

func ListEmotions(c *gin.Context) {
	emoOpe := &rdb.EmotionOperator{
		Connection: dbContext.Connection,
	}

	emos, err := emoOpe.Select()
	if err != nil {
		internalServgerErrorResponse(c, "get emos", err)
	}
	c.JSON(http.StatusOK, emos)
}
