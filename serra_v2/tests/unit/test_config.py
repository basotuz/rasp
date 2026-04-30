from serra_v2.core.config import load_settings


def test_load_settings_defaults():
    settings = load_settings()

    assert settings.environment == "development"
    assert settings.serial_port == "/dev/ttyACM0"
    assert settings.mode == "AUTO"
