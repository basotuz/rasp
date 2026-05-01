# Serra v2 - Project Rules

Questo file e' la fonte ufficiale del progetto Serra v2.
Ogni volta che il progetto viene riaperto, va letto prima di prendere decisioni tecniche.

Deve restare vivo: quando cambiano architettura, struttura, workflow, regole o strategia,
questo file va aggiornato nello stesso ciclo di lavoro.

## Obiettivo del progetto

Serra v2 e' una piattaforma per mini serra SMART basata su Raspberry Pi e Arduino.
L'obiettivo e' costruire un sistema semplice da usare, affidabile e scalabile, capace di:

- leggere temperatura aria;
- leggere umidita' aria;
- leggere umidita' terreno;
- gestire irrigazione automatica;
- gestire apertura e chiusura del tetto;
- offrire controllo manuale da una dashboard operativa Flask;
- supportare modalita' AUTO e MANUALE;
- registrare eventi e comandi;
- predisporre notifiche Telegram future;
- predisporre fertilizzazione futura;
- predisporre integrazioni Home Assistant e MQTT.

Il progetto non deve diventare un prototipo disordinato: deve crescere come una vera piattaforma.

## Architettura Raspberry Pi + Arduino

### Raspberry Pi

Raspberry Pi e' il master del sistema.
Responsabilita':

- eseguire il backend Python;
- mantenere lo stato applicativo;
- salvare dati ed eventi su SQLite;
- decidere automazioni in modalita' AUTO;
- inviare comandi manuali o automatici ad Arduino;
- gestire in futuro Telegram, MQTT e Home Assistant.

### Arduino

Arduino e' lo slave hardware.
Responsabilita':

- leggere sensori collegati fisicamente;
- controllare attuatori come pompa, servomotori/rele' e tetto;
- eseguire comandi ricevuti via seriale;
- inviare letture e stati a Raspberry Pi;
- restare il piu' semplice possibile.

### Comunicazione

La comunicazione Raspberry <-> Arduino avviene via seriale USB.
Il protocollo sara' definito progressivamente in `docs/serial-protocol.md`.
La direzione preferita e' JSON Lines: un messaggio JSON per riga.

## Stack tecnologico

- Python come linguaggio backend principale;
- Flask come stack scelto per dashboard operativa ed endpoint HTTP locali;
- SQLite come database iniziale;
- pyserial per comunicazione USB seriale;
- Apache, PHP e MariaDB installati sul Raspberry come servizi disponibili,
  con Apache riutilizzabile come supporto operativo o reverse proxy e PHP/MariaDB
  non dipendenze applicative di Serra v2;
- Arduino IDE / firmware `.ino` per lo slave;
- pytest per test;
- Ruff per linting;
- Git + GitHub per versionamento e collaborazione;
- futura espansione verso MQTT, Home Assistant e Telegram.

## Struttura progetto

Percorsi di riferimento:

- PC (sviluppo):

```text
~/Documenti/MIA/VSCODE/rasp/serra_v2
```

- Raspberry (runtime/deploy):

```text
/home/baso/serra_v2
```

Struttura attuale:

```text
serra_v2/
  PROJECT_RULES.md          Fonte ufficiale del progetto
  README.md                 Panoramica e avvio rapido
  TODO.md                   Roadmap operativa e prossimi step
  .env.example              Variabili ambiente di esempio
  .gitignore                File e artefatti da non versionare
  pyproject.toml            Configurazione Python/tooling
  requirements.txt          Dipendenze runtime
  requirements-dev.txt      Dipendenze sviluppo/test
  arduino/                  Firmware Arduino
  config/                   Configurazioni versionate
  data/                     Database e dati runtime locali
  deploy/                   File di deploy versionati
    apache/serra_v2.conf    Virtualhost Apache provvisorio
  docs/                     Documentazione tecnica
    raspberry-environment.md Ambiente operativo del Raspberry corrente
  logs/                     Log runtime locali
  scripts/                  Script operativi e test hardware
    python/                 Script Python di prova sensori sul Raspberry
    ino/                    Sketch Arduino di prova
  src/serra_v2/             Codice Python applicativo
  tests/                    Test unitari e integrazione
  web/                      Home statica provvisoria per Apache
```

Separazione logica del codice Python:

- `core`: configurazione, modelli e regole centrali;
- `db`: connessione, schema e bootstrap SQLite;
- `hardware`: adattatori verso Arduino, seriale e dispositivi;
- `services`: logica applicativa e orchestrazione.

Roadmap operativa:

- `TODO.md`: prossimi step, priorita', decisioni aperte e cose da non anticipare.

## Regole di sviluppo

- Prima di lavorare, leggere questo file e controllare `git status`.
- Tenere tutto il progetto dentro `serra_v2/`.
- Usare Flask come stack UI/API di riferimento; non introdurre altri framework web
  senza una decisione esplicita.
- Non far dipendere il dominio direttamente da interfaccia, SQLite o seriale.
- Non spostare il database applicativo da SQLite a MariaDB/MySQL senza una
  decisione esplicita e relativa migrazione documentata.
- Tenere Arduino semplice: esecuzione hardware, non logica applicativa complessa.
- Separare sempre:
  - route/template/UI Flask;
  - logica applicativa;
  - persistenza database;
  - comunicazione hardware.
- Preferire codice piccolo, chiaro e testabile.
- Aggiungere astrazioni solo quando servono davvero.
- Ogni script deve essere ripetibile e sicuro.
- I file runtime locali non vanno committati.
- I segreti non vanno mai nel repository.
- Quando viene creato un nuovo file di progetto, va fatto commit e push su Git appena la modifica e' coerente.
- Ogni nuova decisione strutturale importante va riportata qui.

## Script operativi

Script attuali:

```bash
./scripts/setup_venv.sh          # crea virtualenv e installa dipendenze
./scripts/bootstrap_db.sh        # crea/aggiorna database SQLite locale
./scripts/status.sh              # stampa lo stato applicativo iniziale
./scripts/check.sh               # esegue test e lint
./scripts/sync_to_raspberry.sh   # (da PC) sync del codice verso Raspberry via rsync/ssh
./scripts/deploy_home.sh         # (su Raspberry) installa home statica e virtualhost Apache
./scripts/python/*.py            # test hardware manuali lato Raspberry
./scripts/ino/**/*.ino           # sketch di prova lato Arduino
```

## Hardware emerso dai file attuali

Dai file Python e Arduino presenti oggi nel repository emergono queste prove hardware:

- DHT22 testato lato Raspberry con `adafruit_dht`.
- DS18B20 testato lato Raspberry via 1-Wire Linux.
- Sensore umidita' suolo con doppio approccio:
  - uscita digitale letta direttamente dal Raspberry su `GPIO 25` (BCM);
  - uscita analogica letta da Arduino su `A0`, poi inviata al Raspberry via seriale USB.
- Formato seriale di test gia' osservato: `soil=<percentuale>;raw=<valore>`.

Pin e collegamenti da considerare documentati solo se confermati dal codice:

- `GPIO 25` per la lettura digitale del sensore suolo (`test_soil_hum_d.py`);
- `A0` Arduino per la lettura analogica del sensore suolo (`scripts/ino/soil/soil.ino`);
- `BCM GPIO22` / `pin fisico 15` per il test DHT22 (`test_dht22.py`).

Flusso sviluppo locale consigliato (PC):

```bash
cd ~/Documenti/MIA/VSCODE/rasp/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
```

Flusso runtime/deploy consigliato (Raspberry):

```bash
cd /home/baso/serra_v2
./scripts/setup_venv.sh
source .venv/bin/activate
./scripts/bootstrap_db.sh
./scripts/status.sh
```

## Convenzioni Git e commit

Repository Git principale:

```text
~/Documenti/MIA/VSCODE/rasp
```

Il progetto Serra v2 e' una sottocartella del repository `rasp`.

### Branch

- `main`: sempre stabile e funzionante;
- `feature/<nome>`: nuove funzionalita';
- `fix/<nome>`: correzioni mirate;
- `chore/<nome>`: setup, manutenzione, documentazione, tooling;
- `docs/<nome>`: documentazione significativa.

`develop` e' opzionale: introdurlo solo quando il lavoro parallelo diventa frequente.

### Commit

Usare Conventional Commits:

```text
feat: aggiunge gestione irrigazione automatica
fix: corregge timeout comunicazione seriale
docs: aggiorna regole progetto
chore: prepara struttura iniziale serra v2
test: aggiunge test bootstrap database
refactor: separa servizio serra da entrypoint operativo
```

### Quando committare

Fare commit quando una modifica e' coerente, verificabile e spiegabile in una frase.
Esempi di commit sensati:

- struttura iniziale del progetto;
- setup ambiente;
- schema database;
- entrypoint stato applicativo;
- protocollo seriale;
- integrazione sensori;
- log eventi;
- modalita' AUTO/MANUALE;
- automazione irrigazione.

Prima di ogni commit:

```bash
git status
git diff
git add serra_v2
git diff --staged
```

Quando possibile:

```bash
./scripts/check.sh
```

## Filosofia del progetto

Serra v2 deve essere:

- semplice nella prima versione;
- affidabile prima che sofisticata;
- modulare senza essere sovra-ingegnerizzata;
- comprensibile anche dopo mesi;
- adatta a girare su Raspberry Pi reale;
- pronta a integrare hardware reale senza riscritture traumatiche;
- costruita per iterazioni piccole e pulite.

L'interfaccia deve essere uno strumento operativo, non una pagina decorativa.
La direzione scelta e' una dashboard Flask usabile da tablet o piccolo schermo touch,
con controlli chiari e layout pensato per l'uso vicino alla serra.
La home statica `web/index.html` e il virtualhost `deploy/apache/serra_v2.conf`
restano una pagina di cortesia provvisoria per Apache finche' l'app Flask non
viene aggiunta al progetto.
Telegram e' una integrazione opzionale per notifiche: non deve diventare una
dipendenza necessaria per il funzionamento locale della serra.
L'automazione deve essere prevedibile e sempre tracciabile tramite log/eventi.
La modalita' manuale deve poter intervenire in modo chiaro e controllato.

## Cose da evitare

- Non mettere codice finale prematuro prima di aver definito contratti e hardware.
- Non mescolare logica interfaccia, logica serra e accesso hardware nello stesso file.
- Non mettere logica operativa dentro route Flask, template o JavaScript della dashboard.
- Non salvare database, log, `.env`, virtualenv o file temporanei in Git.
- Non usare commit generici come `update`, `fix stuff`, `prove`.
- Non introdurre MQTT, Telegram o Home Assistant prima di avere una base locale stabile.
- Non rendere Arduino responsabile di decisioni applicative complesse.
- Non hardcodare pin, soglie o porte seriali dentro la logica centrale.
- Non cambiare struttura cartelle senza aggiornare questo file.
- Non lasciare script rotti o non eseguibili.

## Roadmap

### V1 - Base locale funzionante

Obiettivo: sistema avviabile in locale/Raspberry con database, stato applicativo e struttura stabile.

- struttura progetto professionale;
- virtualenv e script setup;
- entrypoint CLI per stato applicativo;
- SQLite bootstrap;
- ambiente Raspberry documentato con Apache, PHP e MariaDB disponibili;
- schema iniziale per letture sensori, eventi e comandi;
- firmware Arduino placeholder;
- protocollo seriale documentato a livello iniziale;
- decisione documentata su Flask come stack UI/API;
- test minimi;
- workflow Git pulito.

### V2 - Serra automatizzata

Obiettivo: controllo reale di sensori e attuatori con modalita' AUTO/MANUALE.

- definizione pin e componenti hardware;
- firmware Arduino per sensori e attuatori;
- client seriale Python reale;
- lettura temperatura/umidita' aria;
- lettura umidita' terreno;
- controllo pompa;
- controllo tetto;
- interfaccia manuale con comandi via Flask;
- regole AUTO configurabili;
- log eventi completo;
- gestione errori seriale e fallback sicuro.

### V3 - Piattaforma estesa

Obiettivo: rendere Serra v2 integrabile, notificabile e piu' intelligente.

- notifiche Telegram;
- MQTT;
- integrazione Home Assistant;
- storico dati e grafici;
- profili coltivazione;
- fertilizzazione automatizzata;
- backup database;
- deploy come servizio systemd su Raspberry;
- autenticazione interfaccia se esposta in rete;
- esportazione dati;
- hardening operativo.

## Regola di mantenimento

Quando vengono prese decisioni architetturali importanti, modifiche strutturali significative,
nuove regole di sviluppo o cambiamenti di strategia, aggiornare questo file nello stesso commit
della modifica.

Se questo file e il codice non sono allineati, il file va corretto prima di proseguire.
