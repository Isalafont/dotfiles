#!/bin/bash

TODAY=$(date +%Y-%m-%d)
CURRENT_HOUR=$(date +%H)
DAILY_LOG="/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/$TODAY.md"
FLAG_FILE="/tmp/claude-evening-notified-$TODAY"

[ "$CURRENT_HOUR" -lt 16 ] && exit 0
[ -f "$FLAG_FILE" ] && exit 0
[ ! -f "$DAILY_LOG" ] && exit 0

if grep -q "À compléter en fin de journée via /evening" "$DAILY_LOG"; then
  touch "$FLAG_FILE"
  osascript -e 'display notification "Lance /evening pour clôturer ta journée 🌅" with title "DataPass — Daily Log" sound name "Ping"'
fi