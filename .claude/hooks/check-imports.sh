#!/usr/bin/env bash
# PostToolUse: Write|Edit — warns if a Python file imports a module not in requirements.txt

FILE_PATH="${CLAUDE_TOOL_RESULT_FILE_PATH:-}"

# Only check Python files
[[ "$FILE_PATH" != *.py ]] && exit 0
[[ ! -f "$FILE_PATH" ]] && exit 0
[[ ! -f "requirements.txt" ]] && exit 0

UNKNOWN=()
while IFS= read -r module; do
  # Strip submodule (e.g. "from os.path" → "os")
  base="${module%%.*}"
  # Skip stdlib-ish single-word builtins that are never in requirements.txt
  if ! grep -qi "^${base}" requirements.txt 2>/dev/null; then
    # Only flag third-party-looking imports (not single chars, not __future__)
    if [[ ${#base} -gt 2 && "$base" != "__"* ]]; then
      UNKNOWN+=("$base")
    fi
  fi
done < <(grep -E '^(import|from)\s+[a-zA-Z]' "$FILE_PATH" | sed -E 's/^(import|from)\s+([a-zA-Z_][a-zA-Z0-9_]*).*/\2/')

if [[ ${#UNKNOWN[@]} -gt 0 ]]; then
  echo "WARNING: imports not found in requirements.txt: ${UNKNOWN[*]}" >&2
  echo "  → Verify these are not hallucinated package names before running." >&2
fi

exit 0
