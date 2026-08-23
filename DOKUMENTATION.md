# Sicherheitsbefunde DSVPWA — Tag 12 Praxis

Dokumentation der Befunde aus **Auftrag 1** (statische Analyse mit Snyk) und **Auftrag 2**
(dynamischer Test mit OWASP ZAP) an der Anwendung
[DSVPWA](https://github.com/tbzdevops/DSVPWA). Die vollständigen Durchführungen stehen in
[tag12/tag12_Praxisauftrag01.md](tag12/tag12_Praxisauftrag01.md) und
[tag12/tag12_Praxisauftrag02.md](tag12/tag12_Praxisauftrag02.md).

## Befunde und Massnahmen

| # | Schwachstelle | Gefunden durch | Severity | Massnahme |
|---|---------------|----------------|----------|-----------|
| 1 | SQL-Injection in `sqli.py` — Benutzereingabe fliesst per String-Konkatenation in den Query | Snyk Code (SAST) **und** ZAP Baseline (DAST) | High | Parametrisierte Query: `cursor.execute("SELECT ... WHERE id = ?", (user_id,))` |
| 2 | Verwundbare Open-Source-Abhängigkeiten in `requirements.txt` (veraltete, gepinnte Versionen) | Snyk Open Source (SCA) | High | Versionen auf die von Snyk vorgeschlagenen gepatchten Releases anheben, danach `snyk test` erneut ausführen |
| 3 | Fehlender `X-Frame-Options`-Header (Clickjacking) | nur ZAP Baseline (DAST) | Medium | Header serverseitig setzen: `resp.headers["X-Frame-Options"] = "DENY"` |
| 4 | Reflektiertes XSS in der Suchausgabe | Snyk Code (SAST) | Medium | Ausgabe kontextgerecht escapen statt roh in die HTML-Antwort schreiben |

## Vergleich SAST/SCA und DAST

Die beiden Verfahren decken **unterschiedliche Klassen** von Lücken auf. SAST sieht den ruhenden
Code und findet die SQL-Injection an der Quelle — inklusive Datei und Zeile. SCA prüft
ausschliesslich die deklarierten Abhängigkeiten und kennt den eigenen Code gar nicht. DAST kennt
umgekehrt den Quellcode nicht, sieht dafür das **Laufzeitverhalten**: fehlende Security-Header wie
`X-Frame-Options` sind statisch nicht sichtbar, weil sie erst beim Ausliefern der Antwort
entstehen (bzw. eben nicht entstehen).

Nur die SQL-Injection wurde von beiden Verfahren gemeldet — sie wurde zusätzlich manuell
verifiziert. Daraus folgt die Priorisierung: Befund 1 und 2 zuerst (direkt ausnutzbar bzw.
bekannte CVEs), danach 3 und 4.

## Automatisierung

Beide Prüfungen laufen als GitHub-Actions-Workflows und damit bei jeder Änderung mit:

- [`.github/workflows/aufgabe1-sast-sca.yml`](.github/workflows/aufgabe1-sast-sca.yml) — Snyk
  Open Source (SCA) und Snyk Code (SAST), Ergebnisse als SARIF im Security-Tab.
- [`.github/workflows/aufgabe2-dast.yml`](.github/workflows/aufgabe2-dast.yml) — Anwendung im
  Runner starten und OWASP ZAP Baseline dagegen laufen lassen.
