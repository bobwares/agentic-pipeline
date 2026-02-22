# Agent Coordination

Rules for multiple agents working in parallel within the same epic.

## Parallelism Principle

Agents working on **different file scopes** never conflict. Assign each agent a clear ownership.

## Default File Scope Assignments

| Agent | Owns |
|-------|------|
| `drizzle-dba` | `packages/database/schema/`, `packages/database/migrations/` |
| `nestjs-engineer` | `apps/api/src/modules/<feature>/` |
| `spring-engineer` | `services/enterprise/src/main/java/` |
| `nextjs-engineer` | `apps/web/app/<route>/`, `apps/web/components/` |
| `test-writer` | `**/*.test.ts`, `**/*.spec.ts`, `e2e/` |
| `doc-generator` | `**/*.md`, JSDoc in any file |

## Coordination Rules

1. Each agent only modifies files within its assigned scope
2. Shared types (`packages/types/`) — one agent creates, others import
3. If a shared file needs updating: **one agent handles it, others wait**
4. Each agent commits after each logical unit of work
5. Agents signal completion via the progress file

## Sync Protocol

```bash
# Before starting work on a shared branch
git pull --rebase origin epic/<name>

# After completing a logical unit
git add <files-in-my-scope>
git commit -m "feat(scope): description"
git pull --rebase origin epic/<name>
git push
```

## Conflict Resolution

- Agents **never auto-resolve conflicts**
- On conflict: stop work, report the conflict to the orchestrator
- Human reviews and resolves; agent continues after resolution

## Communication via Progress Files

Agents write status to `.claude/memory/progress.md`:

```markdown
## [Agent Name] — [Task ID]
**Status**: in_progress | completed | blocked
**Completed**:
- [What was done]
**Blocked by**:
- [What is blocking — only if status is blocked]
```
