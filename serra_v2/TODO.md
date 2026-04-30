# Serra v2 - TODO

Questo file raccoglie la roadmap operativa del progetto.
`PROJECT_RULES.md` resta la fonte ufficiale per regole e decisioni strutturali;
`SESSION_NOTES.md` resta il diario delle sessioni.

## Priorita' attuale

1. Stabilizzare il cuore locale: stato applicativo, database, eventi e hardware.
2. Creare un'interfaccia operativa adatta a tablet o piccolo schermo touch.
3. Aggiungere notifiche Telegram per eventi importanti e anomalie.

## Interfaccia touch / tablet

Obiettivo: una dashboard operativa semplice da usare su tablet o display touch
vicino alla serra, senza diventare una pagina decorativa.

Step proposti:

- Definire le informazioni minime della schermata principale:
  temperatura aria, umidita' aria, umidita' terreno, stato pompa, stato tetto,
  modalita' AUTO/MANUALE e ultimo aggiornamento.
- Definire i comandi manuali minimi:
  avvia/ferma pompa, apri/chiudi tetto, cambia modalita' AUTO/MANUALE.
- Definire gli stati di sicurezza:
  hardware non raggiungibile, lettura sensore vecchia, comando fallito,
  automazione disabilitata.
- Scegliere consapevolmente lo stack UI:
  pagina statica evoluta, backend Python leggero, oppure integrazione web diversa.
- Separare API/servizi dalla UI:
  la dashboard deve consumare stato e comandi, non contenere logica serra.
- Progettare layout touch-first:
  pulsanti grandi, contrasto alto, poche schermate, nessun testo troppo piccolo.
- Preparare una prima pagina dashboard locale:
  sola lettura dello stato applicativo, aggiornamento periodico, nessun comando.
- Aggiungere comandi manuali solo dopo avere eventi/log e conferme lato backend.
- Valutare modalita' kiosk sul Raspberry se verra' usato un display collegato.

## Notifiche Telegram

Obiettivo: ricevere notifiche utili senza rumore, mantenendo Telegram come
integrazione opzionale e separata dal cuore applicativo.

Step proposti:

- Definire quali eventi generano notifiche:
  avvio sistema, errore hardware, sensore non aggiornato, pompa attivata,
  tetto aperto/chiuso, soglie critiche, cambio modalita'.
- Definire livelli di severita':
  info, warning, errore.
- Aggiungere configurazione tramite `.env`:
  token bot, chat id, notifiche abilitate/disabilitate.
- Non committare mai token, chat id reali o segreti.
- Implementare un servizio Telegram isolato sotto `src/serra_v2/services/`
  o un adapter dedicato, testabile senza rete.
- Registrare sempre gli eventi nel database anche quando Telegram e' disabilitato.
- Evitare spam:
  cooldown per notifiche ripetute e deduplicazione degli errori ricorrenti.
- Preparare un comando/script di test per inviare una notifica manuale.
- Solo dopo la base locale stabile, valutare un servizio systemd dedicato.

## Decisioni da prendere

- Stack della dashboard operativa.
- Dimensione e risoluzione target del display touch.
- Se la UI deve girare solo in LAN o anche da remoto.
- Eventuali utenti/autenticazione per i comandi manuali.
- Frequenza di refresh della dashboard.
- Lista finale degli eventi Telegram da notificare nella prima versione.

## Non fare ancora

- Non introdurre una UI complessa prima di avere contratti chiari per stato e comandi.
- Non mettere token Telegram nel repository.
- Non rendere Telegram necessario per far funzionare la serra.
- Non spostare la logica applicativa dentro pagine web o script Telegram.
