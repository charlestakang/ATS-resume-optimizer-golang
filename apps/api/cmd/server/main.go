package main

import (
    "context"
    "fmt"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

// These are set via -ldflags during build
var (
    Version   string
    BuildTime string
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        fmt.Fprintf(w, "OK")
    })

    // Configure HTTP server with proper timeouts
    server := &http.Server{
        Addr:         ":" + port,
        Handler:      nil, // Use DefaultServeMux
        ReadTimeout:  15 * time.Second,
        WriteTimeout: 15 * time.Second,
        IdleTimeout:  60 * time.Second,
    }

    // Start server in a goroutine
    serverErr := make(chan error, 1)
    go func() {
        log.Printf("Server starting on port %s (version=%s build=%s)", port, Version, BuildTime)
        if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
            serverErr <- err
        }
    }()

    // Set up signal handling for graceful shutdown
    ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
    defer stop()

    // Wait for interrupt signal or server error
    select {
    case err := <-serverErr:
        log.Printf("Server error: %v", err)
        return
    case <-ctx.Done():
        log.Println("Shutdown signal received, gracefully shutting down...")
    }

    // Create shutdown context with timeout
    shutdownCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    // Gracefully shutdown the server
    if err := server.Shutdown(shutdownCtx); err != nil {
        log.Printf("Server shutdown error: %v", err)
        return
    }

    log.Println("Server shutdown complete")
}
