# Musterlösung – P3 (für Schnelle) Fix und Re-Scan

**Phase:** Praxis 2, für alle, die mit P2 fertig sind | **Zeit:** 10 Min | **Format:** Einzelarbeit

**Ziel:** Beweisen, dass die SQL-Injection aus P2 wirklich geschlossen ist: mit dem Angriff und mit einem erneuten Scan.

---

## 1. Query parametrisieren

`dsvpwa/attacks.py`, Zeile 39:

```diff
-            cursor.execute("SELECT id, username, firstname, lastname, email, session FROM users WHERE id=" + id)
+            cursor.execute("SELECT id, username, firstname, lastname, email, session FROM users WHERE id=?", (id,))
```

Mit `?` übergibt `sqlite3` die Eingabe als **Wert**. Die Datenbank interpretiert `1 OR 1=1` nicht mehr als SQL, sondern sucht einen Benutzer mit genau dieser ID.

## 2. Angriff wiederholen

App neu starten (`Ctrl+C`, dann `python dsvpwa.py --host 0.0.0.0`):

```bash
curl "http://localhost:65413/users?id=1"            # weiterhin: admin
curl "http://localhost:65413/users?id=1%20OR%201=1" # jetzt: kein Benutzer
```

## 3. Erneut scannen

```bash
snyk code test
```

Das SQL-Injection-Finding an `dsvpwa/attacks.py:39` ist verschwunden. Die SQL-Injection im Login (Zeile 289) bleibt und wäre der nächste Fix. Das zeigt: Ein Re-Scan bestätigt einen Fix, ersetzt aber nicht die Triage der übrigen Findings.

Ohne Snyk geht der Re-Scan auch mit Bandit:

```bash
bandit -r dsvpwa -t B608   # meldet nur noch Zeile 289
```

## 4. Committen

```bash
git add dsvpwa/attacks.py findings.md
git commit -m "fix: SQL-Injection in /users mit parametrisiertem Query behoben"
git push
```

Der Fix ist in diesem Branch umgesetzt, siehe [`dsvpwa/attacks.py`](../dsvpwa/attacks.py), Zeile 39. Der Job «P3 — Fix und Re-Scan» in [`.github/workflows/tag15-praxis.yml`](../.github/workflows/tag15-praxis.yml) prüft ihn bei jedem Push: Er greift das unveränderte DSVPWA und diese Version mit demselben Request an und vergleicht die Antworten.
