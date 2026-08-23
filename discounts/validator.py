"""Rabattcode-Validierung — Musterlösung zu Tag 13, Auftrag 2.

Gegen die Spec (specs/rabattcode.md) implementiert. Die Akzeptanzkriterien aus der
Spec sind 1:1 als Tests übernommen (tests/test_discount.py).
"""

import re

# 6–12 Zeichen, nur Grossbuchstaben und Ziffern (Anforderung aus der Spec).
_CODE_RE = re.compile(r"^[A-Z0-9]{6,12}$")


def validate_discount_code(code, expired_codes=None, redeemed_codes=None) -> bool:
    """Prüft einen Rabattcode gegen Format, Ablauf und Einmal-Einlösung.

    expired_codes / redeemed_codes sind Mengen bekannter Codes; per Default leer.
    Bewusste ADR-Entscheidung: die Prüfung liegt im Applikationscode, die Zustände
    (abgelaufen / eingelöst) werden als Daten hereingereicht (siehe docs/adr/0001).
    """
    expired_codes = expired_codes or set()
    redeemed_codes = redeemed_codes or set()

    if not isinstance(code, str):
        return False
    if _CODE_RE.match(code) is None:
        return False
    if code in expired_codes:
        return False
    if code in redeemed_codes:
        return False
    return True
