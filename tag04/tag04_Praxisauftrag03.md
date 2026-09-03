# Musterlösung: Erweiterte CI-Pipeline (Linter und Docker-Build)

**Ziel:** Die Pipeline aus Auftrag 2 um einen **Linter** (statische Code-Analyse) und einen
**Docker-Image-Build** (CI-Artefakt) erweitern.

Online-Beispiellösung: <https://github.com/tbzdevops/ci-hello-world>

---

## 1. Projektstruktur

Gegenüber Auftrag 2 kommen `Dockerfile` und eine erweiterte `requirements.txt` hinzu:

```
<classroom-repo>/
├── app.py
├── test_app.py
├── requirements.txt
├── Dockerfile
└── .github/
    └── workflows/
        └── ci-build-test.yml
```

---

## 2. Linter ergänzen

**`requirements.txt`**
```
pytest
flake8
```

`flake8` ist ein verbreiteter Python-Linter. Er prüft den Code auf Stil-Verstösse (PEP 8) und
einfache Fehler, ohne ihn auszuführen.

**Linter-Step im Workflow** – wird **vor** den Tests eingefügt:
```yaml
- name: Run Linter
  run: flake8 .
```

Der Punkt `.` lässt `flake8` alle Python-Dateien im Projekt prüfen. Findet der Linter ein Problem,
bricht der Step mit Exit-Code ungleich 0 ab und die Pipeline wird rot.

---

## 3. Dockerfile erstellen

**`Dockerfile`**
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

| Anweisung | Bedeutung |
|-----------|-----------|
| `FROM python:3.10-slim` | Schlankes Basis-Image mit vorinstalliertem Python 3.10. |
| `WORKDIR /app` | Setzt das Arbeitsverzeichnis im Container. |
| `COPY requirements.txt .` | Kopiert zuerst nur die Abhängigkeitsliste (nutzt den Docker-Layer-Cache). |
| `RUN pip install -r requirements.txt` | Installiert die Abhängigkeiten beim Image-Bau. |
| `COPY . .` | Kopiert den restlichen Code in den Container. |
| `CMD [...]` | Standardbefehl, der beim Start des Containers ausgeführt wird. |

**Reihenfolge-Trick:** Zuerst `requirements.txt` kopieren und installieren, danach den Code. So
muss `pip install` nur neu laufen, wenn sich die Abhängigkeiten ändern – das beschleunigt
wiederholte Builds.

---

## 4. Docker-Build im Workflow

**Docker-Build-Step** – wird **nach** den Tests eingefügt:
```yaml
- name: Build Docker Image
  run: docker build -t myapp:latest .
```

Der Befehl baut ein Image mit dem Tag `myapp:latest`. Das Image ist das **CI-Artefakt** – das
fertige, ausführbare Ergebnis der Pipeline, das später deployt werden könnte.

---

## 5. Vollständiger Workflow

**`.github/workflows/ci-build-test.yml`**
```yaml
name: Build, Lint and Docker

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
      - name: Run Linter
        run: flake8 .
      - name: Run Tests
        run: pytest -q
      - name: Build Docker Image
        run: docker build -t myapp:latest .
```

---

## 6. Erwartete Reihenfolge im Lauf

Alle Schritte laufen nacheinander; jeder muss erfolgreich sein, sonst stoppt die Pipeline:

```
Checkout  →  Setup Python  →  Install Dependencies  →  Run Linter  →  Run Tests  →  Build Docker Image
```

Auszug aus einem erfolgreichen Lauf:
```
Run Linter
0   (keine Beanstandungen von flake8)

Run Tests
1 passed in 0.01s

Build Docker Image
Successfully tagged myapp:latest
```

> Hinweis: Der `docker`-Befehl ist auf dem `ubuntu-latest`-Runner bereits vorinstalliert – es ist
> kein zusätzliches Setup nötig.

---

## 7. Erkenntnis

- Der **Linter** erzwingt einheitliche Code-Qualität, bevor überhaupt getestet wird.
- Das **Docker-Image** ist das greifbare CI-Artefakt am Ende der Pipeline.
- Damit deckt die Pipeline den vollständigen CI-Ablauf ab: integrieren → prüfen → testen →
  Artefakt erzeugen. Im Projekt-Block (TechStyle) wird genau diese Struktur auf eine reale
  Flask-Anwendung übertragen.
