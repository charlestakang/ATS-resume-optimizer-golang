## 📋 Description

<!-- Provide a brief description of the changes in this PR -->

### 🎯 Purpose
<!-- Why is this change necessary? What problem does it solve? -->

### 🔗 Related Issue
<!-- Link to the issue this PR addresses -->
Closes #<!-- issue number -->

## 🚀 Type of Change

<!-- Please delete options that are not relevant. -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🎨 Style update (formatting, renaming)
- [ ] ♻️ Code refactor (no functional changes, no API changes)
- [ ] ⚡ Performance improvement
- [ ] 🧪 Test update
- [ ] 🔧 Build configuration change
- [ ] 🤖 CI/CD change
- [ ] 🔐 Security update
- [ ] ⬆️ Dependency update

## 📝 Changes Made

<!-- List the specific changes made in this PR -->

- 
- 
- 

## 🖼️ Screenshots (if applicable)

<!-- Add screenshots to help explain your changes if they affect the UI -->

<details>
<summary>Click to expand screenshots</summary>

<!-- Add your screenshots here -->

</details>

## 🧪 Testing

### Test Coverage
<!-- Current test coverage percentage and changes -->
- **Current Coverage:** <!-- e.g., 85.2% -->
- **Coverage Change:** <!-- e.g., +2.3% -->
- **New Tests Added:** Yes / No

### How Has This Been Tested?

<!-- Describe the tests that you ran to verify your changes -->

- [ ] Unit Tests
- [ ] Integration Tests
- [ ] E2E Tests
- [ ] Manual Testing

### Test Instructions

<!-- Provide instructions so reviewers can test your changes -->

1. 
2. 
3. 

## ✅ Checklist

### Code Quality
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have checked my code with linters (golangci-lint, ESLint, etc.)

### Testing
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] I have tested this code in development environment
- [ ] I have tested edge cases and error scenarios

### Documentation
- [ ] I have updated the README.md with details of changes (if applicable)
- [ ] I have updated API documentation (if applicable)
- [ ] I have added/updated code comments and JSDoc/GoDoc
- [ ] I have updated CHANGELOG.md (if applicable)

### Security
- [ ] I have checked for security vulnerabilities
- [ ] I have not exposed any secrets or sensitive information
- [ ] I have validated all user inputs
- [ ] I have followed secure coding practices

### Performance
- [ ] I have considered the performance impact of my changes
- [ ] I have run performance tests (if applicable)
- [ ] Database queries are optimized
- [ ] No N+1 query problems introduced

## 🚦 Pre-Merge Checklist

<!-- For maintainers -->

- [ ] All CI checks are passing
- [ ] Code coverage meets or exceeds requirements
- [ ] Security scans show no new vulnerabilities
- [ ] At least one approval from code owners
- [ ] No unresolved conversations
- [ ] Branch is up to date with target branch
- [ ] Commits are squashed (if required)

## 📊 Performance Impact

<!-- If your changes affect performance, provide details -->

<details>
<summary>Performance Metrics</summary>

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Response Time | - | - | - |
| Memory Usage | - | - | - |
| CPU Usage | - | - | - |
| Database Queries | - | - | - |

</details>

## 🔄 Migration Guide

<!-- If this is a breaking change, provide a migration guide -->

<details>
<summary>Migration Steps (if applicable)</summary>

1. 
2. 
3. 

</details>

## 📈 Deployment Notes

<!-- Any special considerations for deployment -->

- [ ] Database migrations required
- [ ] Environment variables added/changed
- [ ] Infrastructure changes required
- [ ] Feature flags configured
- [ ] Rollback plan documented

### Environment Variables
<!-- List any new or modified environment variables -->

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| - | - | - | - |

## 🤝 Dependencies

<!-- List any PRs or issues that this PR depends on -->

- Depends on: #<!-- issue/PR number -->
- Blocked by: #<!-- issue/PR number -->

## 👥 Reviewers Guide

<!-- Help reviewers know what to focus on -->

### Key Files to Review
1. 
2. 
3. 

### Areas of Concern
<!-- Any areas where you'd like specific feedback -->

- 
- 

## 📝 Additional Notes

<!-- Any additional information that reviewers should know -->

---

### 🏷️ Labels

<!-- The following labels will be automatically applied based on the changes -->

<!--
Suggested labels:
- `size/XS` - Less than 10 lines changed
- `size/S` - 10-99 lines changed
- `size/M` - 100-499 lines changed
- `size/L` - 500-999 lines changed
- `size/XL` - 1000+ lines changed
-->

### 🔗 References

<!-- Add any relevant references -->

- [Documentation](link)
- [Design Document](link)
- [RFC](link)

---

<details>
<summary>📚 PR Template Instructions (delete before submitting)</summary>

### How to use this template:

1. **Fill in all sections** that apply to your PR
2. **Delete sections** that don't apply
3. **Check all boxes** that apply in the checklist
4. **Add screenshots** if your changes affect the UI
5. **Link to related issues** using keywords like "Closes #123"
6. **Request reviews** from appropriate team members
7. **Add labels** to categorize your PR
8. **Ensure all CI checks pass** before requesting review

### Commit Message Format:

Follow the conventional commits specification:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `perf:` Performance improvements
- `test:` Test additions or updates
- `build:` Build system changes
- `ci:` CI/CD changes
- `chore:` Other changes

Example: `feat(api): add user authentication endpoint`

</details>