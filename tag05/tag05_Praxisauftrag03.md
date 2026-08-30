# Musterlösung: Pipeline schneller machen

**Ziel:** Die Laufzeit des Gates aus Auftrag 2 messbar senken — mit drei Hebeln, die zusammen den
grössten Teil der verlorenen Zeit erklären.

---

## 1. Warum Laufzeit ein Qualitätsmerkmal ist

Ein Gate, das zu lange braucht, wird umgangen: Leute pushen gesammelt statt einzeln, mergen ohne
abzuwarten oder schalten Checks ab. Die Pipeline-Dauer ist deshalb keine Bequemlichkeitsfrage,
sondern gehört zu den DORA-Metriken (*Lead Time for Changes*) aus Tag 01.

**Messen vor dem Optimieren.** Actions → Lauf öffnen → die Dauer steht oben rechts neben dem
Lauf-Titel; pro Job zeigt die Seitenleiste die Einzelzeit. Notiert wird die **Gesamtdauer des
Workflows**, nicht die Summe der Jobs.

---

## 2. Hebel 1 — Dependency-Caching

Ohne Cache lädt `pip install` bei jedem Lauf alle Pakete neu aus dem Netz. `actions/setup-python`
bringt den Cache in einer Zeile mit:

```yaml
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: pip
```

Der Cache-Key wird automatisch aus dem Hash von `requirements.txt` gebildet: Ändert sich die Datei,
gibt es einen neuen Key und einen neuen Download. Bleibt sie gleich, kommen die Pakete aus dem Cache.

**Wichtig beim Messen:** Der erste Lauf nach der Umstellung *legt* den Cache erst an und ist deshalb
nicht schneller. Die Vorher/Nachher-Messung braucht mindestens den zweiten Lauf.

---

## 3. Hebel 2 — Parallelisierung

In Auftrag 2 hing `test` mit `needs: lint` am Linter. Die Pipeline dauerte damit
`lint + test`. Ohne `needs` laufen beide Jobs gleichzeitig, und die Pipeline dauert nur so lange wie
der **langsamere** der beiden.

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    # kein needs mehr
  test:
    runs-on: ubuntu-latest
    # kein needs mehr
```

**Wann ist `needs` trotzdem richtig?** Wenn ein Job das Ergebnis eines anderen braucht (ein Build,
dessen Artefakt der Deploy-Job herunterlädt), oder wenn ein teurer Job nicht starten soll, bevor ein
billiger Vorfilter grün ist. Bei zwei kurzen, unabhängigen Prüfungen kostet die Verkettung nur Zeit.

**Trade-off:** Parallele Jobs belegen zwei Runner gleichzeitig statt nacheinander einen. Das ist bei
einem kleinen Gate unkritisch; bei einer Matrix aus zwanzig Jobs wird es zur Kostenfrage.

---

## 4. Hebel 3 — `concurrency`

Bei drei Pushes kurz hintereinander laufen drei Pipelines gleichzeitig — zwei davon auf Code, der
schon überholt ist. `concurrency` bricht die veralteten Läufe ab:

```yaml
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true
```

`group` definiert, was als „derselbe Kontext“ gilt: `github.ref` ist der Branch, also läuft pro
Branch nur eine Pipeline. `cancel-in-progress: true` stoppt den laufenden Vorgänger, sobald ein
neuer startet.

**Vorsicht:** Auf `main` bzw. bei Deployment-Workflows will man `cancel-in-progress` meist **nicht** —
ein abgebrochener Deploy hinterlässt einen halb ausgerollten Zustand.

---

## 5. Die fertige Pipeline

**`.github/workflows/ci.yml`**
```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: pip
      - run: pip install -r requirements.txt
      - run: flake8 app.py tests/ conftest.py

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: pip
      - run: pip install -r requirements.txt
      - run: pytest -q
```

---

## 6. Messung

| Messung | Laufzeit `ci.yml` |
|---------|-------------------|
| **Vorher** — `test` mit `needs: lint`, kein Cache | 1 min 48 s |
| **Nachher** — parallel, `cache: pip`, `concurrency` | 42 s |

Die konkreten Zahlen schwanken je nach Auslastung der GitHub-Runner; entscheidend ist die
Grössenordnung und dass beide Messungen unter denselben Bedingungen entstanden sind (also nicht der
allererste Lauf gegen den zehnten).

**Weitere Hebel, wenn es noch schneller sein muss:**

- `paths-ignore` im Trigger, damit reine Dokumentations-Commits die Pipeline gar nicht starten.
- `pip install --no-deps` bzw. ein vorgebautes Image, wenn die Installation trotz Cache dominiert.
- `fail-fast` in Matrix-Builds, damit ein früher Fehler die restlichen Kombinationen abbricht.
