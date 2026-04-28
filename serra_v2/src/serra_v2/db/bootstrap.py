from __future__ import annotations

from pathlib import Path

from serra_v2.core.config import load_settings
from serra_v2.db.connection import connect


def bootstrap_database() -> Path:
    settings = load_settings()
    schema_path = Path(__file__).with_name("schema.sql")

    with connect(settings.database_path) as connection:
        connection.executescript(schema_path.read_text(encoding="utf-8"))

    return settings.database_path


if __name__ == "__main__":
    path = bootstrap_database()
    print(f"Database pronto: {path}")
