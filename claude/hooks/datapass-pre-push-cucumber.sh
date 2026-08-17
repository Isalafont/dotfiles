#!/usr/bin/env bash
set -uo pipefail

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"

origin="$(git -C "$project_dir" remote get-url origin 2>/dev/null || true)"
case "$origin" in
  *etalab/data_pass*) : ;;
  *) exit 0 ;;
esac

cd "$project_dir" || { echo "cucumber : impossible d’accéder à $project_dir" >&2; exit 2; }

if ! bundle exec cucumber >&2; then
  echo "✗ Cucumber e2e a échoué (le push est déjà parti — à corriger)." >&2
  exit 2
fi

echo "✓ Cucumber e2e OK." >&2
exit 0
