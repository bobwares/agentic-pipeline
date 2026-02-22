---
name: session-start
description: Load memory bank, initialize turn lifecycle, and orient to current project state. Run at the start of every Claude Code session.
disable-model-invocation: false
---

# Session Start

## Step 1: Load Context Files

Read all context files (in order):
- `.claude/context/context_container.md` — base directories and path variables
- `.claude/context/context_session.md` — turn timing and directory variables
- `.claude/context/context_conventions.md` — naming, git, formatting conventions
- `.claude/context/context_governance.md` — mandatory coding standards
- `.claude/context/context_orchestration.md` — 10-step turn lifecycle
- `.claude/context/context_adr.md` — ADR policy
- `.claude/context/context_skills.md` — available skills reference

## Step 2: Load Memory Bank

Read all memory files:
- `.claude/memory/projectContext.md`
- `.claude/memory/activeContext.md`
- `.claude/memory/progress.md`
- `.claude/memory/sessionHistory.md` (last 30 lines)

## Step 3: Load Git State

Run:
- `git branch --show-current`
- `git status --short`
- `git log --oneline -5`

## Step 4: Resolve Turn State

Check if the turn index exists:
```bash
TURNS_INDEX="./ai/agentic-pipeline/turns_index.csv"
if [ -f "$TURNS_INDEX" ]; then
  LAST_TURN=$(tail -n 1 "$TURNS_INDEX")
  NEXT_TURN_ID=$(tail -n +2 "$TURNS_INDEX" | cut -d',' -f1 | sort -n | tail -1)
  NEXT_TURN_ID=$((NEXT_TURN_ID + 1))
else
  NEXT_TURN_ID=1
fi
```

## Step 5: Display Session Status

Present a session orientation table:

```
═══════════════════════════════════════════════════════════
  AGENTIC-PIPELINE SESSION START
═══════════════════════════════════════════════════════════
  PROJECT      │ [name from projectContext]
  STACK        │ [tech stack summary]
  BRANCH       │ [current branch]
  LAST SESSION │ [date + what was accomplished]
  IN PROGRESS  │ [active epic/task if any]
  UNCOMMITTED  │ [N files changed]
  NEXT TURN ID │ [NEXT_TURN_ID]
  GOVERNANCE   │ Active — metadata headers + ADR required
  CONTEXT      │ 7 context files loaded
═══════════════════════════════════════════════════════════
```

## Step 6: Confirm Readiness

End with: "Context loaded. Governance active. Turn {{NEXT_TURN_ID}} ready. What would you like to work on?"

Do not accept any task until this confirmation is displayed.

---

## Governance Reminder (always display)

```
ACTIVE STANDARDS:
  ✓ Metadata headers required on all source files
  ✓ Semantic versioning per file (new files start at 0.1.0)
  ✓ Commits: "AI Coding Agent Change:" + 3-5 bullets
  ✓ Branches: <type>/<description>[-<task-id>]
  ✓ ADR required every turn (full or minimal)
  ✓ Turn tagged: git tag turn/${TURN_ID}
  ✓ 4 turn artifacts: session_context, pull_request, adr, manifest
```
