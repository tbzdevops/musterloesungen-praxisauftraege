# Tag06 Projektauftrag - Musterlösung

## Entscheidung

Für TechStyle ist eine eigene Python Registry mit `pypiserver` sinnvoll, wenn das Paket von mehreren Projekten, Deployments oder Teammitgliedern wiederverwendet werden soll und das Team den Betrieb einer einfachen Registry selbst verstehen oder kontrollieren will. Wenn du das Artefakt nur kurz prüfen, herunterladen oder zwischen Workflow-Schritten weitergeben willst, reicht `actions/upload-artifact`. Wenn TechStyle eine verwaltete zentrale Registry mit Zugriffskontrolle und weniger eigenem Serverbetrieb möchte, ist Azure DevOps Artifacts eine passende Alternative.

## Fragen

- Wann reicht ein temporäres Artefakt aus, und wann brauchst du eine Registry?
  - `upload-artifact` reicht für Debugging, kurzfristige Übergaben, PoCs und einzelne Build-Ergebnisse ohne langfristige Wiederverwendung.
  - `pypiserver` ist sinnvoll, wenn du Pakete versioniert per `pip install` konsumieren willst oder wenn mehrere Projekte dieselbe Paketversion reproduzierbar verwenden sollen.
  - Azure DevOps Artifacts ist sinnvoll, wenn du einen verwalteten Feed mit Zugriffskontrolle, zentraler Ablage und weniger eigenem Infrastruktur-Betrieb brauchst.

- Welche Vor- und Nachteile haben temporäre Artefakte gegenüber einer Registry?
  - Temporäre Artefakte sind schnell eingerichtet und brauchen keine zusätzliche Infrastruktur.
  - Temporäre Artefakte haben begrenzte Aufbewahrung, keine Paketindexierung und keinen Standard-Installationsweg mit `pip`.
  - `pypiserver` bietet einen PyPI-kompatiblen Installationsweg über `/simple/`.
  - `pypiserver` braucht Betrieb, Netzwerkzugriff, Versionierungsdisziplin und in produktiven Umgebungen Authentifizierung sowie TLS.
  - Azure DevOps Artifacts bietet Feeds, Berechtigungen und zentrale Paketverwaltung als Dienst, bindet dich aber an Azure DevOps und braucht korrekt verwaltete Credentials.

- Welche Qualitätsanforderungen sollten vor einer Veröffentlichung erfüllt sein?
  - Der Build läuft erfolgreich durch.
  - Tests sind grün.
  - Das Paket kann lokal gebaut werden: `python -m build`.
  - Das Paket besteht einen Paketcheck: `python -m twine check dist/*`.
  - Eine saubere virtuelle Umgebung kann das Paket installieren.
  - Die Version in `pyproject.toml` ist eindeutig und wurde nicht bereits veröffentlicht.

- Wie stellst du konsistente Versionen sicher?
  - Verwende SemVer als Versionsregel.
  - Pflege die Version zentral in `pyproject.toml`.
  - Veröffentliche dieselbe Version nicht mehrfach.
  - Erhöhe die Version vor jedem neuen Publish.
  - Optional kannst du Versionen später automatisch aus Tags, Release-Workflows oder CI-Run-Nummern ableiten.

- Welche Kriterien nutzt du künftig zur Entscheidung?
  - Brauchst du das Build-Ergebnis nur kurzfristig? Dann nutze `upload-artifact`.
  - Soll ein anderes Projekt das Paket mit `pip install` installieren? Dann nutze eine Registry.
  - Muss die Version später reproduzierbar installiert werden? Dann nutze eine Registry.
  - Soll die Registry zentral verwaltet werden und Zugriffskontrolle mitbringen? Dann prüfe Azure DevOps Artifacts.
  - Willst du möglichst wenig Infrastruktur betreiben? Dann bleibe bei `upload-artifact`.
  - Gibt es mehrere Consumer oder Deployments? Dann lohnt sich eine Registry.

## Empfehlung

TechStyle sollte drei Varianten unterscheiden:

- Für schnelle interne Tests und einmalige Übergaben verwendest du `actions/upload-artifact`.
- Für wiederverwendbare Python-Pakete verwendest du `pypiserver` als eigene Python Registry.
- Für eine zentral verwaltete Paketablage mit Feed-Konzept verwendest du Azure DevOps Artifacts.

Damit wird der Build-Prozess klarer: Ein Workflow-Artefakt ist ein temporäres Ergebnis eines einzelnen CI-Laufs. Ein Paket in `pypiserver` ist ein versioniertes Artefakt, das andere Projekte gezielt installieren können.
