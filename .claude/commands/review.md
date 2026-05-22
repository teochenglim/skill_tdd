Do a thorough code review of the current branch.

Run `git diff main` to see all changes, then report:
1. **Correctness** — logic errors, off-by-ones, missing edge cases
2. **Tests** — are new behaviours covered? any tests missing?
3. **Security** — OWASP top 10: injection, insecure defaults, exposed secrets
4. **Style** — violations of conventions in CLAUDE.md

Format output as a checklist the engineer can action, grouped by severity (blocking / advisory).
