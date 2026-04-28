from __future__ import annotations

from datetime import datetime

from serra_v2.core.config import Settings
from serra_v2.core.models import GreenhouseStatus


class GreenhouseService:
    def __init__(self, settings: Settings) -> None:
        self.settings = settings

    def current_status(self) -> GreenhouseStatus:
        return GreenhouseStatus(
            mode=self.settings.mode,
            air_temperature_c=None,
            air_humidity_percent=None,
            soil_moisture_percent=None,
            roof_open=False,
            pump_active=False,
            updated_at=datetime.now(),
        )
