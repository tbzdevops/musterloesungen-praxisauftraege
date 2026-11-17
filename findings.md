# Findings Tag 15

Musterlösung zum Praxisauftrag von Tag 15 an der Übungsanwendung DSVPWA. Die Durchführung Schritt für Schritt steht in [tag15/](tag15/README.md).

## P1 – Snyk (SCA und SAST)
| # | Tool | Finding (Datei/Paket, Zeile/Version) | Severity | Echtes Risiko oder False Positive? | Massnahme |
|---|------|--------------------------------------|----------|------------------------------------|-----------|
| 1 | SCA  | `PyYAML` 5.1, Arbitrary Code Execution (CVE-2020-14343), behoben in 5.4 | Critical | Nicht ausnutzbar, also False Positive im Sinne von «nicht erreichbar»: DSVPWA importiert `yaml` nirgends, die Bibliothek steht nur in `requirements.txt` | Ungenutzte Abhängigkeit aus `requirements.txt` entfernen. Würde sie gebraucht, auf `PyYAML>=5.4` anheben |
| 2 | SAST | SQL-Injection in `dsvpwa/attacks.py`, Zeile 39: `id` aus dem Query-String wird an den SQL-String angehängt | High | Echtes Risiko: Die Eingabe kommt ungeprüft aus der URL `/users?id=`, in P2 von Hand bestätigt | Parametrisierter Query: `WHERE id=?` mit `(id,)` als Parameter (in P3 umgesetzt) |
| 3 | SAST | Command Injection in `dsvpwa/attacks.py`, Zeile 167: `subprocess.check_output(..., shell=True)` mit dem Parameter `domain` | High | Echtes Risiko, aber konfigurationsabhängig: Der Code läuft erst ab `--risk 3`, mit dem Standardwert `--risk 1` ist er nicht erreichbar | Trotzdem beheben, weil eine Konfiguration sich ändern kann: `shell=False` mit Argumentliste `["host", domain]` und `domain` gegen ein Domain-Muster prüfen |

## P2 – OWASP ZAP (DAST)
| # | Alert | Risiko | Betroffene URL | Behebung |
|---|-------|--------|----------------|----------|
| 1 | Content Security Policy (CSP) Header Not Set bzw. CSP: Wildcard Directive (`default-src * 'unsafe-inline'`) | Medium | `http://localhost:65413/` und alle Seiten | Restriktive CSP setzen, z.B. `default-src 'self'`, ohne `'unsafe-inline'` |
| 2 | Missing Anti-clickjacking Header (`X-Frame-Options` fehlt) | Medium | `http://localhost:65413/` und alle Seiten | Header `X-Frame-Options: DENY` oder CSP-Direktive `frame-ancestors 'none'` setzen |

### Verifizierte SQL-Injection
- Request: `curl "http://localhost:65413/users?id=1"` liefert einen Benutzer (`admin`). `curl "http://localhost:65413/users?id=1%20OR%201=1"` liefert alle vier Benutzer (`admin`, `guest`, `loella`, `weitzel`).
- Beobachtung: Die Bedingung `OR 1=1` ist immer wahr und wird von der Datenbank ausgeführt. Die Eingabe wird also als SQL interpretiert, nicht als Wert. Snyk Code meldet dieselbe Stelle (`dsvpwa/attacks.py`, Zeile 39) bereits in P1, der passive ZAP-Baseline-Scan dagegen nicht.

### Vergleich
| Nur SAST gefunden | Nur DAST gefunden |
|-------------------|-------------------|
| SQL-Injection in `/users` (Zeile 39) und im Login (Zeile 289): Der Baseline-Scan schickt keine Payloads | Fehlende oder zu offene Security-Header (CSP, `X-Frame-Options`, `X-Content-Type-Options`): Sie entstehen erst in der HTTP-Antwort |
| Command Injection (Zeile 167): bei `--risk 1` für einen Scanner gar nicht erreichbar | `Server`-Header verrät Python-Version: Information Leak zur Laufzeit |
| Unsichere Deserialisierung mit `pickle` (Zeile 199) | Session-Cookie ohne `HttpOnly`- und `SameSite`-Flag |
| SCA: veraltete Bibliotheken mit bekannten CVEs, auch wenn sie nicht genutzt werden | |

**Fazit:** SAST zeigt die Ursache mit Datei und Zeile, DAST zeigt, was im Betrieb tatsächlich sichtbar und ausnutzbar ist. Ein grüner Baseline-Scan heisst nicht, dass keine Injection-Lücken existieren. Darum braucht es beide Verfahren.

## P3 – Fix und Re-Scan
- `dsvpwa/attacks.py`, Zeile 39: `cursor.execute("SELECT id, username, firstname, lastname, email, session FROM users WHERE id=?", (id,))`
- Angriff wiederholt: `/users?id=1%20OR%201=1` liefert keinen Benutzer mehr, `/users?id=1` weiterhin `admin`.
- Re-Scan: Das SQL-Injection-Finding an Zeile 39 ist verschwunden. Die SQL-Injection im Login (Zeile 289) bleibt offen und wäre der nächste Fix.
