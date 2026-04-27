#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let sizes = (
  ("size-label",   tokens.size-label,   "kind annotations · (module) · (interface)"),
  ("size-caption", tokens.size-caption, "container titles · metadata · notes"),
  ("size-body",    tokens.size-body,    "default label text · field names · enum values"),
  ("size-title",   tokens.size-title,   "entity names in bold"),
  ("size-heading", tokens.size-heading, "diagram titles"),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-cell,
  align: (left + horizon, right + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("pt"), col-header("sample"), col-header("usage"),

  ..sizes.map(((name, sz, use)) => (
    raw(name),
    raw(repr(sz)),
    text(size: sz, fill: palette.ink, "The quick brown fox jumps over the lazy dog"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
