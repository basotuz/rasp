# Serra V1 - database osservato

Questa nota raccoglie le informazioni note sul database della Serra V1.
Serve come riferimento per progettare lo schema SQLite iniziale della V2 e una
eventuale migrazione dati.

## Ambiente osservato

Host V1: `serra2`.
Database engine: MariaDB.
Versione osservata: `10.5.28-MariaDB-0+deb11u1 Raspbian 11`.

Accesso osservato:

```bash
mysql -u serra -p serra
```

Database disponibili:

```text
information_schema
serra
```

Database applicativo:

```sql
USE serra;
```

Tabelle osservate:

```text
dati
stati
```

Volumi osservati:

```text
dati:  333045 righe
stati:      1 riga
```

## Tabella `dati`

Schema osservato:

```sql
CREATE TABLE `dati` (
  `datetime` datetime DEFAULT NULL,
  `device_int` varchar(100) DEFAULT NULL,
  `temp_int` decimal(5,2) DEFAULT NULL,
  `hum_int` decimal(5,2) DEFAULT NULL,
  `device_ext` varchar(100) DEFAULT NULL,
  `temp_ext` decimal(5,2) DEFAULT NULL,
  `hum_ext` decimal(5,2) DEFAULT NULL,
  `light_check` float DEFAULT NULL,
  `timelapse` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

Campione osservato:

```text
datetime             device_int  temp_int  hum_int  device_ext  temp_ext  hum_ext  light_check  timelapse
2025-03-14 18:32:29  DHT22       19.70     63.00    DHT11       0.00      0.00     1            20250314183229.jpg
2025-03-14 18:33:16  DHT22       19.70     63.00    DHT11       0.00      0.00     1            20250314183316.jpg
2025-03-14 18:34:03  DHT22       19.80     62.80    DHT11       0.00      0.00     1            20250314183403.jpg
```

Osservazioni:

- Contiene letture storiche sensori.
- Non ha una chiave primaria esplicita.
- `datetime` e' nullable, ma di fatto rappresenta il timestamp della lettura.
- Distingue un sensore interno (`device_int`, `temp_int`, `hum_int`) e uno
  esterno (`device_ext`, `temp_ext`, `hum_ext`).
- `light_check` sembra indicare luce disponibile o controllo luce.
- `timelapse` contiene il nome file dell'immagine scattata.
- Nel campione `device_ext` e' `DHT11`, ma temperatura e umidita' esterne sono
  `0.00`: in V2 questi valori vanno trattati con attenzione per distinguere
  lettura valida, sensore non disponibile e valore realmente zero.

## Tabella `stati`

Schema osservato:

```sql
CREATE TABLE `stati` (
  `id` varchar(100) NOT NULL,
  `L1_PIN` tinyint(4) DEFAULT 0,
  `L1_STATO` tinyint(1) DEFAULT 0,
  `L1_AUTO` tinyint(4) DEFAULT 0,
  `L2_PIN` tinyint(4) DEFAULT 0,
  `L2_STATO` tinyint(4) DEFAULT 0,
  `L2_AUTO` tinyint(1) DEFAULT 0,
  `R1_PIN` tinyint(4) DEFAULT 0,
  `R1_STATO` tinyint(4) DEFAULT 0,
  `R1_AUTO` tinyint(1) DEFAULT 0,
  `R2_PIN` tinyint(4) DEFAULT 0,
  `R2_STATO` tinyint(4) DEFAULT 0,
  `R2_AUTO` tinyint(1) DEFAULT 0,
  `T_min` int(11) NOT NULL,
  `T_max` int(11) NOT NULL,
  `S1_PIN` tinyint(4) DEFAULT NULL,
  `S1_STATO` tinyint(4) DEFAULT NULL,
  `F1_PIN` tinyint(4) DEFAULT NULL,
  `F1_STATO` tinyint(4) DEFAULT NULL,
  `F1_AUTO` tinyint(4) DEFAULT NULL,
  `V1_PIN` tinyint(4) DEFAULT NULL,
  `V1_STATO` tinyint(4) DEFAULT NULL,
  `V1_AUTO` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

Riga osservata:

```text
id:       1
L1_PIN:   23   L1_STATO: 0   L1_AUTO: 0
L2_PIN:   0    L2_STATO: 1   L2_AUTO: 0
R1_PIN:   24   R1_STATO: 1   R1_AUTO: 0
R2_PIN:   22   R2_STATO: 0   R2_AUTO: 0
T_min:    25   T_max: 27
S1_PIN:   NULL S1_STATO: NULL
F1_PIN:   27   F1_STATO: 0   F1_AUTO: 0
V1_PIN:   17   V1_STATO: 0   V1_AUTO: 0
```

Osservazioni:

- Contiene una sola riga, quindi sembra rappresentare stato/configurazione
  corrente del sistema.
- Non ha una chiave primaria dichiarata, anche se `id` e' `NOT NULL`.
- I gruppi `*_PIN`, `*_STATO`, `*_AUTO` indicano attuatori o canali
  controllabili.
- `T_min` e `T_max` sono soglie di temperatura.
- I nomi dei canali vanno mappati guardando gli script V1:
  - `L1`, `L2`;
  - `R1`, `R2`;
  - `S1`;
  - `F1`;
  - `V1`.

## Comandi utili da eseguire sulla V1

Esportare solo lo schema, senza dati:

```bash
mysqldump -u serra -p --no-data serra dati stati > serra_v1_schema.sql
```

Esportare un piccolo campione dati:

```bash
mysqldump -u serra -p --where="1 limit 20" serra dati > serra_v1_dati_sample.sql
mysqldump -u serra -p --where="1 limit 20" serra stati > serra_v1_stati_sample.sql
```

## Implicazioni per Serra V2

- La V2 parte con SQLite, ma lo schema dovrebbe tenere conto dei concetti gia'
  presenti nella V1.
- `dati` conferma la necessita' di una tabella storica per letture sensori.
- `stati` conferma la necessita' di separare stato corrente, configurazione
  attuatori, modalita' automatica/manuale e soglie.
- In V2 conviene evitare una singola tabella larga per tutti gli stati: meglio
  strutture piu' esplicite per sensori, attuatori, impostazioni ed eventi.
- Il volume storico V1 e' gia' significativo: almeno 333045 letture. In V2
  servono indici sul timestamp e query leggere per dashboard e grafici.
- I valori `0.00` dei sensori esterni nel campione non devono essere assunti
  automaticamente come letture valide.

## Da recuperare dalla V1

- Significato esatto dei canali `L1`, `L2`, `R1`, `R2`, `S1`, `F1`, `V1`.
- Script che leggono/scrivono `dati` e `stati`.
- Posizione e formato dei file timelapse `.jpg`.
- Eventuali query usate dalla dashboard V1.
