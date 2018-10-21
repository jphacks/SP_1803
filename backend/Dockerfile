FROM golang:1.11.1-alpine3.8 AS build-env
WORKDIR /go/src/github.com/jphacks/SP_1803/backend
COPY ./ /go/src/github.com/jphacks/SP_1803/backend
RUN go build -o server main.go

FROM alpine:latest
COPY --from=build-env /go/src/github.com/jphacks/SP_1803/backend/server /usr/local/bin/server
COPY ./key.pem /opt/
COPY ./seventh-aquifer-219706-52f6d2dc3c01.json /opt/
ENV CLOUDSQL_USER=root 
ENV CLOUDSQL_PASSWORD=O5IANCsl9Hmu0Be3
ENV CLOUDSQL_HOST=35.232.152.93 
ENV CLOUDSQL_DB=kawai_database
ENV GOOGLE_APPLICATION_CREDENTIALS=/opt/seventh-aquifer-219706-52f6d2dc3c01.json
ENV CLOUD_STORAGE_KEY_PATH=/opt/key.pem
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/server"]