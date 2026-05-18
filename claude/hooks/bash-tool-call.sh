#!/bin/bash
# PreToolUse hook for Bash tool.
# Reads JSON from stdin, returns a permission decision via stdout JSON.
#
# Strategy:
# - Auto-approve safe, read-only or scoped routine commands (no surface for harm).
# - Stay neutral on everything else, letting settings.json permission rules decide.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

[ -z "$COMMAND" ] && exit 0

ALLOW_PATTERNS=(
  "daily-log (log (init|show|append)|weekly (init|show)|stats)"
  "routine (morning|evening|weekly)"
  "calendar-helper.sh (today|week)"
  "linear issue list"
  "monthly-reminders.sh"
  "collect-daily-actions"
)

for pattern in "${ALLOW_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Auto-approved safe routine command"}}\n'
    exit 0
  fi
done

exit 0
