#Builder

FROM golang:1.21.4 as build-stage

WORKDIR /app

#Build the Go app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /tedge-mqtt-proxy

#Build dpkg package
FROM ubuntu:20.04 as dpkg-build-stage

COPY --from=build-stage /tedge-mqtt-proxy /
COPY package.sh /
COPY tedge-mqtt-proxy.service /
RUN chmod +x /package.sh
RUN /package.sh --version 0.1 --arch amd64

# Runner
FROM ghcr.io/thin-edge/tedge-demo-main-systemd:20231105.1

# Copy the Pre-built binary file from the previous stage
COPY --from=dpkg-build-stage /tedge-mqtt-proxy-0.1.deb /tedge-mqtt-proxy-0.1.deb
RUN apt-get update && apt-get install -y /tedge-mqtt-proxy-0.1.deb