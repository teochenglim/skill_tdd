---
name: tw-git-commit
description: >
  Writes conventional commit messages following Thoughtworks team standards.
  Stages changes, proposes a message, and confirms before committing.
  Use when user says "commit", "write a commit message", "git commit",
  "what should I commit this as", or "help me commit these changes".
  Do NOT use for merge commits or release tagging.
license: MIT
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---

# TW Git Commit

## Conventional commit format

```
<type>(<scope>): <short summary>

[optional body — wrap at 72 chars]

[optional footer: JIRA-123, breaking change notice]
```

**Types:**

| Type | When to use |
|------|-------------|
| `feat` | New feature or behaviour visible to users |
| `fix` | Bug fix |
| `refactor` | Code change with no behaviour change |
| `test` | Adding or fixing tests only |
| `chore` | Tooling, deps, CI — no prod code change |
| `docs` | Documentation only |
| `perf` | Performance improvement |

## Workflow

1. Run `git diff --staged` (or `git diff HEAD` if nothing staged yet) to read the actual changes — never guess from filenames alone.
2. Identify the dominant change type. If the diff mixes types, split the commit or pick the most significant.
3. Choose a scope: the module, package, or feature area (e.g. `auth`, `pipeline`, `api`). Omit if the change is truly cross-cutting.
4. Write the summary in **imperative mood**, lowercase, ≤72 chars, no trailing period.
   - ✅ `feat(auth): add JWT refresh token rotation`
   - ❌ `Added refresh token support to auth module.`
5. Propose the full message to the user. Wait for approval before running `git commit`.
6. After commit, print the short hash: `git log --oneline -1`.

## Gotchas

- Never include "Claude" or "AI-generated" in the commit message unless asked.
- If the diff is empty, remind the user to stage files first.
- Breaking changes go in the footer: `BREAKING CHANGE: <what changed and why>`.
- Reference JIRA tickets in the footer, not the summary: `Refs: PLAT-456`.
