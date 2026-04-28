# Serra V1 - servizi systemd osservati

Questa nota raccoglie i servizi systemd attivi sulla Serra V1, usati come
riferimento per progettare la V2. Non sono file da copiare direttamente: servono
a capire responsabilita', frequenze e processi esistenti.

Host V1 osservato: `serra2`.
Percorso servizi: `/etc/systemd/system`.

## Servizi e timer

File presenti:

```text
serra_action.service
serra_action.timer
serra_reader.service
serra_reader.timer
serra_telegram.service
```

## serra_action

`serra_action.service`:

```ini
[Unit]
Description=Esegui script Python serra_action.py
After=network.target

[Service]
#ExecStart=/usr/bin/python /var/www/html/scripts/action.py
ExecStart=/bin/bash /var/www/html/scripts/start_action.sh

WorkingDirectory=/var/www/html/scripts
User=baso
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

`serra_action.timer`:

```ini
[Unit]
Description=Timer per eseguire serra_action ogni  secondi

[Timer]
OnBootSec=20seconds
OnUnitActiveSec=5seconds

[Install]
WantedBy=timers.target
```

Osservazioni:

- Processo dedicato alle azioni/attuatori.
- Avvio tramite wrapper Bash `start_action.sh`.
- Timer ogni 5 secondi.
- Restart continuo in caso di errore.

## serra_reader

`serra_reader.service`:

```ini
[Unit]
Description=Esegui script Python serra_reader.py
After=network.target

[Service]
ExecStart=/usr/bin/python /var/www/html/scripts/reader.py
WorkingDirectory=/var/www/html/scripts
User=baso
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

`serra_reader.timer`:

```ini
[Unit]
Description=Timer per eseguire serra_reader ogni 5 secondi

[Timer]
OnBootSec=20seconds
OnUnitActiveSec=5seconds

[Install]
WantedBy=timers.target
```

Osservazioni:

- Processo dedicato alla lettura sensori.
- Timer ogni 5 secondi.
- Separato dalla logica di azione.

## serra_telegram

`serra_telegram.service`:

```ini
[Unit]
Description=Esegui bot serra
After=network.target

[Service]
ExecStart=/usr/bin/python /var/www/html/scripts/telegram/baso.serra.bot.py
WorkingDirectory=/var/www/html/scripts/telegram/
User=baso
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Osservazioni:

- Bot Telegram come processo separato e persistente.
- Restart automatico ogni 5 secondi in caso di errore.
- Dipende dalla rete.

## Implicazioni per Serra V2

- La V1 separa gia' tre responsabilita': lettura, azione e Telegram.
- In V2 conviene mantenere questa separazione logica, ma con moduli Python
  testabili sotto `src/serra_v2/`.
- I timer a 5 secondi sono un buon riferimento iniziale, da rendere
  configurabile.
- I servizi systemd della V2 dovrebbero puntare a script versionati in
  `scripts/` o entrypoint Python installabili, non a percorsi web come
  `/var/www/html/scripts`.
- Telegram va tenuto come integrazione separata e opzionale, coerente con la
  predisposizione gia' prevista nelle regole progetto.

## Da recuperare dalla V1

- `/var/www/html/scripts/start_action.sh`
- `/var/www/html/scripts/action.py`
- `/var/www/html/scripts/reader.py`
- `/var/www/html/scripts/telegram/baso.serra.bot.py`
- Eventuali configurazioni, database, file cron, log e dashboard web.
