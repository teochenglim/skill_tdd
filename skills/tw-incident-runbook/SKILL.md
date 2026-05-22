---
name: tw-incident-runbook
description: >
  Guides on-call engineers through Thoughtworks incident response.
  Generates a timestamped runbook, action log, and stakeholder update draft.
  Use when user says "start incident", "run an incident",
  "create runbook", "postmortem template", or "help me manage this outage".
license: MIT
compatibility: Claude Code, claude.ai — bash tool recommended for timestamps
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---

# TW Incident Runbook

## Step 1: Capture incident basics

Ask only for what's missing:
- Service / component affected
- Severity (SEV1 / SEV2 / SEV3)
- Incident commander (default: person who triggered this)
- Start time (run `date -u +"%Y-%m-%dT%H:%M:%SZ"` if bash available)

## Step 2: Generate the runbook file

Create `INCIDENT-<YYYYMMDD-HHMM>-<service>.md`:

```
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
```

## Step 3: Maintain the log

As the engineer reports updates, append rows to the Timeline table
and update the Hypothesis section. Keep the file as source of truth.

## Step 4: Stakeholder comms

When asked for a "status update", generate a concise Slack message
(no markdown tables, ≤5 sentences, plain text).

## Gotchas

- If bash is unavailable, ask for the current UTC time rather than guessing.
- SEV1 = customer-impacting, requires immediate escalation.
- SEV2 = degraded but not down; update every 30 min.
- SEV3 = minor / internal only; document but no live comms needed.
