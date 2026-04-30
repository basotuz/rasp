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

## Struttura

```text
serra_v2/
  arduino/                 Firmware Arduino
  config/                  Configurazioni versionate di esempio
  data/                    Database locali e file runtime ignorati da Git
  docs/                    Documentazione tecnica e workflow
  logs/                    Log runtime ignorati da Git
  scripts/                 Script di setup, avvio e manutenzione
  src/serra_v2/            Codice Python applicativo
  tests/                   Test unitari e di integrazione
```

## Avvio rapido sviluppo

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
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

## Stato del progetto

Questa e' una base iniziale professionale. Il codice applicativo e' volutamente minimale:
serve a verificare setup, import, database e stato applicativo senza anticipare logiche hardware definitive.
