package rdb

import (
	"database/sql"
	"time"
)

type Image struct {
	ImageID   int
	ImageURL  string
	EmotionID int
	Gender    string
	CreatedAt time.Time
}

type ImageOperator struct {
	Connetion *sql.DB
}

func (o *ImageOperator) Insert(image *Image) error {
	query := "insert into images (image_url, gender, created_at, emotion_id) values(?,?,?,?);"
	_, err := o.Connetion.Exec(query, image.ImageURL, image.Gender, image.CreatedAt, image.EmotionID)
	if err != nil {
		return err
	}

	return nil
}

func (o *ImageOperator) Select(emo_id string) (*[]Image, error) {
	query := "select * from images where emotion_id = ? order by created_at desc;"
	rows, err := o.Connetion.Query(query, emo_id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var images []Image
	for rows.Next() {
		var image Image
		err := rows.Scan(
			&image.ImageID,
			&image.ImageURL,
			&image.Gender,
			&image.CreatedAt,
			&image.EmotionID,
		)
		if err != nil {
			return nil, err
		}
		images = append(images, image)
	}
	return &images, nil
}
