# ResumeSync Pro - Makefile
# Development and deployment automation

.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m\033[0m"} /^[a-zA-Z0-9_%\-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Docker Commands

.PHONY: up
up: ## Start all services in development mode
	@echo "🚀 Starting all services..."
	@docker-compose up -d
	@echo "✅ Services started! Access at:"
	@echo "   - Frontend: http://localhost:3000"
	@echo "   - Backend API: http://localhost:8080"
	@echo "   - MinIO Console: http://localhost:9001"
	@echo "   - PostgreSQL: localhost:5432"
	@echo "   - Redis: localhost:6379"

.PHONY: down
down: ## Stop all services
	@echo "🛑 Stopping all services..."
	@docker-compose down
	@echo "✅ All services stopped"

.PHONY: restart
restart: down up ## Restart all services
	@echo "✅ All services restarted"

.PHONY: build
build: ## Build all Docker images
	@echo "🔨 Building Docker images..."
	@docker-compose build --no-cache
	@echo "✅ Build complete"

.PHONY: rebuild
rebuild: ## Rebuild and restart all services
	@echo "🔄 Rebuilding all services..."
	@docker-compose down
	@docker-compose build --no-cache
	@docker-compose up -d
	@echo "✅ Rebuild complete"

.PHONY: logs
logs: ## Show logs for all services
	@docker-compose logs -f

.PHONY: logs-api
logs-api: ## Show logs for API service
	@docker-compose logs -f api

.PHONY: logs-web
logs-web: ## Show logs for web service
	@docker-compose logs -f web

.PHONY: logs-worker
logs-worker: ## Show logs for worker service
	@docker-compose logs -f worker

.PHONY: ps
ps: ## Show running services
	@docker-compose ps

.PHONY: clean
clean: ## Stop services and remove volumes
	@echo "🧹 Cleaning up Docker resources..."
	@docker-compose down -v
	@echo "✅ Cleanup complete"

.PHONY: prune
prune: ## Remove all unused Docker resources
	@echo "🧹 Pruning Docker system..."
	@docker system prune -af --volumes
	@echo "✅ Docker system pruned"

##@ Database Commands

.PHONY: db-shell
db-shell: ## Open PostgreSQL shell
	@docker-compose exec postgres psql -U resumesync -d resumesync_dev

.PHONY: db-migrate
db-migrate: ## Run database migrations
	@echo "🔄 Running database migrations..."
	@docker-compose exec api go run cmd/migrate/main.go up
	@echo "✅ Migrations complete"

.PHONY: db-rollback
db-rollback: ## Rollback database migrations
	@echo "⏪ Rolling back migrations..."
	@docker-compose exec api go run cmd/migrate/main.go down 1
	@echo "✅ Rollback complete"

.PHONY: db-seed
db-seed: ## Seed database with test data
	@echo "🌱 Seeding database..."
	@docker-compose exec api go run cmd/seed/main.go
	@echo "✅ Database seeded"

.PHONY: db-reset
db-reset: ## Reset database (drop, create, migrate, seed)
	@echo "🔄 Resetting database..."
	@docker-compose exec postgres psql -U resumesync -c "DROP DATABASE IF EXISTS resumesync_dev;"
	@docker-compose exec postgres psql -U resumesync -c "CREATE DATABASE resumesync_dev;"
	@$(MAKE) db-migrate
	@$(MAKE) db-seed
	@echo "✅ Database reset complete"

.PHONY: db-backup
db-backup: ## Backup database
	@echo "💾 Backing up database..."
	@mkdir -p backups
	@docker-compose exec postgres pg_dump -U resumesync resumesync_dev > backups/backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "✅ Database backed up to backups/"

.PHONY: redis-cli
redis-cli: ## Open Redis CLI
	@docker-compose exec redis redis-cli

##@ Development Commands

.PHONY: dev
dev: ## Start development environment with hot reload
	@echo "🔥 Starting development with hot reload..."
	@docker-compose up

.PHONY: dev-api
dev-api: ## Start only API in development mode
	@docker-compose up api

.PHONY: dev-web
dev-web: ## Start only web in development mode
	@docker-compose up web

.PHONY: dev-worker
dev-worker: ## Start only worker in development mode
	@docker-compose up worker

.PHONY: shell-api
shell-api: ## Open shell in API container
	@docker-compose exec api /bin/sh

.PHONY: shell-web
shell-web: ## Open shell in web container
	@docker-compose exec web /bin/sh

.PHONY: shell-worker
shell-worker: ## Open shell in worker container
	@docker-compose exec worker /bin/sh

##@ Testing Commands

.PHONY: test
test: ## Run all tests
	@echo "🧪 Running all tests..."
	@$(MAKE) test-api
	@$(MAKE) test-web
	@$(MAKE) test-worker
	@echo "✅ All tests passed"

.PHONY: test-api
test-api: ## Run API tests
	@echo "🧪 Running API tests..."
	@docker-compose exec api go test -v ./...

.PHONY: test-web
test-web: ## Run web tests
	@echo "🧪 Running web tests..."
	@docker-compose exec web npm test

.PHONY: test-worker
test-worker: ## Run worker tests
	@echo "🧪 Running worker tests..."
	@docker-compose exec worker go test -v ./...

.PHONY: test-coverage
test-coverage: ## Run tests with coverage
	@echo "📊 Running tests with coverage..."
	@docker-compose exec api go test -cover -coverprofile=coverage.out ./...
	@docker-compose exec api go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report generated: coverage.html"

.PHONY: lint
lint: ## Run linters
	@echo "🔍 Running linters..."
	@$(MAKE) lint-api
	@$(MAKE) lint-web
	@echo "✅ Linting complete"

.PHONY: lint-api
lint-api: ## Run Go linter
	@docker-compose exec api golangci-lint run

.PHONY: lint-web
lint-web: ## Run ESLint
	@docker-compose exec web npm run lint

.PHONY: format
format: ## Format code
	@echo "✨ Formatting code..."
	@docker-compose exec api go fmt ./...
	@docker-compose exec web npm run format
	@echo "✅ Code formatted"

##@ Utility Commands

.PHONY: install
install: ## Install dependencies
	@echo "📦 Installing dependencies..."
	@docker-compose run --rm api go mod download
	@docker-compose run --rm web npm install
	@docker-compose run --rm worker go mod download
	@echo "✅ Dependencies installed"

.PHONY: update
update: ## Update dependencies
	@echo "🔄 Updating dependencies..."
	@docker-compose run --rm api go get -u ./...
	@docker-compose run --rm api go mod tidy
	@docker-compose run --rm web npm update
	@docker-compose run --rm worker go get -u ./...
	@docker-compose run --rm worker go mod tidy
	@echo "✅ Dependencies updated"

.PHONY: env
env: ## Copy .env.example to .env
	@cp .env.example .env
	@echo "✅ Created .env file from .env.example"

.PHONY: minio-setup
minio-setup: ## Setup MinIO buckets
	@echo "🪣 Setting up MinIO buckets..."
	@docker-compose exec minio mc alias set local http://localhost:9000 minioadmin minioadmin123
	@docker-compose exec minio mc mb local/resumesync-uploads --ignore-existing
	@docker-compose exec minio mc mb local/resumesync-exports --ignore-existing
	@docker-compose exec minio mc mb local/resumesync-temp --ignore-existing
	@docker-compose exec minio mc policy set public local/resumesync-uploads
	@echo "✅ MinIO buckets created"

.PHONY: health
health: ## Check health of all services
	@echo "🏥 Checking service health..."
	@docker-compose exec api wget -q --spider http://localhost:8080/health || echo "❌ API is down"
	@docker-compose exec web wget -q --spider http://localhost:3000 || echo "❌ Web is down"
	@docker-compose exec postgres pg_isready -U resumesync || echo "❌ PostgreSQL is down"
	@docker-compose exec redis redis-cli ping || echo "❌ Redis is down"
	@curl -f http://localhost:9000/minio/health/live || echo "❌ MinIO is down"
	@echo "✅ Health check complete"

##@ Production Commands

.PHONY: prod-build
prod-build: ## Build production images
	@echo "🏗️ Building production images..."
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
	@echo "✅ Production build complete"

.PHONY: prod-up
prod-up: ## Start production environment
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo "✅ Production environment started"

.PHONY: prod-down
prod-down: ## Stop production environment
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
	@echo "✅ Production environment stopped"

.PHONY: deploy
deploy: prod-build prod-up ## Deploy to production
	@echo "🚀 Deployment complete!"

# Default target
.DEFAULT_GOAL := help