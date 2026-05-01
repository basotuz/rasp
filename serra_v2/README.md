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
  docs/                    Documentazione tecnica e workflow
  logs/                    Log runtime ignorati da Git
  deploy/                  File di deploy versionati
  scripts/                 Script di setup, avvio e manutenzione
  src/serra_v2/            Codice Python applicativo
  tests/                   Test unitari e di integrazione
  web/                     Home statica provvisoria
```

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
database e integrazione hardware.

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

Per sincronizzare il codice dal PC al Raspberry (senza copiare `.venv/`, `data/`, `logs/`):

```bash
./scripts/sync_to_raspberry.sh
```

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
