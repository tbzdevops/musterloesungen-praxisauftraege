# Tag 15 – Praxis-Musterlösungen (Docker Basics)

Container-Grundlagen mit Docker: erster Container (Übung 1), **eigenes Image** bauen und starten
(Übung 2) und ein **Docker-Compose-Stack** aus zwei Containern (Übung 3). Die Übungen bauen
aufeinander auf; alles läuft lokal, ohne kostenpflichtige Cloud-Dienste.

| Übung | Thema | Erklärung | Lauffähiger Code |
|-------|-------|-----------|------------------|
| 📓 Übung 1 | Hallo Docker! (erster Container) | [tag15_Praxisauftrag01.md](tag15_Praxisauftrag01.md) | reine CLI-Übung |
| 📓 Übung 2 | Eigenes Container-Image bauen | [tag15_Praxisauftrag02.md](tag15_Praxisauftrag02.md) | [Dockerfile](../Dockerfile) + [app.py](../app.py) |
| 📓 Übung 3 | Microservices mit Docker Compose | [tag15_Praxisauftrag03.md](tag15_Praxisauftrag03.md) | [docker-compose.yml](../docker-compose.yml) |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis. Übung 3 baut auf dem Image aus Übung 2 auf und nutzt dasselbe
`Dockerfile` und `app.py`:

```
app.py                                     # Übung 2: Hello-Docker-Webserver (stdlib, Port 8080)
Dockerfile                                 # Übung 2: python:3.11-slim
docker-compose.yml                         # Übung 3: web + redis
.github/workflows/tag15-praxis.yml         # baut/startet/testet Übung 2+3 beweisbar
DOKUMENTATION.md                           # Übung 1: Befehle und Beobachtungen
tag15/
├── README.md                              # diese Übersicht
├── verify.sh                              # lokale Selbstkontrolle
└── tag15_Praxisauftrag0X.md               # die drei Musterlösungs-Dokumente
```

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag15/verify.sh        # alle Übungen
bash tag15/verify.sh 2      # nur Übung 2
```

Prüft die Dateien und — wenn Docker lokal läuft — baut das Image, startet den Container und
testet die HTTP-Antwort bzw. den Compose-Stack. Ohne Docker werden die Build-/Run-Schritte
übersprungen (sie laufen dann in GitHub Actions). Erwartet (mit Docker):

```
✅ Erfüllt:    10
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push laufen im Reiter **Actions** zwei Jobs (Docker ist auf den Runnern
vorinstalliert):

```
Übung 2 — Eigenes Container-Image      Image bauen + Container-HTTP-Test
Übung 3 — Docker Compose (web + redis) Stack starten + web-HTTP + redis-PING
```

---

> Die Containerisierung des **TechStyle**-Projekts liegt im Repo `techstyle`
> (Branch `day_15_solution`), nicht hier.
