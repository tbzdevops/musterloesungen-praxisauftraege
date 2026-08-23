# Tag 04 – Praxis-Musterlösungen

Continuous Integration mit GitHub Actions: Die drei Praxis-Aufträge bauen schrittweise eine
CI-Pipeline auf. Jeder Auftrag erweitert den vorherigen, sodass am Ende eine vollständige Pipeline
mit Checkout, Python-Setup, Linter, automatisierten Tests und Docker-Image-Build steht.

Die Aufträge sind **aufeinander abgestimmt**: Auftrag 1 liefert den ersten lauffähigen Workflow,
Auftrag 2 ergänzt Build und Tests, Auftrag 3 fügt Linter und Docker-Build hinzu.

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | Erste Schritte mit GitHub Actions (Hello CI) | [tag04_Praxisauftrag01.md](tag04_Praxisauftrag01.md) | [.github/workflows/hello-ci.yml](../.github/workflows/hello-ci.yml) |
| 📓 Auftrag 2 | Automatisierter Build und Test | [tag04_Praxisauftrag02.md](tag04_Praxisauftrag02.md) | [.github/workflows/ci-build-test.yml](../.github/workflows/ci-build-test.yml) + [app.py](../app.py), [test_app.py](../test_app.py) |
| 📓 Auftrag 3 | Erweiterte CI-Pipeline (Linter und Docker-Build) | [tag04_Praxisauftrag03.md](tag04_Praxisauftrag03.md) | derselbe Workflow, erweitert um `flake8` und [Dockerfile](../Dockerfile) |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis bzw. in `.github/workflows/`. GitHub führt nur Workflows aus dem
Wurzel-Ordner `.github/workflows/` aus; deshalb gibt es hier keine Unterordner pro Auftrag.

```
.github/workflows/
├── hello-ci.yml            # Auftrag 1
└── ci-build-test.yml       # Auftrag 2, in Auftrag 3 um Linter + Docker-Build erweitert
app.py                      # Auftrag 2: Funktion add()
test_app.py                 # Auftrag 2: pytest-Testfall
requirements.txt            # Auftrag 2: pytest — Auftrag 3 ergänzt flake8
Dockerfile                  # Auftrag 3: CI-Artefakt
tag04/
├── README.md               # diese Übersicht
├── verify.sh               # lokale Selbstkontrolle
└── tag04_Praxisauftrag0X.md  # die drei Musterlösungs-Dokumente
```

> **Auftrag 3 überschreibt Auftrag 2 bewusst.** Der Workflow `ci-build-test.yml` liegt hier im
> Endzustand vor (mit `flake8` und `docker build`). Der Zwischenstand aus Auftrag 2 ist in
> [tag04_Praxisauftrag02.md](tag04_Praxisauftrag02.md) dokumentiert.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag04/verify.sh        # alle drei Aufträge
bash tag04/verify.sh 2      # nur Auftrag 2
```

Das Skript legt ein Wegwerf-Venv an, installiert `requirements.txt` und führt dieselben Schritte
aus wie die Pipeline — Linter, Tests und (falls Docker lokal läuft) den Image-Build. Erwartete
Ausgabe:

```
✅ Erfüllt:    14
❌ Fehlen:     0
```

Schlägt ein Schritt fehl, gibt das Skript die vollständige Fehlermeldung aus und endet mit
Exit-Code 1 — genau wie ein roter Build in GitHub Actions.

### In GitHub Actions

Die Musterlösungs-Workflows laufen hier **selbst** — es gibt keinen separaten Hilfs-Workflow
mehr. Nach einem Push erscheinen im Reiter **Actions** zwei Läufe:

```
Hello CI Workflow        Auftrag 1
Build, Lint and Docker   Auftrag 2 + 3
```

### Den roten Build selbst ausprobieren

Der Lerneffekt aus Auftrag 2 lässt sich direkt nachstellen:

```bash
# In test_app.py: assert add(2, 3) == 6  (statt 5)
bash tag04/verify.sh 2      # -> ❌ und Exit-Code 1
```

Danach den Wert wieder auf `5` setzen — die Prüfung läuft wieder grün.

---

> Die CI-Pipeline für den TechStyle Online-Shop ist Teil des **Projekt-Blocks** und liegt im Repo
> `techstyle` (Branch `day_4_solution`, `docs/DAY_4_COMPLETION.md`), nicht hier.
>
> Online-Beispiellösung: <https://github.com/tbzdevops/ci-hello-world>
