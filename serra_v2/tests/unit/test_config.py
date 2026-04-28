from serra_v2.core.config import load_settings


def test_load_settings_defaults():
    settings = load_settings()

    assert settings.environment == "development"
    assert settings.host == "127.0.0.1"
    assert settings.port == 5000
