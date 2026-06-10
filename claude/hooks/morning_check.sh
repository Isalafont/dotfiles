#!/bin/bash

TODAY=$(date +%Y-%m-%d)
DAILY_LOG="/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/$TODAY.md"
FLAG_FILE="/tmp/claude-morning-reminded-$TODAY"

# Lire le prompt utilisateur depuis stdin
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('prompt', d.get('message', '')).lower())
except:
    print('')
" 2>/dev/null || echo "")

# Détecter une salutation
IS_GREETING=false
for word in bonjour bonsoir salut hey coucou hello; do
  if echo "$PROMPT" | grep -q "$word"; then
    IS_GREETING=true
    break
  fi
done
if echo "$PROMPT" | grep -q "quoi de neuf"; then
  IS_GREETING=true
fi

# Salutation + daily log absent → instruction forte de lancer /morning
if $IS_GREETING && [ ! -f "$DAILY_LOG" ]; then
  touch "$FLAG_FILE"
  printf '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": "INSTRUCTION AUTOMATIQUE : salutation détectée + daily log absent. Tu DOIS lancer la commande /morning immédiatement, avant toute autre réponse."}}\n'
  exit 0
fi

# Daily log absent + rappel pas encore affiché → rappel simple
if [ ! -f "$DAILY_LOG" ] && [ ! -f "$FLAG_FILE" ]; then
  touch "$FLAG_FILE"
  printf '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": "Rappel : le daily log du jour nexiste pas encore. Pense a lancer /morning pour demarrer la journee."}}\n'
fi