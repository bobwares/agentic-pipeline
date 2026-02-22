---
name: session-start
description: Load memory bank and orient to current project state. Run at the start of every Claude Code session.
disable-model-invocation: false
---

# Session Start

## Load Memory Bank

Read all memory files (use Read tool for each):
- `.claude/memory/projectContext.md`
- `.claude/memory/activeContext.md`
- `.claude/memory/progress.md`
- `.claude/memory/sessionHistory.md` (last 30 lines)

## Load Git State

Run:
- `git branch --show-current`
- `git status --short`
- `git log --oneline -5`

## Synthesize Orientation

Present a brief orientation (5-8 bullet points):

```
PROJECT: [name from projectContext]
STACK: [tech stack summary]
BRANCH: [current branch]
LAST SESSION: [date + what was accomplished]
IN PROGRESS: [active epic/task]
UNCOMMITTED: [N files changed]
NEXT: [recommended next action]
```

## Ask

End with: "What would you like to work on today?"
