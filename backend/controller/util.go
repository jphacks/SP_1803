package controller

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func internalServgerErrorResponse(c *gin.Context, message string, err error) {
	text := fmt.Sprintf("ERR: %s: %s", message, err)
	log.Printf(text)
	c.JSON(http.StatusInternalServerError, gin.H{
		"message": text,
	})
}
