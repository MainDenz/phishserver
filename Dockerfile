FROM golang:1.21-alpine AS builder
RUN apk add --no-cache git gcc musl-dev sqlite
WORKDIR /app
COPY . .
RUN go build -o gophish

FROM alpine:latest
RUN apk add --no-cache ca-certificates sqlite
WORKDIR /app
COPY --from=builder /app/gophish .
COPY --from=builder /app/config.json .
COPY --from=builder /app/static ./static
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/db ./db
EXPOSE 3333 80
CMD ["./gophish"]
