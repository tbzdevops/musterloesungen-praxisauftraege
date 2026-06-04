# Musterlösung – 📓 Auftrag 2: The Three Ways anwenden *(Gruppe 2)*

**Format:** Gruppenarbeit + Präsentation
**Ziel:** Flow, Feedback und kontinuierliches Lernen verstehen und Engpässe im Wertstrom
„von der Code-Änderung bis in Produktion" (Szenario „Wunschliste") erkennen.

---

## Theorie-Block: Was sind The Three Ways und was machen sie?

Die *Three Ways* stammen aus *The Phoenix Project* / *The DevOps Handbook* (Gene Kim et al.). Sie
beschreiben die **drei grundlegenden Prinzipien**, auf denen alle konkreten DevOps-Praktiken
aufbauen. Man kann sie als aufeinander aufbauende Schritte lesen.

| Weg | Prinzip | Was der Weg bewirkt |
|-----|---------|---------------------|
| **1. The First Way** | **Flow** (Systemdenken) | Betrachtet den gesamten Wertstrom von **links (Dev) nach rechts (Ops)** als ein System. Ziel: den Arbeitsfluss beschleunigen – kleine Batches, Arbeit sichtbar machen (Kanban), Engpässe beseitigen und **nie bekannte Fehler nach rechts weitergeben**. Ergebnis: kürzere Durchlaufzeit. |
| **2. The Second Way** | **Feedback** | Schafft **schnelle, ständige Rückkopplung von rechts nach links**. Probleme werden früh sichtbar (automatische Tests, Monitoring, Alerts), sodass sie sofort behoben werden, statt erst in Produktion aufzufallen. Ergebnis: höhere Qualität, weniger teure Spätfehler. |
| **3. The Third Way** | **Kontinuierliches Lernen & Experimentieren** | Etabliert eine **Kultur des Experimentierens und Lernens**. Es wird Zeit für Verbesserung eingeplant, aus Fehlern (blameless) gelernt und Routine durch Übung gefestigt. Ergebnis: das System wird über die Zeit kontinuierlich besser und resilienter. |

**Kernbotschaft:** Der erste Weg bringt **Tempo** (Flow), der zweite Weg sichert **Qualität**
(Feedback), der dritte Weg sorgt für **stetige Verbesserung** (Lernen). Erst zusammen erlauben sie
*schnell UND stabil* zu sein – genau das, was die DORA-Metriken messen.

---

## Das Szenario (Kurzfassung)

> Entwicklerin **Sara** baut die Wunschliste. Tag 1: Feature in einem grossen Branch, Test nur „auf
> meinem Laptop". Tag 2–6: PR liegt 4 Tage, weil nur der Teamleiter reviewen darf. Tag 7–13:
> separate QA testet von Hand, schickt einen Bug zurück (Kontextverlust). Tag 14, freitags 18:00:
> Markus deployt 6 Features gebündelt per FTP, ohne automatische Tests. Wochenende: Fehler bei
> jedem zweiten Klick, **niemand merkt es** (kein Monitoring). Montag: Kundenbeschwerden, ganzes
> Release wird zurückgerollt. Danach: **kein Post-mortem** – 3 Wochen später fast derselbe Fehler.

---

## Musterlösung der Gruppenarbeit

| Weg | Beobachtete Engpässe im Szenario | Grösster Engpass | Erster Lösungsschritt | Messbar via DORA |
|-----|----------------------------------|------------------|-----------------------|------------------|
| **1. Flow** | 4 Tage Review-Stau (nur Teamleiter reviewt); grosse Batches (1 grosser Branch, 6 Features in einem Release); Gesamtdurchlaufzeit 14 Tage. | Der **Review-Engpass** + das Bündeln zu Grossreleases. | Review entlasten (mehrere Reviewer / kleine PRs) und **kleine, häufige Releases** statt eines Quartalspakets; CI/CD ab Tag 04. | Lead Time for Changes ↓, Deployment Frequency ↑ |
| **2. Feedback** | Keine automatischen Tests; manuelle QA erst nach Tagen; Fehler erst über **Kundenbeschwerden am Montag** sichtbar (kein Monitoring). | Fehler werden **zu spät** (in Produktion, durch Kunden) entdeckt. | **Automatisierte Tests in der Pipeline** (Tag 06/07) + **Monitoring/Alerts** in Produktion (Tag 10/11). | Change Failure Rate ↓ |
| **3. Lernen** | **Kein Post-mortem** nach dem Rollback; derselbe Fehler wiederholt sich 3 Wochen später; Wissen bleibt bei Einzelnen. | Aus Fehlern wird **nicht gelernt** – sie wiederholen sich. | **Blameless Post-Mortems** nach jedem Incident + feste Zeit für Verbesserungsarbeit (Retros/Workshops). | Time to Restore Service ↓ |

### Erwartetes Präsentationsergebnis
Eine Gruppe hat die Aufgabe gut gelöst, wenn sie:
- die **drei Wege** korrekt benennt und in der richtigen Reihenfolge (Flow → Feedback → Lernen) erklärt,
- für jeden Weg einen **konkreten Engpass aus dem Szenario** belegt,
- pro Weg den **grössten Engpass** markiert und einen **plausiblen ersten Lösungsschritt** vorschlägt,
- die Brücke zu **mindestens einer DORA-Metrik** schlägt.

### Diskussionsimpuls (Plenum)
*Warum die Reihenfolge?* – Ohne **Flow** gibt es nichts, worauf Feedback wirken kann; ohne
**Feedback** weiss man nicht, was man lernen soll. Der dritte Weg verstärkt die ersten beiden.
Im Szenario sieht man die Kette deutlich: langsamer Flow (14 Tage) → spätes Feedback (Montag durch
Kunden) → fehlendes Lernen (Fehler wiederholt sich).

> **Bezug zum Kurs:** Die Three Ways ziehen sich durch alle Tage – Flow (Tag 04 CI, Tag 08
> Deployment), Feedback (Tag 06/07 Testing, Tag 10/11 Monitoring), Lernen (Workshops & Retros).
