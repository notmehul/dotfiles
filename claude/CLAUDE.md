# How I Work

## Problem-Solving Approach
- Gather full context before acting. Read project docs, existing code, and specs first.
- When requirements are unclear, surface the ambiguity and ask. Do not assume and build.
- When context is unavailable, make small moves to find boundaries, then report back.
- When uncertain, say so explicitly and present options with tradeoffs.

## Before Writing Any Code
- Read the project's docs/architecture.md and docs/patterns.md before starting work.
- Search the codebase for existing utilities, components, or patterns that relate to the task.
- Do not write new code that duplicates what already exists. If something close exists, extend it.
- Do not start working on an ambiguous or open-ended task without confirming the plan first.

## Code Principles
- One function does one thing. One file handles one responsibility.
- Prefer simple, readable solutions over clever ones. Optimize for the next person reading this.
- Do not add complexity for edge cases we haven't encountered yet (YAGNI).
- If a maintained, stable library solves a complex problem (database drivers, auth, parsing), use it.
  Do not pull in libraries for trivial tasks — write those yourself.
- Break large implementations into small, reusable pieces. If a block of logic could be used
  elsewhere, extract it into its own utility or module.

## Definition of Done
Every piece of work is finished only when all of these are true:
- Compiles, runs, and passes existing tests
- Has new test cases covering the new or changed behavior
- Follows existing project patterns (check docs/patterns.md)
- Is readable without needing explanation
- Documentation is updated where relevant (architecture.md, patterns.md, README)
- No unrelated code has been changed or refactored

## Code Review Behavior
When reviewing code:
- Read the full file before commenting on any part.
- Prioritize: critical issues first, then important, then minor.
- Do not suggest rewrites of things that are working and readable.
- Do not introduce patterns not already present in the codebase unless asked.

## Subagent Usage
When to use subagents:
- 3+ independent tasks with no shared state, touching different files or subsystems.
- Parallel investigation of unrelated failures.

When not to use subagents:
- Tasks that share state or edit the same files.
- When the problem is not yet fully understood — explore first, dispatch later.

Every subagent dispatch must include: specific scope, clear goal, constraints (what not to change),
and expected output format. Always review after each subagent completes before dispatching the next.

## What Not To Do
- Do not write production code before a plan is confirmed.
- Do not refactor or restructure working code outside the scope of the current task.
- Do not introduce a new library without checking if an existing one already covers it.
- Do not leave documentation out of sync after changing a contract, route, or schema.
- Do not silently pick a direction on an unclear decision — flag it.
- Do not skip tests. Ever.

## When Something New Is Learned
At the end of a session where a non-obvious decision was made, a bug was solved in a surprising
way, or a new pattern was established:
- Update docs/patterns.md directly if the learning is clear and reusable.
- If uncertain whether it belongs, flag it: [PATTERN NOTE: {brief description}]
- If a structural decision was made, update docs/architecture.md.