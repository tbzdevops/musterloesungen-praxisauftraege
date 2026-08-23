# Tag 13 – Praxis-Musterlösungen (AI in DevOps)

AI entlang der DevOps-Kette: **AI-Assisted Development** (Auftrag 1), **Spec-Driven Development
& ADR** (Auftrag 2), **AI in der CI/CD-Pipeline** (Auftrag 3) und **Prompt Injection** (Auftrag 4).
Aufträge 1 und 2 sind lauffähiger, getesteter Python-Code; Auftrag 3 ist eine
GitHub-Actions-Vorlage; Auftrag 4 ist eine Analyse-/Diskussionsübung.

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | AI-Assisted Development (Code kritisch prüfen) | [tag13_Praxisauftrag01.md](tag13_Praxisauftrag01.md) | [utils/validators.py](../utils/validators.py) |
| 📓 Auftrag 2 | Spec-Driven Development & ADR | [tag13_Praxisauftrag02.md](tag13_Praxisauftrag02.md) | [discounts/validator.py](../discounts/validator.py) |
| 📓 Auftrag 3 | AI in der CI/CD-Pipeline (PR-Feedback) | [tag13_Praxisauftrag03.md](tag13_Praxisauftrag03.md) | [.github/workflows/ai-review.yml](../.github/workflows/ai-review.yml) |
| 📓 Auftrag 4 | Prompt Injection — Angriff & Verteidigung | [tag13_Praxisauftrag04.md](tag13_Praxisauftrag04.md) | Analyseübung (kein Code) |

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis bzw. in `.github/workflows/`:

```
utils/validators.py                             # Auftrag 1: validate_email (AI-Entwurf + Review)
tests/test_validators.py                        # Auftrag 1: pytest-Tests
specs/rabattcode.md                             # Auftrag 2: Spec zuerst
discounts/validator.py                          # Auftrag 2: validate_discount_code
tests/test_discount.py                          # Auftrag 2: Akzeptanzkriterien als Tests
docs/adr/0001-rabattcode-validierung.md         # Auftrag 2: Architecture Decision Record
requirements.txt                                # pytest
.github/workflows/
├── ai-review.yml                               # Auftrag 3: AI-Review bei Pull Requests
└── tag13-praxis.yml                            # führt Auftrag 1+2 (pytest) beweisbar aus
DOKUMENTATION.md                                # Auftrag 4: Prompt Injection
tag13/
├── README.md                                   # diese Übersicht
├── verify.sh                                   # lokale Selbstkontrolle
└── tag13_Praxisauftrag0X.md                    # die vier Musterlösungs-Dokumente
```

> **Hinweis:** `ai-review.yml` reagiert auf `pull_request` und braucht einen offenen PR — auf
> einem reinen Push läuft er deshalb nicht an. Damit die Musterlösungen trotzdem beweisbar grün
> sind, führt [`.github/workflows/tag13-praxis.yml`](../.github/workflows/tag13-praxis.yml)
> die Tests von Auftrag 1+2 aus und validiert `ai-review.yml`.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag13/verify.sh        # alle Aufträge
bash tag13/verify.sh 2      # nur Auftrag 2
```

Legt ein Wegwerf-Venv an, installiert `pytest` und führt die Tests der Aufträge aus. Erwartet:

```
✅ Erfüllt:    9
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push laufen im Reiter **Actions** zwei Jobs:

```
Auftrag 1+2 — pytest (validate_email, validate_discount_code)   pytest grün
Auftrag 3 — AI-Review-Workflow (YAML)                           Workflow validiert
```

---

> Die AI-/DevSecOps-Themen fürs **TechStyle**-Projekt liegen im Repo `techstyle`
> (Branch `day_13_solution`), nicht hier.
