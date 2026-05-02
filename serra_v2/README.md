# Serra v2

Serra v2 e' una piattaforma Python + Raspberry Pi + Arduino per una mini serra smart.
Il progetto nasce con una base piccola, ma organizzata per crescere senza diventare caotico.

## Obiettivi

- Monitoraggio temperatura e umidita' aria
- Monitoraggio umidita' terreno
- Irrigazione automatica
- Apertura e chiusura tetto
- Dashboard operativa web basata su Flask
- Modalita' AUTO e MANUALE
- Log eventi
- Predisposizione notifiche Telegram
- Predisposizione fertilizzazione futura
- Predisposizione integrazione Home Assistant / MQTT

## Stack

- Raspberry Pi come master
- Arduino come slave
- Python backend
- Flask per UI/API locali
- SQLite come database iniziale
- Comunicazione seriale USB Raspberry <-> Arduino
- Apache, PHP e MariaDB installati sul Raspberry come servizi disponibili

La direzione applicativa scelta e' Python + Flask + SQLite. Apache/PHP/MariaDB
restano servizi disponibili sul Raspberry, ma Flask e' lo stack deciso per la
dashboard operativa e per i futuri endpoint HTTP locali.

## Struttura

```text
serra_v2/
  arduino/                 Firmware Arduino
  config/                  Configurazioni versionate di esempio
  data/                    Database locali e file runtime ignorati da Git
  db/                      Script SQL e materiali schema database
  docs/                    Documentazione tecnica e workflow
  logs/                    Log runtime ignorati da Git
  deploy/                  File di deploy versionati
  scripts/                 Script di setup, avvio, manutenzione e test hardware
    python/                Prove sensori lato Raspberry
    ino/                   Sketch Arduino di test
  src/serra_v2/            Codice Python applicativo
  tests/                   Test unitari e di integrazione
  web/                     Home statica provvisoria
```

## Sensori e test hardware osservati

Nei file attuali del progetto risultano gia' presenti prove hardware mirate:

- `scripts/python/test_dht22.py`: test DHT22 lato Raspberry con libreria `adafruit_dht`.
- `scripts/python/test_ds18b20.py`: test DS18B20 via interfaccia 1-Wire Linux (`/sys/bus/w1/devices/28-*`).
- `scripts/python/test_soil_hum_d.py`: test uscita digitale del sensore umidita' suolo su `GPIO 25` in modalita' BCM.
- `scripts/python/test_soil_hum_a.py`: lettura seriale da Arduino su `/dev/ttyACM0` a `9600` baud.
- `scripts/ino/soil/soil.ino`: sketch Arduino che legge il sensore suolo analogico su `A0` e invia via seriale `soil=<percentuale>;raw=<valore>`.

Nota importante: il test DHT22 e' stato riallineato a `board.D22`, cioe' `BCM GPIO22`
(`pin fisico 15`).

## Database osservati

Nel repository locale e' ora presente anche:

- `db/init_db_sqlite.sql`: schema SQLite applicativo ufficiale.
- `db/init_db_mariadb.sql`: variante MariaDB dello stesso schema applicativo.

Sul Raspberry corrente sono stati osservati anche questi artefatti runtime:

- `db/serra.db`: database SQLite reale;
- `data/serra_v2.sqlite3`: database legacy creato dal bootstrap Python della fase iniziale.

Nel database `db/serra.db` sul Raspberry risultano attualmente queste tabelle:

- `sensors` (4 righe)
- `sensor_data` (4 righe)
- `devices` (3 righe)
- `device_state` (3 righe)
- `manual_commands` (0 righe)
- `event_log` (2 righe)
- `irrigation_log` (0 righe)

Decisione presa: il nome target del database applicativo deve essere `serra`
(quindi `serra.db` in ambiente SQLite), cosi' il nome resta stabile anche nelle
evoluzioni future del progetto.

Lo schema applicativo e' stato unificato sul modello:

- `sensors`
- `sensor_data`
- `devices`
- `device_state`
- `manual_commands`
- `event_log`
- `irrigation_log`

## Avvio rapido sviluppo (PC)

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
```

## Avvio rapido su Raspberry

Percorso runtime sul Raspberry:

```bash
cd /home/baso/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
```

`scripts/status.sh` stampa lo stato applicativo iniziale in JSON. La scelta
dello stack UI/API e' stata fatta: useremo Flask, mantenendo separati dominio,
database e integrazione hardware. Il bootstrap applicativo ora punta a `db/serra.db`
usando come source of truth `db/init_db_sqlite.sql`.

## Workflow Git

La strategia consigliata e' descritta in [docs/git-workflow.md](docs/git-workflow.md).
In breve: `main` sempre stabile, branch brevi per feature/fix, commit piccoli e descrittivi.

## Roadmap

I prossimi step operativi sono raccolti in [TODO.md](TODO.md).
Le priorita' attuali sono implementare la base Flask per dashboard touch/tablet
e aggiungere notifiche Telegram, dopo avere stabilizzato stato applicativo,
database, eventi e hardware.

## Ambiente Raspberry

L'ambiente preparato sul Raspberry corrente (`rasp3`, accesso `ssh baso@serra-v2`) e' documentato in
[docs/raspberry-environment.md](docs/raspberry-environment.md).

## Sync PC -> Raspberry

Per sincronizzare il codice dal PC al Raspberry (senza copiare `.venv/`, database runtime, `data/`, `logs/`):

```bash
./scripts/sync_to_raspberry.sh
```

Nota: la sync del progetto non copia i file database runtime (`*.db`, `*.sqlite`,
`*.sqlite3`), quindi `db/serra.db` e gli eventuali database legacy restano locali
alla macchina su cui vengono generati.

Per allineare anche cancellando file sul Raspberry (attenzione):

```bash
./scripts/sync_to_raspberry.sh --delete
```

## Home provvisoria Apache

La pagina statica "Serra in costruzione" e' versionata in:

```text
web/index.html
```

Il virtualhost Apache dedicato e' versionato in:

```text
deploy/apache/serra_v2.conf
```

Sul Raspberry la home e il virtualhost possono essere installati con:

```bash
cd /home/baso/serra_v2
./scripts/deploy_home.sh
```

Lo script copia la pagina in `/var/www/serra_v2`, abilita il sito
`serra_v2.conf`, disabilita `000-default.conf` e ricarica Apache.

Questa home resta una pagina di cortesia temporanea. La scelta architetturale
definitiva per l'interfaccia applicativa e' Flask, ma l'app Flask non e' ancora
stata aggiunta al codice versionato.

## Stato del progetto

Questa e' una base iniziale professionale. Il codice applicativo e' volutamente minimale:
serve a verificare setup, import, database e stato applicativo senza anticipare logiche hardware definitive.
