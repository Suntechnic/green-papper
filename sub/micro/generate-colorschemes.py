#!/usr/bin/env python3
"""Generate micro colorschemes from the VS Code themes in ../../themes."""

import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))

THEMES = {
    "main.json": "green-papper",
    "chrome-green.json": "green-chrome",
    "chrome-green-base.json": "green-chrome-base",
    "chrome-green-dark.json": "green-chrome-dark",
    "chrome-green-base-dark.json": "green-chrome-dark-base",
    "chrome-vertguignet.json": "vert-guignet-chrome",
    "chrome-vertguignet-dark.json": "vert-guignet-chrome-dark",
    "white.json": "green-papper-white",
    "bitrix.json": "green-papper-bitrix",
}

# micro group -> TextMate scopes to look up (first matching scope wins)
GROUPS = [
    ("comment", ["comment"]),
    ("constant.string", ["string"]),
    ("constant.specialChar", ["constant.character.escape", "string"]),
    ("constant.number", ["constant.numeric"]),
    ("constant.bool", ["constant.language"]),
    ("identifier", ["variable"]),
    ("identifier.var", ["variable"]),
    ("identifier.class", ["entity.name.type.class", "support.class", "entity.name.type"]),
    ("statement", ["keyword"]),
    ("type", ["storage.type", "storage"]),
    ("preproc", ["keyword.control.import", "keyword.other"]),
    ("special", ["entity.name.tag", "support.type"]),
    ("symbol", ["punctuation"]),
    ("symbol.operator", ["keyword.operator"]),
    ("todo", ["comment.line.todo", "comment"]),
]


def loads_jsonc(text):
    """Parse JSON with comments and trailing commas (VS Code theme files)."""
    out = []
    i, n, in_str = 0, len(text), False
    while i < n:
        c = text[i]
        if in_str:
            out.append(c)
            if c == "\\":
                out.append(text[i + 1])
                i += 2
                continue
            if c == '"':
                in_str = False
            i += 1
        elif c == '"':
            in_str = True
            out.append(c)
            i += 1
        elif text.startswith("//", i):
            while i < n and text[i] != "\n":
                i += 1
        elif text.startswith("/*", i):
            i = text.index("*/", i + 2) + 2
        else:
            out.append(c)
            i += 1
    return json.loads(re.sub(r",(\s*[}\]])", r"\1", "".join(out)))


def load_theme(path):
    """Load a theme and merge its include chain (base first, then overrides)."""
    data = loads_jsonc(open(path, encoding="utf-8").read())
    base = {"colors": {}, "tokenColors": []}
    if data.get("include"):
        base = load_theme(os.path.normpath(os.path.join(os.path.dirname(path), data["include"])))
    return {
        "colors": {**base["colors"], **data.get("colors", {})},
        "tokenColors": base["tokenColors"] + data.get("tokenColors", []),
    }


def find_settings(token_colors, scopes):
    """Return the settings of the last tokenColors rule matching the first found scope."""
    for scope in scopes:
        found = None
        for rule in token_colors:
            rule_scopes = rule.get("scope", [])
            if isinstance(rule_scopes, str):
                rule_scopes = [s.strip() for s in rule_scopes.split(",")]
            if scope in rule_scopes:
                found = rule.get("settings", {})
        if found:
            return found
    return {}


def text_style(settings, default_fg):
    """Build a micro style value such as 'bold italic #rrggbb'."""
    font = settings.get("fontStyle", "")
    attrs = [a for a in ("bold", "italic", "underline") if a in font]
    return " ".join(attrs + [settings.get("foreground", default_fg)])


def color_link(name, fg=None, bg=None, attrs=""):
    value = " ".join(filter(None, [attrs, fg]))
    if bg:
        value = f"{value},{bg}"
    return f'color-link {name} "{value}"'


def hex6(value, default):
    """Strip the alpha channel from #RRGGBBAA-style colors."""
    if not value:
        return default
    return value[:7] if len(value) == 9 else value


def shift(color, amount):
    """Move a color slightly toward white (dark bg) or black (light bg)."""
    r, g, b = (int(color[i:i + 2], 16) for i in (1, 3, 5))
    luma = 0.299 * r + 0.587 * g + 0.114 * b
    target = 255 if luma < 128 else 0
    mix = lambda c: round(c + (target - c) * amount)
    return f"#{mix(r):02x}{mix(g):02x}{mix(b):02x}"


def build(theme_path, scheme_name):
    theme = load_theme(theme_path)
    colors = theme["colors"]
    token_colors = theme["tokenColors"]

    fg = hex6(colors.get("editor.foreground"), "#222222")
    bg = hex6(colors.get("editor.background"), "#ECFAEE")
    panel_bg = hex6(colors.get("statusBar.background"), bg)
    panel_fg = hex6(colors.get("statusBar.foreground"), "#555555")
    accent = hex6(colors.get("editorLink.activeForeground"), "#207f4c")
    # Current line must stay close to the background so text remains readable.
    line_bg = shift(bg, 0.05)
    selection = hex6(colors.get("editor.selectionBackground"), "#97b8a7")
    guide = hex6(colors.get("editorIndentGuide.background"), "#c5d6c7")
    error = hex6(colors.get("editorError.foreground"), "#c43d3d")
    warning = hex6(colors.get("editorWarning.foreground"), "#a66f00")
    info = hex6(colors.get("editorInfo.foreground"), "#28658f")
    muted = hex6(colors.get("badge.background"), "#98a099")
    suggest_bg = hex6(colors.get("editorSuggestWidget.background"), bg)
    suggest_fg = hex6(colors.get("editorSuggestWidget.foreground"), fg)
    widget_bg = hex6(colors.get("editorWidget.background"), panel_bg)
    match_bg = hex6(colors.get("editor.findMatchHighlightBackground"), "#ffd98a")
    inserted = hex6(colors.get("diffEditor.insertedTextBackground"), "#3b9b62")
    removed = hex6(colors.get("diffEditor.removedTextBackground"), "#c84f4f")
    cursor = hex6(colors.get("editorCursor.foreground"), fg)

    lines = [
        f"# {scheme_name}: micro colorscheme generated from themes/{os.path.basename(theme_path)}",
        "# Do not edit by hand: regenerate with generate-colorschemes.py",
        "",
        color_link("default", fg, bg),
    ]

    for group, scopes in GROUPS:
        settings = find_settings(token_colors, scopes)
        lines.append(color_link(group, text_style(settings, fg)))

    lines += [
        "",
        color_link("underlined", accent, attrs="underline"),
        color_link("error", error, attrs="bold"),
        color_link("error-message", error, bg, attrs="bold"),
        color_link("message", suggest_fg, suggest_bg),
        color_link("hlsearch", fg, match_bg),
        color_link("selection", None, selection),
        color_link("cursor-line", line_bg, fg),
        color_link("current-line-number", accent, line_bg, attrs="bold"),
        color_link("line-number", muted),
        color_link("color-column", None, widget_bg),
        color_link("indent-char", guide),
        color_link("divider", guide),
        color_link("scrollbar", muted),
        color_link("statusline", panel_fg, panel_bg),
        color_link("tabbar", panel_fg, panel_bg),
        color_link("tabbar.active", accent, bg, attrs="bold"),
        color_link("gutter-error", error),
        color_link("gutter-warning", warning),
        color_link("gutter-info", info),
        color_link("ignore", muted),
        color_link("diff-added", inserted),
        color_link("diff-modified", warning),
        color_link("diff-deleted", removed),
        color_link("cursor", cursor),
        "",
    ]
    return "\n".join(lines)


def main():
    themes_dir = os.path.join(ROOT, "themes")
    for filename, scheme_name in THEMES.items():
        content = build(os.path.join(themes_dir, filename), scheme_name)
        out = os.path.join(HERE, f"{scheme_name}.micro")
        with open(out, "w", encoding="utf-8") as fh:
            fh.write(content)
        print(f"wrote {os.path.relpath(out, ROOT)}")


if __name__ == "__main__":
    main()
