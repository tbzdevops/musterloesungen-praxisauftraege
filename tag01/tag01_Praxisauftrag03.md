# Musterlösung – 📓 Auftrag 3: DORA-Metriken anwenden *(Gruppe 3)*

**Format:** Gruppenarbeit + Präsentation
**Ziel:** Die vier DORA-Metriken benennen, TechStyle damit einstufen und messbare
Verbesserungsziele ableiten (Szenario „TechStyle im Zahlen-Check").

---

## Theorie-Block: Was sind die DORA-Metriken und was machen sie?

Das **DORA-Team** (DevOps Research and Assessment, heute bei Google) erforscht seit Jahren, was
leistungsfähige Software-Teams ausmacht. Vier Schlüssel-Metriken (die *Four Key Metrics*) haben
sich als zuverlässige Indikatoren etabliert. Sie messen zwei Dimensionen:

| Metrik | Was sie misst | Dimension |
|--------|---------------|-----------|
| **Deployment Frequency** | Wie oft wird erfolgreich in Produktion deployt? | Geschwindigkeit |
| **Lead Time for Changes** | Zeit von Commit bis in Produktion | Geschwindigkeit |
| **Change Failure Rate** | Anteil der Deployments, die einen Fehler verursachen | Stabilität |
| **Time to Restore Service** | Wie schnell ist der Service nach einem Ausfall wiederhergestellt? | Stabilität |

**Kernbotschaft:** Die ersten zwei Metriken messen **Tempo/Durchsatz**, die letzten zwei
**Stabilität**. Anhand der Werte teilt DORA Teams in **Elite / High / Medium / Low Performer** ein.
Entscheidend: Gute Teams sind nachweislich *gleichzeitig* schnell **und** stabil – Tempo geht
**nicht** auf Kosten der Stabilität.

### Orientierungs-Bänder (vereinfacht)

| Metrik | Elite | High | Medium | Low |
|--------|-------|------|--------|-----|
| **Deployment Frequency** | mehrmals pro Tag (on demand) | 1×/Tag – 1×/Woche | 1×/Woche – 1×/Monat | seltener als 1×/Monat |
| **Lead Time for Changes** | < 1 Stunde | < 1 Tag | 1 Tag – 1 Woche | > 1 Woche |
| **Change Failure Rate** | 0–15 % | 0–15 % | 0–15 % | > 30 % |
| **Time to Restore Service** | < 1 Stunde | < 1 Tag | 1 Tag – 1 Woche | > 1 Woche |

---

## Das Szenario (Kurzfassung)

> TechStyle-Kennzahlen der letzten 12 Monate: **4 Releases/Jahr** (quartalsweise, freitags per
> FTP); im Schnitt **14 Tage** von „Code fertig" bis in den Shop; **jedes zweite Release** muss
> zurückgerollt werden (~50 %); letzter Ausfall (Black Friday) **3 h offline**, erst über soziale
> Medien bemerkt.

---

## Musterlösung der Gruppenarbeit

| Metrik | Ist-Wert | Einstufung | Ziel (20 Wochen) | Massnahme |
|--------|----------|------------|------------------|-----------|
| **Deployment Frequency** | 4×/Jahr (~1×/Quartal) | **Low** | mind. **1×/Woche** | CI/CD-Pipeline (Tag 04) + kleine, unabhängige Releases |
| **Lead Time for Changes** | ~14 Tage | **Low** (Ziel sind Stunden) | **< 1 Tag** | Review entlasten + automatische Tests statt manueller QA; kleine PRs |
| **Change Failure Rate** | ~50 % | **Low** (Elite 0–15 %) | **< 15 %** | Automatisierte Tests + Staging/Canary statt „Big-Bang-FTP" am Freitag |
| **Time to Restore Service** | ~3 h, ohne Monitoring entdeckt | **Medium** (siehe Hinweis) | **< 1 Stunde**, aktiv erkannt | Monitoring + Alerting (Tag 10/11), automatisiertes Rollback |

**Hinweis zur Einstufung von Time to Restore:** Nach reiner Zahl (3 h < 1 Tag) läge die Metrik im
**High**-Bereich. ABER: Ohne Monitoring wurde der Ausfall nur **zufällig** über soziale Medien
entdeckt – die Wiederherstellung gelingt rein reaktiv und unzuverlässig. Realistisch ist TechStyle
hier nicht besser als **Medium**. Das ist ein wichtiger Lernpunkt: Eine gute Zahl ohne die
**Fähigkeit, sie verlässlich zu erreichen**, ist Zufall, kein Können.

**Gesamturteil:** TechStyle ist klar ein **Low Performer** – drei von vier Metriken liegen im
Low-Bereich, und auch die Stabilität ist nur scheinbar in Ordnung.

### Erwartetes Präsentationsergebnis
Eine Gruppe hat die Aufgabe gut gelöst, wenn sie:
- jede der **vier Beobachtungen** der **richtigen Metrik** zuordnet,
- TechStyle pro Metrik **plausibel einstuft** (Low/Medium begründet, nicht geraten),
- pro Metrik ein **konkretes, messbares Ziel** und **eine Massnahme** nennt,
- erkennt, dass **Geschwindigkeit (Frequency, Lead Time)** und **Stabilität (Failure Rate,
  Restore)** zusammengehören – beides muss gleichzeitig besser werden.

### Diskussionsimpuls (Plenum)
*Warum sind alle vier Metriken nötig?* – Wer nur auf Tempo optimiert (häufiger deployen), riskiert
mehr Fehler; wer nur auf Stabilität optimiert (selten deployen), wird langsam. Die vier Metriken
zusammen verhindern, dass man eine Dimension auf Kosten der anderen „schönrechnet".

> **Bezug zum Kurs:** Wir kommen ab Tag 04 (CI) und Tag 10/11 (Monitoring) auf diese Metriken
> zurück und prüfen, wie unsere TechStyle-Pipeline jede der vier Zahlen messbar verbessert. DORA
> ist das **Messinstrument**, mit dem wir den Fortschritt der CALMS- und Three-Ways-Massnahmen
> sichtbar machen.
