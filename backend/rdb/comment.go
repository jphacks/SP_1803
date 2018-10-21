package rdb

import "database/sql"

type Comment struct {
	CommentID      int
	CommentContent string
}

type CommentOperator struct {
	Connection *sql.DB
}
