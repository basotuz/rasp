#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

PYTHONPATH="$PROJECT_DIR/src" "${PYTHON:-python3}" -m pytest
PYTHONPATH="$PROJECT_DIR/src" "${PYTHON:-python3}" -m ruff check src tests
