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

## Cartelle osservate sul Raspberry

Oltre alla struttura versionata del repository, sul Raspberry sono attualmente
presenti anche alcune cartelle/file runtime o locali non ancora allineati al PC:

- `.env`
- `db/init_db_sqlite.sql`
- `db/serra.db`
- `src/serra_v2/api/` (cartella presente, al momento senza file osservati)
- `src/serra_v2/web/templates/`
- `src/serra_v2/web/static/css/`
- `src/serra_v2/web/static/js/`

Questi elementi descrivono lo stato reale della macchina, ma non tutti sono
attualmente versionati nel repository locale.

## Database osservati sul Raspberry

Sul Raspberry sono stati osservati due percorsi SQLite distinti:

- `data/serra_v2.sqlite3`: database creato dal bootstrap Python gia' presente nel progetto;
- `db/serra.db`: database SQLite aggiunto manualmente insieme a `db/init_db_sqlite.sql`.

Lo script `db/init_db_sqlite.sql` definisce queste tabelle:

- `sensors`
- `sensor_data`
- `devices`
- `device_state`
- `manual_commands`
- `event_log`
- `irrigation_log`

Nel file reale `db/serra.db` risultano invece presenti:

- `sensors` con 4 righe
- `sensor_data` con 4 righe
- `devices` con 3 righe
- `device_state` con 3 righe
- `manual_commands` con 0 righe
- `event_log` con 2 righe
- `irrigation_log` con 0 righe
- `test` con 0 righe

Nota: la tabella `test` compare nel database reale ma non nello script
`init_db_sqlite.sql`, quindi il file SQLite sul Raspberry non e' perfettamente
allineato allo script di init osservato.

Inoltre il repository locale contiene `db/init_db_mariadb.sql`, concettualmente
simile ma non identico allo script SQLite: la differenza piu' evidente emersa
ora e' `trigger_type` nel draft MariaDB contro `trigger` nello script SQLite.

Decisione di naming: il database applicativo dovra' chiamarsi `serra`
(`serra.db` nel caso SQLite), per evitare rinomini futuri in una possibile V3.
Il cambio di percorso/runtime non e' ancora stato reso operativo nel codice
perche' oggi esistono ancora due schemi diversi da unificare.

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

Resta pero' da consolidare quale percorso SQLite sia quello applicativo ufficiale
tra `data/serra_v2.sqlite3` e `db/serra.db`.
