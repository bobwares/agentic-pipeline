# CLAUDE.md — agentic-pipeline

This file is the global project memory. Read it at the start of every session.

## Memory Bank

The memory bank lives in `.claude/memory/`. Always load these files at session start with `/session-start`.

| File | Purpose | Update Frequency |
|------|---------|-----------------|
| `projectContext.md` | Project identity, stack, key URLs | Rarely (stable) |
| `activeContext.md` | Current branch, WIP, next step | Every session |
| `progress.md` | Epics/tasks status table | Every session |
| `decisionLog.md` | Architecture Decision Records | On new decisions |
| `conventions.md` | Project-specific patterns | As discovered |
| `sessionHistory.md` | Session summaries log | End of every session |

## Workflow: Spec → Code → Ship

```
1. /spec-prd-new   → Define what to build (PRD)
2. /spec-prd-parse → Break PRD into epics and tasks
3. /spec-epic-start → Begin implementation (spawns orchestrator)
4. /spec-task-next  → Get next task
5. /verify-all      → Quality gate before every PR
6. /git-commit-push-pr → Ship it
```

## Agent Team

Invoke agents using the Task tool or by typing their name. The orchestrator handles routing.

| Agent | Role | Model |
|-------|------|-------|
| `orchestrator` | Master coordinator — delegates to specialists | opus |
| `code-architect` | System design, API contracts, database schema design | opus |
| `nextjs-engineer` | Next.js 15 App Router, server components, server actions | sonnet |
| `nestjs-engineer` | NestJS modules, guards, interceptors, DTOs | sonnet |
| `spring-engineer` | Java Spring Boot REST, JPA, Spring Security | sonnet |
| `drizzle-dba` | Drizzle ORM schema, queries, migrations, PostgreSQL | sonnet |
| `ai-engineer` | Vercel AI SDK, streaming, tool calls, embeddings | sonnet |
| `code-reviewer` | Senior-engineer code review checklist | opus |
| `test-writer` | TDD, Vitest unit tests, Playwright E2E | sonnet |
| `verify-app` | Full quality gate (types + lint + test + build) | sonnet |
| `security-auditor` | OWASP top 10, secrets scanning, auth review | opus |
| `doc-generator` | JSDoc, README, OpenAPI/Swagger docs | sonnet |
| `git-guardian` | Conventional commits, PR creation, branch management | sonnet |
| `memory-bank` | Memory bank management, session state | haiku |

## Skill Activation

Domain knowledge skills are auto-suggested by the skill-eval hook when you type a prompt. Workflow skills are invoked manually:

**Domain skills** (auto-suggested): `nextjs-patterns`, `nestjs-patterns`, `spring-patterns`, `drizzle-patterns`, `shadcn-patterns`, `vercel-ai-patterns`, `testing-patterns`, `react-ui-patterns`, `api-design-patterns`, `systematic-debugging`

**Workflow skills** (manual): `/spec-prd-new`, `/spec-prd-parse`, `/spec-prd-list`, `/spec-epic-start`, `/spec-task-next`, `/session-start`, `/session-end`, `/memory-init`, `/verify-all`, `/test-and-fix`, `/security-scan`, `/git-commit-push-pr`, `/git-quick-commit`, `/git-checkpoint`, `/git-rollback`, `/git-undo`, `/context-prime`, `/mode`, `/fix-issue`

## Non-Negotiable Standards

These rules apply to all code in all layers. See `.claude/rules/tech-standards.md` for full detail.

### TypeScript
- `"strict": true` in every tsconfig
- No `any` — use `unknown` + type guards
- No `// @ts-ignore` without a comment

### React / Next.js
- Server Components by default; `'use client'` only when needed
- Loading state: `if (loading && !data)` — never `if (loading)`
- Always handle: loading → error → empty → success

### NestJS
- Every DTO validated with Zod via `nestjs-zod`
- Every endpoint documented with `@ApiOperation` + `@ApiResponse`

### Spring Boot
- `@Valid` on all controller inputs
- `@Transactional(readOnly = true)` on query methods
- DTOs as Java Records — never expose JPA entities directly

### Database
- UUID primary keys with `defaultRandom()`
- All timestamps `{ withTimezone: true }`
- All multi-step writes in `db.transaction()`

### Security
- No secrets in source code — ever
- Validate all user input at every entry point
- Auth at route level; authorization in service layer

### Git
- No direct commits to `main` — PRs only
- Conventional commits: `feat/fix/chore/docs/refactor/test(scope): description`
- Run `/verify-all` before every PR

## Project Structure (Assumed Monorepo)

```
my-app/
├── apps/
│   ├── web/              # Next.js 15 frontend
│   └── api/              # NestJS backend
├── services/
│   └── enterprise/       # Java/Spring Boot (optional)
├── packages/
│   ├── database/         # Drizzle schema + migrations
│   ├── types/            # Shared TypeScript types
│   └── ui/               # Shared UI components (optional)
├── .claude/              # This configuration
├── CLAUDE.md             # This file
└── package.json          # pnpm workspaces root
```

## Key Commands Quick Reference

```bash
pnpm dev              # Start all services (requires turbo)
pnpm dev:web          # Start Next.js only
pnpm dev:api          # Start NestJS only
pnpm build            # Production build
pnpm test             # Run all tests
pnpm lint             # Lint all packages
pnpm typecheck        # TypeScript check all packages
pnpm db:migrate       # Run Drizzle migrations
pnpm db:studio        # Open Drizzle Studio
```
