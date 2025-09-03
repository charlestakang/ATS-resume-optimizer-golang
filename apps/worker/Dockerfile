# Production multi-stage Dockerfile for Golang Worker
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    ca-certificates \
    tzdata

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum* ./

# Download dependencies with cache
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Copy source code
COPY . .

# Build the binary with optimizations
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s -X main.Version=$(git describe --tags --always --dirty) -X main.BuildTime=$(date -u +%Y-%m-%d_%H:%M:%S)" \
    -a -installsuffix cgo -o worker ./cmd/worker

# Final stage: minimal runtime image
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S worker && \
    adduser -u 1001 -S worker -G worker

# Set working directory
WORKDIR /app

# Copy timezone data
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Copy the binary from builder
COPY --from=builder /app/worker /app/worker

# Create necessary directories
RUN mkdir -p /app/logs /app/processing /app/exports && \
    chown -R worker:worker /app

# Set environment variables
ENV WORKER_ENV=production

# Use non-root user
USER worker

# No EXPOSE needed for worker (communicates via Redis/DB)

# Health check - worker should have a health endpoint or check Redis connectivity
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgrep -x worker || exit 1

# Run the binary
CMD ["./worker"]