# Musterlösung – P0 Setup und P1 Statische Analyse mit Snyk (SCA und SAST)

**Phase:** Praxis 1, direkt nach Theorie 1 (SAST & SCA) | **Zeit:** 30 Min | **Format:** Einzelarbeit

**Ziel:** Den ruhenden Code prüfen, **ohne die Anwendung zu starten**: zuerst die verwendeten Bibliotheken (SCA), dann den eigenen Quellcode (SAST). Ergebnis sind drei bewertete Findings in `findings.md`.

---

## P0: Setup (10 Min)

1. Classroom-Auftrag `tag15-praxis` annehmen. Das persönliche Repository enthält DSVPWA und die Vorlage `findings.md`.
2. Repository im GitHub Codespace öffnen: **Code** → **Codespaces** → **Create codespace on main**. Python, Node.js und Docker sind dort installiert.
3. Snyk-Account auf <https://app.snyk.io/login> anlegen, am einfachsten mit dem GitHub-Login.
4. **Snyk Code aktivieren:** **Settings** → **Snyk Code** → **Enable Snyk Code** → **Save**. Ohne diesen Schritt bricht `snyk code test` mit der Meldung ab, dass Snyk Code für die Organisation nicht aktiviert ist.
5. CLI installieren und anmelden:

   ```bash
   npm install -g snyk
   snyk auth          # Link im Browser bestätigen
   ```

   Klappt der Browser-Login im Codespace nicht, den Token aus **Account Settings** → **Auth Token** kopieren und `export SNYK_TOKEN=<token>` setzen.

## P1: SCA mit `snyk test` (10 Min)

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
snyk test
```

Snyk braucht die installierten Pakete, darum zuerst `pip install`. Die Ausgabe listet für jedes Paket aus `requirements.txt` bekannte Schwachstellen. Auszug (Stand November 2026, gekürzt):

| Paket | Version | Beispiel-CVE | Behoben in |
|-------|---------|--------------|-----------|
| PyYAML | 5.1 | CVE-2020-14343 (Arbitrary Code Execution) | 5.4 |
| Werkzeug | 0.14.1 | CVE-2023-25577 (Denial of Service, Multipart) | 2.2.3 |
| Jinja2 | 2.10 | CVE-2019-10906 (Sandbox Escape) | 2.10.1 |
| requests | 2.19.1 | CVE-2018-18074 (Credentials an fremden Host) | 2.20.0 |
| urllib3 | 1.23 | CVE-2019-11324 (Zertifikatsprüfung) | 1.24.2 |
| Flask | 0.12.2 | CVE-2018-1000656 (Denial of Service, JSON) | 0.12.3 |

Die genaue Liste und die Severity hängen vom aktuellen Stand der Snyk-Datenbank ab.

**Wichtige Beobachtung für die Bewertung:** DSVPWA läuft nur mit der Python-Standardbibliothek (`http.server`, `sqlite3`). Keines dieser Pakete wird im Code importiert:

```bash
grep -rnE "import (yaml|flask|requests|jinja2|werkzeug|urllib3)" dsvpwa dsvpwa.py   # keine Treffer
```

Die SCA-Findings sind deshalb echte CVEs, aber in dieser Anwendung **nicht erreichbar**. Die richtige Massnahme ist hier nicht «Version anheben», sondern «ungenutzte Abhängigkeit entfernen». Genau diese Abwägung ist der Kern der Triage.

## P1: SAST mit `snyk code test` (10 Min)

```bash
snyk code test
```

Snyk Code verfolgt, wie Benutzereingaben aus der URL (`handler.params`) durch den Code fliessen. Diese Stellen sind zu erwarten (Zeilennummern im unveränderten DSVPWA, mit Bandit gegengeprüft; Benennung und Severity bei Snyk können leicht abweichen):

| Datei, Zeile | Finding | Warum ist das eine Schwachstelle? |
|--------------|---------|-----------------------------------|
| `dsvpwa/attacks.py:39` | SQL Injection | Der Parameter `id` aus der URL wird mit `+` an den SQL-String gehängt. Eingaben wie `1 OR 1=1` verändern die Abfrage. |
| `dsvpwa/attacks.py:289` | SQL Injection | Gleiches Muster im Login mit `password`. |
| `dsvpwa/attacks.py:167` | Command Injection | `subprocess.check_output(..., shell=True)` mit dem Parameter `domain`: `;ifconfig` führt einen zweiten Befehl aus. |
| `dsvpwa/attacks.py:199` | Deserialization of Untrusted Data | `pickle.loads` auf Daten aus der URL erlaubt Remote Code Execution. |
| `dsvpwa/attacks.py:211–213` | Path Traversal / SSRF | `open()` bzw. `urllib.request.urlopen()` mit dem Parameter `path` aus der URL. |

**Bandit zum Vergleich** (Tipp für Schnelle):

```bash
pip install bandit && bandit -r dsvpwa
```

Bandit meldet dieselben Stellen, z.B. `B608` (SQL-Injection, Zeilen 39 und 289), `B602` (`shell=True`, Zeile 167) und `B301` (`pickle`, Zeile 199). Dazu kommen Hinweise mit geringer Severity wie `B311` (`random` für das Session-Token, `handlers.py:202`), die man einzeln beurteilen muss.

## P1: Drei Findings bewerten

Die ausgefüllte Tabelle steht in [`findings.md`](../findings.md). Begründung der drei Entscheide:

1. **SCA, PyYAML 5.1 (Critical):** Die CVE ist echt, aber `yaml` wird nie importiert. Kein Angriffspfad, also False Positive im Sinne von «nicht erreichbar». Massnahme: Paket aus `requirements.txt` entfernen. So wird das Gate wieder aussagekräftig, ohne das Finding mit `snyk ignore` zu verstecken.
2. **SAST, SQL-Injection Zeile 39 (High):** Echtes Risiko. Die Eingabe kommt direkt aus der URL `/users?id=` und wird in P2 von Hand bestätigt. Massnahme: parametrisierter Query (P3).
3. **SAST, Command Injection Zeile 167 (High):** Echtes Risiko im Code, aber erst ab `--risk 3` aktiv (Standard ist `--risk 1`). Das ist kein False Positive: Eine Konfiguration kann sich ändern. Massnahme: `shell=False` mit Argumentliste und Eingabe gegen ein Domain-Muster prüfen.

**Leitfragen aus der Theorie, angewendet:** Ist der Code erreichbar (1: nein, 2: ja, 3: nur mit `--risk 3`)? Gibt es einen Fix (alle drei: ja)? Wie gross wäre der Schaden (2: alle Benutzerdaten, 3: Befehle auf dem Server)?

## Typische Stolpersteine

| Problem | Lösung |
|---------|--------|
| `snyk code test` bricht mit «Snyk Code is not enabled» ab | P0, Schritt 4: Snyk Code in den Org-Settings aktivieren |
| `snyk test` meldet «Required packages missing» | Zuerst `pip install -r requirements.txt` im aktivierten venv |
| `snyk auth` öffnet im Codespace keinen Browser | Angezeigten Link manuell öffnen oder `SNYK_TOKEN` setzen |
| Zeilennummern weichen ab | Sie gelten für das unveränderte DSVPWA. Nach dem Fix in P3 verschieben sie sich nicht, weil nur Zeile 39 ersetzt wird |
