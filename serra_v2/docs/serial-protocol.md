# Protocollo seriale Raspberry <-> Arduino

Questo file definira' il contratto tra Raspberry e Arduino.

Formato iniziale consigliato: JSON Lines, un messaggio per riga.

## Esempi futuri

Arduino -> Raspberry:

```json
{"type":"sensor_reading","air_temperature_c":24.6,"air_humidity_percent":58,"soil_moisture_percent":42}
```

Raspberry -> Arduino:

```json
{"type":"command","target":"pump","action":"on","duration_seconds":5}
```

Lo schema definitivo verra' introdotto quando inizieremo il firmware e il backend seriale.
