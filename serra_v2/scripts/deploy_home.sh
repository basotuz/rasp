#!/usr/bin/env bash
set -euo pipefail

# Installa la home statica provvisoria di Serra v2 nella document root Apache.
#
# Uso:
#   ./scripts/deploy_home.sh
#   SERRA_WEB_ROOT="/var/www/html" ./scripts/deploy_home.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOURCE_FILE="${PROJECT_DIR}/web/index.html"
WEB_ROOT="${SERRA_WEB_ROOT:-/var/www/html}"
TARGET_FILE="${WEB_ROOT}/index.html"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Errore: home statica non trovata: ${SOURCE_FILE}" >&2
  exit 1
fi

if [[ ! -d "$WEB_ROOT" ]]; then
  echo "Errore: document root Apache non trovata: ${WEB_ROOT}" >&2
  exit 1
fi

echo "Sorgente:     ${SOURCE_FILE}"
echo "Destinazione: ${TARGET_FILE}"

if [[ -w "$WEB_ROOT" ]]; then
  install -m 0644 "$SOURCE_FILE" "$TARGET_FILE"
else
  sudo install -m 0644 "$SOURCE_FILE" "$TARGET_FILE"
fi

echo "OK. Home installata."
