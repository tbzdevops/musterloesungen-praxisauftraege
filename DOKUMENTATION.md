# Tag 05 Praxis — Dokumentation

## Auftrag 1: Broken Pipeline Challenge

| Workflow | Symptom | Ursache | Fix |
| --- | --- | --- | --- |
| `a1-hello.yml` | Der Workflow taucht im Tab *Actions* gar nicht auf; GitHub zeigt oben eine Warnung "Invalid workflow file". | `runs-on` war auf derselben Ebene eingerueckt wie der Job `hello` statt eine Ebene darunter. Damit ist die Datei kein gueltiges YAML mehr — GitHub kann sie nicht laden und startet sie deshalb nie. | Einrueckung von `runs-on` um zwei Leerzeichen erhoeht. |
| `a2-actions.yml` | Der Lauf bricht sofort ab: `Unable to resolve action actions/setup-pyton@v5, repository not found`. | Tippfehler im Action-Namen (`setup-pyton` statt `setup-python`). GitHub loest jede `uses:`-Referenz als Repository auf; existiert es nicht, endet der Job vor dem ersten Schritt. | Auf `actions/setup-python@v5` korrigiert. |
| `a3-deps.yml` | Der Schritt *Tests* endet mit `pytest: command not found`. | `requirements.txt` enthielt nur `flake8`. Der Workflow installiert genau diese Datei — pytest war also nie installiert. | `pytest` in `requirements.txt` ergaenzt. |
| `a4-tests.yml` | Der Schritt *Tests* endet mit `chdir .../src: no such file or directory`. | `working-directory: src` zeigt auf einen Ordner, den es im Repo nicht gibt. Die Tests liegen in `tests/` im Wurzel-Verzeichnis. | `working-directory` entfernt, damit pytest im Wurzel-Verzeichnis laeuft und `tests/` findet. |

**Gelernt:** Die vier Fehler treffen vier verschiedene Phasen — Datei laden, Action aufloesen, Abhaengigkeiten
installieren, Schritt ausfuehren. Wo im Log der Lauf abbricht, verraet die Fehlerklasse, bevor man die
Meldung ueberhaupt gelesen hat.

## Auftrag 2: PR-Gate und Branch Protection

**Ruleset** `protect-main` auf `main`:

- Require a pull request before merging (1 Approval)
- Require status checks to pass: `lint`, `test`
- Block force pushes

> Das Ruleset ist hier **dokumentiert, nicht aktiviert**: Rulesets und Branch Protection sind auf
> privaten Repositories den bezahlten GitHub-Plaenen vorbehalten, und die Kursorganisation laeuft auf
> dem Free-Plan. Die Lehrperson demonstriert die Konfiguration an einem oeffentlichen Repo.

**Roter Pull Request:** #1 — der erste Push enthielt einen absichtlich falschen Erwartungswert in
`tests/test_app.py`. Der Job `test` wurde rot und am PR erschien *Some checks were not successful*;
mit aktivem Ruleset waere der Merge-Button an dieser Stelle gesperrt gewesen. Nach dem
Korrektur-Commit im selben Branch wurde die Statuspruefung gruen, und der PR wurde mit einem
Merge-Commit gemergt (nicht Squash, nicht Rebase — sonst waere in `git log --merges` nichts
nachweisbar).

**Erkenntnis:** Ein gruener Build allein schuetzt nichts — er ist eine Information. Erst der Required
Status Check macht daraus eine Bedingung. Ohne Ruleset bleibt die Regel eine Vereinbarung, an die
sich das Team halten muss.

Zusaetzlich: `.github/pull_request_template.md` mit Review-Checkliste und `.github/CODEOWNERS`,
damit Reviews automatisch angefragt werden.

## Auftrag 3: Pipeline schneller machen

| Messung | Laufzeit `ci.yml` |
| --- | --- |
| **Vorher** (`test` mit `needs: lint`, kein Cache) | 1 min 48 s |
| **Nachher** (parallel, `cache: pip`, `concurrency`) | 42 s |

Drei Hebel:

1. **`cache: pip`** bei `actions/setup-python` — Abhaengigkeiten kommen aus dem Cache statt aus dem Netz.
2. **`needs:` entfernt** — `lint` und `test` laufen parallel; die Pipeline dauert so lange wie der
   langsamere Job, nicht wie beide zusammen.
3. **`concurrency` mit `cancel-in-progress`** — bei mehreren Pushes kurz hintereinander laeuft nur der
   neueste Stand; die ueberholten Laeufe werden abgebrochen und blockieren keine Runner mehr.

**Trade-off:** parallel laufende Jobs verbrauchen mehr Runner gleichzeitig. Bei einem Gate aus wenigen
schnellen Jobs lohnt sich das; eine lange Kette teurer Jobs wuerde man weiter staffeln.
