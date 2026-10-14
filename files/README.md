# Übungsblatt 5: UI-Test-Automatisierung mit Playwright

Zu testende Anwendung: https://demo.playwright.dev/todomvc/

Empfehlung: Für bestes Erlebnis lokal mit VS Code und Playwright UI arbeiten. In Codespaces ist vieles möglich, aber die interaktive UI/Recorder sind dort nicht verfügbar.

**Für lokale Arbeit:** Das Repository muss zunächst geklont werden.

**Node.js und NPM installieren:**
Falls Node.js noch nicht installiert ist, laden Sie von https://nodejs.org herunter oder verwenden Sie den Paketmanager:

- **Windows/macOS:** Installer von nodejs.org
- **Linux (Ubuntu/Debian):** `sudo apt update && sudo apt install nodejs npm`
- **macOS (mit Homebrew):** `brew install node`

```bash
git clone <Ihr Repository in GitHub>
cd <Projektverzeichnis>
npm install  # Abhängigkeiten installieren
npx playwright install  # Browser für Playwright installieren
# Optional (auf Linux, falls Systemabhängigkeiten fehlen): sudo npx playwright install-deps
```

## Ziele

- UI-Tests mit Playwright zielgerichtet erstellen - manuell und mit Codegen (lokal)
- Locator-Strategien verstehen und anwenden (ARIA/Rollen vs. CSS-Selektoren)
- Assertions in Playwright gezielt einsetzen
- Tests in der Playwright UI ausführen und debuggen

## Setup

Playwright ist im Projekt installiert. Tests können vom Root ausgeführt werden oder aus dem Übungs-Pfad.

```bash
npm test  # oder npx playwright test
```

## Playwright UI und Codegen (lokal empfohlen)

enn Sie VS Code lokal benutzen, nutzen Sie die Playwright UI (führt die Tests nachvollziehbar aus) und den integrierten Recorder (Codegen - für die interaktive Testerstellung).

- Playwright UI starten (lokal):

  ```bash
  npx playwright test --ui
  ```

  oder per Script: `npm run test:ui`

- Playwright UI in Codespaces:

  ```bash
  npx playwright test --ui --ui-host=0.0.0.0
  ```

  oder per Script: `npm run test:ui:codespaces` (Port im Ports-Panel freigeben)

- Playwright Codegen (lokal, generiert Code):
  ```bash
  npx playwright codegen https://demo.playwright.dev/todomvc/
  ```
  Optional direkt in eine Datei:
  ```bash
  npx playwright codegen https://demo.playwright.dev/todomvc/ --output Uebung5/tests/todo.codegen.spec.ts
  ```
  **Alternative über die VS Code Playwright Extension:** wählen Sie in der Test-Ansicht "Neu aufzeichnen" (engl. "Record new") oder öffnen Sie eine Testdatei, setzen Sie den Cursor an die gewünschte Stelle und wählen Sie "An Cursor aufzeichnen" (engl. "Record at Cursor"). Ihre Browser-Interaktionen werden direkt als Code eingefügt.

Hinweise:

- Codegen öffnet einen echten Browser – in Codespaces nicht nutzbar.
- Nach der Aufzeichnung Locators und Assertions reviewen und verbessern.

## Locators vs. CSS-Selektoren – kurz erklärt

- Locators sind Playwright-spezifische, semantische Abfragen, die stabil auf Rollen, Labels, Platzhalter oder sichtbaren Text zielen.

  - Beispiele: `getByRole`, `getByLabel`, `getByPlaceholder`, `getByText`, `getByTestId`, `locator()`.
  - Vorteile: Robust gegenüber Layout/CSS-Änderungen, barrierearm (ARIA).

- CSS-Selektoren sind klassische Selektoren wie `.todo-list li` oder `#submit`.
  - Vorteile: Sehr flexibel, bekannt aus Frontend.
  - Nachteile: Fragil (Klassen/IDs ändern sich schnell), weniger semantisch.

Empfehlung: Erst semantische Locators, dann `getByTestId`, zuletzt CSS.

### Wichtige Locator-APIs

- `page.getByRole(role, options)` – ARIA-Rollen/Name, z. B. Buttons/Links/Checkboxen
- `page.getByLabel(text)` – Formularfelder über sichtbares Label
- `page.getByPlaceholder(text)` – Inputs über Placeholder
- `page.getByText(text)` – sichtbarer Text
- `page.getByTestId(id)` – `data-testid`-Attribute
- `page.locator(selector)` – CSS/XPath-ähnlich, kombinierbar mit `.filter()`, `.nth(i)`

IDs und Attribute finden:

- DevTools (F12) → Elements: HTML/IDs/Attribute einsehen
- Playwright UI / VS Code Command „Playwright: Pick Locator“ – Locator bequem aufnehmen

## Assertions in Playwright

Import: `import { expect } from '@playwright/test'`

Häufige Assertions:

- `await expect(locator).toBeVisible()`
- `await expect(locator).toBeHidden()`
- `await expect(locator).toBeEnabled()` / `.toBeDisabled()` / `.toBeChecked()`
- `await expect(locator).toHaveText('…')` / `.toContainText('…')`
- `await expect(locator).toHaveValue('…')` / `.toHaveAttribute('name', 'value')`
- `await expect(locator).toHaveCount(n)`
- `await expect(page).toHaveURL(/regex/)`

Soft Assertions: `expect.soft(...)` – Fehler werden gesammelt, Test läuft weiter.

Tipp: In der Playwright UI können Sie Locators interaktiv überprüfen und Assertions ausprobieren.

## Interaktiv testen (Inspector / UI)

- **Inspector** (Schritt-für-Schritt, nur lokal):

  ```bash
  npm run test:debug
  ```

  Hinweis: Der Inspector öffnet ein lokales GUI-Fenster und funktioniert nicht in Codespaces. In Codespaces verwenden Sie stattdessen die UI (siehe unten).

- **UI-Mode** (Testlaufwerk mit Oberfläche, lokal und Codespaces):
  ```bash
  npm run test:ui           # lokal
  npm run test:ui:codespaces # Codespaces (Port freigeben)
  ```

In der UI können Sie Tests starten/filtern, Locators prüfen und Traces/Screenshots einsehen.

## Playwright-Konfiguration und VS Code Extension

- Diese Übung nutzt die tests in `Uebung5/tests` mit `playwright.config.ts` im Projekt-Root.
- Die VS Code Playwright Extension (Ansicht „Test" links) sollte die Tests automatisch erkennen.
- Falls die Extension nichts findet: Öffnen Sie die Command Palette (Strg+Shift+P) und suchen Sie nach "Playwright: Select Config File", wählen Sie dann `playwright.config.ts` im Root.

### VS Code Playwright Extension nutzen

Die Playwright Extension bietet eine Test-Ansicht in der linken Seitenleiste (Reagenzglas-Symbol oder „Test").

**Funktionen lokal:**

- Tests anzeigen und ausführen (Play-Button)
- Debug-Modus mit Breakpoints
- „Record at Cursor" – generiert Code durch Browser-Interaktion (nicht in Codespaces nutzbar)
- „Pick Locator" – Element im Browser anklicken, Locator wird in Zwischenablage kopiert (nicht in Codespaces nutzbar)
- Traces/Reports direkt öffnen

**So nutzen Sie die Extension:**

1. Öffnen Sie die Test-Ansicht (linke Seitenleiste)
2. Erweitern Sie „Playwright Tests"
3. Klicken Sie auf den Play-Button neben einem Test, um ihn auszuführen
4. Klicken Sie auf das Debug-Symbol, um im Debug-Modus zu starten
5. Nach dem Testlauf: Traces/Reports über die Ansicht öffnen

## Manuell: ersten Test schreiben

In `tests/todo.spec.ts` befindet sich ein minimales Template. Beispiel für das Hinzufügen eines Todos:

```ts
import { expect, test } from "@playwright/test";

test.describe("TodoMVC Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("https://demo.playwright.dev/todomvc/");
  });

  test("Ein neues Todo wird hinzugefügt", async ({ page }) => {
    const newTodoInput = page.getByPlaceholder("What needs to be done?");
    await newTodoInput.fill("Mein erstes Todo");
    await newTodoInput.press("Enter");

    await expect(page.getByText("Mein erstes Todo")).toBeVisible();
  });
});
```

Weitere nützliche Methoden: `.click()`, `.fill()`, `.press('Enter')`, `.check()`, `.uncheck()`, `.hover()`, `.dblclick()`, `.selectOption()`. Die vollständige API finden Sie im Playwright-Handbuch.

## Woher bekomme ich Informationen für das Schreiben von Tests?

### Playwright API-Dokumentation

Wenn Sie wissen möchten, welche Parameter eine Methode akzeptiert oder welche Methoden verfügbar sind:

1. **Offizielle Playwright-Dokumentation:**

   - Haupt-API: https://playwright.dev/docs/api/class-page
   - Locators: https://playwright.dev/docs/api/class-locator
   - Keyboard (z. B. `.press()`): https://playwright.dev/docs/api/class-keyboard
   - Assertions: https://playwright.dev/docs/test-assertions

2. **IntelliSense in VS Code:**

   - Tippen Sie `page.` oder `locator.` und drücken Sie `Strg+Leertaste`
   - VS Code zeigt alle verfügbaren Methoden mit Signaturen an
   - Hover über eine Methode zeigt die Dokumentation

3. **Beispiele in der Dokumentation:**
   - https://playwright.dev/docs/writing-tests – Schritt-für-Schritt-Beispiele
   - https://playwright.dev/docs/selectors – Locator-Strategien

### Welche Keys akzeptiert `.press()`?

Die Methode `.press()` akzeptiert Tastennamen als String:

- Buchstaben: `'a'`, `'A'` (Shift+A)
- Sonderzeichen: `'Enter'`, `'Tab'`, `'Escape'`, `'Backspace'`, `'Delete'`
- Modifikatoren: `'Control+A'`, `'Shift+Enter'`, `'Meta+C'` (Cmd auf Mac)
- Vollständige Liste: https://playwright.dev/docs/api/class-keyboard#keyboard-press

Beispiel:

```typescript
await page.getByPlaceholder("Search").press("Enter");
await page.keyboard.press("Control+A"); // Alles markieren
```

### Element-IDs und Attribute finden

Um IDs, Klassen oder andere Attribute von Elementen zu finden:

1. **Browser DevTools:**

   - Öffnen Sie die TodoMVC-App im Browser
   - Drücken Sie F12 (DevTools öffnen)
   - Wählen Sie das „Inspect"-Tool (Pfeil-Symbol)
   - Klicken Sie auf ein Element in der Seite
   - DevTools zeigt HTML, IDs, Klassen, ARIA-Attribute

2. **Playwright Inspector (lokal):**

   - Starten Sie `npm run test:debug`
   - Klicken Sie auf „Pick Locator"
   - Klicken Sie im Browser auf ein Element
   - Der Inspector zeigt den empfohlenen Locator

3. **Playwright UI (lokal/Codespaces):**

   - Starten Sie `npm run test:ui` (lokal) oder `npm run test:ui:codespaces`
   - Führen Sie einen Test aus
   - Im Trace-Viewer: Klicken Sie auf einen Step
   - Sehen Sie sich den Locator und das HTML an

4. **Programmatisch im Test:**
   ```typescript
   const element = page.getByPlaceholder("What needs to be done?");
   console.log(await element.getAttribute("id")); // Gibt die ID aus
   console.log(await element.getAttribute("class")); // Gibt Klassen aus
   ```

### Häufige Methoden und ihre Verwendung

| Methode           | Beschreibung                 | Beispiel                             |
| ----------------- | ---------------------------- | ------------------------------------ |
| `.fill(text)`     | Text in Input-Feld eingeben  | `await input.fill('Hello')`          |
| `.press(key)`     | Taste drücken                | `await input.press('Enter')`         |
| `.click()`        | Element anklicken            | `await button.click()`               |
| `.check()`        | Checkbox aktivieren          | `await checkbox.check()`             |
| `.uncheck()`      | Checkbox deaktivieren        | `await checkbox.uncheck()`           |
| `.hover()`        | Mit Maus über Element fahren | `await element.hover()`              |
| `.dblclick()`     | Doppelklick                  | `await element.dblclick()`           |
| `.selectOption()` | Option in Dropdown wählen    | `await select.selectOption('value')` |
| `.getAttribute()` | Attribut auslesen            | `await element.getAttribute('id')`   |
| `.textContent()`  | Text-Inhalt auslesen         | `await element.textContent()`        |
| `.isVisible()`    | Sichtbarkeit prüfen          | `await element.isVisible()`          |

Vollständige Referenz: https://playwright.dev/docs/api/class-locator

## Aufgaben

1. Grundlegend (ca. 20 Min)

   - Ein Todo hinzufügen
   - mehrere Todos hinzufügen
   - Checkboxen setzen
   - Zähler „items left“ prüfen

2. Löschen & Toggle-All (ca. 20 Min)

   - Todo via X (verfügbar vie Hover) löschen
   - Toggle-All ("Dropdown"-Pfeil in der Eingabzeile) setzt alle Todos auf erledigt/nicht erledigt
     - hier auch prüfen, was passiert, wenn ein oder mehrere Todos schon ausgewählt sind
   - „Clear completed“ entfernt erledigte

3. Filter (ca. 20 Min)

   - „Active“, „Completed“, „All“ zeigen jeweils die richtigen Todos
   - Count ist korrekt

4. Edge Cases (ca. 15 Min)

   - Leere Eingabe (Enter ohne Text)
   - sehr langer Text
   - Verhalten ohne Todos (z. B. „Clear completed“ nicht sichtbar)

5. Struktur/Refactor (ca. 15 Min)

   - Helper `async unction addTodo(page: Page, text: string)`
   - Konstanten (z. B. `const TODO_URL = 'https://demo.playwright.dev/todomvc/';`)
   - Gruppierung mit `test.describe`.

## Reports & Artefakte

HTML-Report nach Testlauf anzeigen:

```bash
npm run test:report
```

## Hinweise zu Codespaces

- Die UI/Recorder sind in Codespaces eingeschränkt – bevorzugt lokal arbeiten.
- In Codespaces können Sie die UI über `--ui-host=0.0.0.0` starten und den Port im Ports-Panel freigeben.
- Recording/Codegen erfordern eine GUI – daher nur lokal ausführen.

## Ressourcen

- Playwright: https://playwright.dev
- Locator-Guide: https://playwright.dev/docs/locators
- Assertions: https://playwright.dev/docs/test-assertions
- API-Referenz (z. B. `.press()` Keys): https://playwright.dev/docs/api/class-keyboard

Viel Erfolg!
