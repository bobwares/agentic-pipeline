# Context: Container — Base Directories and Path Configuration

## Purpose

This context file defines the canonical directory layout and path variables used throughout the agentic-pipeline. All paths are resolved from the project root (`.`). These are **early-bound** variables: resolved once at session load time and stable for the entire session.

---

## Variable Syntax

| Syntax | Binding | Resolved |
|--------|---------|---------|
| `${VAR}` | Early-bound | At session start — stable, fixed paths |
| `{{VAR}}` | Late-bound | At template render time — dynamic per-turn values |

---

## Core Identity Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `CODING_AGENT` | `claude` | Agent identity — never modify codex directories |
| `SANDBOX_BASE_DIRECTORY` | `.` | Project root — all paths relative to this |

---

## Agentic Pipeline Directories

| Variable | Path | Description |
|----------|------|-------------|
| `AGENTIC_PIPELINE_PROJECT` | `./.claude` | Pipeline configuration root |
| `CONTAINER_SKILLS` | `./.claude/skills` | All skill packages |
| `CONTAINER_CONTEXT` | `./.claude/context` | Context reference files |
| `CONTAINER_TEMPLATES` | `./.claude/templates` | Artifact templates |
| `CONTAINER_MEMORY` | `./.claude/memory` | Memory bank files |
| `CONTAINER_AGENTS` | `./.claude/agents` | Agent definitions |
| `CONTAINER_HOOKS` | `./.claude/hooks` | Hook scripts |
| `CONTAINER_RULES` | `./.claude/rules` | Rule files |

---

## Turn Artifact Directories (per project)

When installed into a target project, the pipeline creates:

| Variable | Path | Description |
|----------|------|-------------|
| `TURN_ROOT` | `./ai/agentic-pipeline` | All pipeline runtime artifacts |
| `TURNS_DIRECTORY` | `./ai/agentic-pipeline/turns` | One directory per turn |
| `TURNS_INDEX` | `./ai/agentic-pipeline/turns_index.csv` | Turn metadata registry |
| `AI_CONTEXT` | `./ai/context` | Project-level context docs |
| `PROJECT_CONTEXT_FILE` | `./ai/context/project_context.md` | Project identity document |

---

## Template Paths

| Variable | Path | Description |
|----------|------|-------------|
| `TEMPLATES` | `./.claude/templates` | Root templates directory |
| `TEMPLATE_METADATA_HEADER` | `./.claude/templates/governance/metadata_header.txt` | Code file header |
| `TEMPLATE_BRANCH_NAMING` | `./.claude/templates/governance/branch_naming.md` | Branch name format |
| `TEMPLATE_COMMIT_MESSAGE` | `./.claude/templates/governance/commit_message.md` | Commit format |
| `TEMPLATE_SESSION_CONTEXT` | `./.claude/templates/contexts/session_context.md` | Session doc template |
| `TEMPLATE_ADR` | `./.claude/templates/adr/adr_template.md` | ADR template |
| `TEMPLATE_PULL_REQUEST` | `./.claude/templates/pr/pull_request_template.md` | PR doc template |
| `TEMPLATE_MANIFEST_SCHEMA` | `./.claude/templates/turn/manifest.schema.json` | Manifest JSON schema |

---

## Project Source Directories (conventional monorepo)

| Path | Contents |
|------|----------|
| `./apps/web` | Next.js 15 App Router frontend |
| `./apps/api` | NestJS REST API |
| `./services/enterprise` | Java Spring Boot service |
| `./packages/database` | Drizzle ORM schema and migrations |
| `./packages/types` | Shared TypeScript types |
| `./e2e` | Playwright end-to-end tests |

---

## Agent Directory Isolation

Claude may only write design documents to the `./claude/` design directory. It must never write to `./codex/`. Every design document must declare `Agent: claude` in its front matter.

| Agent | Design Directory | Source |
|-------|-----------------|--------|
| `claude` | `./claude/` | All source directories |
| `codex` | `./codex/` | All source directories |
