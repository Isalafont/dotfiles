#!/usr/bin/env bash
# Garde partagé des hooks pré-push DataPass, à sourcer en début de script.
#
# Le matcher configuré est `Bash` (le champ `if` des hooks n’est pas honoré) :
# le hook est donc appelé sur *chaque* commande Bash. Sans ce garde, un simple
# `git status` déclencherait toute la suite de tests.
#
# Sort silencieusement (code 0) si la commande interceptée n’est pas un
# `git push` visant data_pass. Sinon, définit DATAPASS_PROJECT_DIR.

# Repère un `git … push` dans une commande, éventuellement chaînée, et renvoie
# le chemin passé à `git -C` s’il y en a un. Ignore `grep push`, `echo "git
# push"` ou `git log --grep=push` : seul un segment dont la sous-commande est
# `push` compte.
datapass_extract_push_dir() {
  local segment token pending dir
  local -a tokens

  while IFS= read -r segment; do
    read -ra tokens <<< "$segment"
    [[ "${tokens[0]:-}" == 'git' ]] || continue

    dir=''
    pending=''
    for token in "${tokens[@]:1}"; do
      if [[ -n "$pending" ]]; then
        [[ "$pending" == 'dir' ]] && dir="$token"
        pending=''
        continue
      fi

      case "$token" in
        -C) pending='dir' ;;
        -c | --git-dir | --work-tree | --namespace) pending='skip' ;;
        -*) ;;
        push)
          printf '%s' "$dir"
          return 0
          ;;
        *) break ;;
      esac
    done
  done < <(printf '%s\n' "$1" | tr ';|&' '\n')

  return 1
}

# Le PATH d’un hook est minimal : privilégier le jq du système, présent sur macOS.
datapass_jq='/usr/bin/jq'
[[ -x "$datapass_jq" ]] || datapass_jq="$(command -v jq || true)"
[[ -n "$datapass_jq" ]] || exit 0

datapass_push_payload="$(cat 2>/dev/null || true)"
datapass_push_command="$(printf '%s' "$datapass_push_payload" | "$datapass_jq" -r '.tool_input.command // empty' 2>/dev/null || true)"
[[ -n "$datapass_push_command" ]] || exit 0

datapass_push_dir="$(datapass_extract_push_dir "$datapass_push_command")" || exit 0

DATAPASS_PROJECT_DIR="${datapass_push_dir:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"

datapass_push_origin="$(git -C "$DATAPASS_PROJECT_DIR" remote get-url origin 2>/dev/null || true)"
case "$datapass_push_origin" in
  *etalab/data_pass*) : ;;
  *) exit 0 ;;
esac
