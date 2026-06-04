# Musterlösung – 📓 Auftrag 2: GitHub Setup & GitHub Classroom

**Ziel:** Persönliches TechStyle-Repository existiert über GitHub Classroom und ist lokal geklont.

## Schritte (Soll-Zustand)

1. **GitHub-Account & lokale Git-Konfiguration**
   ```bash
   git config --global user.name "Vorname Nachname"
   git config --global user.email "mail@example.com"
   # Prüfen:
   git config --global --list
   ```

2. **GitHub Classroom beitreten**
   - Einladungslink öffnen: <https://classroom.github.com/a/RPJ6nPCV>
   - Mit dem GitHub-Account autorisieren.
   - Eigenen Namen aus der Klassenliste zuordnen (falls Roster aktiv).
   - **Accept this assignment** klicken → Classroom legt automatisch ein privates Repository
     `techstyle-<github-username>` an.

3. **Repository klonen**
   ```bash
   git clone https://github.com/<organisation>/techstyle-<username>.git
   cd techstyle-<username>
   ```

4. **Verbindung prüfen**
   ```bash
   git remote -v
   # origin  https://github.com/<organisation>/techstyle-<username>.git (fetch)
   # origin  https://github.com/<organisation>/techstyle-<username>.git (push)
   git status
   ```

## Checkpoint / Abnahme

- [x] `git config --global --list` zeigt korrekten Namen + E-Mail.
- [x] Persönliches Classroom-Repository ist auf GitHub sichtbar.
- [x] `git remote -v` zeigt das eigene Repository als `origin`.

## Häufige Stolpersteine

| Problem | Lösung |
|---------|--------|
| `git clone` fragt nach Passwort | Personal Access Token statt Passwort verwenden, oder SSH-Key einrichten. |
| Assignment-Repo erscheint nicht | Browser neu laden; Classroom braucht kurz, um das Repo zu erstellen. |
| Falscher GitHub-Account aktiv | Im Browser ausloggen und mit dem Kurs-Account neu anmelden. |
| Name nicht in Roster | Lehrperson kontaktieren, damit der Eintrag ergänzt wird. |

> **Bezug zum Kurs:** Dieses Repository ist die Code-Basis für alle weiteren Tage – ab Tag 02
> (Branching-Strategie) und Tag 04 (erste CI-Pipeline).
