package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.Run()
}
