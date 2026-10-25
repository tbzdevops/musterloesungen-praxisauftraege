# Tag 14 – Praxis-Musterlösung (Automatisierter Container-Build mit GitHub Actions)

Eine CI-Pipeline für ein Container-Image: Bei jedem Push wird das Image gebaut, der Container
gestartet und per HTTP getestet. Registry-Push (AWS ECR) und Deployment (AWS EC2) gehören zum
Projektauftrag und liegen im Repo `techstyle` (Branch `day_14_solution`).

| Übung | Thema | Erklärung | Lauffähiger Code |
|-------|-------|-----------|------------------|
| 📓 Übung | Automatisierter Build (CI-Pipeline) | [tag14_Praxisauftrag01.md](tag14_Praxisauftrag01.md) | [.github/workflows/aufgabe1.yml](../.github/workflows/aufgabe1.yml) |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen**, im
Wurzel-Verzeichnis bzw. in `.github/workflows/`:

```
app.py                                             # Flask "Hello, World!" (Port 8080)
requirements.txt                                   # flask
Dockerfile                                         # python:3.11-slim
.github/workflows/
├── aufgabe1.yml                                   # CI-Build + Container-Test
└── tag14-praxis.yml                               # führt den Build hier beweisbar aus
DOKUMENTATION.md                                   # Antworten auf die drei Fragen
tag14/
├── README.md                                      # diese Übersicht
├── verify.sh                                      # lokale Selbstkontrolle
└── tag14_Praxisauftrag01.md                       # Musterlösungs-Dokument
```

> **Hinweis:** `aufgabe1.yml` ist auf `branches: [ "main" ]` begrenzt. Im eigenen Repo ist
> `main` der Default-Branch und der Workflow startet bei jedem Push; auf diesem
> Musterlösungs-Branch läuft er deshalb nicht an. Damit die Musterlösung hier trotzdem
> beweisbar grün läuft, baut und testet
> [`.github/workflows/tag14-praxis.yml`](../.github/workflows/tag14-praxis.yml) das Image.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag14/verify.sh
```

Prüft die Dateien und den Workflow (YAML). Läuft Docker lokal, wird zusätzlich das Image
gebaut, der Container gestartet und die HTTP-Antwort getestet; sonst laufen diese Schritte in
GitHub Actions. Erwartet (mit Docker):

```
✅ Erfüllt:    7
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push läuft im Reiter **Actions** der Job:

```
CI-Build (Image + Test)      Image bauen + Container-HTTP-Test
```

---

> Die Container-CI/CD des **TechStyle**-Projekts (ECR-Push und EC2-Deployment) liegt im Repo
> `techstyle` (Branch `day_14_solution`), nicht hier.
