---
name: context-prime
description: Load all project context into the current conversation for maximum effectiveness. Run at start of a focused work session.
disable-model-invocation: false
---

# Context Prime

Load all relevant context for this session.

## Memory Bank

Read:
- `.claude/memory/projectContext.md`
- `.claude/memory/activeContext.md`
- `.claude/memory/conventions.md`
- `.claude/memory/progress.md`

## Project State

```bash
git branch --show-current
git status --short
git log --oneline -10
```

## Active Epic (if any)

If there's an in-progress epic in progress.md:
- Read `.claude/epics/<epic-name>/epic.md`

## Stack Summary

Read:
- `package.json` (root)
- `CLAUDE.md`

## Synthesize

Present a comprehensive context summary:

```
CONTEXT LOADED
==============
Project: [name]
Stack: [summary]
Branch: [branch]
Active Work: [epic/task]
Recent: [last 3 commits]
Conventions: [key patterns]

Ready for deep work on [project name].
```
