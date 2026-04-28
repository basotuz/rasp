from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class SerialConfig:
    port: str
    baudrate: int
    timeout_seconds: float = 2.0


class ArduinoSerialClient:
    """Placeholder adapter for the future Raspberry <-> Arduino serial protocol."""

    def __init__(self, config: SerialConfig) -> None:
        self.config = config

    def is_configured(self) -> bool:
        return bool(self.config.port and self.config.baudrate)
