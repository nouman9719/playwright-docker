# Playwright Desktop Environment (Docker)

Dieses Projekt stellt eine vollständige, benutzerfreundliche Desktop-Umgebung (XFCE) im Browser bereit. Studierende können damit **Playwright Test UI** und **Playwright Codegen (Test-Recorder)** direkt nutzen – ganz ohne lokale Installation von Node.js, Playwright oder zusätzlichen Browsern.

---

## Voraussetzungen

- **Lokal:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) (inkl. Docker Compose) muss installiert und gestartet sein.
- **In GitHub Codespaces:** Keine Installation nötig – alles ist bereits vorinstalliert.

---

## Schnellstart-Anleitung für Studierende

### 1. Projekt herunterladen (oder im Codespace öffnen)
Öffnen Sie ein Terminal und klonen Sie das Repository auf Ihren Rechner (entfällt in Codespaces):

```bash
git clone https://github.com/nouman9719/playwright-docker.git
cd playwright-docker
```

### 2. Umgebung starten
Starten Sie die Umgebung über das mitgelieferte Start-Skript oder direkt über Docker Compose:

```bash
./run.sh
```
*(Alternativ: `docker compose up --build`)*

Beim ersten Start wird das Docker-Image automatisch gebaut. Das dauert ca. 1–2 Minuten. Bei jedem weiteren Start ist die Umgebung in wenigen Sekunden bereit.

### 3. Virtuellen Desktop im Browser öffnen
Sobald im Terminal die Meldung `Desktop is ready!` erscheint:
1. Öffnen Sie Ihren Webbrowser und rufen Sie folgende Adresse auf:
   **http://localhost:6080**
2. *(In GitHub Codespaces: Klicken Sie unten im Reiter **Ports** bei Port **6080** auf das Weltkugel-Symbol 🌐 „Open in Browser“).*

Die Desktop-Oberfläche verbindet sich automatisch im Vollbildmodus (`1920x1080`) und passt sich automatisch an Ihre Browser-Fenstergröße an.

---

## Arbeiten auf dem virtuellen Desktop

Nach dem Start öffnet sich die **Playwright Test UI** automatisch maximiert auf dem Bildschirm. Zusätzlich finden Sie auf dem Desktop **drei Verknüpfungen (Shortcuts)**, die Sie jederzeit per Doppelklick starten können:

1. **Playwright Test UI:**
   Startet die interaktive Test-Oberfläche (`npx playwright test --ui`). Hier können Sie Tests einzeln oder komplett per Klick auf den grünen Play-Button (`▷`) ausführen, jeden Schritt im Zeitverlauf inspizieren und Fehler debuggen.
2. **Playwright Codegen (Recorder):**
   Startet den interaktiven Test-Generator (`npx playwright codegen`). Es öffnen sich ein Browserfenster und der Playwright Inspector. Alles, was Sie im Browser anklicken oder eintippen, wird automatisch als fertiger Playwright-Testcode aufgezeichnet. Sie können diesen Code kopieren und direkt in Ihre Testdatei einfügen.
3. **Workspace Terminal:**
   Öffnet ein Linux-Terminal direkt im Arbeitsverzeichnis (`/workspace`). Hier können Sie eigene Befehle ausführen (z. B. `npx playwright test` oder `npm run test:report`).

---

## Übungsaufgaben bearbeiten (Ordner `files/`)

Alle Übungsdateien befinden sich im Unterordner **`files/`** (dieser ist live mit dem Ordner `/workspace` im Container verknüpft):

- **`files/tests/todo.spec.ts`** – Ihre Testdatei, in der Sie die Playwright-Tests schreiben.
- **`files/README.md`** – Die detaillierte Aufgabenstellung zum Übungsblatt.
- **`files/package.json`** – Projektkonfiguration und Abhängigkeiten.

**Wichtig:** Sie können die Datei `files/tests/todo.spec.ts` bequem außerhalb des Containers in Ihrem gewohnten **VS Code Editor** bearbeiten und speichern (`Strg + S`). Die laufende Playwright Test UI im Browser erkennt jede gespeicherte Änderung sofort automatisch!

---

## Umgebung beenden

Um die Desktop-Umgebung und den Docker-Container sauber zu beenden:
1. Wechseln Sie zurück in Ihr Terminal, in dem `./run.sh` läuft.
2. Drücken Sie **`Strg + C`** (`Ctrl + C`).

Falls Sie den Container komplett im Hintergrund stoppen und aufräumen möchten, können Sie jederzeit folgenden Befehl nutzen:

```bash
docker compose down
```

---

## Fehlerbehebung (FAQ)

- **Port 6080 ist bereits belegt (`Bind for :::6080 failed: port is already allocated`):**
  Es läuft noch ein alter Container im Hintergrund. Führen Sie `docker compose down` oder `docker stop $(docker ps -a -q)` aus und starten Sie `./run.sh` erneut.
- **Playwright-Fenster wurde versehentlich geschlossen:**
  Doppelklicken Sie einfach auf das Desktop-Icon **„Playwright Test UI“** oder **„Playwright Codegen (Recorder)“** auf dem virtuellen Desktop.
