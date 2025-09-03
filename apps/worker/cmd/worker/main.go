package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	log.Println("Worker starting...")

	// Create a channel to listen for interrupt signals
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	// Start worker loop in goroutine
	go func() {
		for {
			log.Println("Worker processing jobs...")
			time.Sleep(5 * time.Second)
		}
	}()

	// Wait for signal
	<-c
	fmt.Println("\nWorker shutting down...")
}