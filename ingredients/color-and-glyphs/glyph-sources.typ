#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let source-tile(glyph, name, range, best-for) = box(
  width: 220pt,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border-muted,
  radius: tokens.radius-shape,
  inset: tokens.pad-inside-container,
  stack(dir: ttb, spacing: tokens.gap-cell,
    grid(columns: (auto, 1fr), column-gutter: tokens.pad-inside-container, align: (left + horizon, left + horizon),
      text(size: 26pt, fill: palette.blue.stroke, glyph),
      stack(dir: ttb, spacing: tokens.gap-structured-text * 1.4,
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
        text(size: tokens.size-label, fill: palette.ink-subtle, range),
      ),
    ),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", best-for),
  ),
)

#let sources = (
  ("\u{E60B}", "Seti-UI + Custom",     "U+E5FA – U+E6B7",         "file-type icons"),
  ("\u{E73C}", "Devicons",             "U+E700 – U+E8EF",         "languages + frameworks"),
  ("\u{E000}", "Pomicons",             "U+E000 – U+E00A",         "pomodoro / sessions"),
  ("\u{E0B0}", "Powerline",            "U+E0A0 – U+E0B3",         "shell prompt separators"),
  ("\u{E0B6}", "Powerline Extra",      "U+E0A3 – U+E0D7",         "extended separators"),
  ("\u{23FB}", "IEC Power Symbols",    "U+23FB-U+23FE, U+2B58",   "power state, electrical"),
  ("\u{E2A6}", "Font Awesome Ext",     "U+E200 – U+E2A9",         "supplementary FA glyphs"),
  ("\u{E30D}", "Weather Icons",        "U+E300 – U+E3E3",         "weather, atmospheric"),
  ("\u{F31B}", "Font Logos",           "U+F300 – U+F381",         "Linux distros, OSS marks"),
  ("\u{F408}", "Octicons",             "U+F400 – U+F533",         "GitHub, version control"),
  ("\u{F10FE}", "Material Design",     "U+F500 – U+FD46",         "comprehensive general"),
  ("\u{F015}", "Font Awesome",         "U+ED00 – U+F2FF",         "UI, social, brands"),
  ("\u{EB6E}", "Codicons",             "U+EA60 – U+EC1E",         "VS Code, dev environment"),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: left + top,

  ..sources.map(((g, n, r, b)) => source-tile(g, n, r, b)),
)
