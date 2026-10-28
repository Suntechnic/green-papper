# Change Log

## [0.5.1] - 2026-09-13

- Палитры Guake приведены к актуальным цветам тем: исправлены `ansiBlue` (`#28658F`), `ansiBrightWhite` и фон темы White (`#FFFFFF`); добавлены тёмные палитры `Green Papper Chrome Green Dark Base` и `Green Papper Vert Guignet Dark` / Guake palettes aligned with the current theme colors: fixed `ansiBlue` (`#28658F`), `ansiBrightWhite` and the White theme background (`#FFFFFF`); added the dark palettes `Green Papper Chrome Green Dark Base` and `Green Papper Vert Guignet Dark`
- Добавлены темы Obsidian для всех остальных тем VS Code: GreenChromeBase, GreenChromeDarkBase, VertGuignetChrome, VertGuignetChromeDark, GreenPapperWhite, GreenPapperBitrix / Added Obsidian themes for all remaining VS Code themes: GreenChromeBase, GreenChromeDarkBase, VertGuignetChrome, VertGuignetChromeDark, GreenPapperWhite, GreenPapperBitrix
- Добавлена тема Obsidian GreenChromeDark для тёмной темы Green Chrome Dark / Added the Obsidian GreenChromeDark theme for the dark Green Chrome Dark variant
- Цвет строк в Obsidian-темах на основной палитре (`GreenPaper`, `GreenChrome`, `VertGuignetChrome`, `GreenPapperWhite`, `GreenPapperBitrix`) приведён к текущим темам VS Code: `--syntax-string` = `#cc33cc` / Aligned the string color in the main-palette Obsidian themes (`GreenPaper`, `GreenChrome`, `VertGuignetChrome`, `GreenPapperWhite`, `GreenPapperBitrix`) with the current VS Code themes: `--syntax-string` = `#cc33cc`
- В палитры Guake добавлена тема `Green Papper Chrome Green Dark` / Added the `Green Papper Chrome Green Dark` Guake palette
- Добавлен скрипт `sub/guake/patch-palettes.sh`: он переносит палитры из `palettes.md` в `palettes.py` Guake — заменяет совпадающие записи, удаляет устаревшие дубликаты и добавляет отсутствующие палитры, делая резервную копию перед записью / Added `sub/guake/patch-palettes.sh`: it copies the palettes from `palettes.md` into the Guake `palettes.py` — replaces matching entries, removes stale duplicates and adds missing palettes, making a backup before writing
- Исправлена рекурсивная ссылка `include` в `themes/token-colors/main-dark.json` и внутреннее имя темы `Green Chrome Dark` / Fixed the recursive `include` in `themes/token-colors/main-dark.json` and the internal name of the `Green Chrome Dark` theme

## [0.5.0] - 2026-09-12

- Добавлена тёмная тема Green Chrome Dark: base / Added the Green Chrome Dark: base theme (Author: GitHub Copilot)
- Исправлен синий цвет терминала, который ранее совпадал с фоном светлых тем / Fixed the terminal blue color, which previously matched the background in light themes (Author: GitHub Copilot)
- Добавлены цвета для современных областей VS Code: sticky scroll, inlay hints, gutter, minimap, peek view, Git, notebooks, Chat, inline Chat, validation, dropdowns и checkboxes / Added colors for modern VS Code areas: sticky scroll, inlay hints, gutter, minimap, peek view, Git, notebooks, Chat, inline Chat, validation, dropdowns and checkboxes (Author: GitHub Copilot)
- Значения новых цветов адаптированы под все шесть вариантов темы / Adapted the new colors for all six theme variants (Author: GitHub Copilot)

## [0.4.2] - 2026-07-18

- Мелкие исправления / Minor fixes

## [0.4.1] - 2025-10-19

- Базовая цветовая схема и улучшение подсветки комментариев / Base color scheme and improved comment highlighting

## [0.4.0] - 2025-04-09

- Добавление версий «Vert Guignet Chrome» и «Green Chrome» / Adding the «Vert Guignet Chrome» and «Green Chrome» versions.

## [0.3.0] - 2023-04-10

- Добавление bitrix версии / Adding bitrix version

## [0.2.1] - 2023-03-18

- Добавление истории версий / Adding change log

## [0.2.0] - 2023-03-18

- Добавление белой версии / Adding white version

## [0.1.1] - 2023-03-17

- Мелкие исправления / Fix bugs

## [0.1.0] - 2023-03-12

- Первый релиз / Initial release
