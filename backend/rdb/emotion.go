package rdb

import (
	"database/sql"
)

type Emotion struct {
	EmotionID   int
	EmotionName string
}

type EmotionOperator struct {
	Connection *sql.DB
}

func (o *EmotionOperator) Select() (*[]Emotion, error) {
	query := "select * from emotions;"
	rows, err := o.Connection.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var emotions []Emotion
	for rows.Next() {
		var emo Emotion
		if err := rows.Scan(&emo.EmotionID, &emo.EmotionName); err != nil {
			return nil, err
		}
		emotions = append(emotions, emo)
	}
	return &emotions, nil
}
