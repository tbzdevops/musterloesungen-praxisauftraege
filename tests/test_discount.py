"""Tests zu specs/rabattcode.md.

Teil 1: die Akzeptanzkriterien der Spec, 1:1 übernommen.
Teil 2: Randfälle aus dem kritischen Review — sie stehen nicht in der Spec,
und der erste AI-Entwurf ist an zwei davon gescheitert.
"""

import pytest

from discounts.validator import validate_discount_code

EXPIRED = {"EXPIRED10"}
REDEEMED = {"USED2024"}


# --- Akzeptanzkriterien aus der Spec -------------------------------------

def test_gueltiger_code():
    assert validate_discount_code("SUMMER25", EXPIRED, REDEEMED) is True


def test_zu_kurz():
    assert validate_discount_code("abc", EXPIRED, REDEEMED) is False


def test_abgelaufen():
    assert validate_discount_code("EXPIRED10", EXPIRED, REDEEMED) is False


def test_bereits_eingeloest():
    assert validate_discount_code("USED2024", EXPIRED, REDEEMED) is False


# --- Randfälle aus dem Review ---------------------------------------------

@pytest.mark.parametrize("code", [
    "summer25",        # Kleinbuchstaben
    " SUMMER25",       # führendes Leerzeichen
    "SUMMER25!",       # Sonderzeichen
    "SUMMER25\n",      # Zeilenumbruch — der AI-Entwurf liess ihn durch
    "ABCDEFGHIJKLM",   # 13 Zeichen
])
def test_formatfehler_abgelehnt(code):
    assert validate_discount_code(code) is False


def test_kein_string_abgelehnt():
    # Der AI-Entwurf warf hier einen AttributeError.
    assert validate_discount_code(None) is False


def test_grenzen_6_und_12_zeichen():
    assert validate_discount_code("ABC123") is True
    assert validate_discount_code("ABCDEF123456") is True


def test_ohne_listen_aufrufbar():
    assert validate_discount_code("SUMMER25") is True
