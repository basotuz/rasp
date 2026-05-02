from __future__ import annotations

from pathlib import Path

from serra_v2.core.config import load_settings
from serra_v2.db.connection import connect


def bootstrap_database() -> Path:
    settings = load_settings()
    # Keep the versioned SQL file in repo root as the single source of truth.
    schema_path = Path(__file__).resolve().parents[3] / "db" / "init_db_sqlite.sql"

    with connect(settings.database_path) as connection:
        connection.executescript(schema_path.read_text(encoding="utf-8"))

    return settings.database_path


if __name__ == "__main__":
    path = bootstrap_database()
    print(f"Database pronto: {path}")
