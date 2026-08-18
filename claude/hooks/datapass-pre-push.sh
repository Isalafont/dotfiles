#!/usr/bin/env bash
set -uo pipefail

# Ne s’exécuter que sur un vrai `git push` visant data_pass : le garde partagé
# lit la commande depuis le payload JSON sur stdin et sort si ce n’en est pas un.
# shellcheck source=datapass-push-guard.sh
source "$(dirname "${BASH_SOURCE[0]}")/datapass-push-guard.sh"

cd "$DATAPASS_PROJECT_DIR" || {
  echo "pré-push : impossible d’accéder à $DATAPASS_PROJECT_DIR" >&2
  exit 2
}

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
