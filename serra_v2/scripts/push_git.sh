#!/usr/bin/env bash
set -euo pipefail

# Evita che git apra un pager (less) e richieda 'q' / spazio.
export GIT_PAGER=cat
export LESS="${LESS:--FRSX}"

# push_git.sh
#
# Nota: puoi lanciarlo sia da:
#   - rasp/serra_v2            -> ./scripts/push_git.sh "..."
#   - rasp (repo root)         -> ./serra_v2/scripts/push_git.sh "..."
#
# Helper per fare commit+push delle ultime modifiche del progetto serra_v2
# (che vive dentro il repository principale "rasp/").
#
# Cosa fa:
#  - (opzionale) esegue ./serra_v2/scripts/check.sh
#  - aggiunge in stage SOLO la cartella serra_v2/
#  - fa commit con il messaggio fornito
#  - pusha il branch corrente su origin

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"            # .../rasp/serra_v2
REPO_ROOT="$(cd "${PROJECT_DIR}/.." && pwd)"             # .../rasp
PROJECT_SUBDIR="$(basename "${PROJECT_DIR}")"            # serra_v2

usage() {
  cat <<'EOF'
Uso:
  ./scripts/push_git.sh [--skip-check] "tipo: messaggio"

Esempi:
  ./scripts/push_git.sh "chore: aggiorna documentazione"
  ./scripts/push_git.sh "fix: corregge script bootstrap"

Opzioni:
  --skip-check   Salta ./serra_v2/scripts/check.sh
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

SKIP_CHECK="false"
if [[ ${1:-} == "--skip-check" ]]; then
  SKIP_CHECK="true"
  shift
fi

COMMIT_MSG="${1:-}"
if [[ -z "$COMMIT_MSG" ]]; then
  echo "Errore: manca il messaggio di commit." >&2
  echo >&2
  usage >&2
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Errore: git non trovato nel PATH." >&2
  exit 1
fi

if [[ ! -d "${REPO_ROOT}/.git" ]]; then
  echo "Errore: repository git non trovato in: ${REPO_ROOT}" >&2
  exit 1
fi

BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "HEAD" ]]; then
  echo "Errore: sei in detached HEAD. Passa a un branch prima di pushare." >&2
  exit 1
fi

echo "Repo root:      ${REPO_ROOT}"
echo "Project folder: ${PROJECT_SUBDIR}/"
echo "Branch:         ${BRANCH}"
echo

if [[ "$SKIP_CHECK" != "true" ]]; then
  if [[ -x "${PROJECT_DIR}/scripts/check.sh" ]]; then
    echo "Eseguo check: ${PROJECT_SUBDIR}/scripts/check.sh"
    "${PROJECT_DIR}/scripts/check.sh"
    echo
  else
    echo "Nota: ${PROJECT_SUBDIR}/scripts/check.sh non trovato/eseguibile; salto i controlli."
    echo
  fi
fi

echo "Stato git (prima):"
git -C "$REPO_ROOT" status

echo

echo "Remote:"
git -C "$REPO_ROOT" remote -v

echo

echo "Aggiungo in stage SOLO: ${PROJECT_SUBDIR}/"
git -C "$REPO_ROOT" add "$PROJECT_SUBDIR"

if git -C "$REPO_ROOT" diff --cached --quiet; then
  echo "Nessuna modifica da committare in ${PROJECT_SUBDIR}/. Esco."
  exit 0
fi

echo

echo "Diff staged:"
git -C "$REPO_ROOT" --no-pager diff --cached

echo

echo "Commit: $COMMIT_MSG"
git -C "$REPO_ROOT" commit -m "$COMMIT_MSG"

echo

echo "Push su origin ${BRANCH}..."
if git -C "$REPO_ROOT" rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
  git -C "$REPO_ROOT" push
else
  git -C "$REPO_ROOT" push -u origin "$BRANCH"
fi

echo

echo "OK. Ultimi commit:"
git -C "$REPO_ROOT" --no-pager log -5 --oneline
