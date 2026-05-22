# Workshop Project Rules

Loaded automatically at SessionStart.

## AGENT_BOUNDARY

**May read/write:**
- `skills/`       — example skill files
- `solution/`     — reference solutions for the lab
- `*.md`          — workshop documents

**Must never touch:**
- `.env`, `*.pem`, `*.key` — credentials (none exist here, but enforce the habit)
- `.claude/hooks/` — hook scripts are infrastructure, not application code

**Network:** no external calls needed for this workshop.

## Conventions

- Skill folder names are kebab-case and match the `name:` field exactly
- SKILL.md files use `---` YAML frontmatter delimiters
- No XML angle brackets `< >` in frontmatter values
- No README.md inside skill folders — use `references/` instead

## Active skills

tw-git-commit, tw-tdd, tw-incident-runbook, file-reading
