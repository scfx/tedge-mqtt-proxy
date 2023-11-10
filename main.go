package main

import (
	"log"
	"net/http"
	"os"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/gorilla/mux"
)

func main() {
	logger := log.New(os.Stdout, "proxy: ", log.LstdFlags)
	url := "mqtt://localhost:1883"
	opts := mqtt.NewClientOptions().AddBroker(url).SetAutoReconnect(true).SetClientID("tedge-proxy")
	opts.OnConnect = onConnect(logger)
	opts.OnConnectionLost = onConnectionLost(logger)
	client := mqtt.NewClient(opts)
	go connect(client, logger)
	th := NewTedgeHandler(&client, logger)
	r := mux.NewRouter()
	r.SkipClean(true)
	//Wildcard /te path
	r.PathPrefix("/te/").Handler(th)

	//Wildcard /tedge path
	r.PathPrefix("/tedge/").Handler(th)

	//Wildcard /c8y path
	r.PathPrefix("/c8y/").Methods(http.MethodPost).Handler(th)
	if err := http.ListenAndServe(":8020", r); err != nil {
		logger.Printf("Error starting server: %s", err)
	}

}

func onConnect(logger *log.Logger) func(client mqtt.Client) {
	return func(client mqtt.Client) {
		client.Publish("te/device/main/service/tedge-mqtt-proxy", 0, false, "{\"@type\": \"service\",\"name\":\"tedge-mqtt-proxy\",\"type\":\"systemd\"}")
		logger.Println("Connected to MQTT broker")

	}
}

func onConnectionLost(logger *log.Logger) func(client mqtt.Client, err error) {
	return func(client mqtt.Client, err error) {
		logger.Printf("Connection lost: %s", err)
	}
}

func connect(client mqtt.Client, logger *log.Logger) {
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		logger.Printf("Error connecting to broker: %s", token.Error())
		time.Sleep(5 * time.Second)
		connect(client, logger)
	}
}
