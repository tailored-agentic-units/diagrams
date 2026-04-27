#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let samples = (
  ("plain",       [The quick brown fox]),
  ("italic",      text(style: "italic", [The quick brown fox])),
  ("bold",        text(weight: "semibold", [The quick brown fox])),
  ("bold italic", text(weight: "semibold", style: "italic", [The quick brown fox])),
  ("overline",    overline([The quick brown fox])),
  ("strike",      strike([The quick brown fox])),
  ("underline",   underline([The quick brown fox])),
  ("highlight",   highlight(fill: palette.blue.fill, [The quick brown fox])),
  ("colored",     text(fill: palette.red.stroke, [The quick brown fox])),
)

#grid(
  columns: (auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon),

  col-header("style"), col-header("sample"),

  ..samples.map(((name, s)) => (
    raw(name),
    s,
  )).flatten()
)
