---
name: spec-prd-parse
description: Parse a PRD into a technical epic with ordered tasks. Arguments: feature name (must match a file in .claude/prds/).
disable-model-invocation: false
---

# Parse PRD into Epic + Tasks

Feature: $ARGUMENTS

## Step 1: Read the PRD

Read `.claude/prds/$ARGUMENTS.md`

If not found: list files in `.claude/prds/` and ask which one to use.

## Step 2: Analyze Technical Scope

From the PRD, identify:
- Database schema changes needed
- API endpoints needed (NestJS or Spring)
- Next.js pages/components needed
- AI features needed (if any)
- Tests needed

## Step 3: Generate Epic

Write the epic to `.claude/epics/$ARGUMENTS/epic.md`:

```markdown
---
title: [Feature Name]
prd: .claude/prds/$ARGUMENTS.md
status: planned
created: [date]
branch: epic/$ARGUMENTS
---

# Epic: [Feature Name]

## Summary
[2-3 sentence technical summary of what will be built]

## Tech Stack Layers Affected
- [ ] Database (Drizzle schema + migration)
- [ ] API — NestJS (`apps/api/`)
- [ ] API — Spring (`services/enterprise/`)
- [ ] Frontend — Next.js (`apps/web/`)
- [ ] AI Features
- [ ] Tests

## Task Breakdown

### Phase 1: Foundation
- [ ] **T1** [Database] Design and create Drizzle schema for [entities] → `drizzle-dba`
- [ ] **T2** [Database] Generate and verify migration → `drizzle-dba`

### Phase 2: API
- [ ] **T3** [NestJS] Create [Feature]Module, Controller, Service, DTOs → `nestjs-engineer`
- [ ] **T4** [NestJS] Add authentication/authorization guards → `nestjs-engineer`

### Phase 3: Frontend
- [ ] **T5** [Next.js] Create [list page] with loading/error/empty states → `nextjs-engineer`
- [ ] **T6** [Next.js] Create [create/edit form] with server action → `nextjs-engineer`

### Phase 4: Quality
- [ ] **T7** [Tests] Write unit tests for service layer → `test-writer`
- [ ] **T8** [Tests] Write E2E tests for critical flows → `test-writer`
- [ ] **T9** [Review] Code review and security scan → `code-reviewer` + `security-auditor`

## Completion Criteria
- [ ] All tasks checked above
- [ ] `/verify-all` passes
- [ ] Manual E2E tested in browser
- [ ] PR created with review
```

## Step 4: Brief User

Show the epic and ask: "Ready to start? Run `/spec-epic-start $ARGUMENTS` to begin implementation, or adjust the task list first."
