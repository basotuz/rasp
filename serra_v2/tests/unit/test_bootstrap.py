import sqlite3

from serra_v2.db.bootstrap import bootstrap_database


def test_bootstrap_database_creates_unified_schema(monkeypatch, tmp_path):
    database_path = tmp_path / "serra.db"
    monkeypatch.setenv("SERRA_DATABASE_PATH", str(database_path))

    created_path = bootstrap_database()

    assert created_path == database_path
    assert created_path.exists()

    with sqlite3.connect(created_path) as connection:
        table_names = {
            row[0]
            for row in connection.execute(
                "SELECT name FROM sqlite_master WHERE type = 'table'"
            ).fetchall()
        }

    assert {
        "sensors",
        "sensor_data",
        "devices",
        "device_state",
        "manual_commands",
        "event_log",
        "irrigation_log",
    }.issubset(table_names)
