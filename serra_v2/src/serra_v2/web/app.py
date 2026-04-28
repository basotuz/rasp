from __future__ import annotations

from flask import Flask, render_template

from serra_v2.api.routes import api_bp
from serra_v2.core.config import load_settings
from serra_v2.services.greenhouse import GreenhouseService


def create_app() -> Flask:
    app = Flask(__name__)
    app.register_blueprint(api_bp)

    @app.get("/")
    def dashboard():
        status = GreenhouseService(load_settings()).current_status()
        return render_template("dashboard.html", status=status)

    return app
