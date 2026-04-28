#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let trackings = (
  ("0em",    0em),
  ("0.05em", 0.05em),
  ("0.10em", 0.10em),
  ("0.20em", 0.20em),
)

#grid(
  columns: (auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon),

  col-header("tracking"), col-header("sample"),

  ..trackings.map(((label, t)) => (
    raw(label),
    text(size: tokens.size-body, tracking: t, upper("diagram caption example")),
  )).flatten()
)
