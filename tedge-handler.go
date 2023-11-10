package main

import (
	"io"
	"log"
	"net/http"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

type TedgeHandler struct {
	client *mqtt.Client
	logger *log.Logger
}

func (h *TedgeHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// Read request Body
	payload, err := io.ReadAll(r.Body)
	if err != nil {
		h.logger.Printf("Error reading request body: %s", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	//Topic
	topic := r.URL.Path[1:]

	h.logger.Printf("Publish Message: %s on Topic: %s", payload, topic)
	//Publish to MQTT broker
	if token := (*h.client).Publish(topic, 0, false, string(payload)); token.Wait() && token.Error() != nil {
		h.logger.Printf("Error publishing message: %s", token.Error())
		if token.Error() == mqtt.ErrNotConnected {
			http.Error(w, "Not connected to MQTT broker", http.StatusServiceUnavailable)
			return
		} else {
			http.Error(w, token.Error().Error(), http.StatusBadRequest)
			return
		}
	}
	//Return 200
	w.WriteHeader(http.StatusCreated)

}

func NewTedgeHandler(c *mqtt.Client, l *log.Logger) *TedgeHandler {
	return &TedgeHandler{
		client: c,
		logger: l,
	}
}
