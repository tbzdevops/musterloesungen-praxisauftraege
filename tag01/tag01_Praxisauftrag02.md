# Musterlösung – 📓 Auftrag 2: The Three Ways anwenden

**Format:** Gruppenarbeit (3–4er) + Präsentation
**Ziel:** Flow, Feedback und kontinuierliches Lernen verstehen und Engpässe in einem realen
Wertstrom erkennen.

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

## Musterlösung der Gruppenarbeit (Beispiel-Wertstrom: TechStyle "Code-Änderung → Produktion")

| Weg | Beobachteter Engpass bei TechStyle | Erster Lösungsschritt | Messbar via DORA |
|-----|------------------------------------|-----------------------|------------------|
| **1. Flow** | Manuelle Deployments dauern Stunden; Releases stauen sich zu grossen Paketen. | CI/CD-Pipeline + kleinere, häufigere Releases. | Lead Time for Changes ↓, Deployment Frequency ↑ |
| **2. Feedback** | Fehler fallen erst Kunden in Produktion auf; keine automatischen Tests. | Automatisierte Tests in der Pipeline + Monitoring/Alerts. | Change Failure Rate ↓ |
| **3. Lernen** | Nach Incidents keine Aufarbeitung; dieselben Fehler wiederholen sich. | Blameless Post-Mortems + feste Zeit für Verbesserungsarbeit. | Time to Restore Service ↓ |

### Erwartetes Präsentationsergebnis
Eine Gruppe hat die Aufgabe gut gelöst, wenn sie:
- die **drei Wege** korrekt benennt und in der richtigen Reihenfolge (Flow → Feedback → Lernen) erklärt,
- für jeden Weg einen **konkreten Engpass** im gewählten Wertstrom identifiziert,
- pro Weg einen **plausiblen ersten Lösungsschritt** vorschlägt,
- die Brücke zu **mindestens einer DORA-Metrik** schlägt.

### Diskussionsimpuls (Plenum)
*Warum die Reihenfolge?* – Ohne **Flow** gibt es nichts, worauf Feedback wirken kann; ohne
**Feedback** weiss man nicht, was man lernen soll. Der dritte Weg verstärkt die ersten beiden.

> **Bezug zum Kurs:** Die Three Ways ziehen sich durch alle Tage – Flow (Tag 04 CI, Tag 08
> Deployment), Feedback (Tag 06/07 Testing, Tag 10/11 Monitoring), Lernen (Workshops & Retros).
