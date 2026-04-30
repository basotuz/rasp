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

Su PC (sviluppo):

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
source .venv/bin/activate
```

Su Raspberry (runtime/deploy):

```bash
cd /home/baso/serra_v2
source .venv/bin/activate
```

Se `.venv` non esiste ancora:

```bash
./scripts/setup_venv.sh
```

## Stato attuale

- Progetto: `serra_v2`, mini serra smart con Raspberry Pi master e Arduino slave.
- Stack previsto: Python, SQLite, pyserial, pytest, Ruff.
- Sul Raspberry attuale sono installati anche Apache, PHP e MariaDB come servizi disponibili.
- Interfaccia utente rimandata: non usare Flask nella base attuale.
- La base iniziale e' volutamente minimale e pensata per crescere in modo ordinato.
- `PROJECT_RULES.md` va letto prima di prendere decisioni tecniche.

## Decisioni gia' prese

- Raspberry Pi contiene backend, stato applicativo, database e automazioni.
- Arduino resta semplice: sensori, attuatori e comandi ricevuti via seriale.
- Comunicazione Raspberry <-> Arduino via seriale USB.
- Protocollo seriale preferito: JSON Lines, da definire in `docs/serial-protocol.md`.
- Repository Git principale: `~/Documenti/MIA/VSCODE/rasp`.
- Progetto dentro sottocartella `serra_v2/`.
- Conventional Commits per i messaggi di commit.

## Prossimi passi possibili

- Verificare setup ambiente con `./scripts/setup_venv.sh`.
- Inizializzare database con `./scripts/bootstrap_db.sh`.
- Verificare stato applicativo con `./scripts/status.sh`.
- Eseguire controlli con `./scripts/check.sh`.
- Definire meglio il protocollo seriale in `docs/serial-protocol.md`.
- Iniziare dai moduli piccoli: configurazione, database, stato applicativo, poi hardware.
- Recuperare dalla Serra V1 gli script citati in `docs/v1-systemd-services.md`.
- Schema MariaDB V1 di `dati` e `stati` acquisito in `docs/v1-database.md`.
- Recuperare significato dei canali V1 `L1`, `L2`, `R1`, `R2`, `S1`, `F1`, `V1`.

## Comandi utili

PC (sviluppo):

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
./scripts/check.sh
```

Raspberry (runtime/deploy):

```bash
cd /home/baso/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
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
- Aggiunta nota sul database MariaDB della Serra V1 in `docs/v1-database.md`.
- Aggiornato schema V1 reale: tabella `dati` con 333045 letture e tabella `stati` con 1 riga di stato/configurazione.
- Chiusura sessione: repository allineato a GitHub; prossimo passo consigliato e' recuperare gli script V1 per mappare i canali `L1`, `L2`, `R1`, `R2`, `S1`, `F1`, `V1`.

### 2026-04-30

- Riletto `PROJECT_RULES.md`, `SESSION_NOTES.md` e struttura del progetto.
- Installato pacchetto di sistema `python3.13-venv`, necessario per creare `.venv`.
- Creato virtualenv e installate dipendenze dev con `./scripts/setup_venv.sh`.
- Corretto lint Ruff in `src/serra_v2/__main__.py`.
- Aggiornati `scripts/check.sh` e `scripts/bootstrap_db.sh`: ora usano automaticamente `.venv/bin/python` se disponibile, mantenendo l'override `PYTHON=...`.
- Rimossa la base Flask su decisione progettuale: l'interfaccia si scegliera' piu' avanti.
- Aggiunto `scripts/status.sh` per verificare lo stato applicativo da CLI.
- Rimossi `SERRA_HOST`, `SERRA_PORT` e la sezione `[server]` dalla configurazione.
- Verificato `./scripts/check.sh`: test passati e Ruff senza errori.
- Verificato `./scripts/bootstrap_db.sh`: database creato/aggiornato in `data/serra_v2.sqlite3`.

### 2026-04-30 - Ambiente Raspberry

- Preparato Raspberry attuale `baso@10.1.2.66` (`serra3`, Debian 13 trixie, aarch64).
- Clonato progetto in `/home/baso/Documenti/MIA/VSCODE/rasp/serra_v2`.
- Creato `.venv`, installate dipendenze Python e verificati `check`, `bootstrap_db` e `status`.
- Installati pacchetti di sistema: `git`, `sqlite3`, `apache2`, `php`, `libapache2-mod-php`, `php-cli`, `php-mysql`, `mariadb-server`, `mariadb-client`.
- Verificati servizi: `apache2` e `mariadb` sono `enabled` e `active`.
- Versioni verificate: Apache 2.4.66, PHP 8.4.16, MariaDB 11.8.6.
- Aggiunta configurazione Apache `ServerName serra3` per evitare il warning sul nome host.
- Aggiunto documento operativo `docs/raspberry-environment.md`.

### 2026-04-30 - Sync progetto PC -> Raspberry

- Spostato il progetto sul Raspberry in `/home/baso/serra_v2`.
- Aggiornato lo script `scripts/sync_to_raspberry.sh` per sincronizzare verso `/home/baso/serra_v2` di default.
- Verificati su Raspberry: `./scripts/bootstrap_db.sh`, `./scripts/status.sh` (db creato e status OK).

### 2026-04-30 - Home provvisoria Apache

- Aggiunta pagina statica `web/index.html` come home di cortesia "Serra in costruzione".
- Aggiunto `scripts/deploy_home.sh` per installare la pagina in `/var/www/html/index.html`.
- Decisione confermata: la pagina statica non rappresenta ancora la scelta dell'interfaccia applicativa definitiva.
