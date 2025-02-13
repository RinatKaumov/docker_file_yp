FROM golang:1.22 AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o tracker

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache sqlite

COPY --from=builder /app/tracker /app/
COPY tracker.db /app/

EXPOSE 8080

RUN chmod +x /app/tracker

ENTRYPOINT ["/app/tracker"]
