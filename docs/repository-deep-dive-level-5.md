# Agentic Pipeline Repository Deep Dive (Level 5)

## 1) Executive Technical Context

`agentic-pipeline` is a **meta-repository**: instead of shipping a runnable app, it ships an opinionated Claude Code configuration that can be installed into *other* application repositories. The primary product is the `.claude/` control plane, paired with `CLAUDE.md` and `install.sh`.

The repository’s central claim is that high-quality AI-assisted software delivery requires more than ad-hoc prompting. It requires:

- role separation (agents),
- reusable implementation patterns (skills),
- persistent context (memory bank),
- event-driven automation (hooks), and
- explicit quality/security guardrails (rules + verification workflow).

---

## 2) System Topology and Packaging Strategy

### 2.1 Install-time behavior

At installation, `install.sh` copies `.claude` into a target repository and conditionally copies `CLAUDE.md` if absent.

Installer flow:

1. Resolve source and target paths.
2. Validate target directory exists.
3. Backup existing target `.claude` directory to a timestamped path.
4. Copy `.claude` recursively.
5. Copy `CLAUDE.md` only if the target has none.
6. Mark hook scripts executable where possible.

This design emphasizes safe adoption and low-friction bootstrap.

### 2.2 Runtime layout in target repository

Installed structure provides:

- `.claude/agents/` — role prompts for specialists.
- `.claude/skills/` — reusable domain and workflow playbooks.
- `.claude/memory/` — persistent context across sessions.
- `.claude/hooks/` — event-based automation.
- `.claude/rules/` — standards and constraints.
- `.claude/settings.json` — integration settings.

This is effectively an AI engineering control plane overlaid on an app repo.

---

## 3) Agent Layer: Role-based Decomposition

The repository defines a multi-agent topology with an `orchestrator` plus specialists (`nextjs-engineer`, `nestjs-engineer`, `security-auditor`, `verify-app`, etc.).

Technical effects:

1. **Prompt isolation**: specialized context reduces ambiguity.
2. **Parallelizable cognition**: architecture, implementation, testing, review are separable concerns.
3. **Structured delegation**: orchestrator can route tasks by intent and lifecycle stage.

Model assignment is role-sensitive: risk-heavy responsibilities use stronger models.

---

## 4) Skill Layer: Capability Modules and Workflow State Machine

Skills are split into two classes:

- **Domain skills**: framework/pattern guidance (Next.js, NestJS, Drizzle, testing, debugging).
- **Workflow skills**: lifecycle progression (`/spec-prd-new`, `/verify-all`, `/git-commit-push-pr`).

This separation is powerful:

- domain skills encode *how to implement correctly*;
- workflow skills encode *how to progress work safely*.

In systems terms, domain skills are capability modules while workflow skills define state transitions.

---

## 5) Memory Bank: Persistent Externalized Project Cognition

The six memory files capture stable identity, active state, progress, architecture decisions, conventions, and session history.

Memory files:

- `projectContext.md`
- `activeContext.md`
- `progress.md`
- `decisionLog.md`
- `conventions.md`
- `sessionHistory.md`

This pattern reduces “context amnesia” and improves long-horizon consistency.

---

## 6) Hook Layer: Reactive Policy and Quality Feedback

Hooks provide automatic behavior around user and tool interactions:

- skill recommendations from prompt analysis,
- bash audit logging,
- branch/file protection,
- post-edit formatting/testing/type checks,
- dependency-aware automation.

Practically, this shifts key quality controls left into day-to-day development, not just CI.

---

## 7) Standards and Engineering Contract

`CLAUDE.md` and `.claude/rules/tech-standards.md` define non-negotiables across TypeScript strictness, UI state handling, validation boundaries, transaction safety, security, and git conventions.

This limits common AI-code risks:

- weak typing drift,
- partial UI-state handling,
- under-validated interfaces,
- inconsistent commit hygiene.

A central standards layer also improves policy portability across repositories.

---

## 8) Spec-driven Pipeline as Deterministic Delivery

Canonical flow:

1. `/spec-prd-new`
2. `/spec-prd-parse`
3. `/spec-epic-start`
4. `/spec-task-next`
5. `/verify-all`
6. `/git-commit-push-pr`

This sequence transforms intent into verified changes through staged refinement. It functions like a deterministic pipeline: requirement capture → decomposition → implementation → verification → release artifact.

---

## 9) Operational Strengths

Key strengths of this repository design:

- **Repeatability**: consistent lifecycle across contributors.
- **Governance**: built-in standards and guardrails.
- **Traceability**: memory files and structured workflows capture rationale and progress.
- **Scalability of practice**: teams can adopt and fork organizational baselines.

---

## 10) Trade-offs and Risks

Key trade-offs:

- More structure can feel heavyweight for trivial edits.
- Strong standards may conflict with legacy codebases.
- Hook automation can surprise users if behavior is opaque.

Mitigations:

- clearer onboarding docs,
- transparency logs for hook actions,
- configurable strictness profiles.

---

## 11) Improvement Roadmap

Potential enhancements:

1. `install.sh --dry-run` preview mode.
2. selective component install flags.
3. source/target checksum reporting.
4. formal rollback utility for backups.
5. compatibility matrix for monorepo/polyrepo targets.

These would improve enterprise change management and controlled rollout.

---

## 12) Conclusion

`agentic-pipeline` is best understood as an **AI-native SDLC framework** delivered as repository-installable control-plane assets. Its real value is compositional: agents + skills + memory + hooks + rules working together to convert ad-hoc prompting into governed, repeatable engineering execution.
