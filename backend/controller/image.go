package controller

import (
	"encoding/json"
	"log"
	"mime/multipart"
	"net/http"
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
}

func PostImage(c *gin.Context) {
	start := time.Now()
	form, err := c.MultipartForm()
	if err != nil {
		internalServgerErrorResponse(c, "get multipartform", err)
		return
	}
	end := time.Now()
	duration := end.Sub(start)
	log.Println("multipartform time", duration.Seconds())
	log.Println("form", form)

	start = time.Now()
	prop, err := getProp(form)
	if err != nil {
		internalServgerErrorResponse(c, "get prop", err)
		return
	}
	end = time.Now()
	duration = end.Sub(start)
	log.Println("get prop time", duration.Seconds())
	log.Println("prop", prop)

	start = time.Now()
	file, name, err := getMultipartFile(form)
	if err != nil {
		internalServgerErrorResponse(c, "get image", err)
		return
	}
	end = time.Now()
	duration = end.Sub(start)
	log.Println("get file time", duration.Seconds())
	log.Println("image", file)

	start = time.Now()
	if err = storageContext.CreateFile(name, *file); err != nil {
		internalServgerErrorResponse(c, "create gcs file", err)
		return
	}
	end = time.Now()
	duration = end.Sub(start)
	log.Println("storage create time", duration.Seconds())

	start = time.Now()
	url, err := storageContext.GetURL(name)
	if err != nil {
		internalServgerErrorResponse(c, "get file url", err)
		return
	}
	end = time.Now()
	duration = end.Sub(start)
	log.Println("storage get url time", duration.Seconds())
	log.Println("url", url)

	start = time.Now()
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
	end = time.Now()
	duration = end.Sub(start)
	log.Println("insert recode time", duration.Seconds())

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
		}
		vms = append(vms, vm)
	}
	return &vms
}
