#!/usr/bin/env bash
# Enregistre le MCP tidewave sur le port du serveur Rails qu'on vient de lancer.
# Déclenché en PostToolUse/Bash. Ne fait rien sauf si :
#   - la commande lance un serveur Rails (make up / bin/local_run.sh)
#   - le projet courant utilise la gem tidewave
# Le port est lu dans .env.local (défaut 3000), ce qui couvre les worktrees.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)

printf '%s' "$cmd" | grep -qE 'make[[:space:]]+up|local_run\.sh' || exit 0

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
grep -q "gem 'tidewave'" "$project_dir/Gemfile" 2>/dev/null || exit 0

port=$(grep -E '^PORT=' "$project_dir/.env.local" 2>/dev/null | head -1 | cut -d= -f2 | tr -d '[:space:]')
port=${port:-3000}

url="http://localhost:${port}/tidewave/mcp"
claude mcp remove tidewave --scope local >/dev/null 2>&1
if claude mcp add tidewave --scope local --transport http "$url" >/dev/null 2>&1; then
  printf '{"systemMessage": "MCP tidewave enregistré sur le port %s (redémarrer Claude Code pour l’activer)."}\n' "$port"
fi
exit 0
