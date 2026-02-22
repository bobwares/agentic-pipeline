# Context: Skills — Available Capabilities and Invocation Guide

## Purpose

Documents all skills available in the agentic-pipeline, how they are organized, when they activate, and how to invoke them.

---

## Skills Directory

All skills live under `.claude/skills/`. Each skill is a directory containing a `SKILL.md` manifest.

```
.claude/skills/
├── [Domain Knowledge Skills — auto-activated by skill-eval hook]
│   ├── api-design-patterns/
│   ├── drizzle-patterns/
│   ├── nestjs-patterns/
│   ├── nextjs-patterns/
│   ├── react-ui-patterns/
│   ├── shadcn-patterns/
│   ├── spring-patterns/
│   ├── testing-patterns/
│   ├── vercel-ai-patterns/
│   └── systematic-debugging/
│
├── [Workflow Skills — manually invoked]
│   ├── execute/              # Master one-command pipeline trigger
│   ├── spec-prd-new/         # Create a new PRD
│   ├── spec-prd-parse/       # Parse PRD into DDD-aligned epics
│   ├── spec-prd-list/        # List all PRDs
│   ├── spec-epic-start/      # Launch an epic
│   ├── spec-task-next/       # Show/advance current task
│   ├── ddd-parse/            # Parse DDD document into model.json
│   ├── project-init/         # Scaffold monorepo structure
│   ├── session-start/        # Session initialization
│   ├── session-end/          # Session wrap-up and memory update
│   ├── memory-init/          # Initialize memory bank
│   ├── verify-all/           # Full quality gate
│   ├── test-and-fix/         # Run tests and auto-fix failures
│   ├── security-scan/        # OWASP security review
│   ├── git-commit-push-pr/   # Conventional commit + push + PR
│   ├── git-quick-commit/     # Fast checkpoint commit
│   ├── git-checkpoint/       # Save current state
│   ├── git-rollback/         # Rollback to checkpoint
│   ├── git-undo/             # Undo last commit
│   ├── context-prime/        # Load project context
│   ├── mode/                 # Switch agent mode
│   └── fix-issue/            # Fix a specific issue
│
└── [Governance Skills — active every session]
    ├── governance/           # Metadata headers, versioning, git standards
    └── adr/                  # Architecture Decision Record policy
```

---

## Skill Types

### Domain Knowledge Skills

**Activation**: Automatically via the `skill-eval` hook (UserPromptSubmit event). The hook scores the incoming prompt against keyword patterns and path patterns, then injects the highest-scoring skill's context.

**Scoring system** (from `skill-rules.json`):
- Keyword match: +2 points
- Keyword pattern match: +3 points
- Path pattern match: +4 points
- Directory match: +5 points
- Intent pattern match: +4 points

**Directory mappings** — auto-activated when working in these paths:
| Directory | Skill |
|-----------|-------|
| `apps/web/app` | nextjs-patterns |
| `apps/api/src/modules` | nestjs-patterns |
| `services/enterprise/src` | spring-patterns |
| `packages/database/src/schema` | drizzle-patterns |
| `packages/ui/src/components` | shadcn-patterns |
| `apps/web/src/ai` | vercel-ai-patterns |
| `*.test.ts`, `*.spec.ts` | testing-patterns |

### Governance Skills

**Activation**: Always active. Loaded at session start. Apply to every file write and git operation.

| Skill | Triggers |
|-------|---------|
| `governance` | Writing/modifying any source file; creating branches; writing commits |
| `adr` | Making architectural decisions; end of every turn (mandatory) |

### Workflow Skills

**Activation**: Manually invoked by typing `/skill-name` in Claude Code.

---

## Workflow Skills Quick Reference

| Skill | Command | Description |
|-------|---------|-------------|
| execute | `/execute prd=... ddd=... stack=...` | One-command: PRD+DDD+stack → working app |
| ddd-parse | `/ddd-parse docs/app.ddd.md` | Parse DDD doc into model.json |
| project-init | `/project-init nextjs+nestjs+drizzle` | Scaffold monorepo |
| spec-prd-new | `/spec-prd-new` | Start writing a new PRD |
| spec-prd-parse | `/spec-prd-parse <name>` | Generate epic from PRD |
| spec-epic-start | `/spec-epic-start <name>` | Launch epic execution |
| spec-task-next | `/spec-task-next` | Advance to next task |
| memory-init | `/memory-init` | Initialize 6-file memory bank |
| session-start | `/session-start` | Load context, show status |
| session-end | `/session-end` | Update memory, commit state |
| verify-all | `/verify-all` | typecheck + lint + test + build |
| test-and-fix | `/test-and-fix` | Run tests, auto-fix failures |
| security-scan | `/security-scan` | OWASP security review |
| git-commit-push-pr | `/git-commit-push-pr` | Commit + push + open PR |
| git-quick-commit | `/git-quick-commit` | Fast checkpoint commit |
| git-checkpoint | `/git-checkpoint` | Save state |
| git-rollback | `/git-rollback` | Rollback to checkpoint |
| git-undo | `/git-undo` | Undo last commit |
| context-prime | `/context-prime` | Load full project context |
| fix-issue | `/fix-issue <description>` | Fix a specific issue |
| mode | `/mode <mode-name>` | Switch agent mode |

---

## Skill Package Structure

Each skill directory contains:

```
skill-name/
└── SKILL.md          # Required: skill manifest
```

The `SKILL.md` format:
```markdown
---
name: skill-name
description: What this skill does
triggers:
  - when condition 1
  - when condition 2
---

# Skill Name

[Skill content — procedures, standards, templates]
```

---

## Governance Skills Integration

The `governance` and `adr` skills are always loaded and apply globally. They do not need to be invoked manually — the orchestration lifecycle calls them automatically at the appropriate steps:

- `governance` → Step 5 (during execution, on every file write)
- `adr` → Step 8 (post-execution, mandatory every turn)
