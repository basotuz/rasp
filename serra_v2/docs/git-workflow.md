# Workflow Git

## Branch principali

- `main`: sempre stabile, avviabile e pronta per il Raspberry.
- `develop`: opzionale quando il progetto avra' piu' feature in parallelo.
- `feature/<nome>`: nuove funzionalita', per esempio `feature/comandi-manuali`.
- `fix/<nome>`: correzioni mirate, per esempio `fix/serial-timeout`.
- `chore/<nome>`: manutenzione, setup, documentazione, tooling.

Per ora puoi lavorare con `main` + branch brevi. Introduci `develop` solo quando serve davvero.

## Convenzione commit

Usa commit in stile Conventional Commits:

```text
feat: aggiunge comandi manuali
fix: corregge bootstrap database
docs: documenta protocollo seriale
chore: aggiorna struttura progetto
test: aggiunge test servizi irrigazione
refactor: separa logica automazione
```

## Quando fare commit

Fai commit quando una modifica e' coerente e verificabile:

- struttura iniziale progetto
- setup ambiente e script
- schema database
- primo entrypoint operativo
- protocollo seriale
- integrazione sensori
- automazione irrigazione

Evita commit enormi con molte cose insieme. Se una modifica non si spiega in una frase, probabilmente va divisa.

## Come evitare caos

- Prima di iniziare: `git status`
- Crea un branch breve: `git switch -c feature/nome-breve`
- Lavora dentro `serra_v2/`
- Verifica: test, lint, avvio locale
- Controlla cosa stai committando: `git diff --staged`
- Commit piccolo
- Push del branch
- Merge solo quando la base e' stabile

## Comandi consigliati

```bash
git status
git switch -c chore/bootstrap-serra-v2
git add serra_v2
git commit -m "chore: bootstrap serra v2 project structure"
git push -u origin chore/bootstrap-serra-v2
```
