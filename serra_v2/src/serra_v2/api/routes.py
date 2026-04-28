from __future__ import annotations

from flask import Blueprint, jsonify

from serra_v2.core.config import load_settings
from serra_v2.services.greenhouse import GreenhouseService

api_bp = Blueprint("api", __name__, url_prefix="/api")


@api_bp.get("/health")
def health() -> tuple[dict[str, str], int]:
    return {"status": "ok", "service": "serra_v2"}, 200


@api_bp.get("/status")
def status():
    greenhouse_status = GreenhouseService(load_settings()).current_status()
    return jsonify(
        {
            "mode": greenhouse_status.mode,
            "air_temperature_c": greenhouse_status.air_temperature_c,
            "air_humidity_percent": greenhouse_status.air_humidity_percent,
            "soil_moisture_percent": greenhouse_status.soil_moisture_percent,
            "roof_open": greenhouse_status.roof_open,
            "pump_active": greenhouse_status.pump_active,
            "updated_at": greenhouse_status.updated_at.isoformat(),
        }
    )
