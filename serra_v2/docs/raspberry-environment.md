# Ambiente Raspberry

Questa nota descrive l'ambiente preparato sul Raspberry attuale per Serra v2.
Serve come riferimento operativo: il codice applicativo resta Python e, per ora,
usa SQLite come database iniziale.

## Host attuale

```text
SSH: baso@10.1.2.66
Hostname: serra3
OS: Debian GNU/Linux 13 (trixie)
Architettura: aarch64
Python: 3.13.5
```

Percorso progetto:

```bash
/home/baso/Documenti/MIA/VSCODE/rasp/serra_v2
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
ServerName serra3
```

## Progetto Serra v2

Comandi verificati sul Raspberry:

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
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

## Decisione attuale

Apache, PHP e MariaDB sono installati e disponibili sul Raspberry, ma non sono
ancora dipendenze applicative di Serra v2.

La base applicativa resta:

- Python per backend/logica serra;
- SQLite come database iniziale;
- pyserial per comunicazione Raspberry <-> Arduino.

L'interfaccia utente verra' scelta piu' avanti. Se si decidera' di usare Apache,
PHP o MariaDB nel progetto applicativo, la decisione andra' riportata in
`PROJECT_RULES.md` insieme alle modifiche di codice e configurazione.
