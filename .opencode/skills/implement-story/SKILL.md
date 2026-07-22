---
name: implement-story
description: Full end to end user story lifecycle delegating analysis, architecture check, execution, and review loops.
---

# Implement Story Workflow

Use this process whenever implementing a user story, feature, or non-trivial task.

## Phase 1: Analysis & Spec Check
1. Delegate to `@analysis-agent`:
   - Request clarification of user story requirements, edge cases, and acceptance criteria.
2. Delegate to `@architecture-agent`:
   - Validate if the target feature requires architectural changes, database migrations, or ADR additions.
3. **Gate:** Ensure clear acceptance criteria and technical tasks exist before writing any code.

## Phase 2: Implementation Step
1. Delegate to `@implementation-agent`:
   - Provide the spec created in Phase 1.
   - Implement code changes, unit tests, and documentation according to repo guidelines.
   - Run tests locally to ensure build pass status.

## Phase 3: Review Loop
1. Delegate to `@review-agent`:
   - Direct the reviewer to inspect modified files and new tests.
2. Check findings:
   - **If Critical / High / Medium issues exist:** Re-delegate to `@implementation-agent` with the findings list to refactor. Repeat Phase 3.
   - **If Low / Nitpicks only or Approved:** Proceed to Phase 4.

## Phase 4: Finalization
1. Verify all tests pass.
2. Summarize key changes, new tests added, and any architectural or migration notes for the pull request.
