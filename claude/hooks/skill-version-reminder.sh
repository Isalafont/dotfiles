#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit) : rappelle de bumper version + changelog
# quand un fichier d'une skill versionnée est modifié.
# Skill versionnée = dossier ancêtre contenant à la fois
# CHANGELOG.md et .claude-plugin/plugin.json.

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0

base=$(basename "$file_path")
# Ne pas se déclencher sur les fichiers de versioning eux-mêmes (évite la boucle)
case "$base" in
  plugin.json|CHANGELOG.md) exit 0 ;;
esac

dir=$(dirname "$file_path")
skill_dir=""
while [ "$dir" != "/" ] && [ -n "$dir" ]; do
  if [ -f "$dir/CHANGELOG.md" ] && [ -f "$dir/.claude-plugin/plugin.json" ]; then
    skill_dir="$dir"
    break
  fi
  dir=$(dirname "$dir")
done

[ -z "$skill_dir" ] && exit 0

reminder="Tu viens de modifier une skill versionnée ($skill_dir). Avant de terminer, bumpe la version (patch par défaut : x.y.Z+1) dans $skill_dir/.claude-plugin/plugin.json ET ajoute une entrée correspondante en haut de $skill_dir/CHANGELOG.md, datée d'aujourd'hui, décrivant la modification."

jq -nc --arg ctx "$reminder" \
  '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $ctx}}'
