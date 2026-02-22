# Context: Session — Turn-Specific Variables

## Purpose

Defines variables that are computed or resolved at the **start of each turn**. These are late-bound: their values change every turn. They are resolved by the orchestration skill during Step 1 of the turn lifecycle.

---

## Turn Identity

| Variable | How Resolved | Example |
|----------|-------------|---------|
| `TURN_ID` | Read `turns_index.csv`, take `max(turn_id) + 1`. If file doesn't exist, `TURN_ID = 1` | `42` |
| `CURRENT_TURN_DIRECTORY` | `${TURNS_DIRECTORY}/turn-${TURN_ID}` | `./ai/agentic-pipeline/turns/turn-42` |

### turns_index.csv Format

```csv
turn_id,started_at,finished_at,elapsed_seconds,branch,commit_sha,task_summary
1,2026-01-15T09:00:00Z,2026-01-15T09:23:14Z,1394,feat/task-service-T1,abc1234,Implement TaskService with repository pattern
2,2026-01-15T10:05:00Z,2026-01-15T10:41:22Z,2182,feat/sprint-lifecycle-T2,def5678,Sprint lifecycle management and events
```

**Columns**:
- `turn_id` — Monotonically increasing integer starting at 1
- `started_at` — ISO 8601 UTC timestamp when turn began
- `finished_at` — ISO 8601 UTC timestamp when turn completed
- `elapsed_seconds` — Duration in seconds
- `branch` — Git branch active for this turn
- `commit_sha` — Short commit SHA after turn commit
- `task_summary` — One-line summary of what was accomplished

---

## Turn Timing

| Variable | How Resolved | Format |
|----------|-------------|--------|
| `TURN_START_TIME` | `date -u +"%Y-%m-%dT%H:%M:%SZ"` at turn start | `2026-02-22T14:35:00Z` |
| `TURN_END_TIME` | `date -u +"%Y-%m-%dT%H:%M:%SZ"` at turn end | `2026-02-22T15:02:47Z` |
| `TURN_ELAPSED_TIME` | `TURN_END_TIME - TURN_START_TIME` in seconds | `1,667 seconds` |

---

## Project Paths

| Variable | Value | Description |
|----------|-------|-------------|
| `TARGET_PROJECT` | `$(pwd)` — absolute path | Current working directory when session started |
| `PROJECT_CONTEXT` | `${TARGET_PROJECT}/ai/context/project_context.md` | Project identity reference |

---

## Turn Artifact Paths

All artifacts live inside `CURRENT_TURN_DIRECTORY`:

| Artifact | Path | Written By |
|----------|------|-----------|
| `session_context.md` | `${CURRENT_TURN_DIRECTORY}/session_context.md` | Step 3 — Pre-Execution |
| `pull_request.md` | `${CURRENT_TURN_DIRECTORY}/pull_request.md` | Step 7 — Post-Execution |
| `adr.md` | `${CURRENT_TURN_DIRECTORY}/adr.md` | Step 8 — Post-Execution |
| `manifest.json` | `${CURRENT_TURN_DIRECTORY}/manifest.json` | Step 9 — Post-Execution |

---

## Optional Variables

| Variable | Set When | Purpose |
|----------|----------|---------|
| `EXECUTION_PLAN` | Multi-phase tasks | Path to optional execution plan markdown |
| `ACTIVE_PATTERN_NAME` | Named patterns used | Identifies reusable implementation pattern |
| `ACTIVE_PATTERN_PATH` | Named patterns used | Path to pattern definition file |

---

## Initialization Sequence

At the start of every turn, resolve variables in this order:

1. `TARGET_PROJECT` ← `$(pwd)`
2. `TURN_START_TIME` ← current UTC timestamp
3. `TURN_ID` ← read `turns_index.csv` → max + 1 (or 1 if file absent)
4. `CURRENT_TURN_DIRECTORY` ← `${TURNS_DIRECTORY}/turn-${TURN_ID}`
5. Create `CURRENT_TURN_DIRECTORY` if it doesn't exist
6. Write `session_context.md` with all resolved variables
