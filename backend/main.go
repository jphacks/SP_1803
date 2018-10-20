package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(200)
	})
	app.Run()
}
