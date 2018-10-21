package controller

import (
	"encoding/json"
	"log"
	"mime/multipart"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/rdb"
)

type Prop struct {
	EmotionID int    `json:"emotion_id"`
	Gender    string `json:"gender"`
	CreatedAt string `json:"created_at"`
}

type Image struct {
	ImageID  int    `json:"image_id"`
	ImageURL string `json:"image_url"`
	Good     int    `json:"good"`
}

type ImageDetail struct {
	ImageID   int    `json:"image_id"`
	ImageURL  string `json:"image_url"`
	EmotionID int    `json:"emotion_id"`
	Gender    string `json:"gender"`
	Good      int    `json:"good"`
}

func GoodImage(c *gin.Context) {
	imageIDString := c.Param("image_id")
	imageID, err := strconv.Atoi(imageIDString)
	if err != nil {
		internalServgerErrorResponse(c, "convert to string int", err)
		return
	}
	imgOpe := &rdb.ImageOperator{
		Connetion: dbContext.Connection,
	}
	if err = imgOpe.Good(imageID); err != nil {
		internalServgerErrorResponse(c, "cant good rdb", err)
		return
	}
	okResponse(c, "done good")
}

func DetailImage(c *gin.Context) {
	imageIDString := c.Param("image_id")
	imageID, err := strconv.Atoi(imageIDString)
	if err != nil {
		internalServgerErrorResponse(c, "convert to string int", err)
		return
	}
	imgOpe := &rdb.ImageOperator{
		Connetion: dbContext.Connection,
	}
	images, err := imgOpe.GetOne(imageID)
	if err != nil {
		internalServgerErrorResponse(c, "cant good rdb", err)
		return
	}

	one := (*images)[0]

	image := ImageDetail{
		ImageID:   one.ImageID,
		ImageURL:  one.ImageURL,
		EmotionID: one.EmotionID,
		Gender:    one.Gender,
		Good:      one.Good,
	}
	c.JSON(http.StatusOK, image)
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

	url, err := storageContext.GetURL(name)
	if err != nil {
		internalServgerErrorResponse(c, "get file url", err)
		return
	}
	log.Println("url", url)

	imgOpe := rdb.ImageOperator{
		Connetion: dbContext.Connection,
	}

	createdTime, err := time.Parse("2006-01-02 15:04:05", prop.CreatedAt)

	img := rdb.Image{
		ImageURL:  url,
		Gender:    prop.Gender,
		CreatedAt: createdTime,
		EmotionID: prop.EmotionID,
	}
	if err := imgOpe.Insert(&img); err != nil {
		internalServgerErrorResponse(c, "insert image record", err)
		return
	}

	okResponse(c, "done create image file on GCS")
	return
}

func ListImages(c *gin.Context) {
	emoID := c.Query("emotion_id")
	imageOpe := rdb.ImageOperator{
		Connetion: dbContext.Connection,
	}
	images, err := imageOpe.Select(emoID)
	if err != nil {
		internalServgerErrorResponse(c, "cant get images", err)
		return
	}
	vms := parseViewModelImage(images)
	c.JSON(http.StatusOK, vms)
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

func parseViewModelImage(dbImages *[]rdb.Image) *[]Image {
	var vms []Image
	for _, item := range *dbImages {
		vm := Image{
			ImageID:  item.ImageID,
			ImageURL: item.ImageURL,
			Good:     item.Good,
		}
		vms = append(vms, vm)
	}
	return &vms
}
