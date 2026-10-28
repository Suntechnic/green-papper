# Guake Palettes

Палитры на основе тем VS Code из `green-papper/themes/*.json`. Ниже приведены все девять тем расширения, включая тёмные (`Green Papper Chrome Green Dark`, `Green Papper Chrome Green Dark Base`, `Green Papper Vert Guignet Dark`). Палитра `Green Papper Chrome Green Dark` совпадает с `Green Papper Chrome Green Dark Base`: эти темы различаются только подсветкой синтаксиса, которую палитры Guake не задают.

Соответствие элементов палитры Guake:
- Индексы 0–15: ANSI-цвета (`terminal.ansiBlack` … `terminal.ansiBrightWhite`)
- Индекс 16: Цвет текста (Foreground) → `editor.foreground` (`#222222` для светлых тем, `#E0E4DA` для тёмных)
- Индекс 17: Цвет фона (Background) → `editor.background` каждого файла темы

Формат цвета Guake: `#RRRRGGGGBBBB` (удвоенный байт `#RRGGBB` в верхнем регистре).

```
    "Green Papper Main": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#A5A5B1B1B6B6:#222222222222:#ECECFAFAEEEE"
    ),
    "Green Papper Chrome Green": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#AAAABFBFA9A9:#222222222222:#F8F8FBFBF1F1"
    ),
    "Green Papper Chrome Green Base": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#AAAABFBFA9A9:#222222222222:#F8F8FBFBF1F1"
    ),
    "Green Papper Chrome Green Dark": (
        "#19191D1D1717:#EFEF6F6F6F6F:#6666C8C87878:#E8E8B9B96868:#5B5BA3A3FFFF:"
        "#C3C39494E8E8:#5555C9C9B8B8:#C2C2D5D5C7C7:#717185857979:#FFFF92929292:"
        "#A9A9E6E66D6D:#FFFFD0D08383:#7D7DD1D1FFFF:#F0F09B9BE9E9:#8686E4E4DFDF:"
        "#F0F0F7F7F0F0:#E0E0E4E4DADA:#232327272020"
    ),
    "Green Papper Chrome Green Dark Base": (
        "#19191D1D1717:#EFEF6F6F6F6F:#6666C8C87878:#E8E8B9B96868:#5B5BA3A3FFFF:"
        "#C3C39494E8E8:#5555C9C9B8B8:#C2C2D5D5C7C7:#717185857979:#FFFF92929292:"
        "#A9A9E6E66D6D:#FFFFD0D08383:#7D7DD1D1FFFF:#F0F09B9BE9E9:#8686E4E4DFDF:"
        "#F0F0F7F7F0F0:#E0E0E4E4DADA:#232327272020"
    ),
    "Green Papper Vert Guignet": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#B4B4B1B1A8A8:#222222222222:#FBFBF9F9F6F6"
    ),
    "Green Papper Vert Guignet Dark": (
        "#1B1B1C1C1A1A:#FFFF54544949:#A0A0D4D49090:#E4E4C3C38282:#7C7CACACF8F8:"
        "#C1C19494C9C9:#8787B2B2BDBD:#C8C8C6C6C3C3:#6B6B71716161:#FFFF8A8A8080:"
        "#A0A0D4D49090:#E4E4C3C38282:#5D5DD5D5FBFB:#C9C9A0A0CFCF:#5D5DD5D5FBFB:"
        "#E0E0E4E4DADA:#E0E0E4E4DADA:#252526262424"
    ),
    "Green Papper White": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#AEAEBBBBC2C2:#222222222222:#FFFFFFFFFFFF"
    ),
    "Green Papper Bitrix": (
        "#000000000000:#F5F518181818:#4343B2B24444:#F2F2AEAE4949:#282865658F8F:"
        "#A3A37A7ACCCC:#20207F7F4C4C:#6C6C78788080:#6C6C76768080:#F0F071717171:"
        "#8686B3B30000:#FFFF99994040:#5555B4B4D4D4:#FEFE7676FFFF:#3939CBCBCCCC:"
        "#AEAEBBBBC2C2:#222222222222:#FCFCFFFFFEFE"
    )
```

## Установка в Guake / Installation

Палитры из этого файла переносятся в Guake скриптом `patch-palettes.sh`:

The palettes from this file are installed into Guake with the `patch-palettes.sh` script:

```
sudo ./sub/guake/patch-palettes.sh                       # патч файла Guake по умолчанию
sudo ./sub/guake/patch-palettes.sh -n                    # показать diff, ничего не менять
sudo ./sub/guake/patch-palettes.sh --no-backup           # без резервной копии
sudo ./sub/guake/patch-palettes.sh /путь/к/palettes.py   # явный путь к файлу Guake
sudo ./sub/guake/patch-palettes.sh -s ./palettes.md      # другой источник палитр
```

Скрипт читает палитры из `palettes.md` (единственный источник правды), заменяет записи с такими же именами, удаляет их устаревшие дубликаты и добавляет отсутствующие. Перед записью рядом с файлом создаётся резервная копия `palettes.py.bak.<ГГГГММДД-ЧЧММСС>`. После установки перезапустите Guake — палитры появятся в Preferences → Appearance → Palette.
