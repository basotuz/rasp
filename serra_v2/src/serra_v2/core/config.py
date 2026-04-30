from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Settings:
    environment: str
    database_path: Path
    serial_port: str
    serial_baudrate: int
    mode: str


def load_settings() -> Settings:
    return Settings(
        environment=os.getenv("SERRA_ENV", "development"),
        database_path=Path(os.getenv("SERRA_DATABASE_PATH", "data/serra_v2.sqlite3")),
        serial_port=os.getenv("SERRA_SERIAL_PORT", "/dev/ttyACM0"),
        serial_baudrate=int(os.getenv("SERRA_SERIAL_BAUDRATE", "9600")),
        mode=os.getenv("SERRA_MODE", "AUTO"),
    )
