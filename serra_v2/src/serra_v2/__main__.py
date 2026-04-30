from __future__ import annotations

import json

from serra_v2.core.config import load_settings
from serra_v2.services.greenhouse import GreenhouseService


def main() -> None:
    status = GreenhouseService(load_settings()).current_status()
    print(
        json.dumps(
            {
                "mode": status.mode,
                "air_temperature_c": status.air_temperature_c,
                "air_humidity_percent": status.air_humidity_percent,
                "soil_moisture_percent": status.soil_moisture_percent,
                "roof_open": status.roof_open,
                "pump_active": status.pump_active,
                "updated_at": status.updated_at.isoformat(),
            },
            indent=2,
        )
    )

if __name__ == "__main__":
    main()
