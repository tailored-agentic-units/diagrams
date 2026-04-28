#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let weights = (
  ("weight-light", tokens.weight-light, "de-emphasised annotations"),
  ("weight-body",  tokens.weight-body,  "default body text"),
  ("weight-bold",  tokens.weight-bold,  "titles and emphasis"),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("value"), col-header("sample"), col-header("usage"),

  ..weights.map(((name, w, use)) => (
    raw(name),
    raw("\"" + w + "\""),
    text(size: tokens.size-body, weight: w, fill: palette.ink, "The quick brown fox"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
