from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime


@dataclass(frozen=True)
class GreenhouseStatus:
    mode: str
    air_temperature_c: float | None
    air_humidity_percent: float | None
    soil_moisture_percent: float | None
    roof_open: bool
    pump_active: bool
    updated_at: datetime
