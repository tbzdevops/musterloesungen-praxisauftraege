# Tag 12 – Praxis-Musterlösungen (DevSecOps)

DevSecOps mit **Snyk** (SAST/SCA) und **OWASP ZAP** (DAST). Die drei Praxis-Aufträge bauen
aufeinander auf: Zuerst wird der ruhende Code statisch geprüft (Auftrag 1), dann die laufende
Anwendung dynamisch getestet (Auftrag 2), und schliesslich werden beide Prüfungen in eine
GitHub-Actions-Pipeline automatisiert (Auftrag 3).

Als Übungsobjekt dient die absichtlich verwundbare Anwendung **DSVPWA** (Damn Simple Vulnerable
Python Web Application): <https://github.com/tbzdevops/DSVPWA>

| Auftrag | Thema | Erklärung | Lauffähiger Code |
|---------|-------|-----------|------------------|
| 📓 Auftrag 1 | Statische Code-Analyse mit Snyk (SAST + SCA) | [tag12_Praxisauftrag01.md](tag12_Praxisauftrag01.md) | lokal (`snyk` CLI) |
| 📓 Auftrag 2 | Dynamischer Sicherheitstest mit OWASP ZAP (DAST) | [tag12_Praxisauftrag02.md](tag12_Praxisauftrag02.md) | lokal (`docker` + ZAP) |
| 📓 Auftrag 3 | Security-Scans in die CI/CD-Pipeline einbauen | [tag12_Praxisauftrag03.md](tag12_Praxisauftrag03.md) | [auftrag03-ci-security/](auftrag03-ci-security/) |

---

## Aufbau

Auftrag 1 und 2 sind **lokale** Übungen an der geforkten DSVPWA-App (Snyk-CLI bzw. OWASP ZAP im
Docker-Container). Auftrag 3 überführt beides in **GitHub-Actions-Workflows**. Der Ordner
`auftrag03-ci-security/` ist deshalb ein **Mini-Repository** mit den Workflow-Dateien an genau der
Stelle, an die sie im DSVPWA-Fork der Studierenden gehören:

```
tag12/
├── verify.sh                                       # lokale Selbstkontrolle
├── tag12_Praxisauftrag01.md                        # Musterlösung Auftrag 1 (SAST/SCA)
├── tag12_Praxisauftrag02.md                        # Musterlösung Auftrag 2 (DAST)
├── tag12_Praxisauftrag03.md                        # Musterlösung Auftrag 3 (CI/CD)
└── auftrag03-ci-security/
    └── .github/workflows/
        ├── aufgabe1-sast-sca.yml                   # Snyk SCA + Snyk Code (SAST)
        └── aufgabe2-dast.yml                       # App starten + OWASP ZAP Baseline (DAST)
```

> **Hinweis:** GitHub führt nur Workflows aus dem Wurzel-Ordner `.github/workflows/` eines
> Repositories aus. Die Workflow-Dateien im Auftrags-Ordner sind deshalb **Vorlagen** für den
> DSVPWA-Fork der Studierenden. Damit die Musterlösungen hier trotzdem beweisbar grün laufen,
> bildet [`.github/workflows/tag12-praxis.yml`](../.github/workflows/tag12-praxis.yml) im Wurzel
> des Repos die Aufträge als eigene Jobs nach (DSVPWA klonen, starten, ZAP-Scan; Snyk optional).

---

## Eigene Lösung überprüfen

### Lokal

```bash
bash tag12/verify.sh        # alle drei Aufträge
bash tag12/verify.sh 3      # nur Auftrag 3
```

Das Skript prüft ohne externe Accounts, dass die Musterlösungs-Dokumente und die
Workflow-Vorlagen vorhanden, gültig (YAML) und inhaltlich vollständig sind (Snyk-Action,
`SNYK_TOKEN`, ZAP-Baseline-Action …). Erwartete Ausgabe:

```
✅ Erfüllt:    11
❌ Fehlen:     0
```

### In GitHub Actions

Nach einem Push auf dieses Repo läuft `tag12-praxis.yml`. Im Reiter **Actions** erscheinen:

```
Auftrag 3 — Workflow-Vorlagen prüfen     (YAML-Validierung)
Auftrag 2/3 — DAST (OWASP ZAP)           (DSVPWA starten + ZAP Baseline Scan)
Auftrag 1/3 — SAST/SCA (Snyk)            (läuft nur, wenn Secret SNYK_TOKEN gesetzt ist)
```

Der **DAST-Job läuft ohne Secret grün** — er klont DSVPWA, startet die App im Runner und scannt
sie mit OWASP ZAP. Der **Snyk-Job** wird übersprungen, solange kein `SNYK_TOKEN`-Secret im Repo
hinterlegt ist (die Vorlage bleibt trotzdem gültig).

---

## Voraussetzungen (für die eigene Durchführung)

- GitHub-Account, in den DSVPWA geforkt wird
- Kostenloser Snyk-Account; Auth-Token aus *Account Settings → General → Auth Token*
- Snyk-CLI lokal installiert (`npm install -g snyk` oder offizieller Installer)
- Python 3 (DSVPWA läuft mit der Standardbibliothek)
- Docker (für den ZAP-Container in Auftrag 2)
- GitHub-Secret `SNYK_TOKEN` im geforkten Repo (für Auftrag 3)

---

> Die DevSecOps-Pipeline für den **TechStyle Online-Shop** ist Teil des **Projekt-Blocks** und
> liegt im Repo `techstyle` (Branch `day_12_solution`), nicht hier.
>
> Online-Beispiellösung: <https://github.com/tbzdevops/tag11-dsvpwa-musterloesung>
