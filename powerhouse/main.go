package main

import (
	"log"
	"net/http"
)

type server struct {
	state int
}

func NewServer() *server {
	state := 0
	return &server{state: state}
}

func (s *server) healthcheckHandler(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte("ok"))
}

func main() {
	mux := http.NewServeMux()
	server := NewServer()

	mux.HandleFunc("GET /healthcheck", server.healthcheckHandler)

	log.Println("Server running on port 8080")
	err := http.ListenAndServe(":8080", mux)
	if err != nil {
		log.Fatal("Error starting server:", err)
	}
}
