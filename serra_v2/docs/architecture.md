# Architettura

## Visione

Raspberry Pi coordina la logica applicativa, il database, l'hardware e le integrazioni.
Arduino gestisce sensori/attuatori a basso livello e comunica con Raspberry via seriale USB.

## Componenti

- `core`: modelli, configurazione e regole di dominio
- `hardware`: adattatori verso seriale, Arduino e futuri dispositivi
- `services`: orchestrazione di irrigazione, tetto, notifiche e automazioni
- `db`: schema SQLite, connessione e bootstrap

Sul Raspberry attuale sono installati anche Apache, PHP e MariaDB come servizi
di piattaforma disponibili. Non fanno ancora parte dell'architettura applicativa
di Serra v2: la base resta Python + SQLite finche' non viene presa una decisione
esplicita sull'interfaccia o su una migrazione database.

## Principio guida

La logica della serra non deve dipendere direttamente da interfaccia utente, seriale o database.
Gli entrypoint chiamano servizi applicativi, i servizi usano interfacce hardware, e il database resta isolato.

Questo permette in futuro di aggiungere interfaccia utente, MQTT, Home Assistant o Telegram senza riscrivere il cuore.
