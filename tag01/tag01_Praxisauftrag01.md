# Musterlösung – 📓 Auftrag 1: CALMS-Framework anwenden

**Format:** Gruppenarbeit (3–4er) + Präsentation
**Ziel:** Die fünf CALMS-Säulen benennen und auf eine reale Organisation (eigener Betrieb oder
TechStyle) anwenden.

---

## Theorie-Block: Was ist CALMS und was macht es?

CALMS ist ein Modell, mit dem sich die **DevOps-Reife** einer Organisation einordnen lässt. Der
Begriff wurde von Jez Humble geprägt und beschreibt die fünf Dimensionen, die zusammen eine
funktionierende DevOps-Kultur ausmachen. CALMS ist **keine Tool-Liste**, sondern ein Raster, um zu
fragen: *Wo stehen wir – und woran sollten wir als Nächstes arbeiten?*

| Buchstabe | Säule | Was die Säule bewirkt |
|-----------|-------|-----------------------|
| **C** | **Culture** (Kultur) | Baut Silos zwischen Dev und Ops ab. Gemeinsame Verantwortung statt Schuldzuweisung; eine **Blameless-Fehlerkultur**, in der Probleme offen angesprochen werden. Ohne Kultur bleiben alle anderen Säulen wirkungslos. |
| **A** | **Automation** (Automatisierung) | Automatisiert wiederkehrende, fehleranfällige Handarbeit: Builds, Tests, Deployments, Infrastruktur (IaC). Schafft Wiederholbarkeit und Tempo und reduziert menschliche Fehler. |
| **L** | **Lean** | Überträgt Lean-Prinzipien auf IT: **Verschwendung reduzieren**, in **kleinen Batches** arbeiten, den **Wertstrom** sichtbar machen und Engpässe beseitigen. Kleine Schritte = schnelleres Feedback. |
| **M** | **Measurement** (Messung) | Macht Verbesserung **datenbasiert** statt nach Bauchgefühl. Es werden Durchlaufzeit, Fehlerquote, Deployment-Häufigkeit usw. gemessen (vgl. DORA-Metriken). "You can't improve what you don't measure." |
| **S** | **Sharing** (Teilen) | Wissen, Werkzeuge und Verantwortung werden **geteilt**. Transparenz, gemeinsame Dokumentation, offene Feedback-Kanäle. Verhindert Wissensinseln und stärkt die Kultur. |

**Kernbotschaft:** Die Säulen wirken zusammen. *Culture* und *Sharing* bilden das soziale
Fundament, *Automation* und *Lean* die technisch-prozessuale Umsetzung, *Measurement* schliesst
die Feedback-Schleife, damit Verbesserung sichtbar wird.

---

## Musterlösung der Gruppenarbeit (Beispiel: TechStyle)

Beispielhafte Analyse des Ist-Zustands und je einer konkreten Verbesserung pro Säule.

| Säule | Ist-Zustand bei TechStyle | Konkrete Verbesserung |
|-------|---------------------------|-----------------------|
| **Culture** | Entwickler und Betrieb arbeiten in Silos; bei Ausfällen wird nach Schuldigen gesucht. | Gemeinsame Verantwortung einführen; Blameless Post-Mortems nach Incidents. |
| **Automation** | Deployments laufen manuell per Skript, Tests werden von Hand ausgeführt. | CI-Pipeline aufsetzen (ab Tag 04), die bei jedem Push automatisch baut und testet. |
| **Lean** | Grosse Releases alle paar Monate, viele Features auf einmal. | In kleinen, unabhängigen Inkrementen liefern (MVP-Slicing, vgl. Tag 03). |
| **Measurement** | Niemand weiss, wie oft deployt wird oder wie lange ein Fix dauert. | DORA-Metriken erheben; später Monitoring/Dashboards (Tag 10/11). |
| **Sharing** | Wissen steckt in einzelnen Köpfen, kaum Dokumentation. | Gemeinsames Repo-README + Branching-Doku; regelmässige Wissens-Sessions. |

### Erwartetes Präsentationsergebnis
Eine Gruppe hat die Aufgabe gut gelöst, wenn sie:
- alle **fünf Säulen** korrekt benennt und in eigenen Worten erklärt,
- pro Säule einen **plausiblen Ist-Zustand** beschreibt,
- pro Säule **eine konkrete, umsetzbare Verbesserung** nennt (keine Allgemeinplätze),
- erkennt, dass **Culture** die Voraussetzung für die übrigen Säulen ist.

### Diskussionsimpuls (Plenum)
*Welche Säule fällt am schwersten?* – In der Praxis meist **Culture**, weil sie Verhalten und
Organisation betrifft und sich nicht "installieren" lässt.

> **Bezug zum Kurs:** Jede Säule taucht wieder auf – Automation (Tag 04 CI), Measurement
> (Tag 10/11 Monitoring), Sharing (Workshops). CALMS ist die Landkarte für die 20-Wochen-Reise.
