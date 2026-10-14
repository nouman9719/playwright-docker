# Playwright Docker Environment

Dieses Repository stellt eine lokale Docker-Umgebung zur Verfügung, um Playwright-Tests mit einer visuellen Desktop-Oberfläche auszuführen.

## Anleitung für Studierende

1. **Repository klonen:** Klonen Sie dieses Repository auf Ihren Rechner.
2. **Dateien ablegen:** Kopieren Sie die Dateien Ihrer aktuellen Übung (z.B. Test-Skripte und `package.json`) in den Ordner `files/`.
3. **Umgebung starten:** Führen Sie im Terminal das Skript `./run.sh` aus. (Das Skript baut das Image automatisch und startet den Container).
4. **Ergebnisse ansehen:** Öffnen Sie Ihren Browser und navigieren Sie zu `http://localhost:6080`. Playwright startet dort automatisch auf dem virtuellen Desktop.

Um die Umgebung zu beenden, drücken Sie einfach `Ctrl + C` in dem Terminal, in dem Sie das Skript ausgeführt haben.