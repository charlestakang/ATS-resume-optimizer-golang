# Production multi-stage Dockerfile for Golang API
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

# Note: Copy libs from monorepo if needed
# COPY ../../libs /libs

# Build the binary with optimizations
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s -X main.Version=$(git describe --tags --always --dirty 2>/dev/null || echo 'unknown') -X main.BuildTime=$(date -u +%Y-%m-%d_%H:%M:%S 2>/dev/null || echo 'unknown')" \
    -a -installsuffix cgo -o api ./cmd/server

# Final stage: minimal runtime image
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S api && \
    adduser -u 1001 -S api -G api

# Set working directory
WORKDIR /app

# Copy timezone data
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Copy the binary from builder
COPY --from=builder /app/api /app/api

# Note: Copy static files or templates if they exist in your project
# COPY --from=builder /app/static /app/static
# COPY --from=builder /app/templates /app/templates

# Create necessary directories
RUN mkdir -p /app/logs /app/uploads && \
    chown -R api:api /app

# Set environment variables
ENV GIN_MODE=release
ENV PORT=8080

# Use non-root user
USER api

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the binary
CMD ["./api"]