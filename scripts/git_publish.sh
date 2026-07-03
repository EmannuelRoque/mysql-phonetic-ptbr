#!/usr/bin/env bash
set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
  printf 'git nao encontrado no PATH.\n' >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  printf 'Uso: %s "mensagem do commit"\n' "$0" >&2
  exit 1
fi

commit_message="$1"
remote_name="${REMOTE_NAME:-origin}"
current_branch="$(git branch --show-current)"

if [ -z "$current_branch" ]; then
  printf 'Nao foi possivel identificar a branch atual.\n' >&2
  exit 1
fi

printf 'Status atual:\n'
git status --short --branch

if ! git remote get-url "$remote_name" >/dev/null 2>&1; then
  printf 'Remoto %s nao encontrado.\n' "$remote_name" >&2
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  printf 'Nenhuma alteracao local para commit. Fazendo push da branch atual.\n'
else
  printf 'Criando commit: %s\n' "$commit_message"
  git add .
  git commit -m "$commit_message"
fi

printf 'Enviando %s para %s\n' "$current_branch" "$remote_name"
git push -u "$remote_name" "$current_branch"

printf 'Concluido.\n'
