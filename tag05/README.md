# Tag 05 – Praxis-Musterlösungen

Vertrauenswürdige Pipelines: Die drei Praxis-Aufträge machen aus der CI-Pipeline von Tag 04 ein
Gate, das den `main`-Branch schützt — und das schnell genug ist, um nicht umgangen zu werden.

Die Aufträge bauen **aufeinander auf**: Auftrag 1 repariert vier kaputte Workflows und übt das Lesen
von Actions-Logs, Auftrag 2 baut daraus das PR-Gate `ci.yml`, Auftrag 3 optimiert genau dieses
`ci.yml`.

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | Broken Pipeline Challenge | [tag05_Praxisauftrag01.md](tag05_Praxisauftrag01.md) | [a1-hello.yml](../.github/workflows/a1-hello.yml), [a2-actions.yml](../.github/workflows/a2-actions.yml), [a3-deps.yml](../.github/workflows/a3-deps.yml), [a4-tests.yml](../.github/workflows/a4-tests.yml) |
| 📓 Auftrag 2 | PR-Gate und Branch Protection | [tag05_Praxisauftrag02.md](tag05_Praxisauftrag02.md) | [ci.yml](../.github/workflows/ci.yml) + [pull_request_template.md](../.github/pull_request_template.md), [CODEOWNERS](../.github/CODEOWNERS) |
| 📓 Auftrag 3 | Pipeline schneller machen | [tag05_Praxisauftrag03.md](tag05_Praxisauftrag03.md) | dasselbe `ci.yml`, um Cache, Parallelisierung und `concurrency` erweitert |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis bzw. in `.github/`. GitHub führt nur Workflows aus `.github/workflows/` aus;
deshalb gibt es hier keine Unterordner pro Auftrag.

```
.github/workflows/
├── a1-hello.yml            # Auftrag 1, Bug 1 behoben (YAML-Einrückung)
├── a2-actions.yml          # Auftrag 1, Bug 2 behoben (Action-Name)
├── a3-deps.yml             # Auftrag 1, Bug 3 behoben (requirements.txt)
├── a4-tests.yml            # Auftrag 1, Bug 4 behoben (working-directory)
└── ci.yml                  # Auftrag 2, in Auftrag 3 optimiert
.github/pull_request_template.md   # Auftrag 2
.github/CODEOWNERS                 # Auftrag 2
DOKUMENTATION.md            # der schriftliche Teil aller drei Aufträge
app.py, tests/, conftest.py # gegeben, unverändert
requirements.txt            # Auftrag 1 Bug 3: pytest ergänzt
tag05/
├── README.md               # diese Übersicht
├── verify.sh               # lokale Selbstkontrolle
└── tag05_Praxisauftrag0X.md  # die drei Musterlösungs-Dokumente
```

> **Auftrag 3 überschreibt Auftrag 2 bewusst.** `ci.yml` liegt hier im Endzustand vor (parallel, mit
> Cache und `concurrency`). Der Zwischenstand mit `needs: lint` ist in
> [tag05_Praxisauftrag02.md](tag05_Praxisauftrag02.md) dokumentiert.

---

## Lokale Selbstkontrolle

```bash
bash tag05/verify.sh        # alle Aufträge
bash tag05/verify.sh 2      # nur Auftrag 2
```

Das Skript prüft dieselben Punkte wie die Abnahmekriterien im Classroom-Repo, aber ohne Push.

---

## Was in dieser Musterlösung nicht abgebildet werden kann

Zwei Dinge sind Zustände auf GitHub, keine Dateien im Repo, und stehen deshalb nur in der
Dokumentation:

- **Das Ruleset auf `main`.** Rulesets sind auf privaten Repositories den bezahlten GitHub-Plänen
  vorbehalten; die Kursorganisation läuft auf dem Free-Plan. Die Konfiguration ist in
  [tag05_Praxisauftrag02.md](tag05_Praxisauftrag02.md) als Tabelle festgehalten.
- **Die gemessenen Laufzeiten.** Die Zahlen in [DOKUMENTATION.md](../DOKUMENTATION.md) stammen aus
  einem konkreten Lauf und schwanken je nach Auslastung der GitHub-Runner.
