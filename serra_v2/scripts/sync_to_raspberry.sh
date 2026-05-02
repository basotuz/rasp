#!/usr/bin/env bash
set -euo pipefail

# Sincronizza il progetto locale serra_v2 con la cartella sul Raspberry.
#
# Requisiti: rsync + ssh configurati sul PC.
#
# Uso:
#   ./scripts/sync_to_raspberry.sh
#   ./scripts/sync_to_raspberry.sh --delete
#   SERRA_RASP_HOST="baso@serra-v2" SERRA_RASP_PATH="/home/baso/.../serra_v2" ./scripts/sync_to_raspberry.sh
#
# Note:
# - Di default NON usa --delete (evita di cancellare file sul Raspberry).
# - Esclude ambienti virtuali e file runtime (data/, logs/, cache, ecc.).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"  # .../rasp/serra_v2

RASP_HOST="${SERRA_RASP_HOST:-baso@serra-v2}"
RASP_PATH="${SERRA_RASP_PATH:-/home/baso/serra_v2}"

DELETE_MODE="false"
if [[ ${1:-} == "--delete" ]]; then
  DELETE_MODE="true"
  shift
fi

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  cat <<EOF
Uso:
  ./scripts/sync_to_raspberry.sh [--delete]

Env:
  SERRA_RASP_HOST  (default: baso@serra-v2)
  SERRA_RASP_PATH  (default: /home/baso/serra_v2)

Esempi:
  ./scripts/sync_to_raspberry.sh
  ./scripts/sync_to_raspberry.sh --delete
  SERRA_RASP_HOST="baso@serra-v2" ./scripts/sync_to_raspberry.sh
EOF
  exit 0
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "Errore: rsync non trovato (installalo sul PC)." >&2
  exit 1
fi

if ! command -v ssh >/dev/null 2>&1; then
  echo "Errore: ssh non trovato." >&2
  exit 1
fi

RSYNC_ARGS=(
  -avz
  --checksum
  --itemize-changes
  --human-readable
  --stats
  --exclude ".venv/"
  --exclude "__pycache__/"
  --exclude "**/__pycache__/"
  --exclude ".pytest_cache/"
  --exclude ".ruff_cache/"
  --exclude ".mypy_cache/"
  --exclude "*.pyc"
  --exclude "*.pyo"
  # I database runtime restano locali alla macchina che li genera.
  --exclude "*.db"
  --exclude "*.sqlite"
  --exclude "*.sqlite3"
  --exclude "data/"
  --exclude "logs/"
  --exclude ".env"
  --exclude ".env.*"
  --exclude "dist/"
  --exclude "build/"
  --exclude "*.egg-info/"
)

if [[ "$DELETE_MODE" == "true" ]]; then
  RSYNC_ARGS+=(--delete)
fi

echo "Local project:  ${PROJECT_DIR}"
echo "Raspberry host: ${RASP_HOST}"
echo "Remote path:    ${RASP_PATH}"
if [[ "$DELETE_MODE" == "true" ]]; then
  echo "Modalita':      --delete (ATTENZIONE: puo' cancellare file sul Raspberry)"
else
  echo "Modalita':      senza --delete (sicura)"
fi

echo

echo "Creo la cartella remota (se non esiste)..."
ssh "$RASP_HOST" "mkdir -p '$RASP_PATH'"

echo "Sync in corso..."
# Nota: trailing slash su PROJECT_DIR per sincronizzare il contenuto dentro la cartella.
rsync "${RSYNC_ARGS[@]}" -e ssh "${PROJECT_DIR}/" "${RASP_HOST}:${RASP_PATH}/"

echo

echo "OK. Suggerimento: sul Raspberry puoi verificare con:"
cat <<EOF
  cd "$RASP_PATH"
  ./scripts/check.sh
  ./scripts/status.sh
EOF
