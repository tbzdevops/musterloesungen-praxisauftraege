# Musterlösung: Full Self Driving für LKWs in MVP-Schritte aufteilen

---

## 1. Analyse der Kernfunktionalitäten

Das Full Self Driving Feature für LkWs umfasst komplexe autonome Fahrfunktionen, die das Fahrzeug in die Lage versetzen, ohne menschliches Eingreifen sicher zu navigieren. Die wichtigsten Kernfunktionalitäten sind:

- Spurhaltung und adaptive Geschwindigkeitsregelung auf Autobahnen
- Automatisches Spurwechseln
- Verkehrszeichenerkennung und Geschwindigkeitsanpassung
- Hinderniserkennung und Notbremsung
- Navigation auf vorgegebenen Routen
- Kommunikation mit Infrastruktur und anderen Fahrzeugen (V2X)

Für ein erstes MVP konzentrieren wir uns auf die grundlegenden Funktionen, die den LkW sicher und autonom auf Autobahnen bewegen können. Der Autobahnbetrieb bietet das günstigste Verhältnis aus Nutzen, technischer Machbarkeit und Risiko.

---

## 2. Definition der 3 MVP-Phasen

| MVP-Phase | Fokus | Kernfunktionen |
|-----------|-------|----------------|
| **MVP 1 – Highway Pilot** | Basisautonomie auf Autobahnen | Spurhaltung, adaptive Geschwindigkeit, Spurwechsel, Notbremsung |
| **MVP 2 – Erweiterte Autonomie** | Verkehrszeichen & komplexe Manöver | Tempolimits, Baustellen, Ein-/Ausfahrten |
| **MVP 3 – Urbane Erweiterung** | Städtisches Umfeld & Vernetzung | Landstrassen, Stadtverkehr, V2X-Kommunikation |

---

## 3. MVP-Schritte im Detail

### MVP 1: Autonomes Fahren auf Autobahnen (Highway Pilot)

**Funktionen:**
- Stabilität in der Spurhaltung
- Anpassung der Geschwindigkeit an den Verkehrsfluss
- Automatisches Spurwechseln bei freier Bahn
- Erkennung von grösseren Hindernissen und Notbremsung

**Nutzen für den Nutzer:**
- Entlastung des Fahrers bei langen Autobahnfahrten
- Erhöhung der Fahrsicherheit und Reduzierung von Ermüdungserscheinungen

**Feedbackziele:**
- Bedienbarkeit und Vertrauen in das System
- Reaktion des Systems auf Verkehrssituationen
- Komfort- und Sicherheitsempfinden der Nutzer

---

### MVP 2: Erweiterte Autonomie mit Verkehrszeichenerkennung

**Funktionen:**
- Automatische Anpassung an Tempolimits und Baustellen
- Unterstützung beim Ein- und Ausfädeln auf Autobahnen
- Erweiterte Hinderniserkennung im komplexeren Verkehrsfluss

**Nutzen für den Nutzer:**
- Erhöhte Sicherheit durch Einhaltung der Verkehrsregeln
- Weniger manuelle Eingriffe bei komplexeren Situationen

**Feedbackziele:**
- Genauigkeit der Verkehrszeichenerkennung
- Verlässlichkeit bei dynamischen Verkehrssituationen
- Akzeptanz der automatischen Manöver

---

### MVP 3: Teilautonomes Fahren im urbanen Umfeld und Kommunikation

**Funktionen:**
- Autonomes Fahren auf Landstrassen und einfachen Stadtstrassen
- Kommunikation mit Verkehrsampeln, anderen Fahrzeugen und Infrastruktur (V2X)
- Erkennung von Fussgängern, Radfahrern und kleineren Hindernissen

**Nutzen für den Nutzer:**
- Erweiterte Einsatzmöglichkeiten des Systems ausserhalb der Autobahn
- Verbesserte Verkehrssicherheit durch Vernetzung

**Feedbackziele:**
- Funktionalität und Zuverlässigkeit im urbanen Umfeld
- Reaktionsschnelligkeit auf unerwartete Verkehrsteilnehmer
- Wahrgenommenes Sicherheits- und Komfortempfinden

---

## 4. Technische Sicherheitsanforderungen pro MVP

| MVP | Anforderungen |
|-----|---------------|
| **MVP 1** | Hohe Ausfallsicherheit der Sensorik (Radar, Lidar, Kameras); redundante Systeme für Steuerung und Bremsen |
| **MVP 2** | Erweiterte Softwarevalidierung für Verkehrszeichenerkennung; Anpassung an dynamische Baustellenregelungen |
| **MVP 3** | Sichere V2X-Kommunikationsprotokolle; Einhaltung von Datenschutz- und Sicherheitsrichtlinien |

---

## 5. Priorisierung der MVP-Schritte

| Priorität | MVP-Phase | Begründung |
|-----------|-----------|------------|
| 1 | **MVP 1 – Highway Pilot** | Höchster Nutzen bei überschaubarem Risiko; technisch am machbarsten; schnellster Markteintritt |
| 2 | **MVP 2 – Erweiterte Autonomie** | Baut direkt auf MVP 1 auf; erhöht Sicherheit und Funktionalität; moderate Komplexität |
| 3 | **MVP 3 – Urbane Erweiterung** | Höchste Komplexität und regulatorische Hürden; langfristiges Ziel für Markterweiterung |

---

> **Verknüpfung mit Epics & User Stories:** Jede MVP-Phase entspricht einem Epic im Projekt-Backlog. Die detaillierten User Stories für **MVP 1 (Highway Pilot)** — inklusive Akzeptanzkriterien — sind in der Epics & User Stories Musterlösung ausformuliert.
