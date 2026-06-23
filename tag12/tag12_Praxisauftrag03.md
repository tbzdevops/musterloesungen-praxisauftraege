# Musterlösung – Auftrag 3: Security-Scans in die CI/CD-Pipeline einbauen

**Ziel:** Die Erkenntnisse aus Auftrag 1 (SAST/SCA) und Auftrag 2 (DAST) in **GitHub Actions**
automatisieren. Bei jedem Push/Pull-Request laufen die Security-Checks – eine kleine
DevSecOps-Pipeline.

---

## 1. Voraussetzungen

1. DSVPWA-Fork liegt auf GitHub, **Actions aktiviert**.
2. Snyk-API-Token als Repository-Secret hinterlegen:
   *Settings → Secrets and variables → Actions → New repository secret*
   - Name: `SNYK_TOKEN`
   - Value: Token aus *Snyk → Account Settings → General → Auth Token*
3. Für die Issue-/SARIF-Funktionen: *Settings → Actions → General → Workflow permissions →
   Read and write permissions*.

---

## 2. Workflow 1 – SAST + SCA mit Snyk

Datei: **`.github/workflows/aufgabe1-sast-sca.yml`** (vollständige Datei liegt als
[aufgabe1-sast-sca.yml](aufgabe1-sast-sca.yml) bei).

Kernpunkte:

```yaml
on:
  push:
  pull_request:

jobs:
  snyk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # SCA: Abhängigkeiten scannen (bricht bei High/Critical ab)
      - name: Snyk Open Source (SCA)
        uses: snyk/actions/python@master
        continue-on-error: true        # weiterlaufen, damit SARIF hochgeladen wird
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high --sarif-file-output=snyk-sca.sarif

      # SARIF ins GitHub Security-Tab laden
      - name: Upload SCA results
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: snyk-sca.sarif
          category: snyk-sca
```

- `--severity-threshold=high` → nur High/Critical lassen den Schritt scheitern.
- `continue-on-error: true` → der Job läuft weiter, damit das SARIF auch bei Findings hochgeladen
  wird (sonst bräche der Workflow vor dem Upload ab).
- `snyk code test` (SAST) wird analog ergänzt und als zweites SARIF hochgeladen.

---

## 3. Workflow 2 – DAST mit OWASP ZAP

Datei: **`.github/workflows/aufgabe2-dast.yml`** (vollständige Datei liegt als
[aufgabe2-dast.yml](aufgabe2-dast.yml) bei).

Kernidee: App **im Runner** starten, dann ZAP gegen `localhost` laufen lassen.

```yaml
      - name: Start Web App
        run: |
          pip install -r requirements.txt
          python dsvpwa.py &
          sleep 5

      - name: ZAP Baseline DAST Scan
        uses: zaproxy/action-baseline@v0.12.0
        env:
          GITHUB_TOKEN: ""             # Issue-Erstellung unterbinden (Permission-Fehler vermeiden)
        with:
          target: "http://127.0.0.1:65413"
          fail_action: false
          cmd_options: "-m 5"
          allow_issue_writing: false
```

- `fail_action: false` → der Scan-Report soll informieren, den Build aber (im Kurs) nicht hart
  brechen.
- `GITHUB_TOKEN: ""` + `allow_issue_writing: false` → verhindert, dass die Action automatisch
  GitHub-Issues anlegt (häufige Fehlerquelle wegen fehlender Rechte).

---

## 4. Pipeline testen

```bash
git add .github/workflows/aufgabe1-sast-sca.yml .github/workflows/aufgabe2-dast.yml
git commit -m "DevSecOps: SAST/SCA und DAST Workflows"
git push
```

Unter **Actions** beobachten:

- **Snyk-Job:** meldet verwundbare Abhängigkeiten / Codestellen; Findings erscheinen zusätzlich
  unter **Security → Code scanning**.
- **ZAP-Job:** startet die App, scannt sie, lädt den Report als Artefakt hoch.

---

## 5. Interpretation & Ausblick

- Bei jedem Push gibt es jetzt automatisiertes Security-Feedback – ein "Guard" gegen das
  versehentliche Einführen verwundbarer Bibliotheken oder unsicherer Codestellen.
- In echten Projekten erweiterbar um: Container-Image-Scan, IaC-Scan (Terraform), Slack-Reporting,
  und einen ausführlichen DAST-Scan nur nachts / vor Releases (statt bei jedem Commit).

---

## Ergebnis

- Zwei lauffähige GitHub-Actions-Workflows (SAST/SCA + DAST).
- `SNYK_TOKEN` als Secret konfiguriert, Severity-Threshold gesetzt.
- Findings im GitHub Security-Tab sichtbar (SARIF-Upload).
- Damit ist eine minimale, aber vollständige DevSecOps-CI/CD-Pipeline umgesetzt.
