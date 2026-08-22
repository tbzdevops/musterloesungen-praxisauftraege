# Tag 16 – Praxis-Musterlösungen (Container-Automatisierung mit GitHub Actions)

Von der CI-Pipeline für Container-Builds über den Registry-Push bis zum Cloud-Deployment:
**CI-Build** (Übung 1), **Image-Push zu AWS ECR** (Übung 2) und **Continuous Deployment auf
AWS ECS** (Übung 3). Die Übungen bauen aufeinander auf.

| Übung | Thema | Erklärung | Lauffähiger Code |
|-------|-------|-----------|------------------|
| 📓 Übung 1 | Automatisierter Build (CI-Pipeline) | [tag16_Praxisauftrag01.md](tag16_Praxisauftrag01.md) | [uebung01-ci-build/](uebung01-ci-build/) |
| 📓 Übung 2 | Container Registry (Push zu AWS ECR) | [tag16_Praxisauftrag02.md](tag16_Praxisauftrag02.md) | Vorlage (AWS-Secrets) |
| 📓 Übung 3 | Continuous Deployment auf AWS ECS | [tag16_Praxisauftrag03.md](tag16_Praxisauftrag03.md) | Vorlage (AWS-Secrets) |

---

## Aufbau

```
tag16/
├── verify.sh                                      # lokale Selbstkontrolle
└── uebung01-ci-build/
    ├── app.py                                     # Flask "Hello, World!" (Port 8080)
    ├── requirements.txt                           # flask
    ├── Dockerfile                                 # python:3.11-slim
    └── .github/workflows/
        ├── aufgabe1.yml                           # CI-Build + Container-Test
        ├── aufgabe2.yml                           # Push zu AWS ECR (Vorlage)
        └── aufgabe3.yml                           # Deploy zu AWS ECS (Vorlage)
.github/workflows/tag16-praxis.yml                 # baut/testet Übung 1 beweisbar, validiert 2+3
```

> **Hinweis:** Die `aufgabe*.yml` im Auftrags-Ordner sind **Vorlagen** für das eigene Repo der
> Studierenden (GitHub führt nur Workflows im Wurzel-Ordner `.github/workflows/` aus). Übung 2+3
> pushen/deployen nach AWS und brauchen AWS-Secrets. Damit die Musterlösung hier beweisbar grün
> läuft, baut und testet [`.github/workflows/tag16-praxis.yml`](../.github/workflows/tag16-praxis.yml)
> das Image von Übung 1 und validiert die AWS-Vorlagen.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag16/verify.sh        # alle Übungen
bash tag16/verify.sh 1      # nur Übung 1
```

Prüft die Dateien und die Workflow-Vorlagen (YAML). Läuft Docker lokal, wird zusätzlich das
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
Übung 2/3 — AWS-Workflows (YAML)       ECR-/ECS-Vorlagen validiert
```

---

> Die Container-CI/CD des **TechStyle**-Projekts liegt im Repo `techstyle`
> (Branch `day_16_solution`), nicht hier.
