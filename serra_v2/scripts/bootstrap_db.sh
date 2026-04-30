#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DEFAULT_PYTHON="python3"
if [[ -x "$PROJECT_DIR/.venv/bin/python" ]]; then
  DEFAULT_PYTHON="$PROJECT_DIR/.venv/bin/python"
fi

PYTHON="${PYTHON:-$DEFAULT_PYTHON}"

PYTHONPATH="$PROJECT_DIR/src" "$PYTHON" -m serra_v2.db.bootstrap
