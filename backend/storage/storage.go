package storage

import (
	"context"
	"io"
	"io/ioutil"

	"cloud.google.com/go/storage"
)

const (
	BUCKET_NAME = "kawai-storage"
)

type StorageContext struct {
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
		Bucket:  bck,
		Context: &ctx,
	}, nil
}

func (s *StorageContext) CreateFile(fileName string, reader io.Reader) error {
	obj := s.Bucket.Object(fileName)
	buff, err := ioutil.ReadAll(reader)
	if err != nil {
		return err
	}

	writer := obj.NewWriter(*s.Context)
	if _, err := writer.Write(buff); err != nil {
		return err
	}
	if err := writer.Close(); err != nil {
		return err
	}
	return nil
}
