#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let sample-rect(label, radius: tokens.radius-shape) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), label,
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: radius,
  ),
)

#let radii = (
  ("0pt",  0pt),
  ("3pt",  3pt),
  ("6pt",  tokens.radius-shape),
  ("10pt", tokens.radius-container),
  ("20pt", 20pt),
)

#grid(
  columns: (auto,) * radii.len(),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  ..radii.map(((label, _)) => col-header(label)),
  ..radii.map(((_, v)) => sample-rect("sample", radius: v)),
)
