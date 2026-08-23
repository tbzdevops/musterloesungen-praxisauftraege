"""Akzeptanzkriterien aus specs/rabattcode.md als ausführbare Tests."""

from discounts.validator import validate_discount_code

EXPIRED = {"EXPIRED10"}
REDEEMED = {"USED2024"}


def test_gueltiger_code():
    assert validate_discount_code("SUMMER25", EXPIRED, REDEEMED) is True


def test_zu_kurz():
    assert validate_discount_code("abc", EXPIRED, REDEEMED) is False


def test_abgelaufen():
    assert validate_discount_code("EXPIRED10", EXPIRED, REDEEMED) is False


def test_bereits_eingeloest():
    assert validate_discount_code("USED2024", EXPIRED, REDEEMED) is False


def test_kleinbuchstaben_abgelehnt():
    # "summer25" verletzt die Grossbuchstaben-Anforderung
    assert validate_discount_code("summer25") is False
