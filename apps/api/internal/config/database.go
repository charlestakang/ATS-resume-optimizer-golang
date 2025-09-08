package config

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/joho/godotenv"
	"github.com/sirupsen/logrus"
)

// DatabaseConfig holds all database configuration
type DatabaseConfig struct {
	Host            string
	Port            int
	User            string
	Password        string
	Database        string
	SSLMode         string
	TimeZone        string
	MaxOpenConns    int
	MaxIdleConns    int
	ConnMaxLifetime time.Duration
	ConnMaxIdleTime time.Duration
	
	// Connection retries
	MaxRetries    int
	RetryInterval time.Duration
	
	// Performance settings
	SlowQueryThreshold time.Duration
	EnableLogging      bool
}

// RedisConfig holds Redis configuration
type RedisConfig struct {
	Host     string
	Port     int
	Password string
	Database int
	PoolSize int
	
	// Connection settings
	DialTimeout  time.Duration
	ReadTimeout  time.Duration
	WriteTimeout time.Duration
	PoolTimeout  time.Duration
	
	// Retry settings
	MaxRetries      int
	MinRetryBackoff time.Duration
	MaxRetryBackoff time.Duration
}

// Config holds all application configuration
type Config struct {
	Database DatabaseConfig
	Redis    RedisConfig
	
	// Application settings
	Environment string
	LogLevel    string
	LogFormat   string
	
	// Server settings
	Port string
	Host string
	
	// JWT settings
	JWTSecret    string
	JWTExpiresIn time.Duration
	
	// CORS settings
	CORSAllowedOrigins []string
	CORSAllowedMethods []string
	CORSAllowedHeaders []string
	
	// Rate limiting
	RateLimitEnabled  bool
	RateLimitRequests int
	RateLimitWindow   time.Duration
}

// LoadConfig loads configuration from environment variables
func LoadConfig() (*Config, error) {
	// Load .env file if it exists (for development)
	if err := godotenv.Load(); err != nil {
		logrus.Debug("No .env file found, using environment variables")
	}
	
	config := &Config{
		Database: DatabaseConfig{
			Host:               getEnvOrDefault("DB_HOST", "localhost"),
			Port:               getEnvAsIntOrDefault("DB_PORT", 5432),
			User:               getEnvOrDefault("DB_USER", "resumesync"),
			Password:           getEnvOrDefault("DB_PASSWORD", "resumesync123"),
			Database:           getEnvOrDefault("DB_NAME", "resumesync_db"),
			SSLMode:            getEnvOrDefault("DB_SSL_MODE", "disable"),
			TimeZone:           getEnvOrDefault("DB_TIMEZONE", "UTC"),
			MaxOpenConns:       getEnvAsIntOrDefault("DB_MAX_OPEN_CONNS", 25),
			MaxIdleConns:       getEnvAsIntOrDefault("DB_MAX_IDLE_CONNS", 10),
			ConnMaxLifetime:    getEnvAsDurationOrDefault("DB_MAX_LIFETIME", 5*time.Minute),
			ConnMaxIdleTime:    getEnvAsDurationOrDefault("DB_MAX_IDLE_TIME", 10*time.Minute),
			MaxRetries:         getEnvAsIntOrDefault("DB_MAX_RETRIES", 3),
			RetryInterval:      getEnvAsDurationOrDefault("DB_RETRY_INTERVAL", 5*time.Second),
			SlowQueryThreshold: getEnvAsDurationOrDefault("DB_SLOW_QUERY_THRESHOLD", 1*time.Second),
			EnableLogging:      getEnvAsBoolOrDefault("DB_ENABLE_LOGGING", true),
		},
		Redis: RedisConfig{
			Host:            getEnvOrDefault("REDIS_HOST", "localhost"),
			Port:            getEnvAsIntOrDefault("REDIS_PORT", 6379),
			Password:        getEnvOrDefault("REDIS_PASSWORD", ""),
			Database:        getEnvAsIntOrDefault("REDIS_DB", 0),
			PoolSize:        getEnvAsIntOrDefault("REDIS_POOL_SIZE", 10),
			DialTimeout:     getEnvAsDurationOrDefault("REDIS_DIAL_TIMEOUT", 5*time.Second),
			ReadTimeout:     getEnvAsDurationOrDefault("REDIS_READ_TIMEOUT", 3*time.Second),
			WriteTimeout:    getEnvAsDurationOrDefault("REDIS_WRITE_TIMEOUT", 3*time.Second),
			PoolTimeout:     getEnvAsDurationOrDefault("REDIS_POOL_TIMEOUT", 4*time.Second),
			MaxRetries:      getEnvAsIntOrDefault("REDIS_MAX_RETRIES", 3),
			MinRetryBackoff: getEnvAsDurationOrDefault("REDIS_MIN_RETRY_BACKOFF", 8*time.Millisecond),
			MaxRetryBackoff: getEnvAsDurationOrDefault("REDIS_MAX_RETRY_BACKOFF", 512*time.Millisecond),
		},
		
		// Application settings
		Environment: getEnvOrDefault("APP_ENV", "development"),
		LogLevel:    getEnvOrDefault("LOG_LEVEL", "debug"),
		LogFormat:   getEnvOrDefault("LOG_FORMAT", "json"),
		
		// Server settings
		Port: getEnvOrDefault("APP_PORT", "8080"),
		Host: getEnvOrDefault("APP_HOST", "0.0.0.0"),
		
		// JWT settings
		JWTSecret:    getEnvOrDefault("JWT_SECRET", "your-secret-key-change-in-production-must-be-32-chars"),
		JWTExpiresIn: getEnvAsDurationOrDefault("JWT_EXPIRES_IN", 24*time.Hour),
		
		// CORS settings
		CORSAllowedOrigins: getEnvAsSliceOrDefault("CORS_ALLOWED_ORIGINS", []string{"http://localhost:3000"}),
		CORSAllowedMethods: getEnvAsSliceOrDefault("CORS_ALLOWED_METHODS", []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}),
		CORSAllowedHeaders: getEnvAsSliceOrDefault("CORS_ALLOWED_HEADERS", []string{"Content-Type", "Authorization", "X-Requested-With"}),
		
		// Rate limiting
		RateLimitEnabled:  getEnvAsBoolOrDefault("RATE_LIMIT_ENABLED", true),
		RateLimitRequests: getEnvAsIntOrDefault("RATE_LIMIT_REQUESTS", 100),
		RateLimitWindow:   getEnvAsDurationOrDefault("RATE_LIMIT_WINDOW", 1*time.Minute),
	}
	
	// Validate required configuration
	if err := validateConfig(config); err != nil {
		return nil, fmt.Errorf("configuration validation failed: %w", err)
	}
	
	return config, nil
}

// GetDatabaseDSN returns the PostgreSQL connection string
func (c *Config) GetDatabaseDSN() string {
	return fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s TimeZone=%s",
		c.Database.Host,
		c.Database.Port,
		c.Database.User,
		c.Database.Password,
		c.Database.Database,
		c.Database.SSLMode,
		c.Database.TimeZone,
	)
}

// GetRedisAddress returns the Redis connection address
func (c *Config) GetRedisAddress() string {
	return fmt.Sprintf("%s:%d", c.Redis.Host, c.Redis.Port)
}

// IsDevelopment returns true if running in development environment
func (c *Config) IsDevelopment() bool {
	return c.Environment == "development"
}

// IsProduction returns true if running in production environment
func (c *Config) IsProduction() bool {
	return c.Environment == "production"
}

// validateConfig validates the configuration for required fields
func validateConfig(config *Config) error {
	if config.Database.Host == "" {
		return fmt.Errorf("database host is required")
	}
	if config.Database.User == "" {
		return fmt.Errorf("database user is required")
	}
	if config.Database.Password == "" {
		return fmt.Errorf("database password is required")
	}
	if config.Database.Database == "" {
		return fmt.Errorf("database name is required")
	}
	if config.JWTSecret == "" || config.JWTSecret == "your-secret-key-change-in-production-must-be-32-chars" {
		if config.IsProduction() {
			return fmt.Errorf("JWT secret must be set in production")
		}
		logrus.Warn("Using default JWT secret - change this in production!")
	}
	if len(config.JWTSecret) < 32 {
		return fmt.Errorf("JWT secret must be at least 32 characters long")
	}
	
	return nil
}

// Helper functions for environment variable parsing

func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvAsIntOrDefault(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
		logrus.Warnf("Invalid integer value for %s: %s, using default: %d", key, value, defaultValue)
	}
	return defaultValue
}

func getEnvAsBoolOrDefault(key string, defaultValue bool) bool {
	if value := os.Getenv(key); value != "" {
		if boolValue, err := strconv.ParseBool(value); err == nil {
			return boolValue
		}
		logrus.Warnf("Invalid boolean value for %s: %s, using default: %t", key, value, defaultValue)
	}
	return defaultValue
}

func getEnvAsDurationOrDefault(key string, defaultValue time.Duration) time.Duration {
	if value := os.Getenv(key); value != "" {
		if duration, err := time.ParseDuration(value); err == nil {
			return duration
		}
		logrus.Warnf("Invalid duration value for %s: %s, using default: %v", key, value, defaultValue)
	}
	return defaultValue
}

func getEnvAsSliceOrDefault(key string, defaultValue []string) []string {
	if value := os.Getenv(key); value != "" {
		return parseCommaSeparated(value)
	}
	return defaultValue
}

// parseCommaSeparated splits a comma-separated string into a slice
func parseCommaSeparated(value string) []string {
	if value == "" {
		return []string{}
	}
	
	var result []string
	for _, item := range splitAndTrim(value, ",") {
		if item != "" {
			result = append(result, item)
		}
	}
	return result
}

// splitAndTrim splits a string by separator and trims whitespace
func splitAndTrim(s, sep string) []string {
	var result []string
	for _, item := range parseByDelimiter(s, sep) {
		trimmed := trimWhitespace(item)
		if trimmed != "" {
			result = append(result, trimmed)
		}
	}
	return result
}

// parseByDelimiter splits string by delimiter
func parseByDelimiter(s, delimiter string) []string {
	if s == "" {
		return []string{}
	}
	
	var result []string
	current := ""
	
	for i := 0; i < len(s); i++ {
		if i <= len(s)-len(delimiter) && s[i:i+len(delimiter)] == delimiter {
			result = append(result, current)
			current = ""
			i += len(delimiter) - 1
		} else {
			current += string(s[i])
		}
	}
	
	result = append(result, current)
	return result
}

// trimWhitespace removes leading and trailing whitespace
func trimWhitespace(s string) string {
	start := 0
	end := len(s) - 1
	
	// Find first non-whitespace character
	for start <= end && isWhitespace(s[start]) {
		start++
	}
	
	// Find last non-whitespace character
	for end >= start && isWhitespace(s[end]) {
		end--
	}
	
	if start > end {
		return ""
	}
	
	return s[start : end+1]
}

// isWhitespace checks if character is whitespace
func isWhitespace(c byte) bool {
	return c == ' ' || c == '\t' || c == '\n' || c == '\r'
}