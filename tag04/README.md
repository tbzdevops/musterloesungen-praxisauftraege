# Tag 04 – Praxis-Musterlösungen

Continuous Integration mit GitHub Actions: Die drei Praxis-Aufträge bauen schrittweise eine
CI-Pipeline auf. Jeder Auftrag erweitert den vorherigen, sodass am Ende eine vollständige Pipeline
mit Checkout, Python-Setup, Linter, automatisierten Tests und Docker-Image-Build steht.

Die Aufträge sind **aufeinander abgestimmt**: Auftrag 1 liefert den ersten lauffähigen Workflow,
Auftrag 2 ergänzt Build und Tests, Auftrag 3 fügt Linter und Docker-Build hinzu.

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | Erste Schritte mit GitHub Actions (Hello CI) | [tag04_Praxisauftrag01.md](tag04_Praxisauftrag01.md) | [auftrag01-hello-ci/](auftrag01-hello-ci/) |
| 📓 Auftrag 2 | Automatisierter Build und Test | [tag04_Praxisauftrag02.md](tag04_Praxisauftrag02.md) | [auftrag02-build-test/](auftrag02-build-test/) |
| 📓 Auftrag 3 | Erweiterte CI-Pipeline (Linter und Docker-Build) | [tag04_Praxisauftrag03.md](tag04_Praxisauftrag03.md) | [auftrag03-lint-docker/](auftrag03-lint-docker/) |

---

## Aufbau

Jeder `auftragXX-*/`-Ordner ist ein **vollständiges Mini-Repository** zum Vergleichen oder
Kopieren — inklusive der Workflow-Datei an der richtigen Stelle:

```
tag04/
├── verify.sh                                  # lokale Selbstkontrolle
├── auftrag01-hello-ci/
│   └── .github/workflows/hello-ci.yml
├── auftrag02-build-test/
│   ├── app.py
│   ├── test_app.py
│   ├── requirements.txt
│   └── .github/workflows/ci-build-test.yml
└── auftrag03-lint-docker/
    ├── app.py
    ├── test_app.py
    ├── requirements.txt
    ├── Dockerfile
    └── .github/workflows/ci-build-test.yml
```

> **Hinweis:** GitHub führt nur Workflows aus dem Wurzel-Ordner `.github/workflows/` eines
> Repositories aus. Die Workflow-Dateien in den Auftrags-Ordnern sind deshalb **Vorlagen** für
> das eigene Repo der Studierenden. Damit die Musterlösungen hier trotzdem beweisbar grün laufen,
> führt [`.github/workflows/tag04-praxis.yml`](../.github/workflows/tag04-praxis.yml) im Wurzel
> des Repos alle drei Aufträge als eigene Jobs aus.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag04/verify.sh        # alle drei Aufträge
bash tag04/verify.sh 2      # nur Auftrag 2
```

Das Skript legt pro Auftrag ein Wegwerf-Venv an, installiert `requirements.txt` und führt
dieselben Schritte aus wie die Pipeline — Linter, Tests und (falls Docker lokal läuft) den
Image-Build. Erwartete Ausgabe:

```
✅ Erfüllt:    9
❌ Fehlen:     0
```

Schlägt ein Schritt fehl, gibt das Skript die vollständige Fehlermeldung aus und endet mit
Exit-Code 1 — genau wie ein roter Build in GitHub Actions.

### In GitHub Actions

Nach einem Push auf dieses Repo läuft `tag04-praxis.yml` automatisch. Im Reiter **Actions**
erscheinen drei Jobs:

```
Auftrag 1 — Hello CI
Auftrag 2 — Build und Test
Auftrag 3 — Linter und Docker-Build
```

### Den roten Build selbst ausprobieren

Der Lerneffekt aus Auftrag 2 lässt sich direkt nachstellen:

```bash
# In auftrag02-build-test/test_app.py: assert add(2, 3) == 6  (statt 5)
bash tag04/verify.sh 2      # -> ❌ und Exit-Code 1
```

Danach den Wert wieder auf `5` setzen — die Prüfung läuft wieder grün.

---

> Die CI-Pipeline für den TechStyle Online-Shop ist Teil des **Projekt-Blocks** und liegt im Repo
> `techstyle` (Branch `day_4_solution`, `docs/DAY_4_COMPLETION.md`), nicht hier.
>
> Online-Beispiellösung: <https://github.com/tbzdevops/ci-hello-world>
