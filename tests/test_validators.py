"""Unit-Tests für validate_email — decken die geforderten Edge Cases ab."""

from utils.validators import validate_email


def test_gueltige_adresse():
    assert validate_email("test@example.com") is True


def test_ohne_at_zeichen():
    assert validate_email("invalid-email") is False


def test_domain_ohne_punkt():
    # "a@b" -> Domain ohne Punkt ist ungültig
    assert validate_email("a@b") is False


def test_zu_lang():
    # 250 Zeichen Local-Part + "@x.com" => 256 Zeichen (> 254)
    zu_lang = "a" * 250 + "@x.com"
    assert validate_email(zu_lang) is False


def test_none_und_leer():
    # Vom AI-Vorschlag NICHT behandelte Edge Cases (erst im Review ergänzt):
    assert validate_email(None) is False          # type: ignore[arg-type]
    assert validate_email("") is False
