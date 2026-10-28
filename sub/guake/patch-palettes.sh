#!/usr/bin/env bash
#
# patch-palettes.sh — установка палитр Green Papper в Guake.
#
# Скрипт берёт палитры из palettes.md (тот же каталог, единый источник правды)
# и патчит файл Guake palettes.py: отсутствующие палитры добавляет, записи с
# такими же именами заменяет. Остальной файл не изменяется.
#
# После установки перезапустите Guake — палитры появятся в
# Preferences → Appearance → Palette.
#
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_TARGET="/usr/lib/python3/dist-packages/guake/palettes.py"

SOURCE="$SCRIPT_DIR/palettes.md"
TARGET="${GUAKE_PALETTES_FILE:-}"
DRY_RUN=0
MAKE_BACKUP=1

usage() {
    cat <<'EOF'
Использование: sudo ./patch-palettes.sh [ОПЦИИ] [ПУТЬ-К-palettes.py]

Добавляет палитры Green Papper в palettes.py терминала Guake. Существующие
записи с теми же именами заменяются, остальной файл не изменяется.

Опции:
  -n, --dry-run      показать diff, но не изменять файл
      --no-backup    не создавать резервную копию
  -s, --source FILE  путь к palettes.md (по умолчанию — рядом со скриптом)
  -h, --help         показать эту справку

Без явного пути используется $GUAKE_PALETTES_FILE, затем стандартные места
установки (/usr/lib/python3/dist-packages/guake/palettes.py и другие).
EOF
}

info() { printf '%s\n' "$*"; }
die() { printf 'Ошибка: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
    case "$1" in
        -n | --dry-run) DRY_RUN=1 ;;
        --no-backup) MAKE_BACKUP=0 ;;
        -s | --source)
            [ $# -ge 2 ] || die "после $1 нужен путь к palettes.md"
            SOURCE="$2"
            shift
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        -*)
            printf 'Неизвестная опция: %s\n\n' "$1" >&2
            usage >&2
            exit 2
            ;;
        *)
            TARGET="$1"
            ;;
    esac
    shift
done

detect_target() {
    local candidate
    for candidate in \
        "$DEFAULT_TARGET" \
        /usr/lib/python3*/dist-packages/guake/palettes.py \
        /usr/local/lib/python3*/dist-packages/guake/palettes.py \
        /usr/lib/python3*/site-packages/guake/palettes.py \
        "$HOME"/.local/lib/python3*/site-packages/guake/palettes.py; do
        if [ -f "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    python3 - <<'PY'
import os
import sys

for path in sys.path:
    if not path:
        continue
    candidate = os.path.join(path, "guake", "palettes.py")
    if os.path.isfile(candidate):
        print(candidate)
        break
PY
}

command -v python3 >/dev/null 2>&1 || die "не найден python3"
[ -f "$SOURCE" ] || die "не найден файл палитр: $SOURCE"
[ -s "$SOURCE" ] || die "файл палитр пуст: $SOURCE"

if [ -z "$TARGET" ]; then
    TARGET="$(detect_target || true)"
fi
[ -n "$TARGET" ] || die "palettes.py не найден, укажите путь аргументом (например: $DEFAULT_TARGET)"
[ -f "$TARGET" ] || die "файл не найден: $TARGET"

if [ "$DRY_RUN" = 0 ]; then
    if [ ! -w "$TARGET" ] || [ ! -w "$(dirname -- "$TARGET")" ]; then
        die "нет прав на запись в $TARGET
запустите от root: sudo $SCRIPT_DIR/$(basename -- "$0") $TARGET"
    fi
fi

info "Палитры: $SOURCE"
info "Файл Guake: $TARGET"
BACKUP_FILE=""
if [ "$DRY_RUN" = 0 ] && [ "$MAKE_BACKUP" = 1 ]; then
    BACKUP_FILE="$TARGET.bak.$(date +%Y%m%d-%H%M%S)"
    cp -p -- "$TARGET" "$BACKUP_FILE" || die "не удалось создать резервную копию: $BACKUP_FILE"
    info "Резервная копия: $BACKUP_FILE"
fi

if ! python3 - "$TARGET" "$SOURCE" "$DRY_RUN" <<'PY'
"""Патчер палитр: читает палитры из .md и переносит их в palettes.py Guake."""
import difflib
import os
import re
import sys

target, source, dry_run = sys.argv[1], sys.argv[2], sys.argv[3] == "1"

# --- 1. палитры из palettes.md ---------------------------------------------
BLOCK = re.compile(r'"([^"]+)"\s*:\s*\(\s*((?:"[^"]*"\s*)+)\)')
COLOR = re.compile(r"#[0-9A-Fa-f]{12}\Z")

palettes = []
for match in BLOCK.finditer(open(source, encoding="utf-8").read()):
    name = match.group(1)
    chunks = re.findall(r'"([^"]*)"', match.group(2))
    colors = "".join(chunks).split(":")
    if len(colors) != 18:
        sys.exit(f"{source}: в палитре '{name}' {len(colors)} цветов вместо 18")
    for color in colors:
        if not COLOR.match(color):
            sys.exit(f"{source}: палитра '{name}': неверный цвет '{color}'")

    palettes.append((name, [chunk.upper() for chunk in chunks]))

if not palettes:
    sys.exit(f"{source}: палитры не найдены (ожидались блоки вида \"Имя\": (\"#RRRRGGGGBBBB:...\"))")

# --- 2. разбор palettes.py -------------------------------------------------
src = open(target, encoding="utf-8").read()


def find_matching(text, start, opening, closing):
    """Возвращает индекс closing, парного opening на позиции start."""
    depth = 0
    index = start
    length = len(text)
    while index < length:
        char = text[index]
        if char in "\"'":
            if text[index:index + 3] == char * 3:  # тройная кавычка
                end = text.find(char * 3, index + 3)
                if end == -1:
                    sys.exit(f"{target}: незакрытая тройная кавычка")
                index = end + 3
                continue
            index += 1
            while index < length:
                if text[index] == "\\":
                    index += 2
                    continue
                if text[index] == char:
                    index += 1
                    break
                index += 1
            continue
        if char == "#":  # комментарий
            newline = text.find("\n", index)
            index = length if newline == -1 else newline
            continue
        if char == opening:
            depth += 1
        elif char == closing:
            depth -= 1
            if depth == 0:
                return index
        index += 1
    sys.exit(f"{target}: не найдена закрывающая '{closing}'")


dict_open = dict_name = None
for match in re.finditer(r"(?m)^([A-Za-z_][A-Za-z0-9_]*)[ \t]*=[ \t]*\{", src):
    if match.group(1) in ("PALETTES", "palettes"):
        dict_name = match.group(1)
        dict_open = match.end() - 1
        break

if dict_open is None:
    sys.exit(f"{target}: не найден словарь PALETTES = {{ ... }}")

dict_close = find_matching(src, dict_open, "{", "}")

key_line = re.search(r"(?m)^([ \t]*)([\"'])[^\"']*\2[ \t]*:", src[dict_open:dict_close])
entry_indent = key_line.group(1) if key_line else "    "
quote_char = key_line.group(2) if key_line else '"'
def value_end(text, position):
    """Возвращает позицию сразу после значения записи (вместе с запятой)."""
    index = position
    length = len(text)
    while index < length and text[index] in " \t\r\n":
        index += 1
    if index < length and text[index] == "(":
        index = find_matching(text, index, "(", ")") + 1
    elif index < length and text[index] in "\"'":
        quote = text[index]
        index += 1
        while index < length:
            if text[index] == "\\":
                index += 2
                continue
            if text[index] == quote:
                index += 1
                break
            index += 1
    else:
        sys.exit(f"{target}: не удалось разобрать значение палитры (позиция {position})")
    tail = index
    while tail < length and text[tail] in " \t":
        tail += 1
    if tail < length and text[tail] == ",":
        index = tail + 1
    return index


def entry_end(text, position):
    """Конец записи: значение, запятая и следующий перевод строки."""
    end = value_end(text, position)
    if end < len(text) and text[end] == "\n":
        end += 1
    return end


def render(name, chunks):
    """Текст записи словаря в стиле файла Guake."""
    lines = [f"{entry_indent}{quote_char}{name}{quote_char}: ("]
    lines += [f"{entry_indent}    {quote_char}{chunk}{quote_char}" for chunk in chunks]
    lines.append(f"{entry_indent}),")
    return "\n".join(lines) + "\n"


edits = []  # (начало, конец, текст)
added = []
replaced = []
removed = 0

for name, chunks in palettes:
    key_re = re.compile(r"(?m)^[ \t]*(['\"])" + re.escape(name) + r"\1[ \t]*:[ \t]*")
    hits = list(key_re.finditer(src, dict_open, dict_close))
    if hits:
        first = hits[0]
        edits.append((first.start(), entry_end(src, first.end()), render(name, chunks)))
        for extra in hits[1:]:  # дубликаты от прежних патчей — удаляем
            edits.append((extra.start(), entry_end(src, extra.end()), ""))
            removed += 1
        replaced.append(name)
    else:
        # если запись есть, но в нестандартном виде — не дублируем её
        if f'{quote_char}{name}{quote_char}' in src or f"'{name}'" in src or f'"{name}"' in src:
            sys.exit(f"{target}: запись '{name}' найдена, но в неизвестном формате — патч отменён")
        added.append((name, chunks))

if added:
    block = "".join(render(name, chunks) for name, chunks in added)
    tail = dict_close - 1
    while tail >= 0 and src[tail] in " \t\r\n":
        tail -= 1
    if tail >= 0 and src[tail] not in ",{":
        position = tail + 1
        # если последняя запись и так переписывается, запятая уже есть в новом тексте
        if not any(start <= position <= end for start, end, _ in edits):
            edits.append((position, position, ","))
    edits.append((dict_close, dict_close, block))

new_src = src
for start, end, text in sorted(edits, key=lambda edit: edit[0], reverse=True):
    new_src = new_src[:start] + text + new_src[end:]
# --- 3. проверка результата ------------------------------------------------
problems = []
for name, chunks in palettes:
    found = re.findall(r"(?m)^[ \t]*(['\"])" + re.escape(name) + r"\1[ \t]*:", new_src)
    if len(found) != 1:
        problems.append(f"{name}: записей в файле {len(found)}, ожидалась 1")

namespace = {}
try:
    exec(compile(new_src, target, "exec"), namespace)
except SyntaxError as error:
    sys.exit(f"{target}: после патча файл не компилируется ({error})")

result = namespace.get(dict_name)
if not isinstance(result, dict):
    sys.exit(f"{target}: словарь {dict_name} не найден в результате")

for name, chunks in palettes:
    expected = "".join(chunks).split(":")
    value = result.get(name)
    if value is None:
        problems.append(f"{name}: запись отсутствует")
    elif [color.upper() for color in value.split(":")] != expected:
        problems.append(f"{name}: значение не совпадает")

if problems:
    sys.exit(f"{target}: проверка не пройдена: " + "; ".join(problems))

# --- 4. запись результата --------------------------------------------------
if dry_run:
    sys.stdout.writelines(
        difflib.unified_diff(
            src.splitlines(True),
            new_src.splitlines(True),
            fromfile=target,
            tofile=f"{target} (патч)",
        )
    )
    print(f"dry-run: добавится {len(added)}, заменится {len(replaced)}, удалится дубликатов: {removed}")
else:
    temp = f"{target}.tmp-green-papper"
    with open(temp, "w", encoding="utf-8") as handle:
        handle.write(new_src)
    os.chmod(temp, os.stat(target).st_mode & 0o7777)
    os.replace(temp, target)
    print(f"Добавлено: {len(added)}, заменено: {len(replaced)}, удалено дубликатов: {removed}")
    for name, _ in added:
        print(f"  + {name}")
    for name in replaced:
        print(f"  ~ {name}")
PY
then
    if [ "$DRY_RUN" = 0 ] && [ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ]; then
        cp -p -- "$BACKUP_FILE" "$TARGET" && info "Выполнен откат из $BACKUP_FILE"
    fi
    die "патч не применён"
fi

if [ "$DRY_RUN" = 1 ]; then
    info "Режим --dry-run: файл не изменён."
else
    info "Готово. Перезапустите Guake, затем выберите палитру в Preferences → Appearance → Palette."
fi



