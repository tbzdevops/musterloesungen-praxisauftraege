# Spec: Rabattcode-Validierung

## Ziel
Beim Checkout werden Rabattcodes geprüft, bevor der Rabatt angewendet wird.

## Anforderungen
- Funktion `validate_discount_code(code, expired_codes, redeemed_codes) -> bool`
  im Modul `discounts/validator.py`
- Ein Code besteht aus 6–12 Zeichen, nur Grossbuchstaben A–Z und Ziffern
- Codes aus `expired_codes` (abgelaufen) werden abgelehnt
- Codes aus `redeemed_codes` (Einmal-Code bereits eingelöst) werden abgelehnt

## Akzeptanzkriterien
- "SUMMER25"  (gültig)             -> True
- "abc"       (zu kurz)            -> False
- "EXPIRED10" (in expired_codes)   -> False
- "USED2024"  (in redeemed_codes)  -> False

## Out of Scope
- Höhe des Rabatts (prozentual oder absolut) — späteres Feature
