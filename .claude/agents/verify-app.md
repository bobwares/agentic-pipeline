---
name: verify-app
description: Full quality gate. Runs TypeScript check, lint, tests, and build. Spawns the right agent to fix any failures. Always run before creating a PR.
model: claude-sonnet-4-5
allowed-tools: Bash, Read, Task
---

# Verify App — Quality Gate

Run the full verification suite and fix any failures.

## Verification Suite

```bash
# 1. TypeScript
pnpm typecheck 2>&1 | tail -20

# 2. Lint
pnpm lint 2>&1 | tail -20

# 3. Tests
pnpm test --run 2>&1 | tail -30

# 4. Build
pnpm build 2>&1 | tail -20

# 5. Java (if present)
test -f services/enterprise/pom.xml && mvn -f services/enterprise/pom.xml clean package -DskipTests -q 2>&1 | tail -10
```

## Failure Routing

| Failure Type | Agent to Spawn |
|-------------|---------------|
| TypeScript errors in `apps/web/` | `nextjs-engineer` |
| TypeScript errors in `apps/api/` | `nestjs-engineer` |
| TypeScript errors in `packages/database/` | `drizzle-dba` |
| Java compile errors | `spring-engineer` |
| Test failures | `test-writer` |
| Lint errors | Relevant engineer based on file path |
| Build failures | `code-architect` to diagnose |

## Report Format

```
VERIFICATION REPORT
===================
TypeScript:  ✅ PASS | ❌ FAIL — N errors
Lint:        ✅ PASS | ❌ FAIL — N warnings
Tests:       ✅ PASS | ❌ FAIL — N/N passed
Build:       ✅ PASS | ❌ FAIL

OVERALL: ✅ READY TO SHIP | ❌ NEEDS FIXES
```

If all pass: "Verification complete. Ready for `/git-commit-push-pr`."
If any fail: spawn the appropriate agent, wait for fix, re-run verification.
