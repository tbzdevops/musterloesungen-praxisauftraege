# Musterlösung – P2 Dynamischer Test mit OWASP ZAP (DAST)

**Phase:** Praxis 2, direkt nach Theorie 2 (DAST, Baseline- vs. Full-Scan) | **Zeit:** 20 Min | **Format:** Einzelarbeit

**Ziel:** Die **laufende** Anwendung aus Angreifersicht prüfen und erleben, was ein passiver Baseline-Scan findet und was nicht.

---

## 1. Anwendung starten

```bash
python dsvpwa.py --host 0.0.0.0
```

DSVPWA läuft auf Port `65413`. Im Codespace erscheint die Port-Weiterleitung automatisch, lokal unter <http://localhost:65413>.

## 2. ZAP-Baseline-Scan

In einem zweiten Terminal:

```bash
# Codespace / Linux: der Container teilt das Netzwerk des Hosts
docker run --rm --network host -t zaproxy/zap-stable zap-baseline.py -t http://localhost:65413

# Docker Desktop (macOS / Windows): localhost im Container ist der Container selbst
docker run --rm -t zaproxy/zap-stable zap-baseline.py -t http://host.docker.internal:65413
```

Der Baseline-Scan crawlt die Seiten (Spider, standardmässig 1 Minute) und wertet die Antworten **passiv** aus. Er schickt keine Angriffs-Payloads. Am Ende stehen Zeilen wie:

```text
WARN-NEW: Content Security Policy (CSP) Header Not Set [10038] x 4
WARN-NEW: Missing Anti-clickjacking Header [10020] x 4
WARN-NEW: X-Content-Type-Options Header Missing [10021] x 6
WARN-NEW: Server Leaks Version Information via "Server" HTTP Response Header Field [10036] x 8
FAIL-NEW: 0    FAIL-INPROG: 0    WARN-NEW: ...    PASS: ...
```

Die genaue Liste hängt von der ZAP-Version ab. Den echten Lauf zeigt der Job «P2 — DAST (OWASP ZAP)» in [`.github/workflows/tag15-praxis.yml`](../.github/workflows/tag15-praxis.yml).

## 3. Zwei Alerts dokumentieren

Siehe [`findings.md`](../findings.md), Abschnitt P2. Für jeden Alert: Risiko, betroffene URL und Behebung. Die Behebung ist bei Header-Alerts immer ein Header in der HTTP-Antwort, nicht eine Änderung an der Geschäftslogik.

DSVPWA setzt die Header in `dsvpwa/handlers.py` selbst. Mit `curl -s -D - -o /dev/null http://localhost:65413/` sieht man sie:

```text
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.12.11
X-XSS-Protection: 0
Content-Security-Policy: default-src * 'unsafe-inline'
```

`X-Frame-Options` und `X-Content-Type-Options` fehlen, die CSP erlaubt alles, und der `Server`-Header verrät die Python-Version.

## 4. Fund von Hand prüfen

Der Baseline-Scan meldet die SQL-Injection **nicht**, weil er nichts einschleust. Von Hand:

```bash
curl "http://localhost:65413/users?id=1"
curl "http://localhost:65413/users?id=1%20OR%201=1"
```

| Request | Ergebnis |
|---------|----------|
| `/users?id=1` | Eine Zeile: `admin` |
| `/users?id=1%20OR%201=1` | Vier Zeilen: `admin`, `guest`, `loella`, `weitzel` |

Die Datenbank führt `WHERE id=1 OR 1=1` aus. Damit ist die Lücke bestätigt. Ursache: `dsvpwa/attacks.py`, Zeile 39. Snyk Code hat genau diese Stelle in P1 gemeldet.

**Einordnung:** Ein **Full-Scan** (`zap-full-scan.py`) würde die Lücke finden, weil er Payloads wie `' OR '1'='1` an jeden Parameter schickt. Er dauert aber deutlich länger und darf nur gegen Test- oder Staging-Umgebungen laufen.

## 5. Vergleich SAST / DAST

| Nur SAST gefunden | Nur DAST gefunden |
|-------------------|-------------------|
| SQL-Injection (`/users`, Login) | Fehlende oder zu offene Security-Header |
| Command Injection (bei `--risk 1` nicht erreichbar) | `Server`-Header mit Versionsangabe |
| Unsichere Deserialisierung mit `pickle` | Cookie-Flags (`HttpOnly`, `SameSite`) |

SAST sieht den Code, aber nicht die HTTP-Antwort. DAST sieht die HTTP-Antwort, aber nicht den Code. Darum braucht es beide.

## Typische Stolpersteine

| Problem | Lösung |
|---------|--------|
| ZAP meldet `Connection refused` | Auf Docker Desktop `host.docker.internal` statt `localhost` verwenden, unter Linux `--network host` |
| Scan findet nur eine Seite | App läuft nicht oder falscher Port: `curl http://localhost:65413/` prüfen |
| `zaproxy/zap-stable` lädt lange | Das Image ist ca. 1.5 GB gross. Im Codespace dauert der erste Pull 1–2 Minuten |
| Kein Docker verfügbar | ZAP-Desktop-App von <https://www.zaproxy.org/> und **Automated Scan** verwenden |
