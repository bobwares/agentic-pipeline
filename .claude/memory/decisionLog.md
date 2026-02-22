# Decision Log — Architecture Decision Records

All significant architectural decisions are recorded here in ADR format.

---

## ADR-001: agentic-pipeline Configuration Adopted

**Date**: [Project start date]
**Status**: Accepted
**Decider**: Project team

### Context

The project needed a standardized Claude Code configuration to maintain consistency across sessions and provide domain knowledge to the AI assistant.

### Decision

Use the agentic-pipeline configuration with Boris-style memory bank, 14 specialized agents, 29 skills, and domain skill auto-activation via the skill-eval hook.

### Consequences

**Positive**: Consistent code quality, persistent context across sessions, skill-guided generation for Next.js/NestJS/Spring/Drizzle/shadcn/AI stack
**Negative**: Requires discipline to keep memory files updated each session

---

<!-- Add new ADRs below this line in the same format -->
