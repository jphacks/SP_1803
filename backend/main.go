package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.POST("/images", func(c *gin.Context) {

		// reader, err := c.Request.MultipartReader()
		// if err != nil {
		// 	log.Println(err)
		// 	c.Status(500)
		// 	return
		// }
		// for {
		// 	mimePart, err := reader.NextPart()
		// 	if err == io.EOF {
		// 		break
		// 	}
		// 	if err != nil {
		// 		log.Println(err)
		// 		c.Status(500)
		// 		return
		// 	}

		// 	disposition, params, err := mime.ParseMediaType(mimePart.Header.Get("Content-Disposition"))
		// 	if err != nil {
		// 		log.Println(err)
		// 		c.Status(500)
		// 		return
		// 	}
		// 	log.Printf("%+v\n", disposition)
		// 	log.Printf("%+v\n", params)
		// }
		form, err := c.MultipartForm()
		if err != nil {
			log.Println(err)
			c.Status(500)
			return
		}
		log.Printf("%+v\n", form)

		c.Status(200)
	})
	app.Run()
}
