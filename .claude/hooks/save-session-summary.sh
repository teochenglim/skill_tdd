#!/usr/bin/env bash
# SessionEnd — appends a timestamped entry to .claude/session-log.md

LOG=".claude/session-log.md"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if [[ ! -f "$LOG" ]]; then
  echo "# Session Log" > "$LOG"
  echo "" >> "$LOG"
fi

echo "## $TIMESTAMP" >> "$LOG"
echo "" >> "$LOG"
echo "Session ended. Review \`git diff HEAD\` for changes made this session." >> "$LOG"
echo "" >> "$LOG"

exit 0
