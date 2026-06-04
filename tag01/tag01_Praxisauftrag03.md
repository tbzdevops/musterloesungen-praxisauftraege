# Musterlösung – 📓 Auftrag 3: Kanban-Board mit GitHub Projects einrichten

**Ziel:** Ein funktionierendes Kanban-Board, das den Arbeitsfluss (vgl. *The First Way – Flow*)
sichtbar macht.

## Schritte (Soll-Zustand)

1. **Projekt anlegen**
   - Im Repository (oder Profil) auf **Projects → New project** klicken.
   - Vorlage **Board** wählen, Namen vergeben, z. B. *TechStyle Transformation*.

2. **Spalten definieren**
   - Standardspalten so anpassen, dass es genau drei gibt:
     **Todo** · **In Progress** · **Done**.

3. **Issues erstellen** (3–5 Stück)
   - Beispiele für den Start:
     - *App lokal lauffähig machen*
     - *Kickoff-Dokumentation lesen*
     - *Branching-Strategie definieren (Tag 02)*
     - *Erste CI-Pipeline planen (Tag 04)*
   - Jedes Issue mit kurzer Beschreibung und – wo sinnvoll – einer Definition-of-Done-Häkchenliste:
     ```markdown
     ## Definition of Done
     - [ ] App startet ohne Fehler auf localhost:5000
     - [ ] Startseite zeigt Produkte an
     ```

4. **Issues mit dem Board verknüpfen**
   - Issues dem Project hinzufügen (`+ Add item` oder im Issue rechts unter *Projects*).
   - Aktuell bearbeitetes Issue in die Spalte **In Progress** ziehen.

## Beispiel-Board (Soll-Zustand)

| Todo | In Progress | Done |
|------|-------------|------|
| Branching-Strategie definieren | App lokal lauffähig machen | – |
| Erste CI-Pipeline planen | | |
| Kickoff-Dokumentation lesen | | |

## Checkpoint / Abnahme

- [x] Board mit den Spalten Todo / In Progress / Done existiert.
- [x] Mindestens **3 Issues** sind angelegt und mit dem Board verknüpft.
- [x] Mindestens **ein Issue** steht in **In Progress**.

## Häufige Stolpersteine

| Problem | Lösung |
|---------|--------|
| "New project" nicht sichtbar | Projects ist im Repo unter dem Reiter *Projects*, nicht *Settings*. |
| Issue erscheint nicht im Board | Issue manuell über *Add item* hinzufügen oder im Issue das Project setzen. |
| Spalten lassen sich nicht umbenennen | In der neuen Projects-Oberfläche über das Spalten-Menü (`…`) → *Rename*. |

> **Bezug zum Kurs:** Das Board ist eure Arbeitsplanung für die gesamte Transformation. In
> Projekt-Aufgabe 3 hängt ihr euer **erstes echtes Issue** hier ein.
