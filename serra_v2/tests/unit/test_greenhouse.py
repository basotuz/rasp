from serra_v2.core.config import Settings
from serra_v2.services.greenhouse import GreenhouseService


def test_current_status_uses_configured_mode(tmp_path):
    settings = Settings(
        environment="test",
        database_path=tmp_path / "serra.db",
        serial_port="/dev/null",
        serial_baudrate=9600,
        mode="MANUALE",
    )

    status = GreenhouseService(settings).current_status()

    assert status.mode == "MANUALE"
    assert status.roof_open is False
    assert status.pump_active is False
