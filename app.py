"""Kleine Hilfsfunktionen fuer den TechStyle-Warenkorb."""


def rabatt(preis, prozent):
    """Gibt den Preis nach Abzug des Rabatts zurueck."""
    return round(preis * (1 - prozent / 100), 2)


def warenkorb_summe(positionen):
    """Summiert eine Liste von (preis, menge)-Tupeln."""
    return round(sum(preis * menge for preis, menge in positionen), 2)
