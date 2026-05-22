# Agent Skills Workshop — Thoughtworks SG

A 1-hour hands-on workshop for full-stack developers. You will read, discuss, and write SKILL.md files for Claude Code.

---

## Quick Start

```bash
# 1. Clone and open in VS Code
git clone <repo-url>
cd skill_tutorial
code .

# 2. Install the TDD skill into Claude
cp -r ./skills/tw-tdd ~/.claude/skills/

# 3. Set up the Python lab
cd python
uv sync

# 4. Verify everything works
uv run pytest solution/test_cart.py -v
```

Then open the Claude Code chat panel in VS Code and type:
```
When would you use the tw-tdd skill?
```
A crisp answer means you are ready. Proceed to `python/README.md` for the lab.

---

## Reading order

### 1. Start here — workshop guide
[anthropic-skills-workshop.md](anthropic-skills-workshop.md)

The full trainer guide and participant handout. Read top to bottom. Covers:
- What a skill is and how progressive disclosure works (Block 1)
- Anatomy of a SKILL.md — frontmatter fields, description writing, body patterns (Block 2)
- Live library walkthrough (Block 3)
- Lab: write `tw-incident-runbook` together (Block 4)
- How to structure `CLAUDE.md` for a project (Block 5)

---

### 2. Study the two example skills (Block 2 & 3 reference)

Read these side by side. Each demonstrates a different skill pattern.

| File | Pattern | What to notice |
|------|---------|----------------|
| [skills/tw-git-commit/SKILL.md](skills/tw-git-commit/SKILL.md) | **Embedded taste** — encodes team conventions | Negative trigger, decision table, imperative steps |
| [skills/tw-tdd/SKILL.md](skills/tw-tdd/SKILL.md) | **Workflow** — agentic red-green loop | PRD → tests → implement → fix, adversarial test-agent pattern |

Questions to answer after reading:
- What trigger phrases would activate each skill?
- What would happen if the description were only one sentence?
- What would you move to a `references/` file if the body got too long?

---

### 3. Read the lab skill (Block 4 output)

[skills/tw-incident-runbook/SKILL.md](skills/tw-incident-runbook/SKILL.md)

This is the skill you will recreate together during Block 4. Read it before the lab so you understand the target. During the lab, start from a blank file.

---

### 4. Read CLAUDE.md (Block 5 reference)

[CLAUDE.md](CLAUDE.md)

The project-level context file. Block 5 of the workshop uses this file as a live example of what to put in `CLAUDE.md` vs what belongs in a skill. Notice it is short, command-focused, and written for Claude — not humans.

---

## Quick skill checklist

Before shipping any SKILL.md:

```
[ ] Folder name matches the name field exactly
[ ] File is named SKILL.md (exact case)
[ ] Frontmatter has --- delimiters, name + description present
[ ] name uses [a-z0-9-] only, no --, 1–64 chars
[ ] description states WHAT + WHEN + trigger phrases, ≤1024 chars, no < >
[ ] Body has step-by-step instructions
[ ] Body has a Gotchas section for non-obvious caveats
[ ] Body is ≤500 lines; longer content moved to references/
[ ] No README.md inside the skill folder
```

## How to install a skill locally

```bash
# Copy a skill into your Claude Code library
cp -r skills/tw-incident-runbook ~/.claude/skills/

# Test it — ask Claude:
# "When would you use the tw-incident-runbook skill?"
# A crisp, accurate answer means the description is good.
# A vague answer means the description needs more trigger phrases.
```
