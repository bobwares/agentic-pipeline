# Project Context

**INSTRUCTIONS**: Fill in this file when you run `/memory-init`. It persists across all sessions.

## Project Identity

**Name**: [Project name]
**Purpose**: [One sentence: what this project does and for whom]
**Status**: Planning | Active Development | Beta | Production
**Repository**: [GitHub URL]

## Tech Stack

| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| Frontend | Next.js App Router | 15.x | Port 3000 |
| UI Components | shadcn/ui + Tailwind CSS | latest | |
| Node.js API | NestJS | 10.x | Port 3001 |
| Enterprise API | Java/Spring Boot | 3.x | Port 8080 |
| Database | PostgreSQL + Drizzle ORM | 16 / latest | Port 5432 |
| AI Features | Vercel AI SDK | latest | |
| Testing | Vitest + Playwright | latest | |
| Deployment | [Vercel / Railway / Docker] | | |

## Architecture Overview

[Describe how the layers interact. Example:]
- Next.js frontend communicates with NestJS API via REST
- NestJS handles business logic and queries PostgreSQL via Drizzle ORM
- Spring Boot handles enterprise integrations (LDAP, ERP, legacy systems)
- Vercel AI SDK used in Next.js API routes and/or NestJS for AI features

## Key URLs (Local Development)

| Service | URL |
|---------|-----|
| Next.js frontend | http://localhost:3000 |
| NestJS API | http://localhost:3001 |
| NestJS Swagger | http://localhost:3001/api-docs |
| Spring API | http://localhost:8080 |
| Spring Swagger | http://localhost:8080/swagger-ui.html |
| Drizzle Studio | http://localhost:4983 |
| PostgreSQL | localhost:5432 |

## Environment Setup

```bash
# 1. Install dependencies
pnpm install

# 2. Set up environment
cp .env.example .env.local

# 3. Start database
docker compose up -d postgres

# 4. Run migrations
pnpm db:migrate

# 5. Start development
pnpm dev        # Next.js
pnpm dev:api    # NestJS
# Spring: run from IDE or mvn spring-boot:run
```

## Key Architectural Decisions

[ADRs are in decisionLog.md. Summary:]
- [ADR-001]: [Decision title]
