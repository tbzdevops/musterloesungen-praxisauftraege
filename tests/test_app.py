from app import rabatt, warenkorb_summe


def test_rabatt():
    assert rabatt(100, 20) == 80.0
    assert rabatt(49.90, 0) == 49.9


def test_warenkorb_summe():
    assert warenkorb_summe([(19.90, 2), (5.00, 1)]) == 44.8
    assert warenkorb_summe([]) == 0
