# How to Build Apps with agentic-pipeline

## The One-Command Workflow

You supply three documents and say **execute**. The pipeline does everything else.

```
/execute prd=docs/myapp.prd.md ddd=docs/myapp.ddd.md stack=nextjs+nestjs+drizzle+shadcn
```

That single command drives the pipeline from blank directory → working, tested, committed codebase.

---

## What You Supply

### 1. The PRD (Product Requirements Document)

**What it is**: What to build — the product specification.

**Where to put it**: `docs/myapp.prd.md` (or anywhere — you pass the path to `/execute`)

**Format**:

```markdown
# TaskFlow — Product Requirements

## Problem Statement
Engineering teams lose track of who is working on what across sprints.
TaskFlow gives teams a single place to manage tasks with real-time status.

## Goals
- Reduce status-meeting time by 50%
- Give managers instant visibility into blockers
- Let engineers self-assign tasks without email chains

## User Stories
- As an engineer, I want to see all tasks assigned to me so I know what to work on today
- As a manager, I want to see all tasks in a sprint so I can spot blockers early
- As a team lead, I want to create and assign tasks so work gets distributed clearly
- As any user, I want to mark tasks as complete so the board stays accurate

## Success Metrics
- 80% of teams check the board daily after 2 weeks
- Average task-to-close time drops by 30%
- Zero missed deadlines due to lost context

## Out of Scope
- Time tracking
- Billing or invoicing
- Mobile apps (web only for v1)

## Technical Constraints
- Must support 100 concurrent users
- PostgreSQL for persistence
- JWT authentication
```

**Key sections** (all required):
| Section | What to write |
|---------|--------------|
| `Problem Statement` | One paragraph: the pain, who feels it |
| `Goals` | 3–5 bullet outcomes, not features |
| `User Stories` | "As a [role], I want to [action] so that [outcome]" |
| `Success Metrics` | Measurable results |
| `Out of Scope` | Explicit exclusions (prevents scope creep) |
| `Technical Constraints` | Hard requirements: auth method, scale, compliance |

---

### 2. The DDD Document (Domain-Driven Design)

**What it is**: The domain model — entities, aggregates, business rules, ubiquitous language. This is what makes the generated code match your business domain exactly.

**Where to put it**: `docs/myapp.ddd.md`

**Format**:

```markdown
# TaskFlow — Domain Model

## Bounded Contexts

### Task Management Context
**Purpose**: Owns the complete lifecycle of tasks and their assignment to engineers.

#### Aggregates

##### Task Aggregate
**Root Entity**: Task
**Invariants**:
- A task can only be assigned to one engineer at a time
- Completed tasks cannot be reopened without manager approval
- Task status must follow: Backlog → In Progress → In Review → Done

**Entities**:
- `Task`: A unit of work assigned to an engineer
  - `id`: UUID
  - `title`: text — short description of the work
  - `description`: text — detailed requirements, nullable
  - `status`: enum(backlog, in_progress, in_review, done) — default: backlog
  - `priority`: enum(low, medium, high, critical) — default: medium
  - `assigneeId`: UUID — references User.id
  - `sprintId`: UUID — references Sprint.id, nullable
  - `dueDate`: timestamp
  - `completedAt`: timestamp, nullable

**Value Objects**:
- `TaskStatus`: enum of backlog | in_progress | in_review | done
  - Only valid transitions: backlog→in_progress, in_progress→in_review, in_review→done

**Domain Events**:
- `TaskCreated`: emitted when a new task is saved — payload: taskId, title, assigneeId
- `TaskAssigned`: emitted when assigneeId changes — payload: taskId, previousAssigneeId, newAssigneeId
- `TaskCompleted`: emitted when status→done — payload: taskId, completedAt, assigneeId

#### Domain Services
- `TaskAssignmentService`: Validates that assignee is an active team member before assignment

---

### Sprint Management Context
**Purpose**: Groups tasks into time-boxed delivery cycles.

#### Aggregates

##### Sprint Aggregate
**Root Entity**: Sprint
**Invariants**:
- A sprint must have a start date before its end date
- Active sprints cannot be deleted (only closed)
- Only one sprint can be active per team at a time

**Entities**:
- `Sprint`: A time-boxed delivery cycle
  - `id`: UUID
  - `name`: text — e.g. "Sprint 12"
  - `teamId`: UUID — references Team.id
  - `startDate`: timestamp
  - `endDate`: timestamp
  - `status`: enum(planned, active, closed) — default: planned

**Domain Events**:
- `SprintStarted`: emitted when status→active — payload: sprintId, teamId, startDate
- `SprintClosed`: emitted when status→closed — payload: sprintId, completedTaskCount

---

### User Management Context
**Purpose**: Manages engineers, managers, and their team memberships.

#### Aggregates

##### User Aggregate
**Root Entity**: User
**Invariants**:
- Email must be unique across the system
- A user must belong to at least one team

**Entities**:
- `User`: A person who uses the system
  - `id`: UUID
  - `name`: text
  - `email`: text — unique
  - `role`: enum(engineer, manager, admin) — default: engineer
  - `teamId`: UUID — references Team.id

##### Team Aggregate
**Root Entity**: Team
**Entities**:
- `Team`: A group of engineers managed by one or more managers
  - `id`: UUID
  - `name`: text
  - `slug`: text — unique URL identifier

---

## Relationships
- Task Management → User Management: **upstream-downstream** — Tasks reference Users by ID; User context owns user identity
- Task Management → Sprint Management: **upstream-downstream** — Tasks optionally belong to Sprints; Sprint context owns sprint lifecycle
- Sprint Management → User Management: **shared-kernel** — Both contexts use Team as a shared concept

## Ubiquitous Language
| Term | Definition |
|------|-----------|
| Task | A discrete, assignable unit of engineering work |
| Sprint | A time-boxed period (usually 2 weeks) for completing a set of tasks |
| Backlog | Tasks not yet assigned to a sprint |
| Assignee | The engineer responsible for completing a task |
| Team Lead | An engineer with permission to create and assign tasks |
| Done | A task status meaning all acceptance criteria are met and code is merged |
```

**Key sections**:
| Section | What to write |
|---------|--------------|
| `Bounded Contexts` | Named subdomains. Each owns a distinct business capability |
| `Aggregates` | Consistency boundaries. Each has one root entity and business rules (invariants) |
| `Entities` | Objects with identity. Include all fields with types |
| `Value Objects` | Immutable descriptors, constraints |
| `Domain Events` | Named things that happened — what triggers them, what data they carry |
| `Domain Services` | Operations that span multiple aggregates |
| `Relationships` | How contexts depend on each other (upstream/downstream, shared kernel, ACL) |
| `Ubiquitous Language` | The exact terms used in the domain — these become your class, table, and route names |

---

### 3. The Tech Stack

**What it is**: Which layers to generate code for.

**Format**: `+`-separated tokens passed to `/execute`

| Token | Generates |
|-------|----------|
| `nextjs` | `apps/web/` — Next.js 15 App Router frontend |
| `nestjs` | `apps/api/` — NestJS REST API |
| `spring` | `services/enterprise/` — Java Spring Boot API |
| `drizzle` | `packages/database/` — Drizzle ORM + PostgreSQL |
| `shadcn` | shadcn/ui + Tailwind CSS in the web app |
| `ai` | Vercel AI SDK (chat, streaming, structured output) |

**Common combinations**:
```
nextjs+nestjs+drizzle+shadcn          # Standard web app
nextjs+nestjs+drizzle+shadcn+ai       # AI-powered web app
nextjs+nestjs+spring+drizzle+shadcn   # Enterprise (Node + Java backends)
nestjs+drizzle                         # API only (no frontend)
```

---

## The Full Workflow: Step by Step

### Option A: One Command (Recommended)

```bash
# 1. Install Claude Code in your project directory
cd my-project
bash /path/to/agentic-pipeline/install.sh .

# 2. Open Claude Code
claude

# 3. Initialize memory
/memory-init

# 4. Fire the pipeline
/execute prd=docs/taskflow.prd.md ddd=docs/taskflow.ddd.md stack=nextjs+nestjs+drizzle+shadcn
```

The pipeline runs automatically through these stages:

```
/execute
  │
  ├─ Step 1: Validate PRD + DDD documents
  │
  ├─ Step 2: /project-init — scaffold monorepo structure
  │            apps/web/, apps/api/, packages/database/, packages/types/
  │
  ├─ Step 3: /ddd-parse — extract structured domain model
  │            .claude/domain/model.json
  │            .claude/domain/model.md
  │
  ├─ Step 4: /spec-prd-parse — generate DDD-aligned epic
  │            .claude/epics/taskflow/epic.md
  │            (tasks mapped to domain aggregates and bounded contexts)
  │
  ├─ Step 5: For each epic:
  │   ├─ git checkout -b epic/taskflow
  │   ├─ orchestrator: Phase 1 Foundation
  │   │   └─ drizzle-dba: create schema matching model.json entities exactly
  │   ├─ orchestrator: Phase 2 API
  │   │   └─ nestjs-engineer: modules named after bounded contexts
  │   ├─ orchestrator: Phase 3 Frontend
  │   │   └─ nextjs-engineer: pages using domain language in routes
  │   ├─ orchestrator: Phase 4 Quality
  │   │   ├─ test-writer: unit + E2E tests
  │   │   └─ security-auditor: OWASP review
  │   ├─ verify-all: typecheck + lint + test + build (must pass)
  │   └─ git-guardian: commit + push + PR
  │
  └─ Final report with PR links
```

---

### Option B: Step by Step (More Control)

Use this when you want to review and approve each phase.

```bash
# 1. Install and open Claude Code
claude

# 2. Initialize memory
/memory-init

# 3. Parse domain model from DDD doc
/ddd-parse docs/taskflow.ddd.md
# → Review .claude/domain/model.md to confirm model is correct

# 4. Generate epic from PRD (uses domain model automatically)
/spec-prd-parse taskflow
# → Review .claude/epics/taskflow/epic.md — edit if needed

# 5. Start the epic
/spec-epic-start taskflow
# → Creates branch, spawns orchestrator
# → Orchestrator WILL ask for plan approval (Phase 2 of its workflow)
# → Review the plan, say "approve" to proceed

# 6. Monitor progress
/spec-task-next
# → Shows current task, which agent is working, what's next

# 7. Run quality gate
/verify-all
# → Fixes any failures automatically

# 8. Ship
/git-commit-push-pr
# → Creates PR with full description
```

---

## What the Pipeline Guarantees

When `/execute` completes:

✅ **Monorepo scaffolded** — consistent structure for all stack layers
✅ **Database schema matches your DDD entities** — same names, same fields, same relations
✅ **API modules named after bounded contexts** — domain language in the code
✅ **Frontend routes use domain entity names** — `/tasks`, `/sprints`, `/users`
✅ **TypeScript strict mode passes** — no `any`, no type errors
✅ **All tests pass** — unit tests with factory functions, E2E critical paths
✅ **Lint clean** — consistent code style
✅ **Build succeeds** — production build works
✅ **Security scan complete** — OWASP Top 10 reviewed
✅ **PRs created** — one per epic, with full descriptions and checklists
✅ **Memory bank updated** — session state, decisions, and progress saved

---

## Tips for Best Results

### PRD Tips

- **Be specific about user stories** — vague stories produce vague tasks. "As a manager, I want to see a dashboard" is weaker than "As a manager, I want to see all open tasks grouped by assignee on a single page."
- **Include constraints** — auth method, performance requirements, compliance needs
- **Out of Scope matters** — explicitly list what you're NOT building to prevent the pipeline from generating unnecessary code

### DDD Tips

- **Use your actual business language** — if your domain calls it a "Task" not a "Todo", write "Task". The pipeline will use this word in table names, class names, routes, and JSDoc.
- **Define invariants precisely** — "Completed tasks cannot be reopened" becomes a service-layer guard. "Status must follow X → Y → Z" becomes a state machine in the service.
- **List all fields on entities** — the pipeline generates Drizzle schema directly from your entity field definitions. Incomplete fields mean incomplete schema.
- **Domain Events are powerful** — even if you don't implement an event bus on day one, listing events forces the pipeline to design service methods around them.

### Stack Tips

- Start with `nextjs+nestjs+drizzle+shadcn` for most web apps
- Add `spring` only if you have genuine enterprise integration needs (LDAP, ERP, legacy Java services)
- Add `ai` only if your PRD includes AI features — it adds AI SDK setup to both frontend and API

---

## Directory Layout After `/execute`

```
my-project/
├── apps/
│   ├── web/                    # Next.js 15 App Router
│   │   ├── src/app/
│   │   │   ├── tasks/          # Route: /tasks (Task aggregate)
│   │   │   │   ├── page.tsx    # Server component — list tasks
│   │   │   │   └── new/
│   │   │   │       └── page.tsx # Create task form
│   │   │   ├── sprints/        # Route: /sprints (Sprint aggregate)
│   │   │   └── layout.tsx
│   │   └── src/components/
│   │       └── ui/             # shadcn/ui components
│   └── api/                    # NestJS REST API
│       └── src/modules/
│           ├── tasks/          # TaskManagement bounded context
│           │   ├── tasks.module.ts
│           │   ├── tasks.controller.ts
│           │   ├── tasks.service.ts
│           │   └── dto/
│           ├── sprints/        # SprintManagement bounded context
│           └── users/          # UserManagement bounded context
├── packages/
│   ├── database/               # Drizzle ORM
│   │   └── src/schema/
│   │       ├── tasks.ts        # tasks table (matches Task entity from DDD)
│   │       ├── sprints.ts      # sprints table
│   │       └── users.ts        # users table
│   └── types/                  # Shared TypeScript types
│       └── src/
│           ├── task.ts         # Task, NewTask types
│           └── sprint.ts
├── e2e/                        # Playwright E2E tests
│   └── tasks.spec.ts
├── .claude/
│   ├── domain/
│   │   ├── model.json          # Machine-readable domain model
│   │   └── model.md            # Human-readable domain summary
│   ├── prds/
│   │   └── taskflow.prd.md
│   └── epics/
│       └── taskflow/
│           └── epic.md
├── docker-compose.yml
├── package.json                # pnpm workspace root
├── turbo.json
└── CLAUDE.md
```

---

## Frequently Asked Questions

**Q: Do I have to write DDD documents? Can I skip it?**
A: Yes, you can skip it. `/execute` and `/spec-prd-parse` both work without a DDD document — they'll generate a reasonable task breakdown from the PRD alone. But the generated code won't use your domain language, and you'll need to rename things yourself. DDD gives you domain-correct code out of the box.

**Q: What if the pipeline generates wrong code?**
A: The pipeline never auto-merges PRs. Every epic produces a PR that you review. If something is wrong, the specialist agents are named and available — e.g., `/nestjs-engineer` fix the tasks module to use optimistic locking. The memory bank records all decisions and conventions.

**Q: Can I run `/execute` on an existing project?**
A: Yes. `/project-init` skips files that already exist. The pipeline reads your existing structure and builds on top of it. Run `/memory-init` first so Claude understands your existing codebase.

**Q: What if a verification step fails?**
A: `/execute` never gives up on a failure — it spawns the appropriate specialist agent to fix it, then re-runs verification. If after 3 attempts it still fails, it reports exactly what failed and what was tried, then asks you what to do.

**Q: How long does `/execute` take?**
A: Depends on the size of your PRD and DDD. A small app (3–4 aggregates, 2 bounded contexts) typically takes 15–30 minutes of agent execution time. A large app (10+ aggregates, 5+ contexts) may take an hour or more.

**Q: Can I add more features after the initial build?**
A: Yes — this is the ongoing workflow. Write a new PRD, run `/spec-prd-parse`, then `/spec-epic-start`. The orchestrator reads the existing codebase before planning so it builds on top of what's already there.
