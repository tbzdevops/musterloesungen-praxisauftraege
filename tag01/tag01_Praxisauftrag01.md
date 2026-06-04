# Musterlösung – 📓 Auftrag 1: AWS Academy Login einrichten

**Ziel:** Jede Person hat einen funktionierenden AWS-Zugang und kann die Management Console öffnen.

## Schritte (Soll-Zustand)

1. **Einladung annehmen**
   - E-Mail von *AWS Academy* öffnen → Link "Get Started" folgen.
   - Mit der Schul-/Kurs-E-Mail einen Canvas-Account erstellen oder einloggen.

2. **Kurs beitreten**
   - Im [AWS Academy Canvas](https://awsacademy.instructure.com/login/canvas) erscheint der Kurs
     **AWS Academy Learner Lab**.
   - Modul **Learner Lab** öffnen.

3. **Lab starten**
   - Button **Start Lab** klicken. Die Statusampel wechselt von rot → gelb → **grün**.
   - Bei grüner Ampel auf **AWS** klicken → die **AWS Management Console** öffnet sich in einem
     neuen Tab.

4. **CLI-Credentials lokalisieren** (für spätere Tage)
   - Im Lab auf **AWS Details** klicken → dort stehen unter *AWS CLI* die temporären Credentials
     (`aws_access_key_id`, `aws_secret_access_key`, `aws_session_token`).
   - Hinweis: Diese Credentials sind **temporär** und ändern sich bei jedem Lab-Start.

## Checkpoint / Abnahme

- [x] Statusampel im Learner Lab ist **grün**.
- [x] AWS Management Console ist erreichbar (z. B. EC2-Dashboard öffnet sich).
- [x] Screenshot der Konsole mit aktivem Lab als Nachweis.

## Häufige Stolpersteine

| Problem | Lösung |
|---------|--------|
| Einladungslink abgelaufen | Lehrperson bittet um erneute Einladung in AWS Academy. |
| Ampel bleibt gelb | 1–2 Minuten warten; Lab bereitet die Umgebung vor. |
| Console-Tab wird blockiert | Popup-Blocker für `awsacademy.instructure.com` erlauben. |
| Credentials funktionieren später nicht | Lab war gestoppt → neu starten, Credentials neu kopieren. |

> **Bezug zum Kurs:** Den AWS-Zugang brauchen wir ab Tag 08 (Deployment) und Tag 18 (IaC).
