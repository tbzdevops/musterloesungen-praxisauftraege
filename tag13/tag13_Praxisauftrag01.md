# Musterlösung – Auftrag 1: AI-Assisted Development

**Ziel:** AI-generierten Code aus Entwicklerperspektive erzeugen und **kritisch** bewerten.

Lauffähiger Code: [utils/validators.py](../utils/validators.py), [tests/test_validators.py](../tests/test_validators.py)

---

## 1. Funktion mit AI erzeugen

Ausgangspunkt ist der vorgegebene Kommentar-Stub in `utils/validators.py`. Ein
AI-Assistent (Copilot / GitHub Models) schlägt daraufhin eine Implementierung vor.

## 2. AI-Output kritisch prüfen

Der erste Vorschlag ist selten fertig. Diese Punkte fielen im Review auf und wurden korrigiert:

| Frage | Befund am AI-Vorschlag | Korrektur in der Musterlösung |
|-------|------------------------|-------------------------------|
| Logik korrekt? | `a@b` wurde teils als gültig akzeptiert | Regex verlangt Punkt in der Domain (`\.`) |
| Edge Cases? | `None` / `""` führten zu Fehlern bzw. wurden nicht geprüft | Typ- und Leer-Prüfung ergänzt |
| Längenlimit? | fehlte | `len(email) > 254` (RFC 5321) ergänzt |
| Lesbarkeit? | ok, aber unkommentiert | Kommentare zu jeder Prüf-Entscheidung |

Die finale Funktion:

```python
_EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

def validate_email(email: str) -> bool:
    if not isinstance(email, str):
        return False
    if len(email) > 254:
        return False
    return _EMAIL_RE.match(email) is not None
```

## 3. Tests generieren lassen und ergänzen

Die geforderten Inputs sind als Tests hinterlegt (`tests/test_validators.py`):

| Input | Erwartung |
|-------|-----------|
| `test@example.com` | ✅ gültig |
| `invalid-email` | ❌ (kein `@`) |
| `a@b` | ❌ (Domain ohne Punkt) |
| 250×`a` + `@x.com` (256 Zeichen) | ❌ (zu lang) |
| `None`, `""` | ❌ (vom AI-Vorschlag nicht abgedeckt) |

```bash
pip install -r requirements.txt
pytest -q tests/test_validators.py     # 5 passed
```

## 4. Reflexion

- **AI gut:** schneller Grundgerüst-Entwurf inkl. Regex-Idee.
- **Selbst korrigiert:** Domain-Punkt, Längenlimit, `None`/`""`-Edge-Cases.
- **Erkenntnis:** AI beschleunigt den ersten Wurf, der **Review** bleibt Entwicklerarbeit —
  besonders bei Edge Cases und Sicherheitsannahmen.
