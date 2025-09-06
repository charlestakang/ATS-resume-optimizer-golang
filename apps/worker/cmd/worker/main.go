package main

import (
    "context"
    "fmt"
    "log"
    "os"
    "os/signal"
    "sync"
    "syscall"
    "time"
)

// These are set via -ldflags during build
var (
    Version   string
    BuildTime string
)

func main() {
    log.Printf("Worker starting... (version=%s build=%s)", Version, BuildTime)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Create a channel to listen for interrupt signals
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)

	var wg sync.WaitGroup

	// Start worker loop in goroutine
	wg.Add(1)
	go func() {
		defer wg.Done()
		ticker := time.NewTicker(5 * time.Second)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				log.Println("Worker received shutdown signal, exiting loop")
				return
			case <-ticker.C:
				// Process jobs here, respecting ctx for cancellation
				log.Println("Worker processing jobs...")
				// Example: check ctx while doing work
			}
		}
	}()

	// Wait for signal
	<-sigCh
	log.Println("Worker shutting down... sending cancel to goroutines")
	cancel()

    // Wait for goroutines to finish
    wg.Wait()
    fmt.Println("Worker shutdown complete")
}
