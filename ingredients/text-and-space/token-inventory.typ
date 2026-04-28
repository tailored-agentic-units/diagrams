#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let whitespace-tokens = (
  ("pad-inside-shape",     tokens.pad-inside-shape,     "label ↔ shape boundary"),
  ("pad-inside-container", tokens.pad-inside-container, "container ↔ inner content"),
  ("space-between-shapes", tokens.space-between-shapes, "horizontal node spacing"),
  ("space-between-ranks",  tokens.space-between-ranks,  "vertical node spacing"),
  ("gap-structured-text",  tokens.gap-structured-text,  "stack lines in a label"),
  ("gap-cell",             tokens.gap-cell,             "columns in a field grid"),
  ("label-sep",            tokens.label-sep,            "edge label ↔ edge line"),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  align: (left + horizon, right + horizon, left + horizon),

  col-header("token"), col-header("value"), col-header("usage"),

  ..whitespace-tokens.map(((name, v, use)) => (
    raw(name),
    text(fill: palette.ink-muted, repr(v)),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
