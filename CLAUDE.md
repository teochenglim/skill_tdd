# Project: Agent Skills Workshop — Thoughtworks SG

## What this is

A 1-hour hands-on workshop teaching full-stack developers how to write Agent Skills (SKILL.md files) for Claude Code and other compatible AI agents. Participants write a real team skill during the session.

## Workshop structure

```
anthropic-skills-workshop.md   ← trainer guide + participant handout
skills/                        ← example skills library
  tw-git-commit/               ← example: embedded-taste pattern (Block 2)
  tw-tdd/                      ← example: agentic TDD loop pattern (Block 2)
  tw-incident-runbook/         ← lab skill participants write (Block 4)
  file-reading/                ← example: decision router pattern (Block 2)
CLAUDE.md                      ← this file (Block 5 demo)
```

## How to run the examples

```bash
# Install a skill into your local Claude Code library
cp -r skills/tw-incident-runbook ~/.claude/skills/

# Verify Claude sees it
# Ask Claude: "When would you use the tw-incident-runbook skill?"
```

## Active skills in this project

tw-git-commit
tw-tdd
tw-incident-runbook
file-reading

## What NOT to do

- Do not put README.md inside a skill folder — use `references/` instead
- Do not use XML angle brackets `< >` in SKILL.md frontmatter
- Do not make the `name` field differ from the folder name
