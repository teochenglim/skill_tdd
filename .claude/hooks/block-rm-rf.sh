#!/usr/bin/env bash
# PreToolUse: Bash — blocks destructive rm commands targeting the repo root or above

COMMAND="${CLAUDE_TOOL_INPUT:-}"

if echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f?\s+/|rm\s+-[a-zA-Z]*f[a-zA-Z]*r?\s+/'; then
  echo "BLOCKED: rm -rf on root path is not allowed in this project" >&2
  exit 1
fi

if echo "$COMMAND" | grep -qE 'rm\s+.*\.\.\./|rm\s+.*\.\./\.\./'; then
  echo "BLOCKED: rm traversing above the project root is not allowed" >&2
  exit 1
fi

exit 0
