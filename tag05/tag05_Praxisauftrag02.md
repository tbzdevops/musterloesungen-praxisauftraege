# Musterlösung: PR-Gate und Branch Protection

**Ziel:** Aus einer laufenden CI-Pipeline ein Gate machen — eine Pipeline, die nicht nur meldet,
sondern den `main`-Branch tatsächlich schützt.

---

## 1. Das Problem

Nach Auftrag 1 laufen vier Workflows grün. Trotzdem kann jede Person mit Schreibrechten
`git push origin main` mit rotem Code ausführen. Die Pipeline **meldet** den Fehler — sie
**verhindert** ihn nicht. Der Unterschied heisst *Required Status Check*.

```
Pipeline ohne Gate:   Push → main → CI läuft → rot → Code ist trotzdem drin
Pipeline mit Gate:    Push → Branch → PR → CI läuft → rot → Merge blockiert
```

---

## 2. Der Gate-Workflow

Die vier Workflows aus Auftrag 1 sind Übungsstücke. Das Gate ist ein eigener Workflow, der auf
**Pull Requests** reagiert — sonst hätte er im PR gar keinen Status zu melden.

**`.github/workflows/ci.yml`** (Zwischenstand nach Auftrag 2, in Auftrag 3 optimiert)
```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -r requirements.txt
      - run: flake8 app.py tests/ conftest.py

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -r requirements.txt
      - run: pytest -q
```

**Warum genau die Namen `lint` und `test`?** In der Ruleset-Konfiguration wählt man Required Status
Checks über den **Job-Namen** aus. Wer den Job später umbenennt, hat plötzlich ein Gate, das auf
einen Check wartet, den es nicht mehr gibt — und ein `main`, in das nichts mehr gemergt werden kann.
Job-Namen im Gate sind deshalb ein Vertrag, kein Detail.

`needs: lint` verkettet die Jobs: `test` startet erst, wenn `lint` grün ist. Das ist der Stand aus
Tag 04 — Auftrag 3 löst diese Verkettung wieder auf.

---

## 3. Das Ruleset

Auf `main` wird ein Ruleset `protect-main` angelegt (Settings → Rules → Rulesets → New branch ruleset):

| Regel | Einstellung | Wirkung |
|-------|-------------|---------|
| Target branches | `main` (Include default branch) | Gilt nur für den geschützten Branch. |
| Require a pull request before merging | aktiv, 1 Approval | Direkte Pushes auf `main` sind gesperrt. |
| Require status checks to pass | `lint`, `test` | Der Merge-Button bleibt gesperrt, solange ein Check rot ist. |
| Require branches to be up to date | aktiv | Der PR muss den aktuellen `main` enthalten, bevor er gemergt wird. |
| Block force pushes | aktiv | Verhindert das Überschreiben der History. |

> **Hinweis zur Kursumgebung:** Rulesets und Branch Protection sind auf **privaten** Repositories nur
> in bezahlten GitHub-Plänen verfügbar. Die Repositories der Lernenden sind privat und die
> Organisation läuft auf dem Free-Plan — das Ruleset wird deshalb dokumentiert und von der Lehrperson
> an einem öffentlichen Repository demonstriert. Alles andere in diesem Auftrag (Workflow, PR-Ablauf,
> CODEOWNERS, Review) funktioniert unverändert.

---

## 4. Review-Infrastruktur

**`.github/pull_request_template.md`** — füllt jede PR-Beschreibung vor und macht aus „Review“ eine
Checkliste statt einer Geste:

```markdown
## Was ändert dieser PR?

## Review-Checkliste

- [ ] CI ist grün (lint und test)
- [ ] Änderung ist getestet
- [ ] Keine Secrets oder Zugangsdaten im Diff
- [ ] DOKUMENTATION.md bei Bedarf nachgeführt

## Wie wurde geprüft?
```

**`.github/CODEOWNERS`** — GitHub fragt das Review automatisch bei den Eigentümern an:

```
*                       @patrickmorgeneggtbz
/.github/workflows/     @patrickmorgeneggtbz
```

Die Syntax ist die von `.gitignore`: Pfadmuster, danach die Handles. Die **letzte passende Zeile
gewinnt** — spezifischere Regeln gehören deshalb nach unten. Ein Team wird als
`@organisation/team-slug` geschrieben; existiert es nicht, ignoriert GitHub die Zeile stillschweigend.

---

## 5. Der Ablauf in der Praxis

```bash
git switch -c fix/rabatt
# absichtlich einen falschen Erwartungswert setzen
git commit -am "test: falscher Erwartungswert (Demo)"
git push -u origin fix/rabatt
```

Pull Request öffnen. Am PR erscheint der Abschnitt *Some checks were not successful* — `test` ist rot.
Bei aktivem Ruleset steht darunter **„Merging is blocked“**, der grüne Button ist grau.

```bash
# im selben Branch reparieren
git commit -am "fix: Erwartungswert korrigiert"
git push
```

Der Check läuft erneut, wird grün, der Merge-Button wird frei.

**Merge mit Merge-Commit**, nicht mit Squash oder Rebase: Nur so bleibt in der History nachweisbar,
dass die Änderung über einen Pull Request kam. `git log --merges` zeigt genau diese Commits.

---

## 6. Was der Auftrag zeigt

- Ein grüner Build ist eine **Information**. Erst der Required Status Check macht daraus eine
  **Bedingung**.
- Das Gate hängt an drei Dingen, die zusammenpassen müssen: der Workflow muss auf `pull_request`
  triggern, die Job-Namen müssen im Ruleset stimmen, und der Branch muss geschützt sein.
- CODEOWNERS und PR-Template kosten fünf Minuten und ersetzen die Diskussion darüber, wer wann was
  reviewt.
