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

## Ipotesi da verificare

- `dati` probabilmente contiene letture storiche dei sensori.
- `stati` probabilmente contiene stato corrente, modalita' o attuatori.

Queste sono ipotesi: vanno confermate leggendo schema e campioni.

## Comandi utili da eseguire sulla V1

Mostrare lo schema delle tabelle:

```sql
SHOW CREATE TABLE dati\G
SHOW CREATE TABLE stati\G
DESCRIBE dati;
DESCRIBE stati;
```

Contare le righe:

```sql
SELECT COUNT(*) FROM dati;
SELECT COUNT(*) FROM stati;
```

Vedere alcuni record recenti, se esiste una colonna data/ora:

```sql
SELECT * FROM dati ORDER BY id DESC LIMIT 10;
SELECT * FROM stati ORDER BY id DESC LIMIT 10;
```

Se non esiste `id`, usare semplicemente:

```sql
SELECT * FROM dati LIMIT 10;
SELECT * FROM stati LIMIT 10;
```

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
- Prima di fissare lo schema V2 conviene leggere `SHOW CREATE TABLE` di `dati`
  e `stati`.
- Se `dati` e' una tabella storica molto grande, la V2 dovrebbe distinguere
  chiaramente tra letture storiche, stato corrente ed eventi.
- Se `stati` contiene anche comandi o modalita', in V2 conviene separare stato
  applicativo, attuatori e log eventi.

## Da recuperare dalla V1

- Output di `SHOW CREATE TABLE dati\G`.
- Output di `SHOW CREATE TABLE stati\G`.
- Output di `DESCRIBE dati;` e `DESCRIBE stati;`.
- Conteggio righe delle due tabelle.
- Campione di righe recenti, oscurando eventuali segreti se presenti.
