"""Kleine Hilfsfunktionen für den TechStyle-Warenkorb."""


def rabatt(preis, prozent):
    """Gibt den Preis nach Abzug des Rabatts zurück."""
    return round(preis * (1 - prozent / 100), 2)


def warenkorb_summe(positionen):
    """Summiert eine Liste von (preis, menge)-Tupeln."""
    return round(sum(preis * menge for preis, menge in positionen), 2)
