#!/usr/bin/env bash
set -uo pipefail

# Ne s’exécuter que sur un vrai `git push` visant data_pass : le garde partagé
# lit la commande depuis le payload JSON sur stdin et sort si ce n’en est pas un.
# shellcheck source=datapass-push-guard.sh
source "$(dirname "${BASH_SOURCE[0]}")/datapass-push-guard.sh"

cd "$DATAPASS_PROJECT_DIR" || { echo "cucumber : impossible d’accéder à $DATAPASS_PROJECT_DIR" >&2; exit 2; }

if ! bundle exec cucumber >&2; then
  echo "✗ Cucumber e2e a échoué (le push est déjà parti — à corriger)." >&2
  exit 2
fi

echo "✓ Cucumber e2e OK." >&2
exit 0
