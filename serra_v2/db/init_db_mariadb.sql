-- =========================
-- SENSORS
-- =========================
CREATE TABLE IF NOT EXISTS sensors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT,
    type TEXT,
    unit TEXT,
    location TEXT
);

-- =========================
-- SENSOR DATA
-- =========================
CREATE TABLE IF NOT EXISTS sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INTEGER,
    value REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- DEVICES
-- =========================
CREATE TABLE IF NOT EXISTS devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT,
    type TEXT,
    pin INTEGER,
    location TEXT
);

-- =========================
-- DEVICE STATE
-- =========================
CREATE TABLE IF NOT EXISTS device_state (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INTEGER,
    state INTEGER,
    mode TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- MANUAL COMMANDS
-- =========================
CREATE TABLE IF NOT EXISTS manual_commands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    command TEXT,
    target TEXT,
    value TEXT,
    executed INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- EVENT LOG
-- =========================
CREATE TABLE IF NOT EXISTS event_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type TEXT,
    message TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- IRRIGATION LOG
-- =========================
CREATE TABLE IF NOT EXISTS irrigation_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    duration INTEGER,
    trigger_type TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- SAMPLE DATA
-- =========================

-- sensors
INSERT INTO sensors (name, type, unit, location) VALUES
('temp_inside', 'temperature', 'C', 'inside'),
('humidity_inside', 'humidity', '%', 'inside'),
('soil_1', 'soil_moisture', '%', 'basilico'),
('light', 'light', 'lux', 'inside');

-- devices
INSERT INTO devices (name, type, pin, location) VALUES
('pump', 'irrigation', 17, 'inside'),
('roof', 'servo', 18, 'top'),
('light', 'relay', 27, 'inside');

-- sensor_data
INSERT INTO sensor_data (sensor_id, value) VALUES
(1, 24.5),
(2, 60),
(3, 35),
(4, 1200);

-- device_state
INSERT INTO device_state (device_id, state, mode) VALUES
(1, 0, 'AUTO'),
(2, 0, 'AUTO'),
(3, 1, 'MANUAL');

-- event_log
INSERT INTO event_log (type, message) VALUES
('INFO', 'Sistema avviato'),
('INFO', 'Sensori inizializzati');
