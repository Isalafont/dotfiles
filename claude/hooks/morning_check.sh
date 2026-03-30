#!/bin/bash

TODAY=$(date +%Y-%m-%d)
DAILY_LOG="/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/$TODAY.md"
FLAG_FILE="/tmp/claude-morning-reminded-$TODAY"

[ -f "$FLAG_FILE" ] && exit 0
[ -f "$DAILY_LOG" ] && exit 0

touch "$FLAG_FILE"
echo '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": "Rappel : le daily log du jour nexiste pas encore. Pense a lancer /morning pour demarrer la journee."}}'