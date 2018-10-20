package rdb

import (
	"database/sql"
	"fmt"
	"os"

	// MySQL library, comment out to use PostgreSQL.
	_ "github.com/go-sql-driver/mysql"
)

const (
	DB_DRIVER = "mysql"
	SOCKET    = "/cloudsql"
)

var (
	connectionName = os.Getenv("CLOUDSQL_CONNECTION_NAME")
	user           = os.Getenv("CLOUDSQL_USER")
	pass           = os.Getenv("CLOUDSQL_PASSWORD")
	dbURI          = fmt.Sprintf("%s:%s@unix(%s/%s)/", user, pass, SOCKET, connectionName)
)

type DBContext struct {
	Connection *sql.DB
}

func GetDBContext() (*DBContext, error) {
	conn, err := sql.Open(DB_DRIVER, dbURI)
	if err != nil {
		return nil, err
	}
	return &DBContext{Connection: conn}, nil
}
