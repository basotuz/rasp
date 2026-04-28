#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

export PYTHONPATH="$PROJECT_DIR/src"
export FLASK_APP="serra_v2.web.app:create_app"
export FLASK_ENV="${FLASK_ENV:-development}"

"${PYTHON:-python3}" -m flask run \
  --host "${SERRA_HOST:-127.0.0.1}" \
  --port "${SERRA_PORT:-5000}" \
  --debug
