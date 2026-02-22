---
name: spec-epic-start
description: Begin implementing an epic. Creates the branch and spawns the orchestrator to execute all tasks. Arguments: epic name.
disable-model-invocation: false
---

# Start Epic Implementation

Epic: $ARGUMENTS

## Pre-flight

1. Read `.claude/epics/$ARGUMENTS/epic.md` — if not found, suggest running `/spec-prd-parse` first
2. Check current git state:
   - Run: `git status --short`
   - If uncommitted changes: ask user to commit or stash before starting

## Create Branch

```bash
git checkout main && git pull origin main
git checkout -b epic/$ARGUMENTS
git push -u origin HEAD
```

## Update Epic Status

Edit `.claude/epics/$ARGUMENTS/epic.md`: change `status: planned` to `status: in_progress`

Update `.claude/memory/progress.md` to show this epic as active.

## Spawn Orchestrator

Invoke the `orchestrator` agent with this context:

"Start implementing epic '$ARGUMENTS'. The epic specification is in `.claude/epics/$ARGUMENTS/epic.md`. Follow the task breakdown in the Phase 1 → 2 → 3 → 4 order. Spawn the appropriate specialist agent for each task. After all phases complete, run verify-all and then spawn git-guardian to create a PR."

## Report

Confirm to the user:
- Branch created: `epic/$ARGUMENTS`
- Orchestrator spawned
- Check progress with: `/spec-task-next $ARGUMENTS`
