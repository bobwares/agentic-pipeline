---
name: execute
description: One-command full app build. Provide PRD path, DDD path, and tech stack — the pipeline does the rest. Usage: /execute prd=<path> ddd=<path> stack=<stack>
---

# Execute — Full Pipeline Trigger

You are the entry point for the agentic-pipeline's one-command build mode.

The user has supplied everything you need. **Do not ask any clarifying questions.** Parse the arguments, validate inputs, and drive the complete pipeline from PRD + DDD + tech stack all the way to a working, verified, committed codebase.

---

## Step 0: Parse Arguments

Parse the invocation arguments. Accepted formats:

```
/execute prd=docs/my-app.prd.md ddd=docs/my-app.ddd.md stack=nextjs+nestjs+drizzle+shadcn
/execute prd=my-app ddd=my-app stack=nextjs+nestjs+drizzle+shadcn+spring
/execute docs/prd.md docs/ddd.md nextjs+nestjs+drizzle+shadcn
```

Resolution rules:
- If the path ends in `.md` and exists, use it directly
- If it's a bare name like `my-app`, check `.claude/prds/my-app.prd.md`, then `.claude/prds/my-app.md`, then `docs/my-app.prd.md`
- For the DDD file: check `.claude/ddd/<name>.ddd.md`, then `docs/<name>.ddd.md`
- Tech stack: parse `+`-separated tokens. Valid tokens:
  - `nextjs` or `next` — Next.js 15 App Router frontend
  - `nestjs` or `nest` — NestJS API backend
  - `spring` or `springboot` — Java Spring Boot enterprise API
  - `drizzle` — Drizzle ORM + PostgreSQL
  - `shadcn` or `ui` — shadcn/ui + Tailwind CSS
  - `ai` or `vercel-ai` — Vercel AI SDK

If any required input is missing or a file does not exist, report exactly what is missing and stop. Example:
```
❌ Cannot execute: PRD file not found.
   Tried: .claude/prds/my-app.prd.md, docs/my-app.prd.md
   Fix: Create the PRD file or run /spec-prd-new my-app first.
```

---

## Step 1: Read and Validate Inputs

Read both input files completely.

**Read the PRD** and confirm it contains:
- A clear problem statement
- At least one user story or goal
- Success criteria

**Read the DDD document** and confirm it contains:
- At least one bounded context
- Domain entities or aggregates

**If either document is missing critical sections**, report what is incomplete and stop. The user must fix the document before executing.

Print a validation summary:
```
✅ PRD validated: <title> — <one-sentence summary>
✅ DDD validated: <N> bounded contexts, <N> aggregates, <N> entities
✅ Tech stack: <list of selected layers>

Starting full pipeline...
```

---

## Step 2: Initialize Project Structure

Invoke the `project-init` skill with the resolved tech stack.

This skill scaffolds the monorepo directory structure, creates config files, and sets up the workspace so specialist agents have a consistent foundation to build on.

Wait for `project-init` to complete before proceeding.

---

## Step 3: Parse DDD into Domain Model

Invoke the `ddd-parse` skill with the DDD document path.

This skill reads the DDD document and outputs a structured domain model at `.claude/domain/model.json` containing:
- Bounded contexts with their aggregates
- Entities and their fields
- Value objects
- Domain events
- Relationships between aggregates

Wait for `ddd-parse` to complete before proceeding.

---

## Step 4: Parse PRD into Epics

Invoke the `spec-prd-parse` skill with the PRD name AND the domain model.

`spec-prd-parse` will read `.claude/domain/model.json` to:
- Map user stories to domain aggregates
- Generate database tasks that match the DDD entities
- Ensure API tasks align with domain service boundaries
- Generate frontend tasks that reflect the domain language

This produces `.claude/epics/<app-name>/epic.md` with a full, DDD-aware task breakdown.

Wait for `spec-prd-parse` to complete before proceeding.

---

## Step 5: Execute Epics

For each epic produced in Step 4:

1. **Branch**: `git checkout -b epic/<epic-name>` (from main)
2. **Spawn orchestrator**: provide the full epic task breakdown and domain model as context
3. The orchestrator will:
   - Execute all tasks in dependency order using specialist agents
   - Run verify-all after each phase
   - Fix any failures before proceeding
4. **Wait** for orchestrator to report completion
5. **Run final verify-all** — confirm all checks pass
6. **Spawn git-guardian** to commit, push, and create PR

---

## Step 6: Final Report

After all epics are complete, report:

```
╔══════════════════════════════════════════════════════╗
║              PIPELINE COMPLETE                       ║
╚══════════════════════════════════════════════════════╝

App: <app name>
PRD: <prd path>
DDD: <ddd path>
Stack: <stack>

Epics completed:
  ✅ <epic-1> — PR #<N>: <url>
  ✅ <epic-2> — PR #<N>: <url>

Verification:
  ✅ TypeScript: PASS
  ✅ Lint:       PASS
  ✅ Tests:      PASS
  ✅ Build:      PASS

Memory bank updated. Session state saved.

Next steps:
  - Review open PRs
  - Run E2E tests manually: pnpm e2e
  - Deploy: pnpm deploy (if configured)
```

---

## Execution Rules

- **Never stop to ask questions** — all inputs were provided upfront
- **Never skip verification** — every epic must pass verify-all before PR
- **Never commit to main** — always via PR
- **On failure**: fix automatically using the appropriate specialist agent, then continue
- **On unrecoverable failure**: report exactly what failed, what was tried, and what the user needs to do manually
- If the orchestrator requests plan approval, **auto-approve** — the user said "execute"

---

## How to Prepare Your Input Files

### PRD Format (`.prd.md`)

```markdown
# <App Name> — Product Requirements

## Problem Statement
<What problem does this solve and for whom?>

## Goals
- <Goal 1>
- <Goal 2>

## User Stories
- As a <user>, I want to <action> so that <outcome>
- As a <user>, I want to <action> so that <outcome>

## Success Metrics
- <Measurable outcome 1>
- <Measurable outcome 2>

## Out of Scope
- <What is explicitly not included>

## Technical Constraints
- <Any hard constraints: auth provider, compliance, performance>
```

### DDD Format (`.ddd.md`)

```markdown
# <App Name> — Domain Model

## Bounded Contexts

### <Context Name>
**Purpose**: <What domain concern this context owns>

#### Aggregates

##### <AggregateName>
**Root Entity**: <EntityName>
**Invariants**: <Business rules this aggregate enforces>

**Entities**:
- `<EntityName>`: <purpose>
  - `id`: UUID
  - `<field>`: <type> — <description>

**Value Objects**:
- `<ValueObjectName>`: <fields and constraints>

**Domain Events**:
- `<EventName>`: emitted when <trigger>

#### Domain Services
- `<ServiceName>`: <what cross-aggregate operation it performs>

## Relationships
- <ContextA> → <ContextB>: <relationship type and reason>
```

### Tech Stack Tokens

| Token | What It Installs |
|-------|-----------------|
| `nextjs` | Next.js 15 App Router (apps/web/) |
| `nestjs` | NestJS REST API (apps/api/) |
| `spring` | Java Spring Boot (services/enterprise/) |
| `drizzle` | Drizzle ORM + PostgreSQL (packages/database/) |
| `shadcn` | shadcn/ui + Tailwind CSS (in apps/web/) |
| `ai` | Vercel AI SDK (in apps/web/ and/or apps/api/) |

### Full Example Invocation

```
/execute prd=docs/taskflow.prd.md ddd=docs/taskflow.ddd.md stack=nextjs+nestjs+drizzle+shadcn
```
