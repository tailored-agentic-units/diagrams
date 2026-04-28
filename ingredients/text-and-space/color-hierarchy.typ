#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let inks = (
  ("palette.ink",        palette.ink,        "primary — titles, body, must-read"),
  ("palette.ink-muted",  palette.ink-muted,  "secondary — captions, metadata"),
  ("palette.ink-subtle", palette.ink-subtle, "tertiary — de-emphasis, placeholders"),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("sample"), col-header("usage"),

  ..inks.map(((name, c, use)) => (
    raw(name),
    text(size: tokens.size-body, fill: c, "The quick brown fox jumps over"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
