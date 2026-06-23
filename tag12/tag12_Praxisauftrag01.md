# Musterlösung – Auftrag 1: Statische Code-Analyse mit Snyk (SAST + SCA)

**Ziel:** Den ruhenden Code und seine Abhängigkeiten auf Sicherheitslücken prüfen, **ohne die
Anwendung zu starten**. SCA findet verwundbare Bibliotheken, SAST findet unsichere Code-Muster.

---

## 1. Vorbereitung

```bash
# DSVPWA forken (GitHub-UI) und danach den eigenen Fork klonen
git clone https://github.com/<DEIN-USER>/DSVPWA.git
cd DSVPWA

# Snyk-CLI installieren (eine der Varianten)
npm install -g snyk
# oder: brew install snyk     (macOS)
# oder: offizieller Installer von https://docs.snyk.io

# In der CLI an Snyk anmelden (öffnet Browser, Token wird hinterlegt)
snyk auth
```

---

## 2. Software Composition Analysis (SCA) – `snyk test`

SCA prüft die deklarierten Abhängigkeiten gegen die Snyk-Vulnerability-Datenbank. Dafür müssen die
Pakete in einem (virtuellen) Environment installiert sein, damit Snyk die exakten Versionen kennt.

```bash
# Virtuelles Environment anlegen und aktivieren
python -m venv venv
source venv/bin/activate            # Windows: venv\Scripts\activate

# Abhängigkeiten installieren
pip install -r requirements.txt

# Abhängigkeits-Scan ausführen
snyk test
```

**Typische Ausgabe (gekürzt):**

```
Testing /.../DSVPWA...

✗ High severity vulnerability found in werkzeug
  Description: Improper Input Validation
  Info: https://security.snyk.io/vuln/SNYK-PYTHON-WERKZEUG-...
  Introduced through: werkzeug@0.x
  Fix: Upgrade werkzeug to 2.2.3 or higher

Organization:      <deine-org>
Package manager:   pip
Tested 12 dependencies for known issues, found 4 issues.
```

**Interpretation (exemplarisch):**

| Finding | Bedeutung | Behebung |
|---------|-----------|----------|
| `werkzeug` veraltet, High | Bekannte CVE in der Request-Verarbeitung | Version in `requirements.txt` anheben (`werkzeug>=2.2.3`) |
| Transitive Abhängigkeit mit CVE | Lücke kommt indirekt über ein anderes Paket | Direktes Paket aktualisieren oder Override setzen |

> **Behebungsstrategie SCA:** Versionen in `requirements.txt` pinnen und auf die von Snyk
> vorgeschlagene gepatchte Version anheben, danach `snyk test` erneut laufen lassen → die Lücke
> sollte verschwinden.

---

## 3. Static Application Security Testing (SAST) – `snyk code test`

Snyk Code analysiert den **Quellcode** auf unsichere Muster (SQL-Injection, XSS, Command
Injection, Hardcoded Secrets …).

```bash
snyk code test
```

**Typische Ausgabe (gekürzt):**

```
 ✗ [High] SQL Injection
   Path: dsvpwa/handlers/sqli.py, line 23
   Info: Unsanitized input from the HTTP request flows into a SQL query.

 ✗ [Medium] Cross-site Scripting (XSS)
   Path: dsvpwa/handlers/xss.py, line 41
   Info: Unsanitized input is rendered into the HTML response.
```

**Warum ist das eine Schwachstelle?** Bei der SQL-Injection-Stelle fliesst eine
Benutzereingabe **direkt** (per String-Konkatenation) in den SQL-Query. Ein Angreifer kann mit
`' OR '1'='1` die WHERE-Bedingung aushebeln und alle Datensätze auslesen.

**Sichere Variante (parametrisierte Query):**

```python
# Unsicher (verwundbar):
cursor.execute("SELECT * FROM users WHERE name = '" + name + "'")

# Sicher (Parameter-Binding):
cursor.execute("SELECT * FROM users WHERE name = ?", (name,))
```

---

## 4. Umgang mit den Findings (kritisches Prüfen)

Drei Findings beurteilen — nicht jeder Treffer ist real ausnutzbar:

| # | Finding | Einschätzung | Begründung |
|---|---------|-------------|------------|
| 1 | SQL-Injection in `sqli.py` | **Echtes Risiko (High)** | Eingabe geht ungefiltert in den Query, direkt ausnutzbar |
| 2 | XSS in `xss.py` | **Echtes Risiko (Medium)** | Reflektierte Ausgabe ohne Escaping |
| 3 | "Hardcoded password" in einer Testdatei | **Möglicher False Positive** | Nur Test-Fixture, nicht in Produktionspfad – trotzdem dokumentieren |

> Regel: **Alle High/Critical ernst nehmen.** Medium nach Kontext bewerten, dokumentieren statt
> stillschweigend ignorieren.

---

## 5. Bonus: Gegenprobe mit Bandit

```bash
pip install bandit
bandit -r .
```

Bandit ist ein Open-Source-SAST für Python und sollte ähnliche Stellen melden (z. B. `B608`
hardcoded SQL, `B105` hardcoded password). Der Vergleich zeigt: verschiedene Tools überlappen,
ergänzen sich aber – ein Tool allein findet selten alles.

---

## Ergebnis

- SCA (`snyk test`) listet verwundbare Abhängigkeiten inkl. Fix-Version.
- SAST (`snyk code test`) listet unsichere Codezeilen inkl. Datei/Zeile.
- Findings sind beurteilt (echt vs. möglicher False Positive) und Behebungswege notiert.
- Basis für Auftrag 2 (dynamische Sicht) und Auftrag 3 (Automatisierung) ist gelegt.
