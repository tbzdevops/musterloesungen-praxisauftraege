# Auftrag 3 — Erweiterte CI-Pipeline (Linter und Docker-Build)

**Ziel:** Die Pipeline aus Auftrag 2 um einen **Linter** (statische Code-Analyse) und einen
**Docker-Image-Build** (CI-Artefakt) erweitern.

## Ordnerstruktur

```
auftrag03-lint-docker/
├── app.py
├── test_app.py
├── requirements.txt
├── Dockerfile
└── .github/
    └── workflows/
        └── ci-build-test.yml
```

## Linter

`flake8` prüft den Code auf Stil-Verstösse (PEP 8) und einfache Fehler, ohne ihn auszuführen.
Der Step steht **vor** den Tests:

```yaml
- name: Run Linter
  run: flake8 .
```

Der Punkt `.` prüft alle Python-Dateien im Projekt. Findet der Linter ein Problem, endet der
Step mit Exit-Code ungleich 0 und die Pipeline wird rot.

## Dockerfile

| Anweisung | Bedeutung |
|-----------|-----------|
| `FROM python:3.10-slim` | Schlankes Basis-Image mit Python 3.10. |
| `WORKDIR /app` | Arbeitsverzeichnis im Container. |
| `COPY requirements.txt .` | Kopiert zuerst nur die Abhängigkeitsliste (Layer-Cache). |
| `RUN pip install -r requirements.txt` | Installiert die Abhängigkeiten beim Image-Bau. |
| `COPY . .` | Kopiert den restlichen Code in den Container. |
| `CMD [...]` | Standardbefehl beim Start des Containers. |

**Reihenfolge-Trick:** Erst `requirements.txt` kopieren und installieren, danach den Code. So
läuft `pip install` nur neu, wenn sich die Abhängigkeiten ändern.

## Docker-Build als Artefakt

Der Step steht **nach** den Tests:

```yaml
- name: Build Docker Image
  run: docker build -t myapp:latest .
```

Das Image ist das **CI-Artefakt** — das fertige, ausführbare Ergebnis der Pipeline.
Der `docker`-Befehl ist auf dem `ubuntu-latest`-Runner bereits vorinstalliert.

## Erwartete Reihenfolge im Lauf

```
Checkout → Setup Python → Install Dependencies → Run Linter → Run Tests → Build Docker Image
```

Alle Schritte laufen nacheinander; jeder muss erfolgreich sein, sonst stoppt die Pipeline.

## Selbst prüfen

```bash
bash tag04/verify.sh 3
```

Ohne lokal installiertes Docker wird der Image-Build übersprungen — in GitHub Actions
(`.github/workflows/tag04-praxis.yml`) läuft er trotzdem.
