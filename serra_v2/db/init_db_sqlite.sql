-- Source of truth per lo schema SQLite applicativo.
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS sensors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    unit TEXT NOT NULL,
    location TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sensor_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id INTEGER NOT NULL,
    value REAL NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES sensors(id)
);

CREATE TABLE IF NOT EXISTS devices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    pin INTEGER,
    location TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS device_state (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_id INTEGER NOT NULL,
    state INTEGER NOT NULL,
    mode TEXT NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (device_id) REFERENCES devices(id)
);

CREATE TABLE IF NOT EXISTS manual_commands (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    command TEXT NOT NULL,
    target TEXT NOT NULL,
    value TEXT,
    executed INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS event_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    message TEXT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS irrigation_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    duration INTEGER NOT NULL,
    trigger TEXT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_sensor_data_sensor_id
    ON sensor_data(sensor_id);

CREATE INDEX IF NOT EXISTS idx_sensor_data_timestamp
    ON sensor_data(timestamp);

CREATE INDEX IF NOT EXISTS idx_device_state_device_id
    ON device_state(device_id);

CREATE INDEX IF NOT EXISTS idx_device_state_updated_at
    ON device_state(updated_at);

CREATE INDEX IF NOT EXISTS idx_manual_commands_created_at
    ON manual_commands(created_at);

CREATE INDEX IF NOT EXISTS idx_event_log_timestamp
    ON event_log(timestamp);

CREATE INDEX IF NOT EXISTS idx_irrigation_log_timestamp
    ON irrigation_log(timestamp);
