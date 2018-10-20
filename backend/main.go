package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/controller"
)

type Prop struct {
	UserID    string `json:"user_id"`
	EmotionID string `json:"emotion_id"`
	Gender    string `json:"gender"`
	CreatedAt string `json:"created_at"`
}

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.POST("/images", controller.PostImage)
	app.GET("/images", controller.ListImages)
	app.GET("/emotions", controller.ListEmotions)
	app.Run()
}
