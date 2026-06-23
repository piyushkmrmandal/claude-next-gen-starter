# /ship — Feature Pipeline Orchestrator

Run the full four-agent development pipeline for a feature request.

## Usage

```
/ship <feature description>
```

## What It Does

Chains four specialized agents in sequence. Each agent produces a handoff file in `.pipeline/`. The pipeline halts if any gate fails.

```
[Planner] → .pipeline/spec.md
     ↓ (halt if OPEN QUESTIONS exist)
[Coder] → .pipeline/changes.md
     ↓
[Tester] → .pipeline/test-results.md
     ↓ (halt if tests FAIL)
[Reviewer] → .pipeline/review.md
     ↓
Verdict: SHIP | NEEDS WORK | BLOCK
```

## Pipeline Steps

### Step 1 — Planner
Invoke `@planner` with the feature description.

After the Planner writes `.pipeline/spec.md`:
- If `OPEN QUESTIONS` section is non-empty → **stop and present questions to the user**
- If no open questions → proceed to Step 2

### Step 2 — Coder
Invoke `@coder` with: "Implement the feature specified in .pipeline/spec.md"

After the Coder writes `.pipeline/changes.md`:
- Proceed to Step 3

### Step 3 — Tester
Invoke `@tester` with: "Write and run tests for the changes in .pipeline/changes.md"

After the Tester writes `.pipeline/test-results.md`:
- If status is `FAIL` → **stop and present failures to the user**
- If status is `PASS` → proceed to Step 4

### Step 4 — Reviewer
Invoke `@reviewer` with: "Review all pipeline files and changed code"

After the Reviewer writes `.pipeline/review.md`:
- Present the verdict to the user
- If `SHIP` → done, ready to commit
- If `NEEDS WORK` → present required changes to the user
- If `BLOCK` → present blockers, recommend re-running `/ship` after fixes

## Pipeline Files

All handoff files live in `.pipeline/` and are gitignored by default. They are ephemeral — cleared at the start of each `/ship` run.

- `.pipeline/spec.md` — Planner output
- `.pipeline/changes.md` — Coder output  
- `.pipeline/test-results.md` — Tester output
- `.pipeline/review.md` — Reviewer output

## Notes

- You can resume a stalled pipeline by invoking individual agents directly
- To re-run from a specific step: invoke that agent and all subsequent agents
- The `.pipeline/` folder can be committed for audit trails on complex features
