# Tag 12 – Praxis-Musterlösungen (AI in DevOps)

Die Praxis dauert **eine Lektion** und bereitet das Projekt vor: **Spec-Driven Development mit
AI** (Auftrag 1) und **Prompt Injection** (Auftrag 2). Auftrag 1 ist lauffähiger, getesteter
Python-Code; Auftrag 2 ist eine Analyseübung.

| Auftrag | Thema | Zeit | Erklärung | Lauffähiger Code |
|---------|-------|------|-----------|------------------|
| 📓 Auftrag 1 | Spec-Driven Development mit AI (Spec → AI → kritischer Review) | 25 Min | [tag12_Praxisauftrag01.md](tag12_Praxisauftrag01.md) | [discounts/validator.py](../discounts/validator.py) |
| 📓 Auftrag 2 | Prompt Injection — Angriff & Verteidigung | 15 Min | [tag12_Praxisauftrag02.md](tag12_Praxisauftrag02.md) | Analyseübung (kein Code) |

Der AI-Review-Workflow und der ADR gehören seit der Umstellung ins **Projekt** — ihre
Musterlösung liegt im Repo `techstyle`, Branch `day_12_solution`.

---

## Aufbau

Die Lösungsdateien liegen **genau dort, wo sie im eigenen Repo auch liegen müssen** — im
Wurzel-Verzeichnis:

```
specs/rabattcode.md                 # Auftrag 1: Spec zuerst
discounts/validator.py              # Auftrag 1: validate_discount_code (nach Review korrigiert)
tests/test_discount.py              # Auftrag 1: Akzeptanzkriterien + Randfälle aus dem Review
requirements.txt                    # pytest
DOKUMENTATION.md                    # Auftrag 1 + 2: Review des AI-Outputs, Prompt Injection
.github/workflows/tag12-praxis.yml  # führt die Tests von Auftrag 1 beweisbar aus
tag12/
├── README.md                       # diese Übersicht
├── verify.sh                       # lokale Selbstkontrolle
└── tag12_Praxisauftrag0X.md        # die zwei Musterlösungs-Dokumente
```

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag12/verify.sh        # beide Aufträge
bash tag12/verify.sh 1      # nur Auftrag 1
```

Legt ein Wegwerf-Venv an, installiert `pytest` und führt die Tests aus. Erwartet:

```
✅ Erfüllt:    8
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push läuft im Reiter **Actions** der Job:

```
Auftrag 1 — pytest (validate_discount_code)   pytest grün
```

---

> Die Musterlösung fürs **TechStyle**-Projekt (AI-Review-Bot, ADR, Reflexion) liegt im Repo
> `techstyle` (Branch `day_12_solution`), nicht hier.
