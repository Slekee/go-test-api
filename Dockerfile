FROM golang:alpine as builder

ENV GIN_MODE=release

WORKDIR /go/src/
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o backend .

FROM alpine:latest

RUN addgroup -S appuser && adduser -S appuser -G appuser
COPY --chown=appuser:appuser --from=builder /go/src .
USER appuser

EXPOSE 8080
ENTRYPOINT ["./backend"]