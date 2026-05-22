# Intro to Agent Skills — 1-Hour Workshop
*Trainer guide + participant handout · Thoughtworks SG*
*Source: agentskills.io (open standard, originally by Anthropic)*

---

## Agenda (60 min)

| # | Block | Time |
|---|-------|------|
| 1 | What is a Skill? Concepts & mental model | 10 min |
| 2 | Anatomy of a SKILL.md — live dissection | 15 min |
| 3 | Live walkthrough: trainer's `~/.claude/skills/` library | 10 min |
| 4 | Lab: write a team-specific skill together | 15 min |
| 5 | Structure CLAUDE.md for the workshop codebase | 10 min |

---

## Block 1 — What is a Skill? (10 min)

A **skill** is a folder containing a `SKILL.md` file. It packages specialized knowledge and workflows that an agent loads on demand. Write it once; every compatible agent uses it.

```
skill-name/
├── SKILL.md          ← required: YAML frontmatter + instructions
├── scripts/          ← optional: Python, Bash, JS — agent can run these
├── references/       ← optional: docs loaded on demand
└── assets/           ← optional: templates, images, schemas
```

**The open standard.** Agent Skills is an open format now supported by 35+ clients — Claude (claude.ai + Claude Code), GitHub Copilot, Cursor, VS Code, OpenAI Codex, Gemini CLI, OpenHands, and many more. One skill, every agent.

**Why?** Agents are capable but often lack the *context* to do real work reliably. Skills solve this by packaging:
- **Domain expertise** — legal review steps, data pipeline conventions, your team's runbook format
- **Repeatable workflows** — multi-step procedures with validation gates
- **Cross-product reuse** — build once, run anywhere skills-compatible

**Progressive disclosure — three tiers:**

| Tier | What loads | Token cost | When |
|------|-----------|-----------|------|
| 1 · Catalog | `name` + `description` only | ~50–100 per skill | Session start |
| 2 · Instructions | Full `SKILL.md` body | < 5,000 tokens | When skill is relevant |
| 3 · Resources | `scripts/`, `references/`, `assets/` | As needed | On demand |

20 skills installed ≠ 20 full instruction sets in context. Only active skills pay the token cost.

---

## Block 2 — Anatomy of a SKILL.md (15 min)

### Minimal valid skill

```yaml
---
name: skill-name
description: What it does. Use when user asks to [specific phrases].
---

# Instructions go here in Markdown
```

Two required fields, then Markdown. That's the whole format.

---

### Full frontmatter reference

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | ✅ | 1–64 chars, `[a-z0-9-]` only, no `--`, matches folder name |
| `description` | ✅ | 1–1024 chars, states WHAT + WHEN (trigger phrases) |
| `license` | — | Short string or reference to bundled `LICENSE.txt` |
| `compatibility` | — | 1–500 chars, environment requirements only if non-obvious |
| `metadata` | — | Arbitrary key-value map (`author`, `version`, `team`, …) |
| `allowed-tools` | — | Space-separated pre-approved tools (experimental) |

```yaml
---
name: tw-incident-runbook
description: >
  Guides on-call engineers through incident response. Generates a
  timestamped runbook, action log, and stakeholder update draft.
  Use when user says "start incident", "run an incident",
  "create runbook", or "postmortem template".
license: MIT
compatibility: Claude Code, claude.ai — bash tool recommended for timestamps
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---
```

**Hard rules:**
- `name` must match the folder name exactly
- No XML angle brackets `< >` anywhere in frontmatter (security)
- File must be named exactly `SKILL.md` (case-sensitive)
- No `README.md` inside the skill folder (use `references/` instead)

---

### Writing effective descriptions

The description is the *only* thing the agent reads to decide whether to activate the skill. Get it right.

**Use imperative framing:** "Use this skill when…" not "This skill does…"

**Focus on user intent, not implementation:** What is the user trying to accomplish?

**Include explicit trigger phrases** — especially implicit ones: "even if they don't mention 'CSV' directly"

**Add negative triggers** when you need to narrow scope: "Do NOT use for simple data exploration"

```yaml
# ❌ Too vague — will miss most triggers
description: Helps with PDFs.

# ✅ Specific + trigger phrases + scope
description: >
  Extracts text and tables from PDFs, fills forms, and merges files.
  Use when working with PDF documents or when the user mentions PDFs,
  forms, or document extraction — even if they don't say "PDF" explicitly.
```

---

### Body content patterns

**Gotchas section** — the highest-value content in many skills:
```markdown
## Gotchas

- The `users` table uses soft deletes. Always add `WHERE deleted_at IS NULL`.
- User ID is `user_id` in DB, `uid` in auth service, `accountId` in billing.
  All three refer to the same value.
```

**Templates for output format** — more reliable than prose description:
```markdown
## Report structure

Use this template:
# [Analysis Title]
## Executive summary
[One-paragraph overview]
## Key findings
- Finding with supporting data
## Recommendations
1. Specific actionable item
```

**Checklists for multi-step workflows:**
```markdown
## Processing workflow
- [ ] Step 1: Analyze form (`scripts/analyze_form.py`)
- [ ] Step 2: Create field mapping (`fields.json`)
- [ ] Step 3: Validate (`scripts/validate_fields.py`)
- [ ] Step 4: Fill form (`scripts/fill_form.py`)
```

**Calibrate specificity to fragility:** give the agent freedom for flexible tasks; be prescriptive when sequence and consistency matter.

---

### Two real skills from `~/.claude/skills/public/`

**`frontend-design`** — *embedded taste pattern*
- Outcome-first description ("production-grade interfaces")
- Explicit trigger phrases (web components, pages, React components)
- Negative signal ("avoids generic AI aesthetics")
- Body embeds the team's design system: typography rules, color system, anti-patterns

**`file-reading`** — *decision router pattern*
- Uses `compatibility` field to signal environment
- Negative trigger: "Do NOT use if file content already in context"
- Body is a dispatch table: file extension → correct tool
- Stat before read; sample, don't slurp

---

## Block 3 — Live Library Walkthrough (10 min)

*Trainer runs these live; audience watches.*

```bash
# Show the library layout
ls ~/.claude/skills/
# gstack/   public/   examples/

# Inspect a simple skill
cat ~/.claude/skills/gstack/tw-adr-writer/SKILL.md

# Show a heavier skill with scripts/
ls ~/.claude/skills/gstack/pptx-enhancer/
# SKILL.md  scripts/  references/

# ── The fastest debugging trick ──────────────────────────
# Ask Claude about itself:
# "When would you use the tw-adr-writer skill?"
# → Claude quotes the description back verbatim.
#   Vague response = vague description. Fix the description.
```

**Key observations to highlight:**
- Skills are plain folders — git-trackable, diffable, PR-reviewable
- The `gstack/` namespace keeps team skills separate from public ones
- `scripts/` files are real Python/Bash; Claude runs them and reads stdout
- `references/` files are never pre-loaded; Claude navigates them lazily

**Where agents look for skills:**

| Scope | Paths scanned |
|-------|--------------|
| Project | `.agents/skills/`, `.<client>/skills/` |
| User | `~/.agents/skills/`, `~/.<client>/skills/` |

Project skills override user skills (name collision = project wins).

---

## Block 4 — Lab: Write tw-incident-runbook (15 min)

### Step 1 — Define trigger phrases (2 min)

Think about what engineers *actually type*:
- `"start incident for [service]"`
- `"help me run an incident"`
- `"create runbook"`
- `"postmortem template"`

### Step 2 — Write the frontmatter (3 min)

```yaml
---
name: tw-incident-runbook
description: >
  Guides on-call engineers through Thoughtworks incident response.
  Generates a timestamped runbook, action log, and stakeholder update.
  Use when user says "start incident", "run an incident",
  "create runbook", "postmortem template", or "help me manage this outage".
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---
```

### Step 3 — Write the body (10 min)

```markdown
# TW Incident Runbook

## Step 1: Capture incident basics

Ask only for what's missing:
- Service / component affected
- Severity (SEV1 / SEV2 / SEV3)
- Incident commander (default: person who triggered this)
- Start time (run `date -u +"%Y-%m-%dT%H:%M:%SZ"` if bash available)

## Step 2: Generate the runbook file

Create `INCIDENT-<YYYYMMDD-HHMM>-<service>.md`:

---
# INCIDENT: <service> — <severity>
**Started:** <timestamp>  **Commander:** <name>  **Status:** 🔴 Active

## Timeline
| Time (UTC) | Action | Who |
|-----------|--------|-----|
| <start>   | Incident declared | <commander> |

## Hypothesis
(what we think is wrong)

## Actions taken

## Stakeholder update (draft)
> **[<severity>] <service> degraded — <time>**
> We are actively investigating [description]. Current impact: [impact].
> Next update in 30 minutes.

## Resolution & postmortem checklist
- [ ] Timeline completed
- [ ] Root cause identified
- [ ] Action items in JIRA
- [ ] Postmortem meeting scheduled within 48h
---

## Step 3: Maintain the log

As the engineer reports updates, append rows to the Timeline table
and update the Hypothesis section. Keep the file as source of truth.

## Step 4: Stakeholder comms

When asked for a "status update", generate a concise Slack message
(no markdown tables, ≤5 sentences, plain text).

## Gotchas

- If bash is unavailable, ask for the current UTC time rather than guessing.
- SEV1 = customer-impacting, requires immediate escalation.
```

### Discussion prompts after writing

- Do the trigger phrases match what engineers actually type under pressure?
- Is the body specific enough that Claude won't ask obvious follow-up questions?
- What would go in a `references/` doc? (e.g. PagerDuty escalation matrix, SEV definitions)
- Where would a validation script in `scripts/` help?

### Testing the skill

```bash
# The fastest test:
# Ask: "When would you use the tw-incident-runbook skill?"
# Claude quotes the description back. Vague answer = fix the description.

# Then run a real trigger:
# "Start incident for Singapore RTSP ingestion pipeline"
# Does the skill auto-activate? Does it follow the steps?
```

---

## Block 5 — Structuring CLAUDE.md (10 min)

`CLAUDE.md` is **not** a skill. It is project-level persistent context that Claude Code reads automatically from the repo root (and parent directories). Think of it as the README that Claude reads, not humans.

**Key distinction:**
- `CLAUDE.md` = project context (what the codebase is, how to run it, conventions)
- Skills = reusable behaviours that travel across projects

### Merge hierarchy

Claude Code merges in order — lower files inherit from and can override higher ones:

```
~/.claude/CLAUDE.md          ← global personal preferences
/repo/CLAUDE.md              ← project-level context
/repo/src/CLAUDE.md          ← sub-directory (optional, for monorepos)
```

### What to include

```markdown
# Project: <name>

## What this codebase does
One paragraph. Stack, purpose, scale.

## How to run
[exact bash commands, no prose]

## How to test
[exact bash commands]

## Code conventions
- Language version, formatter, linter
- Patterns to follow, patterns to avoid
- Structured logging vs f-strings, etc.

## Key files
Only the non-obvious entry points.
- `src/pipeline/ingest.py` — entry point for all camera streams

## What NOT to do
- Never commit secrets
- Never bypass schema validation in `src/models/`

## Active skills in this project
tw-incident-runbook
tw-adr-writer
frontend-design
```

**Write for Claude, not humans.** Claude can read the directory tree itself — only explain the non-obvious parts. Keep it lean; verbose CLAUDE.md costs tokens on every message.

---

## Quick Reference Card

### Skill checklist (pre-ship)

```
[ ] Folder: kebab-case, matches name field exactly
[ ] File: SKILL.md (exact case)
[ ] Frontmatter: --- delimiters, name + description present
[ ] name: [a-z0-9-] only, no --, 1–64 chars
[ ] description: states WHAT + WHEN, trigger phrases included
[ ] description: ≤1024 chars, no < > brackets
[ ] Body: step-by-step instructions
[ ] Body: gotchas for non-obvious env specifics
[ ] Body: ≤500 lines; move detail to references/
[ ] No README.md inside the folder
[ ] test-prompts.md: 5 should-trigger, 3 should-not-trigger
```

### Trigger debugging

```
Ask: "When would you use the [skill-name] skill?"
→ Vague answer        → description too vague; add trigger phrases
→ Covers unrelated    → description too broad; add "Do NOT use for…"
→ Crisp & correct     → ship it
```

### Optimizing descriptions — the eval loop

1. Write ~20 test prompts (10 should-trigger, 10 should-not)
2. Split 60/40 into train / validation sets
3. Run each prompt 3× through the agent; compute trigger rate
4. Revise description based on train failures; don't overfit to exact keywords
5. Check validation pass rate; pick the best iteration (not always the last)
6. Update `description` field; verify ≤1024 chars

### Scripts in skills

- Use `uvx`, `npx`, `bunx`, `deno run` for one-off commands (no bundled scripts needed)
- For reusable logic, bundle in `scripts/` with inline dependency declarations (PEP 723 for Python)
- Scripts must: avoid interactive prompts, implement `--help`, use structured stdout, write diagnostics to stderr
- Use distinct exit codes; support `--dry-run` for destructive operations

---

## Further Reading

| Resource | URL |
|----------|-----|
| agentskills.io spec | `https://agentskills.io/specification` |
| Best practices | `https://agentskills.io/skill-creation/best-practices` |
| Optimizing descriptions | `https://agentskills.io/skill-creation/optimizing-descriptions` |
| Evaluating skills | `https://agentskills.io/skill-creation/evaluating-skills` |
| Using scripts | `https://agentskills.io/skill-creation/using-scripts` |
| Anthropic skills repo | `https://github.com/anthropics/skills` |
| skill-creator skill | `~/.claude/skills/examples/skill-creator/` |
