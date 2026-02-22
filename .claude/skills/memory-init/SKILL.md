---
name: memory-init
description: Initialize or rebuild the memory bank by reading the current project. Run once when installing agentic-pipeline into a new project.
disable-model-invocation: false
---

# Initialize Memory Bank

## Explore Project

Run these commands to understand the project:

```bash
git log --oneline -10 2>/dev/null
git remote get-url origin 2>/dev/null
git branch --show-current 2>/dev/null
ls -la
find . -name "package.json" -not -path "*/node_modules/*" | head -5
cat package.json 2>/dev/null | head -30
ls .claude/memory/ 2>/dev/null
```

Also read:
- `README.md` (if exists)
- `CLAUDE.md` (if exists beyond the agentic-pipeline one)

## Write Memory Files

### projectContext.md

Based on what you found, write:
- Project name (from package.json or git remote URL)
- Purpose (from README or package.json description)
- Tech stack detected (from dependencies)
- Local development URLs (inferred from package.json scripts)
- Repository URL

### activeContext.md

```markdown
---
updatedAt: [now]
---

## Current State
**Branch**: [current branch]
**Initialized**: [date]
**Status**: Just initialized — ready to start
**Next**: Run /session-start to begin, or /spec-prd-new to define first feature
```

### progress.md

```markdown
---
updatedAt: [now]
---

## Active Epics
None yet.

## Backlog PRDs
None yet.

## Metrics
- Sessions: 0
- PRDs created: 0
- Epics completed: 0
```

### decisionLog.md, conventions.md, sessionHistory.md

Write template versions with placeholder content.

## Confirm

Report which files were created/updated and what was detected about the project.

Suggest: "Memory bank initialized! Run `/session-start` to begin your first session."
