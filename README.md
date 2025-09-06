# ResumeSync Pro

[![CI Pipeline](https://github.com/charlestakang/ATS-resume-optimizer-golang/actions/workflows/ci.yml/badge.svg)](https://github.com/charlestakang/ATS-resume-optimizer-golang/actions/workflows/ci.yml)
[![Security Scanning](https://github.com/charlestakang/ATS-resume-optimizer-golang/actions/workflows/security.yml/badge.svg)](https://github.com/charlestakang/ATS-resume-optimizer-golang/actions/workflows/security.yml)
[![codecov](https://codecov.io/gh/charlestakang/ATS-resume-optimizer-golang/graph/badge.svg)](https://codecov.io/gh/charlestakang/ATS-resume-optimizer-golang)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Go Version](https://img.shields.io/badge/go-%3E%3D1.21-blue)](https://go.dev/)
[![Next.js](https://img.shields.io/badge/Next.js-14+-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue)](https://www.typescriptlang.org/)
[![Turborepo](https://img.shields.io/badge/Turborepo-latest-red)](https://turbo.build/)

An intelligent web application that automatically optimizes resumes to match job descriptions, ensuring maximum ATS compatibility and increasing interview callback rates.

## 🚀 Features

- **AI-Powered Resume Optimization**: Automatically enhance resumes to match job requirements
- **ATS Compatibility Scoring**: Real-time scoring against ATS algorithms
- **Multi-Format Support**: Parse PDF, DOCX, and TXT files
- **Keyword Optimization**: Intelligent keyword matching and density optimization
- **Professional Templates**: Export ATS-friendly resume templates
- **Subscription Management**: Tiered pricing with free and premium features
- **Real-time Preview**: Side-by-side comparison of original vs optimized resume

## 🏗️ Architecture

This project is built as a **Turborepo monorepo** with the following structure:

- **`apps/web`**: Next.js 14+ frontend with App Router
- **`apps/api`**: Golang backend using Clean Architecture
- **`apps/worker`**: Background job processor for document processing
- **`packages/*`**: Shared frontend packages (UI components, types, configs)
- **`libs/*`**: Shared backend libraries (auth, database, logging)

## 🛠️ Tech Stack

### Frontend
- **Framework**: Next.js 14+ with App Router
- **Language**: TypeScript 5.0+
- **Styling**: Tailwind CSS + shadcn/ui
- **State Management**: Zustand
- **Forms**: React Hook Form + Zod validation
- **API Client**: Axios with React Query

### Backend
- **Language**: Go 1.21+
- **Framework**: Gin Web Framework
- **ORM**: GORM
- **Database**: PostgreSQL 15+
- **Cache**: Redis
- **Authentication**: JWT + Better Auth
- **File Storage**: AWS S3 / MinIO

### DevOps
- **Containerization**: Docker & Docker Compose
- **Development**: Tilt for hot reload
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana

## 📦 Getting Started

### Prerequisites

- Node.js 18+ and PNPM 8+
- Go 1.21+
- Docker and Docker Compose
- PostgreSQL 15+ (or use Docker)
- Redis (or use Docker)

### Installation

1. **Clone the repository**

2. **Install dependencies**
   ```bash
   # Install all workspace dependencies
   pnpm install
   
   # Install Go dependencies
   cd apps/api && go mod download
   cd ../worker && go mod download
   cd ../../  # Return to root directory
   ```

3. **Set up environment variables**
   ```bash
   # Copy example env files
   cp .env.example .env
   cp apps/web/.env.example apps/web/.env.local
   cp apps/api/.env.example apps/api/.env
   cp apps/worker/.env.example apps/worker/.env
   ```

4. **Start Docker services**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d postgres redis minio
   ```

5. **Run database migrations**
   ```bash
   cd apps/api
   go run cmd/migrate/main.go up
   ```

6. **Start the development environment**
   ```bash
   # Start all services using Turborepo
   pnpm dev  # Starts all apps in dev mode
   ```

### Development Workflow

```bash
# Run all apps in development
pnpm dev

# Run specific app
pnpm dev --filter=web
pnpm dev --filter=api

# Build all apps
pnpm build

# Run tests
pnpm test

# Lint and format
pnpm lint
pnpm format

# Type checking
pnpm type-check
```

## 📁 Project Structure

```
resumesync-pro/
├── apps/
│   ├── web/                 # Next.js frontend
│   ├── api/                 # Golang API server
│   └── worker/              # Background job processor
├── packages/
│   ├── ui/                  # Shared React components
│   ├── shared-types/        # TypeScript type definitions
│   └── config/              # Shared configurations
├── libs/
│   ├── auth/                # Authentication library
│   ├── database/            # Database utilities
│   ├── logger/              # Logging utilities
│   └── fileprocessor/       # Document processing
├── docker/                  # Docker configurations
├── scripts/                 # Build and utility scripts
└── docs/                    # Documentation
```

## 🔧 Configuration

### Environment Variables

Key environment variables needed:

```env
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/resumesync

# Redis
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRY=24h

# Storage
STORAGE_TYPE=s3|minio|local
S3_BUCKET=resumesync-uploads
S3_REGION=us-east-1

# API URLs
NEXT_PUBLIC_API_URL=http://localhost:8080
NEXT_PUBLIC_WS_URL=ws://localhost:8080
```

## 🧪 Testing

```bash
# Run all tests
pnpm test

# Run frontend tests
pnpm test:web

# Run backend tests
cd apps/api && go test ./...

# Run e2e tests
pnpm test:e2e

# Coverage reports
pnpm test:coverage
```

## 📊 API Documentation

API documentation is available at:
- Development: http://localhost:8080/swagger
- Production: https://api.resumesync.pro/swagger

Key endpoints:
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/resume/upload` - Upload resume
- `POST /api/v1/resume/optimize` - Optimize resume
- `GET /api/v1/job/parse` - Parse job description

## 🚢 Deployment

### Docker Deployment

```bash
# Build production images
docker-compose build

# Run production stack
docker-compose up -d
```

### Kubernetes Deployment

```bash
# Apply k8s manifests
kubectl apply -f k8s/

# Or use Helm
helm install resumesync ./charts/resumesync
```

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Development Guidelines

1. Follow Clean Architecture principles for backend code
2. Use conventional commits for commit messages
3. Write tests for new features
4. Update documentation as needed
5. Ensure all CI checks pass before merging

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [shadcn/ui](https://ui.shadcn.com/) for the component library pattern
- [Turborepo](https://turbo.build/) for the monorepo tooling
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) principles by Robert C. Martin

---

# Product Requirements Document (PRD)

### 1. Product Overview

**Product Name**: ResumeSync Pro  
**Version**: 1.0  
**Product Type**: Web Application (SaaS)  
**Target Release**: Q2 2025

#### 1.1 Product Vision
Create an intelligent web application that automatically optimizes user resumes to match specific job descriptions, ensuring maximum ATS compatibility and increasing interview callback rates.

#### 1.2 Problem Statement
- 75% of resumes are filtered out by ATS systems before human review
- Job seekers struggle to tailor resumes for each application
- Manual resume optimization is time-consuming and often ineffective
- Lack of understanding of ATS-friendly formatting requirements

#### 1.3 Success Metrics
- User resume optimization completion rate: >85%
- Average keyword match improvement: >40%
- User satisfaction score: >4.5/5
- Time to optimize resume: <5 minutes

---

### 2. Target Users & Personas

#### 2.1 Primary Users
- **Job Seekers** (Individual Contributors, Managers, Executives)
- **Career Changers** seeking to pivot industries
- **Recent Graduates** entering the job market
- **Freelancers/Contractors** applying to multiple roles

#### 2.2 User Journey
1. Upload existing resume or create new one
2. Paste/upload target job description
3. Review AI-generated optimization suggestions
4. Customize and approve changes
5. Download ATS-optimized resume in multiple formats

---

### 3. Functional Requirements

#### 3.1 Core Features

##### 3.1.1 Resume Input System
- **File Upload Support**: 
  - Formats: .docx, .pdf, .txt (max 5MB)
  - Drag-and-drop interface
  - Bulk upload capability (up to 3 resumes)
- **Manual Resume Builder**:
  - Progressive form with auto-save
  - Pre-built templates (5 ATS-friendly designs)
  - Real-time formatting preview
  - Section reordering capability

##### 3.1.2 Job Description Processing
- **Input Methods**:
  - Direct text paste (up to 10,000 characters)
  - URL scraping from major job boards
  - File upload (.txt, .pdf, .docx)
- **Content Extraction**:
  - Required vs preferred qualifications
  - Key responsibilities identification
  - Industry-specific terminology detection
  - Salary range and benefits parsing

##### 3.1.3 Resume Optimization Engine
- **Keyword Analysis**:
  - Missing critical keywords identification
  - Keyword density optimization
  - Synonym and related term suggestions
  - Industry-specific jargon incorporation
- **Content Enhancement**:
  - Achievement quantification suggestions
  - Action verb optimization
  - Bullet point restructuring
  - Skills section reorganization
- **ATS Compatibility**:
  - Format standardization
  - Font and spacing optimization
  - Section header standardization
  - Contact information formatting

##### 3.1.4 Preview & Comparison System
- **Side-by-Side View**:
  - Original vs optimized resume display
  - Highlight changed content
  - Show keyword match percentage
  - ATS compatibility score
- **Interactive Editing**:
  - Accept/reject individual suggestions
  - Manual content editing
  - Real-time optimization scoring
  - Undo/redo functionality

##### 3.1.5 Export & Download
- **Format Options**: PDF, DOCX, TXT
- **Template Selection**: 5 ATS-optimized designs
- **Quality Assurance**: Final ATS compatibility check
- **Version Management**: Save multiple optimized versions

#### 3.2 User Management

##### 3.2.1 Authentication (Better Auth Integration)
- **Registration Methods**:
  - Email/password
  - Google OAuth
  - LinkedIn OAuth
  - GitHub OAuth (for developers)
- **User Profiles**:
  - Personal information storage
  - Resume history tracking
  - Optimization preferences
  - Usage analytics dashboard

##### 3.2.2 Subscription Management
- **Free Tier**: 3 optimizations/month, basic templates
- **Pro Tier**: Unlimited optimizations, premium templates, bulk processing
- **Enterprise**: Team management, API access, white-label options

#### 3.3 Advanced Features

##### 3.3.1 AI-Powered Insights
- **Match Score Algorithm**: Percentage compatibility with job requirements
- **Improvement Suggestions**: Specific recommendations for enhancement
- **Industry Benchmarking**: Compare against successful resumes in same field
- **Trend Analysis**: Identify emerging skills and keywords in target industry

##### 3.3.2 Integration Capabilities
- **Job Board APIs**: Indeed, LinkedIn, Glassdoor integration
- **CRM Integration**: Export to applicant tracking systems
- **Calendar Integration**: Interview scheduling reminders
- **Email Templates**: Follow-up message suggestions

---

### 4. Technical Architecture

#### 4.1 System Architecture
```
Frontend (Next.js) ↔ API Gateway ↔ Backend Services (Golang)
                                           ↓
                                   Document Processing
                                           ↓
                                    AI/ML Services
                                           ↓
                                   Database Layer (PostgreSQL)
```

#### 4.2 Technology Stack
- **Frontend**: Next.js 14+, TypeScript, Tailwind CSS, Zustand
- **Backend**: Golang (Gin framework), GORM, Redis
- **Database**: PostgreSQL 15+, Redis for caching
- **Authentication**: Better Auth
- **File Storage**: AWS S3 or MinIO
- Document Processing in Go
- Go has excellent libraries for document processing:
PDF Processing:

github.com/ledongthuc/pdf - Pure Go PDF reader
github.com/pdfcpu/pdfcpu - Comprehensive PDF processing

DOCX Processing:

github.com/fumiama/go-docx - Pure Go DOCX reader
github.com/lukasjarosch/go-docx - Simple DOCX processing
github.com/nguyenthenguyen/docx - DOCX template processing

Text Processing & NLP:

github.com/kljensen/snowball - Stemming algorithms
github.com/bbalet/stopwords - Stop words removal
github.com/jdkato/prose - Natural language processing
github.com/james-bowman/nlp - Machine learning for NLP
OpenAI API or similar for advanced text analysis
- **Containerization**: Docker, Docker Compose
- **Development**: Tilt for hot reload
- **Deployment**: Kubernetes, Helm charts

#### 4.3 API Design
- **RESTful APIs** with OpenAPI 3.0 specification
- **Rate Limiting**: 100 requests/minute for free users
- **Error Handling**: Standardized error responses
- **Versioning**: URL path versioning (/v1/, /v2/)

#### 4.4 Data Models

##### 4.4.1 User Model
```
User {
  id: UUID
  email: string
  profile: UserProfile
  subscription: SubscriptionPlan
  createdAt: timestamp
  updatedAt: timestamp
}
```

##### 4.4.2 Resume Model
```
Resume {
  id: UUID
  userId: UUID
  originalContent: JSON
  optimizedContent: JSON
  jobDescriptionId: UUID
  matchScore: float
  optimizationHistory: JSON[]
  createdAt: timestamp
}
```

##### 4.4.3 Job Description Model
```
JobDescription {
  id: UUID
  userId: UUID
  rawContent: text
  parsedData: JSON
  requiredSkills: string[]
  preferredSkills: string[]
  industryKeywords: string[]
  createdAt: timestamp
}
```

---

### 5. Non-Functional Requirements

#### 5.1 Performance
- **Response Time**: API responses <2 seconds, document processing <30 seconds
- **Throughput**: Support 1000 concurrent users
- **Availability**: 99.9% uptime SLA
- **Scalability**: Auto-scaling based on demand

#### 5.2 Security
- **Data Encryption**: AES-256 at rest, TLS 1.3 in transit
- **Access Control**: Role-based permissions, API key management
- **Privacy Compliance**: GDPR, CCPA compliant
- **Data Retention**: User data deleted after 2 years of inactivity

#### 5.3 Usability
- **Mobile Responsive**: Full functionality on mobile devices
- **Accessibility**: WCAG 2.1 AA compliance
- **Browser Support**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Loading Performance**: First Contentful Paint <2s

#### 5.4 Reliability
- **Error Recovery**: Graceful handling of file processing failures
- **Data Backup**: Daily automated backups with 30-day retention
- **Monitoring**: Real-time application and infrastructure monitoring
- **Disaster Recovery**: RTO 4 hours, RPO 1 hour

---

### 6. User Interface Requirements

#### 6.1 Design System
- **Component Library**: Custom design system built on Tailwind CSS
- **Responsive Design**: Mobile-first approach
- **Dark/Light Mode**: User preference based theme switching
- **Accessibility**: Screen reader compatible, keyboard navigation

#### 6.2 Key User Flows
1. **Onboarding Flow**: Welcome → Sign up → Upload resume → First optimization
2. **Quick Optimization**: Upload → Paste job → Review → Download
3. **Manual Builder**: Create → Fill sections → Optimize → Export
4. **Subscription Upgrade**: Feature limit → Upgrade prompt → Payment → Access

#### 6.3 Dashboard Features
- **Resume Library**: View all saved resumes and optimizations
- **Usage Analytics**: Optimization history, success metrics
- **Quick Actions**: Recent job applications, template gallery
- **Account Settings**: Profile, billing, preferences

---

### 7. Business Requirements

#### 7.1 Monetization Strategy
- **Freemium Model**: Limited free usage with premium upgrades
- **Subscription Tiers**:
  - Free: 3 optimizations/month, basic templates
  - Pro ($19/month): Unlimited optimizations, advanced analytics
  - Enterprise ($99/month): Team features, API access, white-label

#### 7.2 Go-to-Market Strategy
- **Target Channels**: Job search websites, career coaches, university partnerships
- **Content Marketing**: SEO-optimized blog, resume optimization guides
- **Referral Program**: Credit-based referral system
- **Partnerships**: Integration with job boards and career platforms

#### 7.3 Compliance Requirements
- **Data Privacy**: GDPR, CCPA compliance
- **Security Standards**: SOC 2 Type II certification
- **Accessibility**: Section 508 compliance for enterprise customers
- **International**: Multi-language support (English, Spanish, French initially)

---

### 8. Success Criteria & KPIs

#### 8.1 User Metrics
- **User Acquisition**: 10,000 registered users in first 6 months
- **User Retention**: 40% monthly active users
- **Conversion Rate**: 15% free-to-paid conversion
- **User Satisfaction**: NPS score >50

#### 8.2 Product Metrics
- **Feature Adoption**: 80% of users complete full optimization flow
- **Technical Performance**: 99.9% uptime, <2s average response time
- **Quality Metrics**: 85% user-reported interview increase
- **Support Metrics**: <24 hour response time, 90% first-contact resolution

#### 8.3 Business Metrics
- **Revenue**: $100K ARR within 12 months
- **Customer Acquisition Cost**: <$50 per paid user
- **Lifetime Value**: >$200 per paid user
- **Gross Margin**: >70% after infrastructure costs

---

### 9. Development Phases

#### Phase 1 (MVP - 3 months)
- Basic file upload and parsing
- Simple keyword matching
- Basic ATS template export
- User authentication and basic dashboard

#### Phase 2 (Enhanced Features - 2 months)
- Advanced AI optimization
- Multiple export formats
- Job description URL scraping
- Premium subscription features

#### Phase 3 (Scale & Polish - 2 months)
- Advanced analytics dashboard
- Mobile app companion
- Enterprise features
- International expansion

This PRD provides a comprehensive foundation for your ATS resume optimizer. Would you like me to elaborate on any specific section or move forward with technical implementation planning?
