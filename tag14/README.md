# Tag 14 – Praxis-Musterlösungen (Container-Automatisierung mit GitHub Actions)

Von der CI-Pipeline für Container-Builds über den Registry-Push bis zum Cloud-Deployment:
**CI-Build** (Übung 1), **Image-Push zu AWS ECR** (Übung 2) und **Continuous Deployment auf
AWS ECS** (Übung 3). Die Übungen bauen aufeinander auf.

| Übung | Thema | Erklärung | Lauffähiger Code |
|-------|-------|-----------|------------------|
| 📓 Übung 1 | Automatisierter Build (CI-Pipeline) | [tag14_Praxisauftrag01.md](tag14_Praxisauftrag01.md) | [.github/workflows/aufgabe1.yml](../.github/workflows/aufgabe1.yml) |
| 📓 Übung 2 | Container Registry (Push zu AWS ECR) | [tag14_Praxisauftrag02.md](tag14_Praxisauftrag02.md) | [.github/workflows/aufgabe2.yml](../.github/workflows/aufgabe2.yml) |
| 📓 Übung 3 | Continuous Deployment auf AWS ECS | [tag14_Praxisauftrag03.md](tag14_Praxisauftrag03.md) | [.github/workflows/aufgabe3.yml](../.github/workflows/aufgabe3.yml) |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis bzw. in `.github/workflows/`:

```
app.py                                             # Flask "Hello, World!" (Port 8080)
requirements.txt                                   # flask
Dockerfile                                         # python:3.11-slim
.github/workflows/
├── aufgabe1.yml                                   # Übung 1: CI-Build + Container-Test
├── aufgabe2.yml                                   # Übung 2: Push zu AWS ECR
├── aufgabe3.yml                                   # Übung 3: Deploy zu AWS ECS
└── tag14-praxis.yml                               # baut/testet Übung 1 beweisbar, validiert 2+3
DOKUMENTATION.md                                   # Übung 1-3: Pipeline-Doku
tag14/
├── README.md                                      # diese Übersicht
├── verify.sh                                      # lokale Selbstkontrolle
└── tag14_Praxisauftrag0X.md                       # die drei Musterlösungs-Dokumente
```

> **Hinweis:** Die drei `aufgabe*.yml` sind auf `branches: [ "main" ]` begrenzt. Im eigenen Repo
> ist `main` der Default-Branch und sie starten bei jedem Push; auf diesem Musterlösungs-Branch
> laufen sie deshalb nicht an — Übung 2 und 3 brauchen ausserdem AWS-Secrets. Damit die
> Musterlösung hier trotzdem beweisbar grün läuft, baut und testet
> [`.github/workflows/tag14-praxis.yml`](../.github/workflows/tag14-praxis.yml) das Image von
> Übung 1 und validiert die AWS-Workflows.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag14/verify.sh        # alle Übungen
bash tag14/verify.sh 1      # nur Übung 1
```

Prüft die Dateien und die Workflows (YAML). Läuft Docker lokal, wird zusätzlich das
Image gebaut, der Container gestartet und die HTTP-Antwort getestet; sonst laufen diese Schritte
in GitHub Actions. Erwartet (mit Docker):

```
✅ Erfüllt:    10
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push laufen im Reiter **Actions** zwei Jobs:

```
Übung 1 — CI-Build (Image + Test)      Image bauen + Container-HTTP-Test
Übung 2/3 — AWS-Workflows (YAML)       ECR-/ECS-Workflows validiert
```

---

> Die Container-CI/CD des **TechStyle**-Projekts liegt im Repo `techstyle`
> (Branch `day_14_solution`), nicht hier.
