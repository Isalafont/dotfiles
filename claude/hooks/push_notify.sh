#!/bin/bash
# Pousse une notification vers le téléphone via ntfy.
#   start   → mémorise le début du tour (UserPromptSubmit)
#   waiting → Claude attend une réponse (Notification)
#   done    → tour terminé, seulement s'il a duré plus que le seuil (Stop)
# Silencieux tant que ~/.claude/ntfy-topic n'existe pas.

MODE="${1:-waiting}"
TOPIC_FILE="$HOME/.claude/ntfy-topic"
SEUIL_SECONDES="${CLAUDE_PUSH_SEUIL:-180}"

INPUT=$(cat)
SESSION=$(echo "$INPUT" | jq -r '.session_id // "inconnue"' 2>/dev/null)
CWD=$(echo "$INPUT" | jq -r '.cwd // ""' 2>/dev/null)
MESSAGE=$(echo "$INPUT" | jq -r '.message // ""' 2>/dev/null)
PROJET=$(basename "${CWD:-$PWD}")
HORODATAGE="/tmp/claude-push-${SESSION}"

if [ "$MODE" = "start" ]; then
  date +%s > "$HORODATAGE"
  exit 0
fi

[ -r "$TOPIC_FILE" ] || exit 0
TOPIC=$(tr -d '[:space:]' < "$TOPIC_FILE")
[ -n "$TOPIC" ] || exit 0

case "$MODE" in
  waiting)
    TITRE="$PROJET — Claude attend"
    CORPS="${MESSAGE:-Une réponse est nécessaire pour continuer.}"
    PRIORITE=4
    ;;
  done)
    [ -f "$HORODATAGE" ] || exit 0
    DEBUT=$(cat "$HORODATAGE")
    rm -f "$HORODATAGE"
    DUREE=$(( $(date +%s) - DEBUT ))
    [ "$DUREE" -lt "$SEUIL_SECONDES" ] && exit 0
    TITRE="$PROJET — terminé"
    CORPS="Tour terminé après $(( DUREE / 60 )) min."
    PRIORITE=3
    ;;
  *)
    exit 0
    ;;
esac

CHARGE=$(jq -nc \
  --arg topic "$TOPIC" \
  --arg title "$TITRE" \
  --arg message "$CORPS" \
  --argjson priority "$PRIORITE" \
  '{topic: $topic, title: $title, message: $message, priority: $priority, tags: ["robot"]}')

curl -s -m 5 -H "Content-Type: application/json" -d "$CHARGE" https://ntfy.sh >/dev/null 2>&1

exit 0
