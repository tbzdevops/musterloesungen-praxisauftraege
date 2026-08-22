# ADR 0001: Rabattcode-Validierung im Applikationscode

## Status
Akzeptiert

## Kontext
Rabattcodes müssen beim Checkout geprüft werden (Format, Ablauf, Einmal-Einlösung).
Die Prüfung könnte entweder direkt in der Datenbank (Constraints / Stored Procedures)
oder im Applikationscode erfolgen. Wir wollten die Regeln testbar, versionierbar und
unabhängig vom konkreten Datenbanksystem halten.

## Entscheidung
Die Validierung erfolgt im Applikationscode (`discounts/validator.py`) mit einer
reinen Funktion. Ablauf- und Einlöse-Status werden als Daten (Mengen) hereingereicht,
statt sie in der Funktion selbst aus der DB zu laden. So bleibt die Kernlogik frei von
I/O und ist mit einfachen Unit-Tests vollständig abgedeckt.

## Konsequenzen
**Vorteile:**
- Regeln sind als Code versioniert und mit `pytest` schnell testbar.
- Portabel — kein DB-spezifischer Constraint-Dialekt.
- Die Akzeptanzkriterien der Spec lassen sich 1:1 als Tests übernehmen.

**Nachteile:**
- Die Validierung schützt nicht auf DB-Ebene; wird die Funktion umgangen, greift die
  Regel nicht. Für kritische Invarianten (z. B. doppelte Einlösung) ist zusätzlich eine
  DB-Transaktion / ein Unique-Constraint sinnvoll.
