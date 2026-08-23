# Basis-Image: schlankes Python-Laufzeit-Environment
FROM python:3.11-slim

# Arbeitsverzeichnis im Container setzen
WORKDIR /app

# Anwendungscode in das Image kopieren
COPY app.py /app/

# Container soll auf Port 8080 horchen (Dokumentation)
EXPOSE 8080

# Befehl zum Starten der Anwendung
CMD ["python", "app.py"]
