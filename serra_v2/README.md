# Serra v2

Serra v2 e' una piattaforma Python + Raspberry Pi + Arduino per una mini serra smart.
Il progetto nasce con una base piccola, ma organizzata per crescere senza diventare caotico.

## Obiettivi

- Monitoraggio temperatura e umidita' aria
- Monitoraggio umidita' terreno
- Irrigazione automatica
- Apertura e chiusura tetto
- Interfaccia operativa futura, da scegliere piu' avanti
- Modalita' AUTO e MANUALE
- Log eventi
- Predisposizione notifiche Telegram
- Predisposizione fertilizzazione futura
- Predisposizione integrazione Home Assistant / MQTT

## Stack

- Raspberry Pi come master
- Arduino come slave
- Python backend
- SQLite come database iniziale
- Comunicazione seriale USB Raspberry <-> Arduino
- Apache, PHP e MariaDB installati sul Raspberry come servizi disponibili

La base applicativa resta Python + SQLite. Apache/PHP/MariaDB sono pronti sul
Raspberry, ma l'interfaccia utente non e' ancora stata scelta.

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

`scripts/status.sh` stampa lo stato applicativo iniziale in JSON. L'interfaccia utente non e'
ancora scelta: verra' progettata dopo aver stabilizzato dominio, database e hardware.

## Workflow Git

La strategia consigliata e' descritta in [docs/git-workflow.md](docs/git-workflow.md).
In breve: `main` sempre stabile, branch brevi per feature/fix, commit piccoli e descrittivi.

## Ambiente Raspberry

L'ambiente preparato sul Raspberry attuale e' documentato in
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

Questa home e' solo una pagina di cortesia: non introduce ancora una scelta
definitiva sull'interfaccia applicativa.

## Stato del progetto

Questa e' una base iniziale professionale. Il codice applicativo e' volutamente minimale:
serve a verificare setup, import, database e stato applicativo senza anticipare logiche hardware definitive.
