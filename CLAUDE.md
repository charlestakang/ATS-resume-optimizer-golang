# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ResumeSync Pro** - An ATS (Applicant Tracking System) Resume Optimizer web application that helps job seekers optimize their resumes to match job descriptions and pass ATS filters.

## Architecture

This is a **Turborepo monorepo** with multiple applications and shared packages following modern 2025 best practices.

## Technology Stack

### Monorepo Structure
- **Build System**: Turborepo
- **Package Manager**: PNPM
- **Workspace**: Go workspace + PNPM workspace

### Backend Stack
- **Language**: Golang
- **Web Framework**: Gin framework
- **ORM**: GORM
- **Database**: PostgreSQL 15+
- **Caching**: Redis
- **Message Queue**: Redis/RabbitMQ for job processing
- **Authentication**: JWT with Better Auth integration
- **Architecture**: Clean Architecture (Domain-Driven Design)

### Frontend Stack
- **Framework**: Next.js 14+ with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: shadcn/ui pattern
- **State Management**: Zustand
- **Form Handling**: React Hook Form + Zod
- **API Client**: Axios/Fetch with React Query

### Infrastructure
- **Containerization**: Docker, Docker Compose
- **Development**: Tilt for hot reload, Air for Go hot reload
- **Deployment**: Kubernetes with Helm charts
- **File Storage**: AWS S3 or MinIO
- **CI/CD**: GitHub Actions

## Development Commands

### Monorepo Management

```bash
# Install dependencies for all workspaces
pnpm install

# Run development environment with Tilt
tilt up

# Build all applications
pnpm run build

# Run all tests
pnpm run test

# Lint all code
pnpm run lint

# Type check
pnpm run type-check
```

### Frontend (Next.js) Commands

```bash
# Navigate to web app
cd apps/web

# Install dependencies
pnpm install

# Run development server
pnpm dev

# Build for production
pnpm build

# Run production build
pnpm start

# Run tests
pnpm test

# Lint
pnpm lint

# Type check
pnpm type-check
```

# Initialize module (first time)
go mod init github.com/charlestakang/ATS-resume-optimizer-golang/apps/api
# Run tests
go test ./...

# Run tests with coverage
go test -cover -coverprofile=coverage.out ./...

# View coverage report
go tool cover -html=coverage.out

# Format code
go fmt ./...

# Lint (requires golangci-lint)
golangci-lint run

# Generate mocks
go generate ./...
```

### Worker Commands

```bash
# Navigate to worker
cd apps/worker

# Run worker
go run cmd/worker/main.go

# Build worker
go build -o bin/worker cmd/worker/main.go
```

### Docker Commands

```bash
# Start all services (development)
docker-compose -f docker-compose.dev.yml up

# Start specific service
docker-compose -f docker-compose.dev.yml up api

# Rebuild containers
docker-compose -f docker-compose.dev.yml build

# View logs
docker-compose -f docker-compose.dev.yml logs -f [service]

# Stop all services
docker-compose -f docker-compose.dev.yml down

# Remove volumes
docker-compose -f docker-compose.dev.yml down -v
```

### Database Commands

```bash
# Run migrations up
migrate -path apps/api/internal/infrastructure/database/migrations \
        -database "postgresql://user:pass@localhost/resumesync?sslmode=disable" up

# Run migrations down
migrate -path apps/api/internal/infrastructure/database/migrations \
        -database "postgresql://user:pass@localhost/resumesync?sslmode=disable" down

# Create new migration
migrate create -ext sql -dir apps/api/internal/infrastructure/database/migrations -seq [migration_name]

# Seed database
go run scripts/seed.go
```

## Project Structure (Turborepo Monorepo)

```
resumesync-pro/
├── apps/
│   ├── web/                        # Next.js 14+ Frontend
│   │   ├── src/
│   │   │   ├── app/               # App Router with route groups
│   │   │   │   ├── (marketing)/   # Public pages
│   │   │   │   ├── (auth)/        # Authentication pages
│   │   │   │   ├── (dashboard)/   # Protected app pages
│   │   │   │   └── api/           # API routes
│   │   │   ├── components/        # React components
│   │   │   ├── lib/              # Utilities
│   │   │   ├── store/            # Zustand stores
│   │   │   └── types/            # TypeScript types
│   │   └── public/                # Static assets
│   │
│   ├── api/                       # Golang Backend (Clean Architecture)
│   │   ├── cmd/server/            # Application entry point
│   │   ├── internal/
│   │   │   ├── domain/            # Core business logic
│   │   │   ├── usecases/          # Application logic
│   │   │   ├── adapters/          # Interface adapters
│   │   │   └── infrastructure/    # External services
│   │   └── pkg/                   # Shared packages
│   │
│   └── worker/                    # Background job processor
│       ├── cmd/worker/
│       └── internal/
│           ├── jobs/              # Job definitions
│           └── processors/        # Document processors
│
├── packages/                      # Shared frontend packages
│   ├── ui/                       # React component library
│   ├── shared-types/             # TypeScript definitions
│   └── config/                   # Shared configs
│
├── libs/                         # Shared backend libraries
│   ├── auth/                    # Authentication
│   ├── database/                # Database utilities
│   ├── logger/                  # Logging
│   └── fileprocessor/           # Document processing
│
├── docker/                       # Docker configurations
├── scripts/                      # Build scripts
├── docs/                        # Documentation
└── .github/workflows/           # CI/CD pipelines
```

## Architecture Patterns

### Clean Architecture
The project follows clean architecture principles with clear separation of concerns:
- **Domain Layer**: Core business logic, independent of frameworks
- **Repository Layer**: Data persistence abstractions
- **Service Layer**: Business operations and orchestration
- **API Layer**: HTTP handlers and request/response handling

### Key Components

1. **Document Processing Pipeline**
   - Parse uploaded resumes (PDF, DOCX, TXT)
   - Extract structured data from documents
   - Libraries: `github.com/pdfcpu/pdfcpu`, `github.com/fumiama/go-docx`

2. **ATS Optimization Engine**
   - Keyword extraction and matching
   - Content enhancement suggestions
   - Score calculation algorithms

3. **Job Description Parser**
   - Extract requirements and skills
   - Identify industry keywords
   - NLP libraries: `github.com/jdkato/prose`, `github.com/james-bowman/nlp`

4. **User Management System**
   - Authentication with Better Auth
   - Subscription management
   - Resume version history

## API Design Guidelines

- Follow RESTful conventions
- Use OpenAPI 3.0 specification for documentation
- Implement proper error handling with standardized error responses
- Include rate limiting (100 req/min for free tier)
- Version APIs with URL path versioning (/v1/, /v2/)

## Database Schema

Key models as defined in the PRD:
- **User**: Authentication and profile management
- **Resume**: Original and optimized content storage
- **JobDescription**: Parsed job requirements
- **Optimization**: History of resume optimizations

## Testing Strategy

```bash
# Unit tests for individual components
go test ./internal/...

# Integration tests
go test ./tests/...

# E2E tests (when frontend is integrated)
# Will require additional test setup
```

## Performance Requirements

- API response time: <2 seconds
- Document processing: <30 seconds
- Support 1000 concurrent users
- 99.9% uptime SLA

## Security Considerations

- Implement AES-256 encryption for data at rest
- Use TLS 1.3 for data in transit
- Follow OWASP security guidelines
- Implement role-based access control
- Ensure GDPR and CCPA compliance

## Development Phases

Currently in **Pre-Phase 1**: Project setup and architecture

### Phase 1 (MVP - 3 months)
- Basic file upload and parsing
- Simple keyword matching
- Basic ATS template export
- User authentication and dashboard

### Phase 2 (Enhanced Features - 2 months)
- Advanced AI optimization
## Security Considerations

- Implement AES-256 encryption for data at rest
- Use TLS 1.3 for data in transit
- Follow OWASP security guidelines
- Implement role-based access control
- Ensure GDPR and CCPA compliance
- Maintain threat model (STRIDE-lite) and security checklist per release
- Secrets management via SOPS + KMS or GitHub OIDC to cloud secrets manager
- Data classification (PII inventory) and retention policy enforced in code + DB
- SBOM and container image scanning (Trivy) in CI
- Enterprise features
- International expansion

## Standard Workflow

1. First think through the problem, read the codebase for relevant files, and write a plan to projectplan.md.
2. The plan should have a list of todo items that you can check off as you complete them
3. Before you begin working, check in with me and I will verify the plan.
4. Then, begin working on the todo items, Donot  make any changes to the code file. give me directions anad snippets and i will complete the write the code myself the you will check and mark them as complete as you go.
5. Please every step of the way just give me a high level explanation of what changes have been made.
6. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
7. Finally, add a review section to the todo.md file with a summary of the changes you made and any other relevant information.
8. After you finish the todo list, please write a summary of the changes you made and any other relevant information in the review section of projectplan.md.
