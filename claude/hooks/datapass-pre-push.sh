#!/usr/bin/env bash
set -uo pipefail

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"

origin="$(git -C "$project_dir" remote get-url origin 2>/dev/null || true)"
case "$origin" in
  *etalab/data_pass*) : ;;
  *) exit 0 ;;
esac

cd "$project_dir" || { echo "pré-push : impossible d’accéder à $project_dir" >&2; exit 2; }

run_step() {
  step_label="$1"; shift
  echo "▶ $step_label" >&2
  if ! "$@" >&2; then
    echo "✗ Échec : $step_label — push bloqué." >&2
    exit 2
  fi
}

run_step "rubocop"    bundle exec rubocop
run_step "rspec"      bundle exec rspec
run_step "standardjs" standard app/javascript

echo "✓ Vérifications pré-push (rubocop, rspec, standardjs) OK." >&2
exit 0
