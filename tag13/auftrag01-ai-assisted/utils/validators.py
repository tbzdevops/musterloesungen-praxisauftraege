"""E-Mail-Validierung — Musterlösung zu Tag 13, Auftrag 1.

Entstanden aus einem AI-Vorschlag (Copilot / GitHub Models) und danach KRITISCH
geprüft und korrigiert. Die Kommentare halten fest, was am AI-Output angepasst wurde.
"""

import re

# Bewusst pragmatisch (kein RFC-5322-Vollparser): genau ein '@', nicht-leerer
# Local-Part, Domain mit mindestens einem Punkt und nicht-leeren Labels.
_EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


def validate_email(email: str) -> bool:
    """Gibt True zurück, wenn die E-Mail-Adresse plausibel gültig ist.

    Prüft: genau ein '@', Domain enthält einen Punkt, Gesamtlänge <= 254 Zeichen.
    """
    # AI-Ergänzung nach Review: Typ-Absicherung, sonst crasht len()/re bei None.
    if not isinstance(email, str):
        return False
    # Review-Korrektur: RFC 5321 begrenzt die Adresse auf 254 Zeichen.
    if len(email) > 254:
        return False
    return _EMAIL_RE.match(email) is not None
