# Musterlösungen der Praxisaufträge

Dieses Repository enthält die **Musterlösungen zu den Praxisaufträgen** des Moduls
DevOps & Infrastruktur (HF, TBZ). Zu jedem Kurstag gibt es einen eigenen Branch — die
Lösungen liegen bewusst **nicht** alle zusammen auf `main`, damit pro Tag genau der
Stand sichtbar ist, den man am Ende des Tages im eigenen Repo haben sollte.

---

## Wie dieses Repo verwendet wird

1. **Erst selbst lösen.** Die Musterlösung ist zum Vergleichen und Nachschlagen da,
   nicht zum Abschreiben. Die Abnahmekriterien im Classroom-Repo werden an *deinem*
   Repo geprüft.
2. **Branch des Tages auschecken:**
   ```bash
   git clone git@github.com:tbzdevops/musterloesungen-praxisauftraege.git
   cd musterloesungen-praxisauftraege
   git checkout day_5_solution     # Beispiel: Tag 05
   ```
   Alternativ direkt im Browser über die Links in der Tabelle unten.
3. **Ordner `tagXX/` lesen.** Dort liegen die Übersicht (`README.md`), die
   ausformulierten Lösungsdokumente (`tagXX_PraxisauftragNN.md`) und — wo vorhanden —
   das Selbstkontroll-Skript `verify.sh`.
4. **Lauffähiger Code liegt dort, wo er hingehört.** Workflows unter
   `.github/workflows/`, Anwendungscode im Wurzelverzeichnis. Der Ordner `tagXX/`
   enthält nur Doku und Prüfskript — so entspricht der Branch dem echten Repo-Aufbau.
5. **Selbstkontrolle laufen lassen** (falls `verify.sh` vorhanden):
   ```bash
   bash tag05/verify.sh        # alle Aufträge des Tages
   bash tag05/verify.sh 2      # nur Auftrag 2
   ```
   Das Skript prüft dieselben Punkte wie die Abnahmekriterien, aber lokal ohne Push.

> **Branch-Konvention:** `day_<N>_solution` (ohne führende Null), Ordner `tag<NN>`
> (mit führender Null). Beispiel: Branch `day_5_solution`, Ordner `tag05/`.

---

## Übersicht der Lösungen

| Tag | Thema | Musterlösung | Status |
|-----|-------|--------------|--------|
| Tag 01 | Einführung in DevOps: CALMS, The Three Ways, DORA | [`day_1_solution` → `tag01/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_1_solution/tag01) | ✅ |
| Tag 02 | Git & Versionskontrolle, Semantic Versioning | [`day_2_solution`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_2_solution) | ⚠️ nur Code-Base |
| Tag 03 | MVP und User Stories (Slicing, INVEST) | [`day_3_solution` → `tag03/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_3_solution/tag03) | ✅ |
| Tag 04 | CI-Grundlagen mit GitHub Actions | [`day_4_solution` → `tag04/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_4_solution/tag04) | ✅ |
| Tag 05 | Vertrauenswürdige Pipelines: PR-Gate, Branch Protection, Tuning | [`day_5_solution` → `tag05/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_5_solution/tag05) | ✅ |
| Tag 06 | Artifact Management: Python-Paket & eigener PyPI-Index | [`day_6_solution` → `tag06/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_6_solution/tag06) | ✅ |
| Tag 07 | Test Automation: SonarQube auf EC2 mit Docker Compose | [`day_7_solution` → `tag07/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_7_solution/tag07) | ✅ |
| Tag 08 | Continuous Deployment: Blue-Green & Canary | `day_8_solution` | 🕓 folgt |
| Tag 09 | Hands-on Day 1: Konsolidierung Tag 01–08 | `day_9_solution` | 🕓 folgt |
| Tag 10 | CALMS + Monitoring: Grafana Dashboards, SLO/SLI | `day_10_solution` | 🕓 folgt |
| Tag 11 | Monitoring & Alerting: Metriken, Alerts, User Journeys | `day_11_solution` | 🕓 folgt |
| Tag 12 | AI in DevOps: AI-assisted Dev, ADR, AI in CI/CD, Prompt Injection | [`day_12_solution` → `tag12/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_12_solution/tag12) | ✅ |
| Tag 13 | Container-Grundlagen (Docker Basics): erster Container, eigenes Image, Compose-Stack | [`day_13_solution` → `tag13/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_13_solution/tag13) | ✅ |
| Tag 14 | Container-Automatisierung: CI-Build, ECR-Push, ECS-Deployment | [`day_14_solution` → `tag14/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_14_solution/tag14) | ✅ |
| Tag 15 | DevSecOps: Snyk (SAST/SCA) und OWASP ZAP (DAST) | [`day_15_solution` → `tag15/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_15_solution/tag15) | ✅ |
| Tag 16 | Container-Automatisierung: CI-Build, ECR-Push, ECS-Deployment | [`day_16_solution` → `tag16/`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_16_solution/tag16) | ✅ |
| Tag 17 | Hands-on Day 2: Projekt-Workshop, offene Punkte | `day_17_solution` | 🕓 folgt |
| Tag 18 | Infrastructure as Code mit Terraform | `day_18_solution` | 🕓 folgt |
| Tag 19 | ArgoCD: App-of-Apps, Helm Charts, Sync Policies | `day_19_solution` | 🕓 folgt |
| Tag 20 | ArgoCD & GitOps auf MicroK8s | `day_20_solution` | 🕓 folgt |
| Tag 21 | Konsolidierung & Abschluss-Workshop, End-to-End Testing | `day_21_solution` | 🕓 folgt |
| Tag 22 | DevOps Transformation Review, Abschlusspräsentation | `day_22_solution` | 🕓 folgt |

**Legende:** ✅ Musterlösung verfügbar · ⚠️ Branch vorhanden, aber nur Ausgangs-Code · 🕓 Branch wird zum jeweiligen Kurstag erstellt

---

## Zugehörige Repositories

| Repository | Inhalt |
|------------|--------|
| [ch-tbz-wb/Stud/devops](https://gitlab.com/ch-tbz-wb/Stud/devops) | Tagesplanungen, Theorie- und Unterrichtsressourcen |
| [tbzdevops/techstyle](https://github.com/tbzdevops/techstyle) | Referenz-Applikation für die Projektaufträge (`day_X_checkpoint` / `day_X_solution`) |
| Classroom-Repos `tagNN-*` | Die eigentlichen Praxisaufträge inkl. automatischer Abnahme |
