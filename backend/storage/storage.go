package storage

import (
	"context"
	"log"

	"cloud.google.com/go/storage"
)

const (
	BUCKET_NAME = "kawai-storage"
)

type StorageContext struct {
	Client  *storage.Client
	Bucket  *storage.BucketHandle
	Context *context.Context
}

func NewStorageContext() (*StorageContext, error) {
	ctx := context.Background()
	cli, err := storage.NewClient(ctx)
	if err != nil {
		return nil, err
	}
	bck := cli.Bucket(BUCKET_NAME)
	return &StorageContext{
		Client:  cli,
		Bucket:  bck,
		Context: &ctx,
	}, nil
}

func (s *StorageContext) CreateFile(fileName string) {
	obj := s.Bucket.Object(fileName)
	log.Println(obj)
}
