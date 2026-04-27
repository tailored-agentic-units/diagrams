#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let column-title(s) = align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s)))

#let edge-demo(edge-str) = diagram(
  spacing: (90pt, 0pt),
  node-stroke: none, node-fill: none,
  node((0, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "from"))),
  node((1, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "to"))),
  edge((0, 0), (1, 0), edge-str, stroke: tokens.stroke-default + palette.ink),
)

#let strokes = (
  ("-|>",  "solid"),
  ("=|>",  "double"),
  ("--|>", "dashed"),
  ("..|>", "dotted"),
  ("~|>",  "wavy"),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (right + horizon, left + horizon, center + horizon),

  column-title("style"), column-title("string"), column-title("rendered"),

  ..strokes.map(((s, name)) => (
    text(fill: palette.ink, name),
    raw(s),
    edge-demo(s),
  )).flatten()
)
