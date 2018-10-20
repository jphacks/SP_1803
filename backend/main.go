package main

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"net/http"

	"cloud.google.com/go/storage"
	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/rdb"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.GET("/db", handler)
	app.GET("/storage", storagehander)
	app.Run()
}

func handler(c *gin.Context) {
	context, err := rdb.GetDBContext()
	if err != nil {
		c.Status(http.StatusInternalServerError)
	}
	conn := context.Connection

	rows, err := conn.Query("SHOW DATABASES")
	if err != nil {
		log.Printf("Could not query db: %v", err)
		c.Status(http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	buf := bytes.NewBufferString("Databases:\n")
	for rows.Next() {
		var dbName string
		if err := rows.Scan(&dbName); err != nil {
			log.Printf("Could not scan result: %v", err)
			c.Status(http.StatusInternalServerError)
			return
		}
		fmt.Fprintf(buf, "- %s\n", dbName)
	}
	c.String(http.StatusOK, "%s", buf.String())
}

func storagehander(c *gin.Context) {
	ctx := context.Background()
	// Sets your Google Cloud Platform project ID.
	projectID := "seventh-aquifer-219706"

	// Creates a client.
	client, err := storage.NewClient(ctx)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
		c.Status(500)
		return
	}

	// Sets the name for the new bucket.
	bucketName := "my-new-bucket"

	// Creates a Bucket instance.
	bucket := client.Bucket(bucketName)

	// Creates the new bucket.
	if err := bucket.Create(ctx, projectID, nil); err != nil {
		log.Fatalf("Failed to create bucket: %v", err)
		c.Status(500)
		return
	}

	fmt.Printf("Bucket %v created.\n", bucketName)
	c.Status(200)
}
