# Musterlösung – Auftrag 2: Spec-Driven Development & ADR

**Ziel:** Den Unterschied zwischen Ad-hoc-Prompting (Auftrag 1) und **spec-getriebenem**
Vorgehen erleben und eine Entscheidung als **ADR** dokumentieren.

Lauffähiger Code: [discounts/validator.py](../discounts/validator.py), [tests/test_discount.py](../tests/test_discount.py)

---

## Teil A — Spec zuerst

Die Spec [`specs/rabattcode.md`](../specs/rabattcode.md) beschreibt das Feature
**vor** der Implementierung: Anforderungen, Akzeptanzkriterien, Out of Scope.

## Teil B — AI gegen die Spec implementieren

Mit der **ganzen Spec** als Kontext generiert der AI-Assistent `validate_discount_code()`.
Gegenüber Auftrag 1 (Ad-hoc) liegt der Output näher am Ziel, und — entscheidend — die
Akzeptanzkriterien lassen sich **direkt als Tests** übernehmen:

```python
_CODE_RE = re.compile(r"^[A-Z0-9]{6,12}$")

def validate_discount_code(code, expired_codes=None, redeemed_codes=None) -> bool:
    expired_codes = expired_codes or set()
    redeemed_codes = redeemed_codes or set()
    if not isinstance(code, str) or _CODE_RE.match(code) is None:
        return False
    return code not in expired_codes and code not in redeemed_codes
```

| Akzeptanzkriterium (Spec) | Test | Ergebnis |
|---------------------------|------|----------|
| `SUMMER25` gültig | `test_gueltiger_code` | ✅ |
| `abc` zu kurz | `test_zu_kurz` | ❌ abgelehnt |
| `EXPIRED10` abgelaufen | `test_abgelaufen` | ❌ abgelehnt |
| Einmal-Code erneut | `test_bereits_eingeloest` | ❌ abgelehnt |

```bash
pip install -r requirements.txt
pytest -q tests/test_discount.py       # 5 passed
```

## Teil C — Entscheidung als ADR

Während der Umsetzung fiel die Entscheidung *Validierung im Applikationscode* (statt in der
DB). Festgehalten in [`docs/adr/0001-rabattcode-validierung.md`](../docs/adr/0001-rabattcode-validierung.md)
mit Status / Kontext / Entscheidung / Konsequenzen.

## Reflexion

Die Spec schärft **vor** dem Coden das gemeinsame Verständnis, macht den AI-Output zielgenauer
und liefert die Tests quasi gratis mit. Der ADR hält das **Warum** einer Entscheidung fest —
wertvoll für spätere Wartung.
