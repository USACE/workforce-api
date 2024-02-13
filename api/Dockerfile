# BASE IMAGE
# FROM golang:1.21-alpine3.18 AS base
FROM public.ecr.aws/docker/library/golang:1.21-alpine3.18 AS base
# Install Git
RUN apk update && apk add --no-cache ca-certificates

# Copy In Source Code
WORKDIR /go/src/app
COPY . .

# Install Dependencies
RUN go mod download && \
    go mod verify

# ----------------------------------------------------------------------
# IMAGE FOR DEVELOPMENT
FROM base as development
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go get github.com/go-delve/delve

# ----------------------------------------------------------------------
# SCRATCH IMAGE FOR PRODUCTION
FROM base as production

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
    go build -ldflags="-w -s" -o /go/bin/api

# ----------------------------------------------------------------------

FROM scratch
COPY --from=production /go/bin/api /go/bin/api
COPY --from=base /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/go/bin/api"]
