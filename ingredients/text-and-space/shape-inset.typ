#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let sample-rect(label, inset: tokens.pad-inside-shape) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), label,
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: inset,
    corner-radius: tokens.radius-shape,
  ),
)

#let insets = (
  ("0pt",  0pt),
  ("4pt",  4pt),
  ("10pt", tokens.pad-inside-shape),
  ("16pt", 16pt),
  ("24pt", 24pt),
)

#grid(
  columns: (auto,) * insets.len(),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  ..insets.map(((label, _)) => col-header(label)),
  ..insets.map(((_, v)) => sample-rect("sample", inset: v)),
)
