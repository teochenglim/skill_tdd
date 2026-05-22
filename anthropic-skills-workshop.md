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
| 6 | Claude Code Hooks — lifecycle enforcement *(optional +15 min)* | 15 min |

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

### Two real skills — live in `skills/` in this repo

**`tw-git-commit`** — *embedded taste pattern*
- Outcome-first description ("conventional commit messages")
- Explicit trigger phrases ("commit", "write a commit message", "help me commit")
- Negative trigger: "Do NOT use for merge commits or release tagging"
- Body embeds the team's format rules: type table, workflow steps, gotchas

**`file-reading`** — *decision router pattern* (`skills/file-reading/SKILL.md`)
- Uses `compatibility` field to signal required tools
- Negative trigger: "Do NOT use if file content already in context"
- Body is a dispatch table: file extension → correct tool + strategy
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

## Block 6 — Claude Code Hooks (15 min optional extension)

Hooks let you run shell commands at every key moment in a Claude Code session. Think of them as the CI pipeline *inside* your AI pair programmer — enforcing rules before damage can happen.

---

### The full lifecycle — 6 symmetric hook types

```
Session start
    │
    ▼
┌─────────────────────────────────────────────────────┐
│  SessionStart   — inject project rules, warm caches  │
└─────────────────────────────────────────────────────┘
    │
    ▼  ◄─── user types ───────────────────────────────
┌─────────────────────────────────────────────────────┐
│  UserPromptSubmit — scan prompt before Claude reads  │
└─────────────────────────────────────────────────────┘
    │
    ▼  ◄─── Claude decides to call a tool ───────────
┌─────────────────────────────────────────────────────┐
│  PreToolUse   — block dangerous calls before run     │
└─────────────────────────────────────────────────────┘
    │
    ▼  ◄─── tool runs ────────────────────────────────
┌─────────────────────────────────────────────────────┐
│  PostToolUse  — format, lint, verify output          │
└─────────────────────────────────────────────────────┘
    │
    ▼  ◄─── Claude stops responding ─────────────────
┌─────────────────────────────────────────────────────┐
│  Stop         — run quick tests, notify team         │
└─────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────┐
│  SessionEnd   — save summary, audit log              │
└─────────────────────────────────────────────────────┘
```

| Event | Fires when | Can block? | Key use |
|-------|-----------|-----------|---------|
| `SessionStart` | Session opens | — | Inject context, load rules |
| `UserPromptSubmit` | User hits enter | ✅ | Secret scanning, scope check |
| `PreToolUse` | Before tool runs | ✅ | Block `rm -rf`, enforce boundaries |
| `PostToolUse` | After tool returns | — | Lint, format, import check |
| `Stop` | Claude finishes turn | — | Quick tests, CI trigger |
| `SessionEnd` | Session closes | — | Audit log, session summary |

**Can block?** — non-zero exit code from the hook command aborts the tool call. Claude sees the stderr output and can explain what was blocked.

---

### Where hooks live

```
.claude/settings.json        ← project-level, committed — shared with the whole team
.claude/settings.local.json  ← local overrides, gitignored — personal or trainer demos
~/.claude/settings.json      ← user-level personal guardrails across all projects
```

Project settings override user settings on name collision. Treat `.claude/settings.json` like your CI config — it goes through PR review. Use `settings.local.json` for hooks you want to demo live without committing.

---

### Live examples in this repo

**This repo ships all six hooks pre-wired.** Open `.claude/settings.local.json` to see the full config, then explore each file:

```
.claude/
├── settings.local.json        ← all 6 hooks enabled (live — open this now)
├── project-rules.md           ← loaded by SessionStart into every conversation
├── commands/
│   ├── review.md              ← /review slash command
│   └── deploy.md              ← /deploy slash command
└── hooks/
    ├── block-rm-rf.sh         ← PreToolUse: blocks destructive rm
    ├── check-imports.sh       ← PostToolUse: hallucination firewall for Python imports
    └── save-session-summary.sh ← SessionEnd: appends to session-log.md
```

**Try it now:**
```bash
# Trigger /review
# In Claude Code: type /review

# Watch SessionStart fire — project-rules.md appears in Claude's context automatically

# Trigger the import firewall — write a .py file that imports a made-up package
# Claude will see the warning on the next turn
```

---

### Slash commands

Slash commands are Markdown files in `.claude/commands/`. Each file becomes a `/command-name` the whole team can invoke — no plugin, no config beyond the file itself.

```
/review   →  .claude/commands/review.md
/deploy   →  .claude/commands/deploy.md
```

Open either file to see the full prompt. The pattern: state the goal, list the checks, specify the output format.

---

### What each hook does

| Hook | File | Effect |
|------|------|--------|
| `SessionStart` | `project-rules.md` | Injects AGENT_BOUNDARY + conventions before Claude reads your first message |
| `UserPromptSubmit` | *(inline grep)* | Warns if your prompt looks like it contains a secret before Claude sees it |
| `PreToolUse` Bash | `block-rm-rf.sh` | Exits 1 (blocks) if the command targets root or traverses above the project |
| `PostToolUse` Write\|Edit | `check-imports.sh` | Warns if a written `.py` file imports a package not in `requirements.txt` |
| `Stop` | *(inline pytest)* | Runs `pytest -q` after each turn so Claude sees test failures immediately |
| `SessionEnd` | `save-session-summary.sh` | Appends a timestamped entry to `.claude/session-log.md` |

**Community library:** [npmjs.com/package/@premierstudio/ai-hooks](https://www.npmjs.com/package/@premierstudio/ai-hooks) has ready-to-use hook scripts for common patterns — a good starting point before writing your own.

---

### Responsible Tech: the golden rule

> **Bots can have access to internal data OR the ability to communicate externally. Never both.**

An agent that can read your database *and* POST to Slack is one prompt injection away from exfiltrating every customer record. Structure your hooks to enforce this at the tool layer:

```bash
# .claude/hooks/block-external-calls.sh
# Blocks curl/wget/fetch to non-internal hostnames
COMMAND="$CLAUDE_TOOL_INPUT"
if echo "$COMMAND" | grep -qE 'curl|wget|fetch|axios'; then
  if ! echo "$COMMAND" | grep -qE 'api\.internal|localhost|127\.0\.0\.1'; then
    echo "BLOCKED: external network call from data-access session" >&2
    exit 1
  fi
fi
```

---

### AGENT_BOUNDARY declarations

Add an `AGENT_BOUNDARY` section to `CLAUDE.md` to declare the scope explicitly. Pair it with a `PreToolUse` hook that reads these rules and rejects out-of-scope calls.

```markdown
## AGENT_BOUNDARY

**May read/write:**
- `src/`          — application source
- `tests/`        — test files
- `scripts/`      — build helpers

**Must never touch:**
- `infra/terraform/`     — infrastructure (human-only)
- `.env`, `*.pem`, `*.key` — credentials
- Production databases

**Network:**
- Dev: `api.internal` only
- Production: requires explicit `/deploy` command (human in the loop)
```

**Credential scoping principle:** Claude only gets the env vars it explicitly needs. Never export your full shell environment to the agent. Pass targeted vars:

```bash
# ✅ scoped: only what this task needs
GITHUB_TOKEN=$GH_TOKEN claude "open a draft PR for this branch"

# ❌ unscoped: every secret in your shell is now Claude's
claude "open a draft PR for this branch"
```

---

### Discussion

- Which of the 6 hooks would have caught your last incident?
- What would your team's `AGENT_BOUNDARY` look like?
- Who reviews `.claude/settings.json` changes in your repo? (treat it like `.github/workflows/`)
- Where does the golden rule ("data access OR external comms, not both") already apply in your architecture?

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
