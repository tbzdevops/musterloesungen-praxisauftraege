# Tag 13 – Praxis-Musterlösungen (AI in DevOps)

AI entlang der DevOps-Kette: **AI-Assisted Development** (Auftrag 1), **Spec-Driven Development
& ADR** (Auftrag 2), **AI in der CI/CD-Pipeline** (Auftrag 3) und **Prompt Injection** (Auftrag 4).
Aufträge 1 und 2 sind lauffähiger, getesteter Python-Code; Auftrag 3 ist eine
GitHub-Actions-Vorlage; Auftrag 4 ist eine Analyse-/Diskussionsübung.

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | AI-Assisted Development (Code kritisch prüfen) | [tag13_Praxisauftrag01.md](tag13_Praxisauftrag01.md) | [auftrag01-ai-assisted/](auftrag01-ai-assisted/) |
| 📓 Auftrag 2 | Spec-Driven Development & ADR | [tag13_Praxisauftrag02.md](tag13_Praxisauftrag02.md) | [auftrag02-spec-adr/](auftrag02-spec-adr/) |
| 📓 Auftrag 3 | AI in der CI/CD-Pipeline (PR-Feedback) | [tag13_Praxisauftrag03.md](tag13_Praxisauftrag03.md) | [auftrag03-ai-cicd/](auftrag03-ai-cicd/) |
| 📓 Auftrag 4 | Prompt Injection — Angriff & Verteidigung | [tag13_Praxisauftrag04.md](tag13_Praxisauftrag04.md) | Analyseübung (kein Code) |

---

## Aufbau

```
tag13/
├── verify.sh                                   # lokale Selbstkontrolle
├── auftrag01-ai-assisted/
│   ├── utils/validators.py                     # validate_email (AI-Entwurf + Review)
│   ├── tests/test_validators.py
│   └── requirements.txt
├── auftrag02-spec-adr/
│   ├── specs/rabattcode.md                     # Spec zuerst
│   ├── discounts/validator.py                  # validate_discount_code
│   ├── tests/test_discount.py                  # Akzeptanzkriterien als Tests
│   ├── docs/adr/0001-rabattcode-validierung.md # Architecture Decision Record
│   └── requirements.txt
└── auftrag03-ai-cicd/
    └── .github/workflows/ai-review.yml         # AI-Review-Workflow (Vorlage)
.github/workflows/tag13-praxis.yml              # führt Auftrag 1+2 (pytest) beweisbar aus
```

> **Hinweis:** GitHub führt nur Workflows im Wurzel-Ordner `.github/workflows/` aus. `ai-review.yml`
> im Auftrags-Ordner ist deshalb eine **Vorlage** fürs eigene Repo. Damit die Musterlösungen hier
> beweisbar grün laufen, führt [`.github/workflows/tag13-praxis.yml`](../.github/workflows/tag13-praxis.yml)
> die Tests von Auftrag 1+2 aus und validiert die Vorlage.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag13/verify.sh        # alle Aufträge
bash tag13/verify.sh 2      # nur Auftrag 2
```

Legt pro Auftrag ein Wegwerf-Venv an, installiert `pytest` und führt die Tests aus. Erwartet:

```
✅ Erfüllt:    8
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push laufen im Reiter **Actions** drei Jobs:

```
Auftrag 1 — AI-Assisted (validate_email)          pytest grün
Auftrag 2 — Spec-Driven (validate_discount_code)  pytest grün
Auftrag 3 — AI-Review-Workflow (YAML)             Vorlage validiert
```

---

> Die AI-/DevSecOps-Themen fürs **TechStyle**-Projekt liegen im Repo `techstyle`
> (Branch `day_13_solution`), nicht hier.
