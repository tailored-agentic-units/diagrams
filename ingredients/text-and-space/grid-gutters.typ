#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let cell(i) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), text(size: tokens.size-label, str(i)),
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: 4pt,
    corner-radius: tokens.radius-shape,
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("tight (5 / 5)"),
    grid(columns: 3, column-gutter: 5pt, row-gutter: 5pt,
      ..range(9).map(cell)),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("comfortable (14 / 14)"),
    grid(columns: 3, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-cell,
      ..range(9).map(cell)),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("airy (28 / 28)"),
    grid(columns: 3, column-gutter: tokens.space-between-shapes, row-gutter: tokens.space-between-shapes,
      ..range(9).map(cell)),
  ),
)
