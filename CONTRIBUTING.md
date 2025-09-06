# Contributing to ResumeSync Pro

Thank you for your interest in contributing to ResumeSync Pro! This document outlines the process for contributing to our intelligent resume optimization platform.

## =Ë Table of Contents

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

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## =€ Getting Started

### Prerequisites

Before contributing, ensure you have the following installed:

- **Node.js** 18+ and **PNPM** 8+
- **Go** 1.21+
- **Docker** and **Docker Compose**
- **Git** with proper SSH keys configured
- **PostgreSQL** 15+ (or use Docker)
- **Redis** (or use Docker)

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

- **`main`**: Production-ready code
- **`develop`**: Integration branch for features
- **`feature/*`**: Individual feature branches
- **`hotfix/*`**: Critical bug fixes
- **`release/*`**: Release preparation

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

## =Ý Contribution Guidelines

### Types of Contributions

We welcome the following types of contributions:

- **= Bug fixes**: Fix existing functionality issues
- **( New features**: Add new functionality to the platform
- **=Ú Documentation**: Improve or add documentation
- **<¨ UI/UX improvements**: Enhance user interface and experience
- **¡ Performance improvements**: Optimize application performance
- **>ê Tests**: Add or improve test coverage
- **=' DevOps**: Improve CI/CD, Docker, or deployment processes

### Before You Start

1. **Check existing issues**: Look for existing issues or discussions
2. **Create an issue**: For new features or significant changes
3. **Discuss your approach**: Comment on the issue to discuss your approach
4. **Start small**: Begin with small contributions to get familiar with the codebase

## <× Code Standards

### Frontend (Next.js/TypeScript)

- Use **TypeScript** for all new code
- Follow **ESLint** and **Prettier** configurations
- Use **functional components** with hooks
- Implement **proper error boundaries**
- Follow **Tailwind CSS** conventions
- Use **Zustand** for state management
- Write **unit tests** with Jest/Testing Library

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

- Follow **Clean Architecture** principles
- Use **gofmt** and **golangci-lint**
- Write **comprehensive unit tests**
- Implement **proper error handling**
- Follow **Go naming conventions**
- Use **dependency injection**
- Document **public APIs** with comments

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

- **Commit messages**: Use conventional commits format
- **Variable naming**: Use descriptive, clear names
- **Comments**: Write clear, concise comments for complex logic
- **Error handling**: Always handle errors appropriately
- **Security**: Never commit secrets or sensitive data
- **Performance**: Consider performance implications of changes

## >ê Testing Requirements

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

- **Frontend**: Minimum 80% coverage for new code
- **Backend**: Minimum 85% coverage for new code
- **Critical paths**: 100% coverage for authentication and payment flows

## = Pull Request Process

### Before Submitting

1. **Run all tests**: Ensure all tests pass
2. **Run linting**: Fix all linting issues
3. **Update documentation**: Update relevant docs
4. **Test manually**: Verify your changes work as expected
5. **Check CI**: Ensure all CI checks pass

### Pull Request Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

### Pull Request Template

When creating a pull request, please use our [PR template](.github/PULL_REQUEST_TEMPLATE.md) and provide:

- **Clear description** of what your PR does
- **Issue reference** (if applicable)
- **Screenshots** (for UI changes)
- **Testing instructions** for reviewers
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

- **Clear title**: Descriptive but concise
- **Steps to reproduce**: Exact steps to reproduce the issue
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: OS, browser, versions
- **Screenshots**: Visual evidence (if applicable)

### Feature Requests

Use our [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and include:

- **Problem statement**: What problem does this solve?
- **Proposed solution**: How should it work?
- **Alternatives considered**: Other approaches you've considered
- **Additional context**: Mockups, examples, etc.

## <÷ Labels and Issue Management

### Priority Labels

- **P0**: Critical - System down, data loss, security issue
- **P1**: High - Major feature broken, no workaround
- **P2**: Medium - Feature broken, workaround available
- **P3**: Low - Minor issue, enhancement

### Type Labels

- **bug**: Something isn't working
- **enhancement**: New feature or request
- **documentation**: Improvements or additions to docs
- **good first issue**: Good for newcomers
- **help wanted**: Extra attention is needed

### Area Labels

- **area/api**: API service related
- **area/worker**: Worker service related
- **area/web**: Frontend related
- **area/ci**: CI/CD related
- **area/docs**: Documentation related

## <¯ Contribution Rewards

### Recognition

- **Contributors list**: All contributors are recognized in our README
- **Release notes**: Significant contributions mentioned in release notes
- **Special mentions**: Outstanding contributions highlighted in community updates

### Swag and Rewards

- **First contribution**: Welcome package with stickers
- **Regular contributors**: ResumeSync Pro t-shirt and swag
- **Top contributors**: Exclusive early access to premium features

## =Ú Resources

### Documentation

- [README.md](README.md) - Project overview and setup
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Technical architecture
- [API.md](docs/API.md) - API documentation
- [DEPLOYMENT.md](docs/DEPLOYMENT.md) - Deployment guides

### Communication

- **GitHub Discussions**: For questions and general discussion
- **Issues**: For bug reports and feature requests
- **Pull Requests**: For code contributions

### Learning Resources

- [Go by Example](https://gobyexample.com/) - Learn Go programming
- [Next.js Documentation](https://nextjs.org/docs) - Next.js framework
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Architecture principles

## S Getting Help

If you need help with contributing:

1. **Check the documentation** first
2. **Search existing issues** for similar problems
3. **Create a new issue** with the `help wanted` label
4. **Join our discussions** for community support

## =Ä License

By contributing to ResumeSync Pro, you agree that your contributions will be licensed under the same MIT License that covers the project. See [LICENSE](LICENSE) for details.

---

Thank you for contributing to ResumeSync Pro! =€ Your contributions help make resume optimization accessible to job seekers worldwide.