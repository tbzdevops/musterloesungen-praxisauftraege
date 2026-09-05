# Musterlösung – Auftrag 2: Dynamischer Sicherheitstest mit OWASP ZAP (DAST)

**Ziel:** Die **laufende** Anwendung von aussen wie ein Angreifer prüfen. DAST findet Lücken, die
im ruhenden Code nicht sichtbar sind (fehlende Security-Header, Directory Listing, Verhalten zur
Laufzeit).

---

## 1. Vorbereitung

```bash
# DSVPWA-Fork (aus Auftrag 1) verwenden
cd DSVPWA

# OWASP ZAP als Docker-Image holen
docker pull zaproxy/zap-stable:latest
```

---

## 2. Anwendung lokal starten

```bash
python dsvpwa.py
```

Die App lauscht standardmässig auf Port **65413**. In der Konsole erscheint sinngemäss:

```
Navigate to http://127.0.0.1:65413 to access DSVPWA
```

Kontrolle: URL im Browser öffnen – die verwundbare Demo-App muss erreichbar sein.

---

## 3. DAST-Scan mit OWASP ZAP (Baseline)

ZAP läuft im Container; die App läuft auf dem Host. Mit `host.docker.internal` erreicht der
Container den Host:

```bash
docker run --add-host=host.docker.internal:host-gateway \
  -t zaproxy/zap-stable:latest \
  zap-baseline.py -t http://host.docker.internal:65413
```

> `--add-host=host.docker.internal:host-gateway` erstellt im Container einen DNS-Eintrag, der auf
> die Host-IP zeigt – so landet der Scan auf der lokal gestarteten App.
>
> **Alternative GUI:** ZAP von <https://www.zaproxy.org> installieren, *Automated Scan* wählen,
> Ziel-URL `http://127.0.0.1:65413` eintragen.

---

## 4. Ergebnisse analysieren

Der Baseline-Scan gibt eine Tabelle mit Alerts aus (PASS / WARN / FAIL):

```
WARN-NEW: Cross Domain JavaScript Source File Inclusion
WARN-NEW: Missing Anti-clickjacking Header (X-Frame-Options)        [1]
WARN-NEW: X-Content-Type-Options Header Missing
WARN-NEW: Absence of Anti-CSRF Tokens
FAIL-NEW: SQL Injection                                             [1]
```

**Mindestens eine kritische Lücke verifizieren – SQL Injection manuell nachstellen:**

```bash
# Verdächtigen Parameter manuell mit einem Injection-String testen
curl "http://127.0.0.1:65413/?id=1' OR '1'='1"
```

Liefert die Anwendung daraufhin **alle** Datensätze (statt einem), ist die Injection bestätigt.

| Fund (DAST) | Im SAST sichtbar? | Behebung |
|-------------|-------------------|----------|
| SQL Injection | ja (Auftrag 1) | Parametrisierte Queries |
| Fehlender `X-Frame-Options` Header | **nein** | Header serverseitig setzen (Clickjacking-Schutz) |
| Fehlender `X-Content-Type-Options` | **nein** | `nosniff` Header setzen |
| Directory Listing | **nein** | Verzeichnis-Browsing deaktivieren |

> **Kernaussage:** DAST deckt **Konfigurations- und Laufzeitprobleme** auf (Header, Listing), die
> ein reiner Code-Scan nicht sieht. SAST und DAST ergänzen sich.

---

## 5. Ergebnisdokumentation

- Welche Alerts hat ZAP gemeldet (FAIL vs. WARN)?
- Welche davon waren in der statischen Analyse **nicht** sichtbar?
- Behebungsvorschläge (Header setzen, Eingaben filtern, Listing aus).

Beispiel-Behebung der fehlenden Header in einer Flask-App:

```python
@app.after_request
def set_security_headers(resp):
    resp.headers["X-Frame-Options"] = "DENY"
    resp.headers["X-Content-Type-Options"] = "nosniff"
    resp.headers["Content-Security-Policy"] = "default-src 'self'"
    return resp
```

---

## Ergebnis

- DAST-Scan mit OWASP ZAP gegen die laufende DSVPWA durchgeführt.
- Mindestens eine kritische Lücke (SQL Injection) manuell verifiziert.
- Funde dokumentiert, inkl. der nur dynamisch sichtbaren Header-Probleme.
- Aufwand/Nutzen von DAST verstanden (langsamer, dafür realistische Aussensicht).
