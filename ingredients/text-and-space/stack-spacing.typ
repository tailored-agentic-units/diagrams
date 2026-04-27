#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let sample-rect(label, inset: 6pt) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), label,
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: inset,
    corner-radius: tokens.radius-shape,
  ),
)

#let spacings = (
  ("0pt",  0pt,                          "no gap"),
  ("5pt",  tokens.gap-structured-text,   "inside structured labels"),
  ("14pt", tokens.gap-cell,              "between cells in a field grid"),
  ("28pt", tokens.space-between-shapes,  "between nodes in a Fletcher row"),
  ("36pt", tokens.space-between-ranks,   "between vertically stacked groups"),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: (left + horizon, right + horizon, left + horizon, left + horizon),

  col-header("label"), col-header("token"), col-header("visual"), col-header("usage"),

  ..spacings.map(((label, v, usage)) => (
    raw(label),
    text(fill: palette.ink-muted, repr(v)),
    stack(dir: ttb, spacing: v,
      sample-rect(text(size: tokens.size-label, "one")),
      sample-rect(text(size: tokens.size-label, "two")),
    ),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", usage),
  )).flatten()
)
