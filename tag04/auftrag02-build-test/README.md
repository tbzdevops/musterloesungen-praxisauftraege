# Auftrag 2 — Automatisierter Build und Test

**Ziel:** Eine CI-Pipeline, die bei jedem Commit die Abhängigkeiten installiert und die
Unit-Tests ausführt. Schlägt ein Test fehl, wird der Build rot.

## Ordnerstruktur

```
auftrag02-build-test/
├── app.py
├── test_app.py
├── requirements.txt
└── .github/
    └── workflows/
        └── ci-build-test.yml
```

## Die neuen Steps

| Step | Aufgabe |
|------|---------|
| `actions/setup-python@v5` | Installiert die gewünschte Python-Version im Runner. |
| `Install Dependencies` | Installiert die Pakete aus `requirements.txt` mit `pip`. |
| `Run Tests` | Startet `pytest`. Das Flag `-q` hält die Ausgabe kompakt. |

**Reihenfolge:** Checkout → Python bereitstellen → Dependencies installieren → Tests ausführen.
Jeder Step setzt voraus, dass der vorherige erfolgreich war.

`pytest` findet Testdateien (`test_*.py`) und Testfunktionen (`test_*`) automatisch.

## Erwartete Ausgabe (grüner Build)

```
1 passed in 0.01s
```

## Fehlerszenario: der rote Build

Ändere den Test absichtlich auf einen falschen Wert:

```python
def test_add():
    assert add(2, 3) == 6   # falsch: 2 + 3 ergibt 5
```

Dann schlägt der Step `Run Tests` fehl:

```
>       assert add(2, 3) == 6
E       assert 5 == 6
E        +  where 5 = add(2, 3)

test_app.py:5: AssertionError
1 failed in 0.02s
```

Der fehlerhafte Stand ist sofort sichtbar und darf nicht nach `main` gemergt werden.
Danach den Wert wieder auf `5` korrigieren — die Pipeline läuft wieder grün.

## Selbst prüfen

```bash
bash tag04/verify.sh 2
```
