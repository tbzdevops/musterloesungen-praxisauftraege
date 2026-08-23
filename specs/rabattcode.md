# Spec: Rabattcode-Validierung

## Ziel
Beim Checkout sollen Rabattcodes geprüft werden.

## Anforderungen
- Code besteht aus 6–12 alphanumerischen Zeichen (Grossbuchstaben)
- Abgelaufene Codes werden abgelehnt
- Bereits eingelöste Einmal-Codes werden abgelehnt

## Akzeptanzkriterien
- "SUMMER25"  (gültig)        -> akzeptiert
- "abc"       (zu kurz)       -> abgelehnt
- "EXPIRED10" (abgelaufen)    -> abgelehnt

## Out of Scope
- Prozentuale vs. absolute Rabatte (späteres Feature)
