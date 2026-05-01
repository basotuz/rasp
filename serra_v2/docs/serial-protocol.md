# Protocollo seriale Raspberry <-> Arduino

Questo file definisce il contratto tra Raspberry e Arduino.

Direzione architetturale target: JSON Lines, un messaggio JSON per riga.

## Stato attuale osservato nei file di test

Nei file presenti oggi nel repository esiste gia' un formato seriale semplice
usato per il sensore umidita' suolo analogico letto da Arduino:

Arduino -> Raspberry:

```text
soil=37;raw=812
```

Dettagli osservati:

- baud rate: `9600`
- device lato Raspberry: `/dev/ttyACM0`
- sketch sorgente: `scripts/ino/soil/soil.ino`
- lettore Python: `scripts/python/test_soil_hum_a.py`

Semantica attuale:

- `soil`: percentuale umidita' suolo calcolata con `map(..., secco=1023, bagnato=445, 0, 100)`
- `raw`: valore ADC grezzo letto da Arduino su `A0`

Questo formato e' utile per test e bring-up hardware, ma non e' ancora il
contratto definitivo dell'applicazione.

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

## Sensori attualmente provati fuori seriale

Non tutto passa gia' da Arduino:

- `scripts/python/test_dht22.py` prova il DHT22 direttamente dal Raspberry;
- `scripts/python/test_ds18b20.py` prova il DS18B20 tramite 1-Wire Linux;
- `scripts/python/test_soil_hum_d.py` prova l'uscita digitale del sensore suolo su `GPIO 25`.

Nota: il test DHT22 ora e' allineato a `board.D22`, cioe' `BCM GPIO22`
(`pin fisico 15`).
