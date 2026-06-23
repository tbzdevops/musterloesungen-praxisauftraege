# Tag 12 – Praxis-Musterlösungen (DevSecOps)

DevSecOps mit Snyk (SAST/SCA) und OWASP ZAP (DAST). Die drei Praxis-Aufträge bauen aufeinander
auf: Zuerst wird der ruhende Code statisch geprüft (Auftrag 1), dann die laufende Anwendung
dynamisch getestet (Auftrag 2), und schliesslich werden beide Prüfungen in eine
GitHub-Actions-Pipeline automatisiert (Auftrag 3).

Als Übungsobjekt dient die absichtlich verwundbare Anwendung **DSVPWA** (Damn Simple Vulnerable
Python Web Application): <https://github.com/tbzdevops/DSVPWA>

| Auftrag | Thema | Lösung |
|---------|-------|--------|
| 📓 Auftrag 1 | Statische Code-Analyse mit Snyk (SAST + SCA) | [tag12_Praxisauftrag01.md](tag12_Praxisauftrag01.md) |
| 📓 Auftrag 2 | Dynamischer Sicherheitstest mit OWASP ZAP (DAST) | [tag12_Praxisauftrag02.md](tag12_Praxisauftrag02.md) |
| 📓 Auftrag 3 | Security-Scans in die CI/CD-Pipeline einbauen | [tag12_Praxisauftrag03.md](tag12_Praxisauftrag03.md) |

## Lauffähige Workflow-Dateien (Auftrag 3)

| Datei | Zweck |
|-------|-------|
| [aufgabe1-sast-sca.yml](aufgabe1-sast-sca.yml) | GitHub-Actions-Workflow: Snyk SCA + Snyk Code (SAST) |
| [aufgabe2-dast.yml](aufgabe2-dast.yml) | GitHub-Actions-Workflow: App starten + OWASP ZAP Baseline Scan |

> Die DevSecOps-Pipeline für den **TechStyle Online-Shop** ist Teil des **Projekt-Blocks** und
> liegt im Repo `techstyle` (Branch `day_12_solution`, `.github/workflows/security-pipeline.yml`
> und `DAY_12_COMPLETION.md`), nicht hier.
>
> Online-Beispiellösung: <https://github.com/tbzdevops/tag11-dsvpwa-musterloesung>

## Voraussetzungen (alle Aufträge)

- GitHub-Account, in den DSVPWA geforkt wird
- Kostenloser Snyk-Account; Auth-Token aus *Account Settings → General → Auth Token*
- Snyk-CLI lokal installiert (`npm install -g snyk` oder offizieller Installer)
- Python 3 mit `venv`
- Docker (für den ZAP-Container in Auftrag 2)
- GitHub-Secret `SNYK_TOKEN` im geforkten Repo (für Auftrag 3)
