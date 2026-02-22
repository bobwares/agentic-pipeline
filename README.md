# agentic-pipeline

> A best-of-all-worlds Claude Code configuration for generating full-stack apps with AI assistance.

Built by synthesizing patterns from 28 Claude Code repositories — from the Anthropic team, Trail of Bits, the ccpm project, claude-boris, and the broader community.

## What's Inside

```
.claude/
├── agents/     14 specialist agents (orchestrator, engineers, reviewer, tester, security...)
├── skills/     29 skills = 10 domain knowledge + 19 workflow
├── memory/      6-file memory bank (persistent context across sessions)
├── hooks/       skill-eval (auto-suggests skills) + audit-log
├── rules/       tech standards, branch operations, agent coordination
└── settings.json  permissions + hooks wired together
```

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/agentic-pipeline.git
cd agentic-pipeline
bash install.sh /path/to/your/project
```

Then in your project:
```bash
claude
/memory-init
/spec-prd-new user-authentication
```

## The Workflow

This config implements a **spec-driven development** pipeline:

```
PRD (what to build)
  ↓  /spec-prd-new
Epic (how to break it down)
  ↓  /spec-prd-parse
Tasks (who builds what)
  ↓  /spec-epic-start
Code (specialist agents implement)
  ↓  orchestrator delegates
Verify (quality gate)
  ↓  /verify-all
Ship (PR + docs + memory update)
  ↓  /git-commit-push-pr
```

## Tech Stack

Optimized for full-stack apps using:

| Layer | Technology |
|-------|-----------|
| Frontend | **Next.js 15** App Router + Server Components |
| UI | **shadcn/ui** + Tailwind CSS |
| Node.js API | **NestJS** with Drizzle ORM |
| Enterprise API | **Java Spring Boot** with JPA |
| Database | **PostgreSQL** + **Drizzle ORM** |
| AI Features | **Vercel AI SDK** (streaming, tools, structured output) |
| Testing | **Vitest** (unit) + **Playwright** (E2E) |

## Agents (14)

| Agent | Role | Model |
|-------|------|-------|
|  | Master coordinator. 5-phase: Understand→Plan→Execute→Verify→Ship | opus |
|  | System design, API contracts, ADRs, data modeling | opus |
|  | Next.js 15 App Router: pages, server components, actions | sonnet |
|  | NestJS: modules, controllers, services, DTOs, guards | sonnet |
|  | Java Spring Boot: REST, JPA, Spring Security | sonnet |
|  | Drizzle ORM: schema design, queries, migrations, transactions | sonnet |
|  | Vercel AI SDK: streaming, tool calls, embeddings, RAG | sonnet |
|  | Senior-engineer review with full checklist | opus |
|  | TDD: Vitest unit tests, Playwright E2E, factory pattern | sonnet |
|  | Full quality gate: typecheck + lint + test + build | sonnet |
|  | OWASP Top 10, secrets scanning, auth/authz review | opus |
|  | JSDoc, README, OpenAPI/Swagger, CHANGELOG | sonnet |
|  | Conventional commits, branch safety, PR creation | sonnet |
|  | Session state, progress tracking, memory files | haiku |

## Skills (29)

### Domain Knowledge (auto-activated by skill-eval hook)

| Skill | Activates When |
|-------|---------------|
|  | Building pages, layouts, server components, actions |
|  | Building NestJS modules, controllers, services |
|  | Working in Java/Spring Boot |
|  | Schema design, queries, migrations |
|  | Building UI components, forms, tables |
|  | Implementing AI/LLM/streaming features |
|  | Writing or fixing tests |
|  | Loading states, error handling, empty states |
|  | Designing or reviewing API endpoints |
|  | Investigating bugs or unexpected behavior |

### Workflow (invoke manually)

| Skill | What It Does |
|-------|-------------|
|  | Guided PRD creation with discovery questions |
|  | Transform PRD into epic + numbered task breakdown |
|  | List all PRDs and their status |
|  | Begin implementing an epic (creates branch, assigns agents) |
|  | Get the next actionable task in the current epic |
|  | Load memory bank + orient to current project state |
|  | Save session state + update memory bank |
|  | Initialize/rebuild memory bank from existing project |
|  | Run typecheck + lint + test + build; fix failures |
|  | Iterative failing-test fixing loop |
|  | Spawn security-auditor for a full security review |
|  | Verify → conventional commit → push → create PR |
|  | Fast local commit (skips verification) |
|  | Create a named save point |
|  | Restore from a checkpoint |
|  | Revert the last Claude commit |
|  | Load all project context into the conversation |
|  | Switch modes: architect / code / debug / review / test |
|  | GitHub issue → branch → implement → PR |

## Memory Bank

Six files that persist context across sessions:

| File | Purpose | Update Frequency |
|------|---------|-----------------|
|  | Project identity, stack, URLs | Rarely |
|  | Current session state, branch, goal | Every session |
|  | Epics, tasks, sprint tracking | Every session |
|  | Architecture Decision Records | When decisions made |
|  | Learned project-specific patterns | As patterns emerge |
|  | Session summaries log | Every session end |

## Hooks

| Hook | Trigger | What It Does |
|------|---------|-------------|
|  | UserPromptSubmit | Analyzes prompt, suggests relevant domain skills |
|  | PreToolUse (Bash) | Logs all bash commands for debugging |
| Branch protection | PreToolUse (Edit/Write) | Blocks file edits on  branch |
| Auto-format | PostToolUse (Edit/Write) | Runs prettier after file changes |
| Auto-install | PostToolUse (Edit) | Installs deps when package.json changes |
| Auto-test | PostToolUse (Edit) | Runs tests when test files change |
| Type-check | PostToolUse (Edit) | Runs Version 5.8.3
tsc: The TypeScript Compiler - Version 5.8.3

COMMON COMMANDS

  tsc
  Compiles the current project (tsconfig.json in the working directory.)

  tsc app.ts util.ts
  Ignoring tsconfig.json, compiles the specified files with default compiler options.

  tsc -b
  Build a composite project in the working directory.

  tsc --init
  Creates a tsconfig.json with the recommended settings in the working directory.

  tsc -p ./path/to/tsconfig.json
  Compiles the TypeScript project located at the specified path.

  tsc --help --all
  An expanded version of this information, showing all possible compiler options

  tsc --noEmit
  tsc --target esnext
  Compiles the current project, with additional settings.

COMMAND LINE FLAGS

--help, -h
Print this message.

--watch, -w
Watch input files.

--all
Show all compiler options.

--version, -v
Print the compiler's version.

--init
Initializes a TypeScript project and creates a tsconfig.json file.

--project, -p
Compile the project given the path to its configuration file, or to a folder with a 'tsconfig.json'.

--showConfig
Print the final configuration instead of building.

--build, -b
Build one or more projects and their dependencies, if out of date

COMMON COMPILER OPTIONS

--pretty
Enable color and formatting in TypeScript's output to make compiler errors easier to read.
type: boolean
default: true

--declaration, -d
Generate .d.ts files from TypeScript and JavaScript files in your project.
type: boolean
default: `false`, unless `composite` is set

--declarationMap
Create sourcemaps for d.ts files.
type: boolean
default: false

--emitDeclarationOnly
Only output d.ts files and not JavaScript files.
type: boolean
default: false

--sourceMap
Create source map files for emitted JavaScript files.
type: boolean
default: false

--noEmit
Disable emitting files from a compilation.
type: boolean
default: false

--target, -t
Set the JavaScript language version for emitted JavaScript and include compatible library declarations.
one of: es5, es6/es2015, es2016, es2017, es2018, es2019, es2020, es2021, es2022, es2023, es2024, esnext
default: es5

--module, -m
Specify what module code is generated.
one of: none, commonjs, amd, umd, system, es6/es2015, es2020, es2022, esnext, node16, node18, nodenext, preserve
default: undefined

--lib
Specify a set of bundled library declaration files that describe the target runtime environment.
one or more: es5, es6/es2015, es7/es2016, es2017, es2018, es2019, es2020, es2021, es2022, es2023, es2024, esnext, dom, dom.iterable, dom.asynciterable, webworker, webworker.importscripts, webworker.iterable, webworker.asynciterable, scripthost, es2015.core, es2015.collection, es2015.generator, es2015.iterable, es2015.promise, es2015.proxy, es2015.reflect, es2015.symbol, es2015.symbol.wellknown, es2016.array.include, es2016.intl, es2017.arraybuffer, es2017.date, es2017.object, es2017.sharedmemory, es2017.string, es2017.intl, es2017.typedarrays, es2018.asyncgenerator, es2018.asynciterable/esnext.asynciterable, es2018.intl, es2018.promise, es2018.regexp, es2019.array, es2019.object, es2019.string, es2019.symbol/esnext.symbol, es2019.intl, es2020.bigint/esnext.bigint, es2020.date, es2020.promise, es2020.sharedmemory, es2020.string, es2020.symbol.wellknown, es2020.intl, es2020.number, es2021.promise, es2021.string, es2021.weakref/esnext.weakref, es2021.intl, es2022.array, es2022.error, es2022.intl, es2022.object, es2022.string, es2022.regexp, es2023.array, es2023.collection, es2023.intl, es2024.arraybuffer, es2024.collection, es2024.object/esnext.object, es2024.promise, es2024.regexp/esnext.regexp, es2024.sharedmemory, es2024.string/esnext.string, esnext.array, esnext.collection, esnext.intl, esnext.disposable, esnext.promise, esnext.decorators, esnext.iterator, esnext.float16, decorators, decorators.legacy
default: undefined

--allowJs
Allow JavaScript files to be a part of your program. Use the 'checkJS' option to get errors from these files.
type: boolean
default: false

--checkJs
Enable error reporting in type-checked JavaScript files.
type: boolean
default: false

--jsx
Specify what JSX code is generated.
one of: preserve, react, react-native, react-jsx, react-jsxdev
default: undefined

--outFile
Specify a file that bundles all outputs into one JavaScript file. If 'declaration' is true, also designates a file that bundles all .d.ts output.

--outDir
Specify an output folder for all emitted files.

--removeComments
Disable emitting comments.
type: boolean
default: false

--strict
Enable all strict type-checking options.
type: boolean
default: false

--types
Specify type package names to be included without being referenced in a source file.

--esModuleInterop
Emit additional JavaScript to ease support for importing CommonJS modules. This enables 'allowSyntheticDefaultImports' for type compatibility.
type: boolean
default: false

You can learn about all of the compiler options at https://aka.ms/tsc after TypeScript changes |

## Source Attribution

This configuration synthesizes patterns from:

| Pattern | Source |
|---------|--------|
| 6-file memory bank | [claude-boris](https://github.com/llcoolblaze/claude-boris) |
| Master orchestrator | [claude-boris](https://github.com/llcoolblaze/claude-boris) |
| Skill evaluation hook | [claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) |
| Branch protection hooks | [claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) |
| Spec-driven PRD workflow | [ccpm](https://github.com/automazeio/ccpm) |
| Agent coordination rules | [ccpm](https://github.com/automazeio/ccpm) |
| SKILL.md format | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) |
| Agent specialist model | [feiskyer/claude-code-settings](https://github.com/feiskyer/claude-code-settings) |
| Official skills reference | [anthropics/skills](https://github.com/anthropics/skills) |

## License

MIT
