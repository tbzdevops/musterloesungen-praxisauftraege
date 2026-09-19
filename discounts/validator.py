"""Rabattcode-Validierung — Musterlösung zu Tag 12, Auftrag 1.

Gegen die Spec (specs/rabattcode.md) implementiert. Die Akzeptanzkriterien aus der
Spec sind 1:1 als Tests übernommen, dazu die Randfälle aus dem kritischen Review
(tests/test_discount.py).
"""

import re

# 6–12 Zeichen, nur Grossbuchstaben und Ziffern (Anforderung aus der Spec).
_CODE_RE = re.compile(r"[A-Z0-9]{6,12}")


def validate_discount_code(code, expired_codes=None, redeemed_codes=None) -> bool:
    """Prüft einen Rabattcode gegen Format, Ablauf und Einmal-Einlösung.

    expired_codes / redeemed_codes sind Mengen bekannter Codes; per Default leer.
    """
    # Review-Korrektur 1: Der AI-Entwurf rief code.upper() auf und stürzte bei
    # None ab. Kein String -> ungültig, keine Exception.
    if not isinstance(code, str):
        return False
    # Review-Korrektur 2: Der AI-Entwurf nutzte re.match mit "^...$". "$" passt
    # auch vor einem abschliessenden Zeilenumbruch, "SUMMER25\n" galt als gültig.
    # fullmatch prüft den ganzen String.
    if _CODE_RE.fullmatch(code) is None:
        return False
    # Review-Korrektur 3: Der AI-Entwurf hatte mutable Defaults (expired_codes=set()).
    if code in (expired_codes or set()):
        return False
    if code in (redeemed_codes or set()):
        return False
    return True
