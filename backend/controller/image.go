package controller

import (
	"encoding/json"
	"log"
	"mime/multipart"

	"github.com/gin-gonic/gin"
)

type Prop struct {
	EmotionID string `json:"emotion_id"`
	Gender    string `json:"gender"`
	CreatedAt string `json:"created_at"`
}

func PostImage(c *gin.Context) {
	form, err := c.MultipartForm()
	if err != nil {
		internalServgerErrorResponse(c, "get multipartform", err)
		return
	}
	log.Println("form", form)

	prop, err := getProp(form)
	if err != nil {
		internalServgerErrorResponse(c, "get prop", err)
		return
	}
	log.Println("prop", prop)

	file, name, err := getMultipartFile(form)
	if err != nil {
		internalServgerErrorResponse(c, "get image", err)
		return
	}
	log.Println("image", file)

	if err = storageContext.CreateFile(name, *file); err != nil {
		internalServgerErrorResponse(c, "create gcs file", err)
		return
	}

	okResponse(c, "done create image file on GCS")
	return
}

func getProp(form *multipart.Form) (*Prop, error) {
	propString := form.Value["prop"][0]
	var prop Prop
	err := json.Unmarshal([]byte(propString), &prop)
	if err != nil {
		return nil, err
	}
	return &prop, nil
}

func getMultipartFile(form *multipart.Form) (*multipart.File, string, error) {
	fileHeader := form.File["image"][0]
	file, err := fileHeader.Open()
	if err != nil {
		return nil, "", err
	}
	return &file, fileHeader.Filename, nil
}
