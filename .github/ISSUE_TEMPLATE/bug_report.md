---
name: 🐛 Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: bug, triage
assignees: ''

---

## 🐛 Bug Description

<!-- A clear and concise description of what the bug is -->

### 📍 Location
**Service/Component:** <!-- e.g., API, Worker, Web, Database -->
**Module/Feature:** <!-- e.g., Authentication, Resume Parser, Job Queue -->

## 🔄 Reproduction Steps

<!-- Steps to reproduce the behavior -->

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

### 📝 Minimal Reproduction Code

<!-- If applicable, provide minimal code to reproduce the issue -->

<details>
<summary>Code Sample</summary>

```go
// For Go code issues
```

```typescript
// For TypeScript/JavaScript issues
```

```bash
# For command line issues
```

</details>

## 🎯 Expected Behavior

<!-- A clear and concise description of what you expected to happen -->

## 💥 Actual Behavior

<!-- What actually happened -->

### 📸 Screenshots

<!-- If applicable, add screenshots to help explain your problem -->

<details>
<summary>Screenshots</summary>

<!-- Add your screenshots here -->

</details>

## 🌍 Environment

### System Information
- **OS:** <!-- e.g., macOS 14.0, Ubuntu 22.04, Windows 11 -->
- **Browser:** <!-- e.g., Chrome 120.0, Safari 17.0, Firefox 121.0 -->
- **Node Version:** <!-- Run: node --version -->
- **Go Version:** <!-- Run: go version -->
- **Docker Version:** <!-- Run: docker --version -->

### Deployment Environment
- [ ] Local Development
- [ ] Docker Compose
- [ ] Kubernetes (Development)
- [ ] Kubernetes (Staging)
- [ ] Kubernetes (Production)
- [ ] Other: <!-- Please specify -->

### Service Versions
```yaml
API Version: # e.g., v1.2.3 or commit hash
Worker Version: # 
Web Version: # 
Database Version: # PostgreSQL version
Redis Version: # 
MinIO Version: # 
```

## 📊 Impact Assessment

### Severity
- [ ] 🔴 **Critical** - System is unusable, data loss, security issue
- [ ] 🟠 **High** - Major functionality broken, no workaround
- [ ] 🟡 **Medium** - Feature broken, workaround available
- [ ] 🟢 **Low** - Minor issue, cosmetic, enhancement

### Affected Users
- [ ] All users
- [ ] Specific user group: <!-- Specify group -->
- [ ] Specific customer: <!-- If applicable -->
- [ ] Internal only

### Frequency
- [ ] Always reproducible
- [ ] Intermittent (~50% of the time)
- [ ] Rare (< 10% of the time)
- [ ] Only happened once

## 🔍 Error Details

### Error Message
```
<!-- Paste the complete error message here -->
```

### Stack Trace
<details>
<summary>Full Stack Trace</summary>

```
<!-- Paste the full stack trace here -->
```

</details>

### Relevant Logs

<details>
<summary>Application Logs</summary>

```log
<!-- Paste relevant application logs here -->
```

</details>

<details>
<summary>Browser Console Logs</summary>

```javascript
<!-- Paste browser console output here -->
```

</details>

<details>
<summary>Network Logs</summary>

```
<!-- Include relevant HTTP requests/responses -->
```

</details>

## 🔗 Related Information

### Related Issues/PRs
<!-- Link any related issues or PRs -->
- Related to #
- Depends on #
- Blocks #

### External References
<!-- Any relevant external links, documentation, or discussions -->
- 

## 💡 Possible Solution

<!-- If you have suggestions on how to fix the issue, please describe them here -->

### Root Cause Analysis
<!-- If you've investigated the cause -->

### Proposed Fix
<!-- Your suggested solution -->

## ✅ Checklist

Before submitting this bug report, please confirm:

- [ ] I have searched for existing issues that describe this bug
- [ ] I have provided a clear description of the bug
- [ ] I have included steps to reproduce the issue
- [ ] I have included the environment information
- [ ] I have included relevant error messages and logs
- [ ] I have assessed the severity and impact
- [ ] I have removed any sensitive information from logs/screenshots
- [ ] I have tested with the latest version

## 🔧 For Maintainers Only

<!-- Do not modify below this line -->

### Triage Information
- **Priority:** <!-- P0/P1/P2/P3 -->
- **Component:** <!-- API/Worker/Web/Infra -->
- **Milestone:** <!-- Version milestone -->
- **Sprint:** <!-- Sprint number -->

### Investigation Notes
<!-- Space for maintainer notes during investigation -->

### Resolution
- [ ] Bug confirmed
- [ ] Root cause identified
- [ ] Fix implemented
- [ ] Tests added
- [ ] Documentation updated
- [ ] Released in version: 

---

<details>
<summary>📚 Bug Report Guidelines (click to expand)</summary>

### Tips for a Good Bug Report

1. **Be Specific**: Include exact error messages, not paraphrases
2. **Be Complete**: Include all steps needed to reproduce
3. **Be Minimal**: Remove unnecessary steps or code
4. **One Bug Per Report**: Don't combine multiple issues
5. **Search First**: Check if the bug has already been reported
6. **Update**: Keep the issue updated with new findings

### What Makes a Bug Report Useful?

- **Reproducible**: Can someone else follow your steps and see the same issue?
- **Specific**: Is it clear what the problem is?
- **Actionable**: Is there enough information to start investigating?
- **Professional**: Is it respectful and constructive?

### Security Issues

⚠️ **IMPORTANT**: If you've found a security vulnerability, please DO NOT create a public issue. Instead, email security@resumesync.pro or use the GitHub Security Advisory feature.

</details>