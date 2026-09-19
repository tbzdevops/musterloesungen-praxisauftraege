# Musterlösung – Auftrag 1: Spec-Driven Development mit AI

**Ziel:** AI nicht ad hoc, sondern gegen eine **Spec** implementieren lassen — und das Ergebnis
so kritisch prüfen, als hätte es ein neues Teammitglied geschrieben.

Lauffähiger Code: [discounts/validator.py](../discounts/validator.py), [tests/test_discount.py](../tests/test_discount.py)

---

## Teil A — Spec zuerst

Die Spec [`specs/rabattcode.md`](../specs/rabattcode.md) beschreibt das Feature **vor** der
Implementierung: Ziel, Anforderungen (inkl. Signatur und Modulpfad), Akzeptanzkriterien, Out of
Scope. Dass Signatur und Pfad in der Spec stehen, ist kein Detail: Nur so passen AI-Output und
Tests ohne Nacharbeit zusammen.

## Teil B — AI gegen die Spec implementieren

Mit der **ganzen Spec** als Kontext lieferte der AI-Assistent diesen ersten Entwurf:

```python
import re

def validate_discount_code(code, expired_codes=set(), redeemed_codes=set()) -> bool:
    code = code.upper()
    if not re.match(r"^[A-Z0-9]{6,12}$", code):
        return False
    return code not in expired_codes and code not in redeemed_codes
```

Die vier Akzeptanzkriterien als Tests übernommen — **alle grün**.

## Teil C — Kritisch prüfen

Grüne Akzeptanztests heissen nur: Die vier genannten Fälle stimmen. Die Randfälle dazwischen
zeigen drei Fehler:

| Randfall | Erwartung | AI-Entwurf | Ursache |
|----------|-----------|------------|---------|
| `"summer25"` | `False` (Spec: Grossbuchstaben) | `True` | `code.upper()` biegt die Eingabe zurecht |
| `"SUMMER25\n"` | `False` | `True` | `$` passt auch vor einem abschliessenden `\n` |
| `None` | `False` | `AttributeError` | keine Typprüfung |
| Default-Argumente | — | `set()` als Default | mutable Default, teilt Zustand zwischen Aufrufen |

Korrigierte Fassung:

```python
_CODE_RE = re.compile(r"[A-Z0-9]{6,12}")

def validate_discount_code(code, expired_codes=None, redeemed_codes=None) -> bool:
    if not isinstance(code, str):
        return False
    if _CODE_RE.fullmatch(code) is None:
        return False
    if code in (expired_codes or set()):
        return False
    if code in (redeemed_codes or set()):
        return False
    return True
```

```bash
pip install -r requirements.txt
python -m pytest -q          # 12 passed
```

## Reflexion

- **Was die Spec gebracht hat:** richtige Signatur, richtiger Pfad, Tests quasi gratis — der
  Entwurf lag deutlich näher am Ziel als ein Prompt ohne Spec.
- **Was sie nicht abgefangen hat:** Die AI füllt Lücken *zwischen* den Kriterien mit eigenen
  Annahmen (`upper()` „hilft" dem Nutzer). Genau dort braucht es den menschlichen Review.
- **Konsequenz fürs Projekt:** Randfälle, die im Review auffallen, gehören zurück in die Spec —
  dann prüft sie beim nächsten Mal auch die AI.
