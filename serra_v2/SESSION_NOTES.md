# Serra v2 - Session Notes

Questo file serve a non perdere il contesto tra una chat e l'altra.
Non sostituisce `PROJECT_RULES.md`: quello resta la fonte ufficiale per regole,
architettura e decisioni strutturali. Qui teniamo memoria operativa veloce.

## Come ripartire

Quando riapri il progetto:

1. Leggere `PROJECT_RULES.md`.
2. Leggere questo file.
3. Controllare lo stato del repository:

```bash
cd ~/Documenti/MIA/VSCODE/rasp
git status
```

4. Se serve lavorare sull'app:

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
source .venv/bin/activate
```

Se `.venv` non esiste ancora:

```bash
./scripts/setup_venv.sh
```

## Stato attuale

- Progetto: `serra_v2`, mini serra smart con Raspberry Pi master e Arduino slave.
- Stack previsto: Python, Flask, SQLite, pyserial, pytest, Ruff.
- Dashboard locale prevista su `http://127.0.0.1:5000`.
- La base iniziale e' volutamente minimale e pensata per crescere in modo ordinato.
- `PROJECT_RULES.md` va letto prima di prendere decisioni tecniche.

## Decisioni gia' prese

- Raspberry Pi contiene backend, dashboard, stato applicativo, database e automazioni.
- Arduino resta semplice: sensori, attuatori e comandi ricevuti via seriale.
- Comunicazione Raspberry <-> Arduino via seriale USB.
- Protocollo seriale preferito: JSON Lines, da definire in `docs/serial-protocol.md`.
- Repository Git principale: `~/Documenti/MIA/VSCODE/rasp`.
- Progetto dentro sottocartella `serra_v2/`.
- Conventional Commits per i messaggi di commit.

## Prossimi passi possibili

- Verificare setup ambiente con `./scripts/setup_venv.sh`.
- Inizializzare database con `./scripts/bootstrap_db.sh`.
- Avviare dashboard con `./scripts/run_dev.sh`.
- Eseguire controlli con `./scripts/check.sh`.
- Definire meglio il protocollo seriale in `docs/serial-protocol.md`.
- Iniziare dai moduli piccoli: configurazione, database, dashboard base, poi hardware.
- Recuperare dalla Serra V1 gli script citati in `docs/v1-systemd-services.md`.

## Comandi utili

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/run_dev.sh
./scripts/check.sh
```

Git dal repository principale:

```bash
cd ~/Documenti/MIA/VSCODE/rasp
git status
git diff
git add serra_v2
git diff --staged
```

## Note aperte

- Aggiornare questo file a fine sessione con:
  - cosa e' stato fatto;
  - cosa resta da fare;
  - eventuali problemi incontrati;
  - comandi gia' eseguiti e relativo risultato.

## Diario sessioni

### 2026-04-28

- Creato `SESSION_NOTES.md` per conservare il contesto operativo tra chat.
- Confermato che `PROJECT_RULES.md` resta la fonte ufficiale del progetto.
- Aggiunta nota sui servizi systemd della Serra V1 in `docs/v1-systemd-services.md`.
