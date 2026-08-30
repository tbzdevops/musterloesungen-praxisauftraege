# Musterlösung: Broken Pipeline Challenge

**Ziel:** Vier rote GitHub-Actions-Workflows systematisch reparieren und dabei die vier häufigsten
Fehlerklassen einer CI-Pipeline unterscheiden lernen.

---

## 1. Die Methode: erst lesen, dann ändern

Der häufigste Anfängerfehler beim Debuggen einer Pipeline ist das Raten — eine Zeile ändern, pushen,
warten, wieder ändern. Jeder Durchlauf kostet Minuten. Schneller geht es mit einer festen Reihenfolge:

1. **Wo bricht der Lauf ab?** Actions → Lauf öffnen → der rote Schritt ist markiert.
2. **Welche Meldung steht in der letzten Zeile?** Nicht die erste Warnung lesen, sondern die letzte
   Fehlermeldung vor dem Abbruch.
3. **Welche Fehlerklasse ist das?** Die Stelle des Abbruchs verrät sie bereits:

| Wo es abbricht | Fehlerklasse | Typische Meldung |
|----------------|--------------|------------------|
| Workflow erscheint gar nicht in *Actions* | Die Datei ist kein gültiges YAML | Rotes Banner im Repo: *Invalid workflow file* |
| Vor dem ersten Schritt | `uses:`-Referenz nicht auflösbar | `Unable to resolve action …, repository not found` |
| Im Schritt, der ein Tool aufruft | Abhängigkeit fehlt | `command not found` / `ModuleNotFoundError` |
| Im Schritt selbst, mit Pfadangabe | Pfad oder `working-directory` zeigt ins Leere | `no such file or directory` |

4. **Erst dann ändern**, und zwar genau eine Sache pro Commit.

---

## 2. Bug 1 — `a1-hello.yml`: ungültiges YAML

**Symptom:** Der Workflow taucht im Reiter *Actions* überhaupt nicht auf. GitHub zeigt stattdessen
oben im Repository eine Warnung *Invalid workflow file*.

**Fehlerhafte Datei:**
```yaml
jobs:
  hello:
  runs-on: ubuntu-latest      # ← gleiche Einrückung wie 'hello'
    steps:
      - uses: actions/checkout@v4
```

**Ursache:** `runs-on` steht auf derselben Ebene wie der Job-Name `hello` statt eine Ebene darunter.
Damit liest YAML `hello:` als leeren Wert und `runs-on:` als zweiten Job — und stolpert danach über
`steps:`, das plötzlich tiefer eingerückt ist als sein Elternknoten. Das Ergebnis ist ein
Parse-Fehler. **Eine Datei, die YAML nicht laden kann, führt GitHub nie aus** — deshalb gibt es auch
keinen roten Lauf, den man anschauen könnte.

**Korrigiert:**
```yaml
jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Gruss ausgeben
        run: echo "Hallo aus Tag 05!"
```

**Merksatz:** Kein Lauf sichtbar = Syntaxfehler. Lokal prüfbar mit
`python3 -c "import yaml; yaml.safe_load(open('.github/workflows/a1-hello.yml'))"`.

---

## 3. Bug 2 — `a2-actions.yml`: Action nicht auflösbar

**Symptom:** Der Lauf startet und bricht sofort ab, ohne dass ein Schritt Ausgabe erzeugt:

```
Error: Unable to resolve action `actions/setup-pyton@v5`, repository not found
```

**Ursache:** Tippfehler im Action-Namen — `setup-pyton` statt `setup-python`. Jede `uses:`-Referenz
ist ein echter Pfad zu einem GitHub-Repository (`owner/repo@ref`). Existiert er nicht, kann GitHub
den Job gar nicht erst zusammenstellen.

**Korrigiert:**
```yaml
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
```

**Merksatz:** Abbruch *vor* dem ersten Schritt heisst fast immer: falscher Action-Name oder falscher
Tag/Version. Prüfen lässt sich das, indem man `https://github.com/<owner>/<repo>` im Browser öffnet.

---

## 4. Bug 3 — `a3-deps.yml`: fehlende Abhängigkeit

**Symptom:** Die Schritte *Checkout*, *Setup Python* und *Abhängigkeiten installieren* sind grün,
der Schritt *Tests* bricht ab:

```
pytest: command not found
Error: Process completed with exit code 127.
```

**Ursache:** Der Workflow installiert mit `pip install -r requirements.txt` genau das, was in dieser
Datei steht — und dort stand nur `flake8`. pytest war nie installiert. Der Runner ist bei jedem Lauf
eine frische VM: **was nicht explizit installiert wird, existiert nicht.**

**Korrigiert — `requirements.txt`:**
```
flake8
pytest
```

**Merksatz:** `command not found` (Exit-Code 127) oder `ModuleNotFoundError` heisst immer:
Abhängigkeit fehlt in der Installationsquelle, nicht im Workflow.

---

## 5. Bug 4 — `a4-tests.yml`: falscher Pfad

**Symptom:** Alle Schritte grün bis auf *Tests*:

```
Error: An error occurred trying to start process '/usr/bin/bash' with working directory
'/home/runner/work/praxis-day05/praxis-day05/src'. No such file or directory
```

**Fehlerhafter Schritt:**
```yaml
      - name: Tests
        working-directory: src
        run: pytest -q
```

**Ursache:** `working-directory: src` wechselt vor dem Befehl in den Ordner `src` — den es in diesem
Repository nicht gibt. Die Tests liegen in `tests/` im Wurzel-Verzeichnis.

**Korrigiert:**
```yaml
      - name: Tests
        run: pytest -q
```

Ohne `working-directory` läuft der Schritt im Wurzel-Verzeichnis. pytest findet `tests/` von selbst,
und `conftest.py` im Wurzel-Verzeichnis sorgt dafür, dass `from app import …` funktioniert.

**Merksatz:** Meldungen mit einem absoluten Pfad im Text sind fast immer Pfadfehler — nicht
Code-Fehler. Der Pfad in der Meldung zeigt, wo der Runner gesucht hat.

---

## 6. Ergebnis

Nach den vier Fixes laufen alle Workflows grün. Die Dokumentation in `DOKUMENTATION.md` hält pro
Workflow Symptom, Ursache und Fix fest — genau diese Tabelle ist im Berufsalltag der Kern eines
Post-Mortems.

| Workflow | Fehlerklasse | Fix |
|----------|--------------|-----|
| `a1-hello.yml` | YAML-Syntax | Einrückung von `runs-on` korrigiert |
| `a2-actions.yml` | Action-Referenz | `setup-pyton` → `setup-python` |
| `a3-deps.yml` | Abhängigkeit | `pytest` in `requirements.txt` ergänzt |
| `a4-tests.yml` | Pfad | `working-directory: src` entfernt |
