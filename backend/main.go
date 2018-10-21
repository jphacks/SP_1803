package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/controller"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.POST("/images", controller.PostImage)
	app.GET("/images", controller.ListImages)
	app.POST("/images/:image_id/good", controller.GoodImage)
	app.GET("/images/:image_id", controller.DetailImage)
	app.GET("/emotions", controller.ListEmotions)
	app.Run()
}
