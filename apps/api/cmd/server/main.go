package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
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

    log.Printf("Server starting on port %s (version=%s build=%s)", port, Version, BuildTime)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err)
    }
}
