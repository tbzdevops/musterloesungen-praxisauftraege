# Tag 15 – Praxis-Musterlösung (DevSecOps)

DevSecOps mit **Snyk** (SCA und SAST) und **OWASP ZAP** (DAST) an der absichtlich verwundbaren Übungsanwendung **DSVPWA** (Damn Simple Vulnerable Python Web Application, <https://github.com/tbzdevops/DSVPWA>).

Die Praxis ist **Einzelarbeit** und läuft **nur lokal** mit den Tools. Sie besteht aus zwei Arbeitsphasen, die jeweils direkt auf einen Theorieblock folgen. Den Einbau in eine Pipeline machen die Gruppen anschliessend im Projekt am TechStyle-Shop (Repo `techstyle`, Branch `day_15_solution`).

| Phase | Auftrag | Zeit | Ergebnis in `findings.md` | Erklärung |
|-------|---------|------|---------------------------|-----------|
| Praxis 1 | **P0** Setup und **P1** SCA und SAST mit Snyk | 30 Min | Drei bewertete Findings | [tag15_Praxisauftrag01.md](tag15_Praxisauftrag01.md) |
| Praxis 2 | **P2** DAST mit ZAP und Fund von Hand prüfen | 20 Min | Zwei ZAP-Alerts, verifizierte SQL-Injection, Vergleich SAST / DAST | [tag15_Praxisauftrag02.md](tag15_Praxisauftrag02.md) |
| für Schnelle | **P3** Fix und Re-Scan | 10 Min | Behobene SQL-Injection | [tag15_Praxisauftrag03.md](tag15_Praxisauftrag03.md) |

---

## Aufbau

Dieser Branch entspricht einem fertig bearbeiteten Classroom-Repository (`tag15-praxis`): DSVPWA liegt im Wurzelverzeichnis, die ausgefüllte [`findings.md`](../findings.md) daneben, und der Fix aus P3 ist in [`dsvpwa/attacks.py`](../dsvpwa/attacks.py), Zeile 39, umgesetzt.

```
findings.md                         # Ergebnis von P1, P2 und P3
dsvpwa/attacks.py                   # P3: parametrisierter Query in Zeile 39
dsvpwa.py, dsvpwa/, db/, …          # DSVPWA (Original-README: DSVPWA.md)
.github/workflows/tag15-praxis.yml  # wiederholt P1–P3 im Runner
tag15/
├── README.md                       # diese Übersicht
├── verify.sh                       # lokale Selbstkontrolle
├── tag15_Praxisauftrag01.md        # P0 und P1
├── tag15_Praxisauftrag02.md        # P2
└── tag15_Praxisauftrag03.md        # P3
```

## Kernaussagen für die Besprechung

- **SCA-Findings sind echt, aber nicht erreichbar.** DSVPWA nutzt nur die Python-Standardbibliothek. Flask, PyYAML, requests usw. stehen in `requirements.txt`, werden aber nie importiert. Richtige Massnahme: Abhängigkeit entfernen, nicht ignorieren.
- **Erreichbarkeit hängt von der Konfiguration ab.** Die Command Injection (Zeile 167) läuft erst ab `--risk 3`. Sie bleibt ein echtes Risiko, weil sich die Konfiguration ändern kann.
- **Ein grüner Baseline-Scan beweist nichts über Injection-Lücken.** ZAP meldet passiv nur Header- und Cookie-Probleme. Die SQL-Injection in `/users?id=` findet erst der Test von Hand (oder ein Full-Scan).
- **SAST und DAST ergänzen sich.** SAST zeigt Datei und Zeile, DAST zeigt, was in der HTTP-Antwort tatsächlich sichtbar ist.

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag15/verify.sh        # P1, P2 und P3
bash tag15/verify.sh 2      # nur P2
```

Das Skript prüft `findings.md` mit denselben Regeln wie die Classroom-Prüfung (`praxis-day15`, `.github/classroom/checks/day-15.sh`) und kontrolliert den Fix aus P3. Erwartete Ausgabe:

```
✅ Erfüllt:    8
❌ Fehlen:     0
```

### In GitHub Actions

Nach jedem Push läuft [`tag15-praxis.yml`](../.github/workflows/tag15-praxis.yml):

| Job | Beweist |
|-----|---------|
| findings.md und Fix prüfen | `tag15/verify.sh` ist grün |
| P1/P3 — SAST (Bandit) | Zeile 39 wird im Original gemeldet, nach dem Fix nicht mehr |
| P2/P3 — SQL-Injection vorher und nachher | `id=1 OR 1=1` liefert im Original alle Benutzer, mit Fix keinen |
| P2 — DAST (OWASP ZAP Baseline) | Der Baseline-Scan läuft. Bericht als Artefakt `zap-baseline-report`, Alerts in der Job-Zusammenfassung |
| P1 — Snyk SCA und SAST (optional) | Läuft nur, wenn das Secret `SNYK_TOKEN` gesetzt ist |

---

## Voraussetzungen (für die eigene Durchführung)

- GitHub Codespace (empfohlen) oder lokal Python 3, Node.js und Docker
- Kostenloser Snyk-Account mit aktiviertem **Snyk Code** (Settings → Snyk Code)
- Snyk CLI: `npm install -g snyk`, danach `snyk auth`
