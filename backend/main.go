package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jphacks/SP_1803/backend/rdb"
)

func main() {
	app := gin.Default()
	app.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
	app.GET("/db", handler)
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
