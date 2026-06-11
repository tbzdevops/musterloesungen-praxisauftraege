# Musterlösung: Epics und User Stories – FSD Highway Pilot

> **Grundlage:** Diese Lösung baut direkt auf **MVP 1 (Highway Pilot)** aus der FSD MVP-Musterlösung auf. Die vier Kernfunktionen und die drei Feedbackziele von MVP 1 werden hier als Epic und User Stories ausformuliert.

---

## Epic 1: Autonomes Fahren auf Autobahnen (Highway Pilot)

**Beschreibung:**  
Das System ermöglicht es LKWs, auf Autobahnen autonom zu fahren. Es hält die Spur stabil, passt die Geschwindigkeit an den Verkehrsfluss an, führt Spurwechsel durch und bremst bei Hindernissen kontrolliert ab. Ziel ist die Entlastung des Fahrers bei langen Autobahnfahrten, die Erhöhung der Fahrsicherheit und die Reduzierung von Ermüdungserscheinungen.

**Umfang (entspricht MVP 1):**
- Stabilität in der Spurhaltung
- Anpassung der Geschwindigkeit an den Verkehrsfluss
- Automatisches Spurwechseln bei freier Bahn
- Erkennung von grösseren Hindernissen und Notbremsung

---

## User Stories

### US-01: Spurhaltung

*Als LKW-Fahrer möchte ich, dass das System den LKW stabil und sicher in der Fahrspur hält, damit ich mich bei langen Autobahnfahrten nicht durchgehend auf die Spurhaltung konzentrieren muss und Ermüdung reduziert wird.*

**Akzeptanzkriterien:**
- Das System erkennt Fahrbahnmarkierungen bei Tageslicht, Nacht und leichtem Regen zuverlässig.
- Das System korrigiert die Lenkung automatisch, um den LKW mittig in der Spur zu halten.
- Bei Verlust der Fahrbahnmarkierung warnt das System den Fahrer akustisch und visuell innerhalb von 2 Sekunden.

---

### US-02: Adaptive Geschwindigkeitsregelung

*Als LKW-Fahrer möchte ich, dass das System die Geschwindigkeit automatisch an den Verkehrsfluss anpasst, damit ich sicher und effizient fahre, ohne ständig auf Bremse oder Gas treten zu müssen.*

**Akzeptanzkriterien:**
- Das System erkennt vorausfahrende Fahrzeuge und hält einen dem Tempo entsprechenden Sicherheitsabstand.
- Die Geschwindigkeit wird stets innerhalb des gültigen Tempolimits gehalten.
- Der Fahrer kann die automatische Geschwindigkeitsanpassung jederzeit manuell übersteuern.

---

### US-03: Automatischer Spurwechsel

*Als LKW-Fahrer möchte ich, dass das System bei freier Bahn selbstständig den Spurwechsel einleitet, damit Überholvorgänge sicher und komfortabel ablaufen, ohne dass ich manuell eingreifen muss.*

**Akzeptanzkriterien:**
- Das System prüft vor jedem Spurwechsel den toten Winkel und den rückwärtigen Verkehr vollständig.
- Der Spurwechsel wird nur ausgeführt, wenn keine Gefährdung anderer Verkehrsteilnehmer besteht.
- Das System informiert den Fahrer vor und während des Spurwechsels über den laufenden Vorgang.

---

### US-04: Notbremsung bei Hindernissen

*Als Sicherheitsbeauftragter möchte ich, dass das System grössere Hindernisse frühzeitig erkennt und automatisch eine kontrollierte Notbremsung einleitet, damit Unfälle und Sachschäden verhindert werden.*

**Akzeptanzkriterien:**
- Das System erkennt Hindernisse auf der Fahrbahn bis mindestens 150 Meter Entfernung.
- Bei erkannter Kollisionsgefahr leitet das System sofort eine kontrollierte Notbremsung ein.
- Der Fahrer wird gleichzeitig akustisch und visuell über die Notbremsung informiert.

---

### US-05: Bedienbarkeit und Systemvertrauen

*Als LKW-Fahrer möchte ich, dass das System einfach aktivierbar ist und mir jederzeit seinen aktuellen Zustand anzeigt, damit ich Vertrauen in das autonome Fahren aufbauen und das System sicher im Alltag einsetzen kann.*

**Akzeptanzkriterien:**
- Das System kann über eine klar beschriftete Schaltfläche aktiviert und deaktiviert werden.
- Alle Systemzustände (aktiv, Warnung, Übernahme durch Fahrer erforderlich) werden übersichtlich und verständlich angezeigt.
- Der Fahrer kann jederzeit manuell eingreifen und hat immer Vorrang vor dem System.

---

> **Nächste Epics:** MVP 2 (Erweiterte Autonomie mit Verkehrszeichenerkennung) und MVP 3 (Urbane Erweiterung & V2X-Kommunikation) werden als Epic 2 und Epic 3 in nachfolgenden Sprint-Zyklen ausformuliert — die Grundlage dafür liefert die FSD MVP-Musterlösung.
