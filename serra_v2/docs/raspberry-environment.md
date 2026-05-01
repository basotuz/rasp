# Ambiente Raspberry

Questa nota descrive l'ambiente preparato sul Raspberry corrente per Serra v2.
Serve come riferimento operativo: il codice applicativo resta Python e usa
SQLite come database iniziale. La UI/API locale scelta per Serra v2 e' Flask.

## Host corrente

```text
Dispositivo: rasp3
SSH: baso@serra-v2
Hostname: serra-v2
OS: Debian GNU/Linux 13 (trixie)
Architettura: aarch64
Python: 3.13.5
```

Percorso progetto:

```bash
/home/baso/serra_v2
```

## Pacchetti installati

Pacchetti base:

```text
git
sqlite3
```

Stack web/database disponibile sul Raspberry:

```text
apache2
php
libapache2-mod-php
php-cli
php-mysql
mariadb-server
mariadb-client
```

Versioni verificate:

```text
Apache 2.4.66
PHP 8.4.16
MariaDB 11.8.6
```

Servizi systemd:

```text
apache2: enabled, active
mariadb: enabled, active
```

Apache ha una configurazione locale minima per evitare il warning sul nome host:

```text
/etc/apache2/conf-available/servername.conf
ServerName serra-v2
```

## Progetto Serra v2

Comandi verificati sul Raspberry:

```bash
cd /home/baso/serra_v2
./scripts/setup_venv.sh
./scripts/check.sh
./scripts/bootstrap_db.sh
./scripts/status.sh
```

Risultati attesi:

- test e Ruff senza errori;
- database SQLite locale in `data/serra_v2.sqlite3`;
- tabelle SQLite iniziali: `sensor_readings`, `events`, `actuator_commands`;
- stato applicativo stampato in JSON da `scripts/status.sh`.

## Test hardware presenti nel repository

Nel repository sono ora presenti anche script manuali di bring-up hardware:

- `scripts/python/test_dht22.py`
- `scripts/python/test_ds18b20.py`
- `scripts/python/test_soil_hum_d.py`
- `scripts/python/test_soil_hum_a.py`
- `scripts/ino/soil/soil.ino`

Informazioni osservate dai file:

- sensore suolo digitale letto direttamente dal Raspberry su `GPIO 25` (BCM);
- sensore suolo analogico letto da Arduino su `A0` e pubblicato via seriale USB;
- porta seriale usata nei test: `/dev/ttyACM0`;
- baud rate usato nei test: `9600`;
- DS18B20 letto tramite filesystem 1-Wire Linux (`/sys/bus/w1/devices/28-*`);
- DHT22 presente nei test lato Raspberry su `BCM GPIO22` (`pin fisico 15`).

## Decisione attuale

Apache, PHP e MariaDB sono installati e disponibili sul Raspberry, ma la base
applicativa scelta per Serra v2 e':

- Python per backend/logica serra;
- Flask per dashboard operativa locale ed endpoint HTTP;
- SQLite come database iniziale;
- pyserial per comunicazione Raspberry <-> Arduino.

Apache puo' restare un supporto operativo per virtualhost, pagina di cortesia o
reverse proxy davanti a Flask. PHP e MariaDB non sono dipendenze applicative
necessarie nella direzione corrente del progetto.
