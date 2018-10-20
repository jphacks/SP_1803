package controller

import (
	"fmt"
	"log"
	"net/http"

	"github.com/jphacks/SP_1803/backend/rdb"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/storage"
)

var (
	storageContext *storage.StorageContext
	dbContext      *rdb.DBContext
)

func init() {
	var err error
	storageContext, err = storage.NewStorageContext()
	if err != nil {
		log.Fatal("ERR:init storage context:", err)
	}
	dbContext, err = rdb.NewDBContext()
	if err != nil {
		log.Fatal("ERR:init db context:", err)
	}

}

func okResponse(c *gin.Context, message string) {
	text := fmt.Sprintf("INFO: %s", message)
	log.Println(text)
	c.JSON(http.StatusOK, gin.H{
		"message": text,
	})
}

func internalServgerErrorResponse(c *gin.Context, message string, err error) {
	text := fmt.Sprintf("ERR: %s: %s", message, err)
	log.Printf(text)
	c.JSON(http.StatusInternalServerError, gin.H{
		"message": text,
	})
}
