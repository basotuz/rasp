#!/usr/bin/env bash
set -euo pipefail

# Installa la home statica provvisoria e il virtualhost Apache di Serra v2.
#
# Uso:
#   ./scripts/deploy_home.sh
#   SERRA_WEB_ROOT="/var/www/serra_v2" ./scripts/deploy_home.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOURCE_DIR="${PROJECT_DIR}/web"
APACHE_SITE_SOURCE="${PROJECT_DIR}/deploy/apache/serra_v2.conf"
WEB_ROOT="${SERRA_WEB_ROOT:-/var/www/serra_v2}"
APACHE_SITE_TARGET="/etc/apache2/sites-available/serra_v2.conf"

if [[ ! -f "${SOURCE_DIR}/index.html" ]]; then
  echo "Errore: home statica non trovata: ${SOURCE_DIR}/index.html" >&2
  exit 1
fi

if [[ ! -f "$APACHE_SITE_SOURCE" ]]; then
  echo "Errore: virtualhost Apache non trovato: ${APACHE_SITE_SOURCE}" >&2
  exit 1
fi

echo "Sorgente web:      ${SOURCE_DIR}"
echo "DocumentRoot:      ${WEB_ROOT}"
echo "VirtualHost source: ${APACHE_SITE_SOURCE}"

sudo install -d -m 0755 "$WEB_ROOT"
sudo install -m 0644 "${SOURCE_DIR}/index.html" "${WEB_ROOT}/index.html"
sudo install -m 0644 "$APACHE_SITE_SOURCE" "$APACHE_SITE_TARGET"

sudo a2dissite 000-default.conf >/dev/null
sudo a2ensite serra_v2.conf >/dev/null
sudo apache2ctl configtest
sudo systemctl reload apache2

echo "OK. Home e virtualhost Apache installati."
