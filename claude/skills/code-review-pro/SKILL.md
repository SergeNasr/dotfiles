---
name: code-review-pro
description: Comprehensive code review covering security vulnerabilities, performance bottlenecks, best practices, and refactoring opportunities. Use when user requests code review, security audit, or performance analysis.
---

# Code Review Pro

Parallel code review using focused subagents for each review pillar.

## When to Use This Skill

Activate when the user:
- Asks for a code review
- Wants security vulnerability scanning
- Needs performance analysis
- Asks to "review this code" or "audit this code"
- Mentions finding bugs or improvements
- Wants refactoring suggestions
- Requests best practice validation

## Tenets

1. **Elegance through established patterns.** Prefer well-known, industry-standard patterns over bespoke or ad-hoc solutions. When code reinvents something that a language built-in, framework convention, or widely-adopted pattern already solves, flag it and suggest the standard replacement. Consult the memory file `memory/code-elegance.md` for the full pattern-preference hierarchy and replacement catalog.
2. **Simplicity is a feature.** The best code is the code you don't have to explain. Favor straightforward, idiomatic implementations over clever ones.
3. **Outside standards over inside habits.** When a codebase has developed its own non-standard way of doing something (e.g., hand-rolled auth, custom serialization, ad-hoc error handling), and a recognized external standard exists (OWASP, 12-Factor, REST/OpenAPI, language style guides, SOLID/FP idioms), recommend migrating to the standard approach.

## Instructions

### Step 1: Identify the review scope

Determine which files to review. If the user specifies files, use those. Otherwise, look at recent changes (e.g., `git diff` against the base branch) to identify the relevant files.

Read all files in scope so you understand the code before dispatching agents.

### Step 2: Launch pillar agents in parallel

Spawn **all five** subagents in a single message using the Task tool with `subagent_type: "general-purpose"`. Each agent gets a focused mandate for one pillar. Pass the full file paths and content inline so agents don't waste turns re-reading.

**Agent 1 — Security**
```
Review the following code exclusively for security issues. Check for:
- Injection vulnerabilities (SQL, command, XSS, template)
- Auth/authz flaws (missing checks, privilege escalation, token handling)
- Secrets or credentials in code
- Unsafe deserialization, path traversal, SSRF
- CSRF protection gaps
- Insecure cryptography or randomness
- Input validation gaps at trust boundaries

For each finding report: file:line, severity (Critical/High/Medium/Low), the vulnerable code snippet, the fix, and why it matters. If no issues found, say so.
```

**Agent 2 — Performance**
```
Review the following code exclusively for performance issues. Check for:
- N+1 queries or redundant DB calls
- Inefficient algorithms (note Big-O)
- Memory leaks or unbounded growth
- Blocking operations on hot paths
- Missing resource cleanup (file handles, connections, subscriptions)
- Unnecessary re-renders or re-computations (for UI code)
- Missing caching or memoization opportunities
- Excessive network calls or payload sizes

For each finding report: file:line, severity (Critical/High/Medium/Low), the problematic code snippet, the fix, and expected impact. If no issues found, say so.
```

**Agent 3 — Bugs & Edge Cases**
```
Review the following code exclusively for correctness bugs and unhandled edge cases. Check for:
- Logic errors and off-by-one mistakes
- Race conditions and concurrency issues
- Null/undefined dereferences
- Unhandled error paths or missing try/catch
- Timezone, encoding, or floating-point issues
- Boundary conditions (empty collections, max values, negative inputs)
- State inconsistencies

For each finding report: file:line, severity (Critical/High/Medium/Low), the buggy code snippet, the fix, and a scenario that triggers it. If no issues found, say so.
```

**Agent 4 — Business Logic & Assumptions**
```
Review the following code exclusively for business logic correctness and implicit assumptions. Check for:
- Assumptions that don't hold (e.g., assuming a list is non-empty, assuming uniqueness, assuming ordering)
- Domain invariants that aren't enforced (e.g., balances going negative, overlapping date ranges, orphaned records)
- Mismatches between what the code does and what the function/variable names promise
- Silent data loss or truncation (e.g., casting away precision, ignoring return values, swallowing partial failures)
- Implicit coupling to external state (e.g., relying on DB row order, assuming env vars exist, depending on clock time)
- Missing or wrong validation of business rules (e.g., allowing invalid state transitions, skipping permission checks for edge-case paths)
- Inconsistent handling of the same concept across code paths (e.g., one path checks ownership, another doesn't)
- Default values that mask real problems (e.g., falling back to empty string when null means "missing data")
- Partial operations without rollback (e.g., creating a record but failing to create its dependency, leaving inconsistent state)
- Hardcoded business constants that should be configurable or derived

For each finding report: file:line, severity (Critical/High/Medium/Low), the code snippet, what assumption is being made, why it might not hold, and the fix. If no issues found, say so.
```

**Agent 5 — Code Quality, Maintainability & Pattern Elegance**
```
Review the following code exclusively for code quality, maintainability, and pattern elegance. Check for:
- DRY violations and copy-paste code
- Functions/methods exceeding ~50 lines or high cyclomatic complexity
- Unclear or misleading naming
- God classes/functions doing too many things
- Tight coupling or missing abstractions
- Inconsistent patterns within the codebase
- Type safety gaps
- Violations of language/framework idioms

Additionally, apply these elegance and simplicity tenets:
- Hand-rolled solutions where a language/framework built-in already exists (e.g., manual iteration vs built-in map/filter/reduce, custom string building vs template literals or f-strings)
- Ad-hoc patterns where an established industry standard should be used (e.g., bespoke error handling vs Result/Either types, hand-rolled auth vs OWASP-aligned patterns, custom serialization vs JSON Schema/Protobuf)
- Overly clever or complex implementations where a simpler, idiomatic approach exists
- Non-standard internal conventions that should be replaced by recognized outside standards (language style guides, framework conventions, SOLID/FP idioms, 12-Factor, REST/OpenAPI)
- Reinvented wheels: custom utilities or abstractions that duplicate well-known libraries or platform capabilities

For each finding report: file:line, severity (High/Medium/Low), the current code snippet, the suggested refactor (citing the standard pattern or convention by name), and why it improves maintainability. If no issues found, say so.
```

### Step 3: Synthesize the report

Once all agents return, combine their findings into a single report. Deduplicate overlapping findings. Sort by severity (Critical first).

Use this format:

```
# Code Review: [short description]

## Critical
### [Title] — `file:line`
**Pillar**: Security | Performance | Bug | Business Logic | Quality
[Description, code snippet, fix, explanation]

## High
...

## Medium
...

## Low
...

## Summary
- Critical: N | High: N | Medium: N | Low: N
- Pillars with findings: [list]
- Pillars clean: [list]

## Quick Wins
High-impact, low-effort changes:
1. ...

## Strengths
- ...
```

### Step 4: Offer to fix

After presenting the report, ask the user:
> "Run `/code-review-pro:fix` to apply all fixes, or tell me which specific findings to address."

---

## Sub-skill: fix

**Trigger**: User runs `/code-review-pro:fix` or asks to "fix the review findings" after a review has been produced in the current conversation.

### Instructions

1. **Extract findings from the review report** in the current conversation. Parse each finding's file:line, pillar, severity, and the suggested fix.

2. **Sort by severity** (Critical → High → Medium → Low), then by pillar priority (Security → Bugs → Business Logic → Performance → Quality).

3. **Apply fixes using subagents in parallel, grouped by file.** For each file that has findings, spawn one Task agent (`subagent_type: "general-purpose"`) with:
   - The full current file content
   - All findings for that file, ordered by severity
   - Instructions to apply each fix, preserving surrounding code
   - Instructions to return the complete fixed file content

   Launch all file-level agents in a single message for parallelism. Each agent prompt:
   ```
   You are applying code review fixes to a single file. You will be given the file content and a list of findings with fixes.

   Apply ALL fixes listed below to the file. For each fix:
   - Make the exact change described
   - Preserve surrounding code, formatting, and style
   - If two fixes conflict or overlap, prefer the higher-severity one

   After applying all fixes, return ONLY the complete updated file content with no explanation.

   File: [path]
   Content:
   [full file content]

   Fixes to apply (in priority order):
   [list of findings with before/after snippets]
   ```

4. **Write the fixed files** using the Write tool. Do NOT use Edit for these — the agents return complete file contents.

5. **Verify the fixes compile/lint.** Run the project's build or typecheck command (e.g., `bazel build`, `tsc --noEmit`, etc.) to confirm no regressions.

6. **Report results:**
   ```
   # Fixes Applied

   ## Files Modified
   - `path/to/file.ts` — N fixes (Critical: X, High: Y, ...)
   - ...

   ## Build Status
   [Pass/Fail with details]

   ## Fixes Skipped (if any)
   - [Finding] — [reason: conflicting fix / ambiguous change / requires manual intervention]
   ```

   If build fails, identify which fix caused the regression and revert just that fix.

### Guidelines

- Always provide file:line references
- Include before/after code for every finding
- Explain *why* something is a problem, not just *what*
- Acknowledge strengths — don't just list problems
- Be pragmatic: flag what matters, skip nitpicks
- If a pillar returns clean, call that out as a positive signal
