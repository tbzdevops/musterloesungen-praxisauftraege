# Musterlösung – 📓 Auftrag 1: CALMS-Framework anwenden *(Gruppe 1)*

**Format:** Gruppenarbeit + Präsentation
**Ziel:** Die fünf CALMS-Säulen benennen und am konkreten Szenario „Ein Tag bei TechStyle"
Ist-Zustand und Verbesserungen ableiten.

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

## Das Szenario (Kurzfassung)

> TechStyle: Online-Shop als ein grosser Codeblock. Deployments macht Admin **Markus** freitags um
> 18:00 von Hand per FTP. Dev und Ops sitzen in getrennten Abteilungen und schieben sich nach
> Ausfällen die Schuld zu. Releases nur viermal im Jahr; die Wunschliste liegt seit fünf Monaten
> „fast fertig". Kein Monitoring – der Black-Friday-Ausfall (3 h) fiel erst über soziale Medien
> auf. Wie deployt wird, weiss nur Markus; die Doku ist von 2019.

---

## Musterlösung der Gruppenarbeit

Jede Beobachtung im Szenario lässt sich genau einer Säule zuordnen. Erwartet wird pro Säule ein
belegter Ist-Zustand **und** eine konkrete Massnahme.

| Säule | Ist-Zustand (Beleg im Szenario) | Konkrete Verbesserung |
|-------|----------------------------------|-----------------------|
| **Culture** | Dev und Ops in getrennten Abteilungen; nach Ausfällen Schuldzuweisung („kaputter Code" ↔ „instabiler Server"). | Gemeinsame Verantwortung „you build it, you run it"; **Blameless Post-Mortems** nach jedem Incident statt Schuldsuche. |
| **Automation** | Deployment freitags von Hand per FTP, Server-Neustart „und hoffen"; keine automatischen Tests. | **CI/CD-Pipeline** (ab Tag 04), die bei jedem Push automatisch baut, testet und deployt – reproduzierbar statt Handarbeit. |
| **Lean** | Nur 4 grosse Releases/Jahr; Wunschliste seit 5 Monaten „fast fertig" auf einem Branch (Bestand statt Wert). | In **kleinen Inkrementen** liefern (MVP-Slicing, vgl. Tag 03); Feature-Branches kurz halten, häufig mergen. |
| **Measurement** | Kein Monitoring; der 3-stündige Ausfall wurde erst durch Kunden in sozialen Medien bemerkt. | **Monitoring + Alerting** (Tag 10/11) und Erhebung der **DORA-Metriken** – Probleme messen statt erraten. |
| **Sharing** | Nur Markus kennt das Deployment; Doku von 2019; bei seiner Krankheit traute sich niemand an ein Release. | Deployment dokumentieren und automatisieren (Bus-Faktor senken); gemeinsames Repo-README/Runbooks; Wissens-Sessions. |

### Erwartetes Präsentationsergebnis
Eine Gruppe hat die Aufgabe gut gelöst, wenn sie:
- alle **fünf Säulen** korrekt benennt und in eigenen Worten erklärt,
- jede Säule mit einer **konkreten Stelle aus dem Szenario** belegt (nicht nur allgemein),
- pro Säule **eine umsetzbare Verbesserung** nennt (keine Allgemeinplätze),
- erkennt, dass **Culture** die Voraussetzung für die übrigen Säulen ist.

### Diskussionsimpuls (Plenum)
*Welche Säule ist bei TechStyle am schwächsten?* – Technisch fällt **Automation** sofort auf
(FTP-Freitag). Die eigentliche Wurzel ist aber **Culture**: Solange Dev und Ops sich die Schuld
zuschieben, wird keine Pipeline gebaut und kein Wissen geteilt. Schnellster Hebel mit grosser
Wirkung: die CI-Pipeline (Automation), weil sie zugleich Measurement und Sharing ermöglicht.

> **Bezug zum Kurs:** Jede Säule taucht wieder auf – Automation (Tag 04 CI), Measurement
> (Tag 10/11 Monitoring), Sharing (Workshops). CALMS ist die Landkarte für die 20-Wochen-Reise.
