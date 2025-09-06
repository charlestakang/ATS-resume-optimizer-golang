# Contributing to ResumeSync Pro

Thank you for your interest in contributing to ResumeSync Pro! This document outlines the process for contributing to our intelligent resume optimization platform.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Contribution Guidelines](#contribution-guidelines)
- [Code Standards](#code-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)


## > Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow. Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) to help create a welcoming environment for all contributors.

### Our Standards


## =� Getting Started

### Prerequisites

Before contributing, ensure you have the following installed:


### Setting Up Your Development Environment

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone git@github.com:yourusername/resumesync-pro.git
   cd resumesync-pro
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream git@github.com:charlestakang/resumesync-pro.git
   ```

3. **Install dependencies**
   ```bash
   # Install all workspace dependencies
   pnpm install
   
   # Install Go dependencies
   cd apps/api && go mod download
   cd ../worker && go mod download
   ```

4. **Set up environment variables**
   ```bash
   cp .env.example .env
   cp apps/web/.env.example apps/web/.env.local
   cp apps/api/.env.example apps/api/.env
   cp apps/worker/.env.example apps/worker/.env
   ```

5. **Start development services**
   ```bash
   # Start Docker services
   docker-compose -f docker-compose.dev.yml up -d postgres redis minio
   
   # Run database migrations
   cd apps/api && go run cmd/migrate/main.go up
   
   # Start all applications
   pnpm dev
   ```

## = Development Workflow

### Branching Strategy

We use GitFlow for our branching model:


### Creating a Feature Branch

```bash
# Switch to develop and pull latest changes
git checkout develop
git pull upstream develop

# Create a new feature branch
git checkout -b feature/your-feature-name

# Make your changes and commit
git add .
git commit -m "feat: add your feature description"

# Push to your fork
git push origin feature/your-feature-name
```

### Keeping Your Branch Up to Date

```bash
# Regularly sync with upstream
git checkout develop
git pull upstream develop
git checkout feature/your-feature-name
git rebase develop
```

## =� Contribution Guidelines

### Types of Contributions

We welcome the following types of contributions:


### Before You Start

1. **Check existing issues**: Look for existing issues or discussions
2. **Create an issue**: For new features or significant changes
3. **Discuss your approach**: Comment on the issue to discuss your approach
4. **Start small**: Begin with small contributions to get familiar with the codebase

## <� Code Standards

### Frontend (Next.js/TypeScript)


```typescript
// Good: Functional component with TypeScript
interface UserProfileProps {
  user: User;
  onUpdate: (user: User) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({ user, onUpdate }) => {
  // Component implementation
};
```

### Backend (Go)


```go
// Good: Clean Architecture service
type UserService interface {
    CreateUser(ctx context.Context, user *domain.User) error
    GetUser(ctx context.Context, id string) (*domain.User, error)
}

type userService struct {
    repo domain.UserRepository
    logger logger.Logger
}

func NewUserService(repo domain.UserRepository, logger logger.Logger) UserService {
    return &userService{
        repo:   repo,
        logger: logger,
    }
}
```

### General Guidelines


## >� Testing Requirements

### Frontend Testing

```bash
# Run all frontend tests
pnpm test:web

# Run tests in watch mode
pnpm test:web --watch

# Run specific test file
pnpm test:web UserProfile.test.tsx
```

### Backend Testing

```bash
# Run all Go tests
go test ./...

# Run tests with coverage
go test -cover ./...

# Run specific package tests
go test ./internal/services/user
```

### Integration Testing

```bash
# Run integration tests
pnpm test:integration

# Run E2E tests
pnpm test:e2e
```

### Test Coverage Requirements


## =
 Pull Request Process

### Before Submitting

1. **Run all tests**: Ensure all tests pass
2. **Run linting**: Fix all linting issues
3. **Update documentation**: Update relevant docs
4. **Test manually**: Verify your changes work as expected
5. **Check CI**: Ensure all CI checks pass

### Pull Request Checklist
- [ ] Any dependent changes have been merged and published

### Pull Request Template

When creating a pull request, please use our [PR template](.github/PULL_REQUEST_TEMPLATE.md) and provide:
- **Breaking changes** (if any)

### Code Review Process

1. **Automated checks**: All CI checks must pass
2. **Peer review**: At least one approval from a maintainer
3. **Manual testing**: Reviewers may test changes manually
4. **Feedback addressed**: All feedback must be addressed or discussed
5. **Final approval**: Maintainer gives final approval and merges

## = Issue Reporting

### Bug Reports

Use our [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) and include:
- **Screenshots**: Visual evidence (if applicable)

### Feature Requests

Use our [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and include:
- **Additional context**: Mockups, examples, etc.

## <� Labels and Issue Management

### Priority Labels
- **P3**: Low - Minor issue, enhancement

### Type Labels
- **help wanted**: Extra attention is needed

### Area Labels
- **area/docs**: Documentation related

## <� Contribution Rewards

### Recognition
- **Special mentions**: Outstanding contributions highlighted in community updates

### Swag and Rewards
- **Top contributors**: Exclusive early access to premium features

## =� Resources

### Documentation
- [DEPLOYMENT.md](docs/DEPLOYMENT.md) - Deployment guides

### Communication
- **Pull Requests**: For code contributions

### Learning Resources
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Architecture principles

## S Getting Help

If you need help with contributing:

1. **Check the documentation** first
2. **Search existing issues** for similar problems
3. **Create a new issue** with the `help wanted` label
4. **Join our discussions** for community support

## =� License

By contributing to ResumeSync Pro, you agree that your contributions will be licensed under the same MIT License that covers the project. See [LICENSE](LICENSE) for details.
---

Thank you for contributing to ResumeSync Pro! =� Your contributions help make resume optimization accessible to job seekers worldwide.