# Architettura

## Visione

Raspberry Pi coordina la logica applicativa, la dashboard web, il database e le integrazioni.
Arduino gestisce sensori/attuatori a basso livello e comunica con Raspberry via seriale USB.

## Componenti

- `web`: dashboard Flask e pagine HTML
- `api`: endpoint HTTP per comandi manuali e stato serra
- `core`: modelli, configurazione e regole di dominio
- `hardware`: adattatori verso seriale, Arduino e futuri dispositivi
- `services`: orchestrazione di irrigazione, tetto, notifiche e automazioni
- `db`: schema SQLite, connessione e bootstrap

## Principio guida

La logica della serra non deve dipendere direttamente da Flask o dalla seriale.
Flask chiama servizi applicativi, i servizi usano interfacce hardware, e il database resta isolato.

Questo permette in futuro di aggiungere MQTT, Home Assistant o Telegram senza riscrivere il cuore.
