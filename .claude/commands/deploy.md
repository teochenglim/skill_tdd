Walk through the pre-deploy checklist for this project.

1. **Tests green?** Run `pytest -q` and confirm all pass.
2. **No uncommitted changes?** Run `git status` and confirm clean.
3. **Skill files valid?** Check each skills/*/SKILL.md has `name:` matching its folder name and no `< >` in frontmatter.
4. **CLAUDE.md in sync?** Confirm `Active skills` list matches actual folders in `skills/`.
5. **Session log present?** Check `.claude/session-log.md` exists.

Report each item as ✅ / ❌ with a one-line explanation.
Generate a summary suitable for a Slack deploy message.
