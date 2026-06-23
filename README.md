# claude-next-gen-starter

A production-grade Next.js template engineered for Claude Code — with a four-agent development pipeline, live knowledge graph, and cinematic design system baked in from day one.

> Built for teams who want AI-assisted development that is disciplined, reviewable, and ships real product quality.

---

## What This Template Provides

| Capability | What You Get |
|---|---|
| **Four-agent pipeline** | Planner → Coder → Tester → Reviewer, each with a defined role and handoff contract |
| **`/ship` command** | One command triggers the full pipeline end-to-end |
| **Live knowledge graph** | graphify auto-rebuilds on every file save — agents query it before reading raw files |
| **Design system** | Typography, spacing, motion, and anti-AI rules enforced in every agent prompt |
| **Premium stack** | Next.js 16, React 19, Framer Motion, GSAP, Three.js, shadcn/ui, Tailwind v4 |

---

## Quick Start

```bash
# 1. Clone or use as template
git clone <repo-url> my-project
cd my-project

# 2. Install dependencies
npm install

# 3. Install graphify globally (required for knowledge graph)
npm install -g graphify-code

# 4. Build the initial knowledge graph
graphify update .

# 5. Start development
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see the result.

---

## The Four-Agent Pipeline

Each agent has a single, bounded responsibility. They communicate through handoff files in `.pipeline/`. The pipeline halts automatically at any quality gate failure.

### Trigger with `/ship`

```
/ship <describe what you want to build>
```

That single command runs the full sequence below.

---

### Step 1 — Planner (`@planner`)

**Model:** Claude Opus 4.8  
**Input:** Your feature description  
**Output:** `.pipeline/spec.md`

The Planner analyzes the existing codebase, identifies patterns, and produces a precise specification before any code is written. It flags ambiguities as `OPEN QUESTIONS` and halts the pipeline until they are resolved.

```
Spec includes:
  - Files to create / modify
  - Exact TypeScript function signatures
  - Data shapes and interfaces
  - Edge cases
  - Acceptance criteria (checkable)
  - Pattern references (real file paths, not invented ones)
```

**Gate:** If `OPEN QUESTIONS` exist in the spec → pipeline stops, questions are presented to you.

---

### Step 2 — Coder (`@coder`)

**Model:** Claude Sonnet 4.6  
**Input:** `.pipeline/spec.md`  
**Output:** `.pipeline/changes.md` + implemented code

The Coder reads the spec line-by-line and implements it exactly. No additions, no deviations, no self-review. If the spec is ambiguous, it stops and reports rather than guessing.

```
Rules enforced:
  - TypeScript strict mode — no `any`, no implicit types
  - Server Components by default, "use client" only when required
  - Follows typography-rules.md, spacing-rules.md, motion-rules.md
  - No unused imports, no monolithic files (200-line limit per file)
  - No patterns from anti-ai-rules.md
```

---

### Step 3 — Tester (`@tester`)

**Model:** Claude Sonnet 4.6  
**Input:** `.pipeline/spec.md` + `.pipeline/changes.md`  
**Output:** `.pipeline/test-results.md`

The Tester writes and runs tests against every acceptance criterion. It does not fix code. If tests fail, it documents exactly what failed and why, then halts.

```
Coverage required per feature:
  - Happy path
  - Edge cases (boundary values, empty states, null/undefined)
  - Error states
  - TypeScript compilation pass
  - UI behavior (renders, props, events)
```

**Gate:** If any test `FAIL` → pipeline stops, failures are presented to you.

---

### Step 4 — Reviewer (`@reviewer`)

**Model:** Claude Opus 4.8  
**Input:** All three pipeline files + changed source files  
**Output:** `.pipeline/review.md` with a verdict

The Reviewer is read-only. It audits spec adherence, code quality, design quality, test quality, and security/performance. It produces one of three verdicts:

| Verdict | Meaning |
|---|---|
| **SHIP** | All criteria met. Ready to commit. |
| **NEEDS WORK** | Minor issues. Fix these specific items before merging. |
| **BLOCK** | Fundamental problem — spec not met, tests failing, or security issue. Re-plan. |

---

### Pipeline Flow

```
/ship "add dark mode toggle"
         │
         ▼
    [Planner]
    writes .pipeline/spec.md
         │
         ├─ OPEN QUESTIONS? ──→ HALT → ask you → resume manually
         │
         ▼
    [Coder]
    writes .pipeline/changes.md + code
         │
         ▼
    [Tester]
    writes .pipeline/test-results.md
         │
         ├─ FAIL? ──────────→ HALT → show failures → fix code → re-run tester
         │
         ▼
    [Reviewer]
    writes .pipeline/review.md
         │
         ├─ NEEDS WORK ──────→ show required changes
         ├─ BLOCK ───────────→ show blockers → re-run /ship after fixes
         └─ SHIP ────────────→ ready to commit ✓
```

### Resuming a Stalled Pipeline

You can invoke any agent directly without re-running the whole pipeline:

```
# Resume from Coder (after answering open questions)
@coder Implement the feature specified in .pipeline/spec.md

# Re-run Tester only (after fixing a bug)
@tester Write and run tests for the changes in .pipeline/changes.md

# Re-run Reviewer only
@reviewer Review all pipeline files and changed code
```

---

## Knowledge Graph (graphify)

graphify builds a live AST-based knowledge graph of your entire codebase — every file, component, hook, type, and import relationship — and keeps it current automatically.

### How It Stays Current

The graph rebuilds automatically on three triggers:

1. **Every `Edit` or `Write` tool call** — via PostToolUse hooks in `.claude/settings.json`
2. **Every `git commit`** — via git post-commit hook
3. **Every `git checkout`** — via git post-checkout hook

No LLM cost. Pure AST extraction.

### What Agents Use It For

Before opening any raw file, agents query the graph to understand:
- Which components depend on what
- What will break if X is changed
- How data flows between files
- Which patterns are established in the codebase

### Commands

| Task | Command |
|---|---|
| Find where a component or function is used | `graphify query "where is X used"` |
| Trace the relationship between two files | `graphify path "ComponentA" "ComponentB"` |
| Get a plain-language explanation of any node | `graphify explain "useTheme"` |
| Find all files affected by changing X | `graphify affected "X"` |
| Rebuild the graph manually | `graphify update .` |
| Browse full architecture report | `cat graphify-out/GRAPH_REPORT.md` |
| Browse the wiki (if generated) | `cat graphify-out/wiki/index.md` |

### When to Use Each Command

- **Before modifying a shared utility** → `graphify affected "utilityName"` — see everything downstream
- **Before adding a component** → `graphify query "similar components"` — avoid duplication
- **When debugging** → `graphify path "A" "B"` — trace exactly how two things connect
- **For broad orientation** → `graphify-out/GRAPH_REPORT.md` — full architecture overview

> The graph is gitignored. Rebuild it locally any time with `graphify update .`

---

## Design System

The design rules are enforced across all four agents. Every UI feature produced by this pipeline must meet these standards.

### Typography

- Display: 72–120px, tight tracking (−0.04em to −0.06em)
- H1: 48–64px, weight 700–900
- Body: 16–18px, line-height 1.6–1.75, max-width 65–75ch
- Always `font-feature-settings: "kern" 1, "liga" 1` on headings
- Minimum 4.5:1 contrast ratio (WCAG AA)

### Spacing

- 8px base grid — all values are multiples of 8
- Sections: min 96px vertical padding on desktop
- Asymmetric vertical padding for editorial rhythm
- Content max-width: 1280px layout / 768px prose / 1024px dashboard
- Horizontal page padding: 24px mobile → 48px tablet → 80px desktop

### Motion

- Easing: `cubic-bezier(0.22, 1, 0.36, 1)`
- UI transitions: 200–300ms
- Page transitions: 400–600ms
- Cinematic reveals: 800–1200ms
- Stagger children: 60–80ms increments
- Only animate `transform` and `opacity` — never layout properties

### What Is Explicitly Forbidden

- Generic SaaS layouts, repetitive card grids
- Excessive glassmorphism, random gradient blobs
- AI-looking sections, floating startup animations
- Low-contrast typography, poor visual hierarchy
- Spring bounce on navigation elements
- Scale animations beyond 1.05 on hover

---

## Stack

| Category | Library | Version |
|---|---|---|
| Framework | Next.js | 16.2.6 |
| React | React | 19.2.4 |
| Language | TypeScript | ^5 |
| Styling | Tailwind CSS | ^4 |
| Animation | Framer Motion | ^12 |
| Animation | GSAP | ^3.15 |
| Scroll | Lenis | ^1.3 |
| 3D | Three.js + React Three Fiber | ^0.184 / ^9.6 |
| UI Components | shadcn/ui + Radix UI | latest |
| Icons | Lucide React + Tabler Icons | latest |
| State | Zustand | ^5 |
| Utilities | clsx, tailwind-merge, CVA | latest |

---

## Project Structure

```
.
├── .claude/
│   ├── agents/
│   │   ├── planner.md       # Planner agent definition
│   │   ├── coder.md         # Coder agent definition
│   │   ├── tester.md        # Tester agent definition
│   │   └── reviewer.md      # Reviewer agent definition
│   ├── commands/
│   │   └── ship.md          # /ship pipeline orchestrator
│   ├── rules/
│   │   ├── typography-rules.md
│   │   ├── spacing-rules.md
│   │   ├── motion-rules.md
│   │   └── anti-ai-rules.md
│   └── settings.json        # Hooks: graphify auto-update on file changes
├── .pipeline/               # Ephemeral handoff files (gitignored)
│   ├── spec.md
│   ├── changes.md
│   ├── test-results.md
│   └── review.md
├── graphify-out/            # Live knowledge graph (gitignored)
├── app/                     # Next.js App Router
├── components/              # Shared UI components
├── CLAUDE.md                # Agent system role + graphify rules
└── package.json
```

---

## Using This as a Template

When you fork this repository for a new project:

1. **Run** `graphify update .` after cloning to build your initial knowledge graph
2. **Edit** `CLAUDE.md` to describe your project's specific domain and constraints
3. **Start building** with `/ship <feature description>` — the pipeline handles planning through review
4. **Trust the halts** — when the pipeline stops, it stopped for a reason. Resolve open questions and test failures before continuing
5. **Query before you grep** — before browsing files, run `graphify query "what you're looking for"` — it returns a scoped subgraph in seconds

### Recommended First Steps

```bash
# Build the knowledge graph
graphify update .

# Orient yourself
cat graphify-out/GRAPH_REPORT.md

# Ship your first feature (in Claude Code)
/ship add a hero section with cinematic scroll animation
```

---

## Design References

The agents are calibrated to produce interfaces at the quality level of:

- [Apple](https://apple.com) — spatial clarity, premium typography
- [Stripe](https://stripe.com) — editorial layout, purposeful motion
- [Linear](https://linear.app) — dense information, elegant hierarchy
- [Vercel](https://vercel.com) — technical precision, minimal noise
- [Framer](https://framer.com) — interactive depth, layered motion
- [Raycast](https://raycast.com) — micro-interaction craft
- [Huly](https://huly.io) — cinematic product storytelling
