---
name: session-end
description: Save session state to memory bank. Run at the end of every session before closing Claude Code.
disable-model-invocation: false
---

# Session End

## Capture Session Work

Run:
- `git status --short`
- `git log --oneline --since="8 hours ago"`
- `git branch --show-current`

## Handle Uncommitted Work

If there are uncommitted changes:
Ask: "There are uncommitted changes. Would you like to commit before ending? (yes/no)"
If yes: spawn `git-guardian` to create a commit.

## Update Memory Files

### Update activeContext.md

```markdown
---
updatedAt: [ISO timestamp]
---

## Current State
**Branch**: [branch]
**Last worked on**: [date]
**What was done**: [brief bullets]
**Next session**: [what to pick up]
**Open blockers**: [any blockers]
```

### Update progress.md

- Check off completed tasks
- Add any newly discovered tasks
- Update epic status percentages

### Append to sessionHistory.md

```markdown
## [YYYY-MM-DD] — [Branch]
**Duration**: [estimate]
**Accomplished**:
- [bullet]
**Decisions**:
- [any ADRs]
**Next Session**:
- [what to pick up]
---
```

### If new patterns: append to conventions.md
### If new decisions: append to decisionLog.md

## Confirm

Report: "Session saved. Memory bank updated. See you next time!"
