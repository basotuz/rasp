# Architettura

## Visione

Raspberry Pi coordina la logica applicativa, il database, l'hardware e le integrazioni.
Arduino gestisce sensori/attuatori a basso livello e comunica con Raspberry via seriale USB.

## Componenti

- `core`: modelli, configurazione e regole di dominio
- `hardware`: adattatori verso seriale, Arduino e futuri dispositivi
- `services`: orchestrazione di irrigazione, tetto, notifiche e automazioni
- `db`: schema SQLite, connessione e bootstrap
- `web`: entrypoint HTTP Flask, route handler, template e asset UI

Sul Raspberry corrente sono installati anche Apache, PHP e MariaDB come servizi
di piattaforma disponibili. La scelta applicativa per Serra v2 e' Flask come
livello web locale, mantenendo SQLite come database iniziale. Apache puo' restare
un supporto operativo per virtualhost o reverse proxy; PHP e MariaDB non fanno
parte della base applicativa corrente.

## Principio guida

La logica della serra non deve dipendere direttamente da interfaccia utente, seriale o database.
Gli entrypoint chiamano servizi applicativi, i servizi usano interfacce hardware, e il database resta isolato.

Nel caso della UI Flask questo significa:

- route e handler HTTP sottili;
- logica operativa dentro `services`;
- accesso a SQLite confinato in `db`;
- nessuna logica hardware direttamente dentro view o template.

Questo permette di far crescere dashboard, API, MQTT, Home Assistant o Telegram
senza riscrivere il cuore.
