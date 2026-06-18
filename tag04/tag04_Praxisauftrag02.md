# Musterlösung: Automatisierter Build und Test

**Ziel:** Eine CI-Pipeline aufbauen, die bei jedem Commit den Code installiert und die Unit-Tests
ausführt. Bei einem fehlschlagenden Test soll der Build rot werden.

---

## 1. Projektstruktur

```
ci-build-test/
├── app.py
├── test_app.py
├── requirements.txt
└── .github/
    └── workflows/
        └── ci-build-test.yml
```

---

## 2. Die Anwendung

**`app.py`**
```python
def add(a, b):
    """Gibt die Summe von a und b zurück."""
    return a + b
```

---

## 3. Der Test

**`test_app.py`**
```python
from app import add


def test_add():
    assert add(2, 3) == 5
    assert add(0, 0) == 0
```

Der Test importiert die Funktion `add` und prüft mit `assert`, ob sie die erwarteten Resultate
liefert. `pytest` findet Testdateien (`test_*.py`) und Testfunktionen (`test_*`) automatisch.

---

## 4. Abhängigkeiten

**`requirements.txt`**
```
pytest
```

So weiss die Pipeline, welche Pakete installiert werden müssen. Hier reicht `pytest` als
Test-Framework.

---

## 5. Der Workflow

**`.github/workflows/ci-build-test.yml`**
```yaml
name: Build and Test

on: [push]

jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.10"
      - name: Install Dependencies
        run: pip install -r requirements.txt
      - name: Run Tests
        run: pytest -q
```

### Erklärung der neuen Schritte

| Step | Aufgabe |
|------|---------|
| `actions/setup-python@v5` | Installiert die gewünschte Python-Version im Runner. `with: python-version` legt die Version fest. |
| `Install Dependencies` | Installiert die in `requirements.txt` aufgeführten Pakete mit `pip`. |
| `Run Tests` | Startet `pytest`. Das Flag `-q` (quiet) hält die Ausgabe kompakt. |

**Reihenfolge ist wichtig:** Checkout → Python bereitstellen → Dependencies installieren →
Tests ausführen. Jeder Step setzt voraus, dass der vorherige erfolgreich war.

---

## 6. Der grüne Build

```bash
git add .
git commit -m "Add build and test pipeline"
git push
```

Im Actions-Reiter erscheint der Job `build-test` mit grünem Haken. Auszug aus dem Log:

```
collected 1 item

test_app.py .                                                    [100%]

1 passed in 0.01s
```

---

## 7. Fehlerszenario: der rote Build

Um zu sehen, wie CI Fehler aufdeckt, wird der Test absichtlich falsch gemacht:

```python
def test_add():
    assert add(2, 3) == 6   # falsch: 2 + 3 ergibt 5, nicht 6
```

Nach `commit` und `push` schlägt der Step `Run Tests` fehl, der Job wird **rot**:

```
>       assert add(2, 3) == 6
E       assert 5 == 6
E        +  where 5 = add(2, 3)

test_app.py:5: AssertionError
1 failed in 0.02s
```

GitHub zeigt ein rotes Kreuz und benachrichtigt die verantwortlichen Entwickler. Der fehlerhafte
Stand ist sofort sichtbar und darf nicht nach `main` gemergt werden.

### Korrektur

```python
def test_add():
    assert add(2, 3) == 5   # korrigiert
```

Nach erneutem Push läuft die Pipeline wieder grün.

---

## 8. Erkenntnis

- Die Pipeline gibt **automatisches, schnelles Feedback** bei jedem Commit.
- Ein roter Build verhindert, dass fehlerhafter Code unbemerkt im Hauptbranch landet.
- Genau dieses Prinzip wird im Projekt-Block auf den TechStyle Online-Shop angewendet.
