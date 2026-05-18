#!/bin/bash
# SessionStart hook — détecte un ticket Linear depuis le nom de la branche
# courante et injecte un additionalContext invitant Claude à charger le
# ticket via le MCP Linear si pertinent.

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

REMOTE=$(git remote get-url origin 2>/dev/null)
case "$REMOTE" in
  *etalab/data_pass*) ;;
  *) exit 0 ;;
esac

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

TICKET=$(echo "$BRANCH" | grep -oiE '(dp|api)-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
[ -z "$TICKET" ] && exit 0

CTX="Branche courante : \`$BRANCH\` → ticket Linear détecté : **$TICKET**. Si la conversation porte sur cette feature, charge le ticket via \`mcp__linear-server__get_issue\` pour avoir le contexte (acceptance criteria, comments). Sinon, ignore."

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' "$(printf '%s' "$CTX" | python3 -c 'import sys, json; print(json.dumps(sys.stdin.read()))')"
