---
name: session-end
description: Complete turn lifecycle post-execution artifacts, update memory bank, and save session state. Run at the end of every session or after completing a turn.
disable-model-invocation: false
---

# Session End

## Step 1: Capture Git State

Run:
- `git status --short`
- `git log --oneline --since="8 hours ago"`
- `git branch --show-current`
- `git rev-parse --short HEAD`

## Step 2: Complete Turn Artifacts (if turn was executed)

If a turn was executed this session (TURN_ID is set), complete all Post-Execution artifacts:

### Step 2a: Write pull_request.md

File: `./ai/agentic-pipeline/turns/turn-${TURN_ID}/pull_request.md`

Use template: `.claude/templates/pr/pull_request_template.md`

Fill in:
- Turn summary (3–5 bullets of what was accomplished)
- Start and end timestamps
- Tasks executed (table)
- Files added/modified (tables with metadata header descriptions)
- Compliance checklist (check all boxes that apply)

### Step 2b: Write adr.md

File: `./ai/agentic-pipeline/turns/turn-${TURN_ID}/adr.md`

Apply ADR policy from `.claude/context/context_adr.md`:
- If architectural decisions were made → Full ADR using `.claude/templates/adr/adr_template.md`
- If no architectural decisions → Minimal one-liner

### Step 2c: Write manifest.json

File: `./ai/agentic-pipeline/turns/turn-${TURN_ID}/manifest.json`

Compute SHA-256 for each output file:
```bash
# macOS
shasum -a 256 <file> | cut -d' ' -f1
# Linux
sha256sum <file> | cut -d' ' -f1
```

Validate against: `.claude/templates/turn/manifest.schema.json`

### Step 2d: Update turns_index.csv

Append row:
```
${TURN_ID},${TURN_START_TIME},${TURN_END_TIME},${ELAPSED_SECONDS},${BRANCH},${COMMIT_SHA},${TASK_SUMMARY}
```

### Step 2e: Tag the commit

```bash
git tag turn/${TURN_ID}
git push origin turn/${TURN_ID}
```

---

## Step 3: Handle Uncommitted Work

If there are uncommitted changes:
Ask: "There are uncommitted changes. Would you like to commit before ending? (yes/no)"
If yes: spawn `git-guardian` to create a commit following the `AI Coding Agent Change:` format.

---

## Step 4: Update Memory Bank

### Update activeContext.md

```markdown
---
updatedAt: [ISO timestamp]
---

## Current State
**Branch**: [branch]
**Last worked on**: [date]
**Turn**: [TURN_ID]
**What was done**: [brief bullets]
**Next session**: [what to pick up next]
**Open blockers**: [any blockers]
```

### Update progress.md

- Check off completed tasks
- Add any newly discovered tasks
- Update epic status percentages
- Note current TURN_ID

### Append to sessionHistory.md

```markdown
## [YYYY-MM-DD] — Turn ${TURN_ID} — [Branch]
**Duration**: [TURN_ELAPSED_TIME]
**Accomplished**:
- [bullet]
- [bullet]
**Decisions**:
- [reference any ADRs written]
**Next Session**:
- [what to pick up]
---
```

### If new patterns discovered: append to conventions.md

### If full ADR written: append summary to decisionLog.md

```markdown
## [YYYY-MM-DD] — Turn ${TURN_ID}: [Decision Title]
[One paragraph summary of the decision and rationale]
Full ADR: `./ai/agentic-pipeline/turns/turn-${TURN_ID}/adr.md`
```

---

## Step 5: Confirm Completion

Report:

```
═══════════════════════════════════════════════════════════
  SESSION END — Turn ${TURN_ID} Complete
═══════════════════════════════════════════════════════════
  ARTIFACTS    │ session_context.md ✓
               │ pull_request.md ✓
               │ adr.md ✓
               │ manifest.json ✓
               │ turns_index.csv updated ✓
               │ git tag turn/${TURN_ID} ✓
  MEMORY       │ activeContext.md updated ✓
               │ sessionHistory.md updated ✓
               │ decisionLog.md updated (if ADR written)
═══════════════════════════════════════════════════════════
Session saved. See you next time!
```
