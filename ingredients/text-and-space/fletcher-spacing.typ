#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let demo-diagram(sx, sy) = diagram(
  spacing: (sx, sy),
  node((0, 0), "a", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((1, 0), "b", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((0, 1), "c", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((1, 1), "d", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  edge((0, 0), (1, 0), "->", stroke: tokens.stroke-default + palette.ink),
  edge((0, 0), (0, 1), "->", stroke: tokens.stroke-default + palette.ink),
  edge((0, 1), (1, 1), "->", stroke: tokens.stroke-default + palette.ink),
  edge((1, 0), (1, 1), "->", stroke: tokens.stroke-default + palette.ink),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("tight (15, 20)"),
    demo-diagram(15pt, 20pt),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("default (28, 36)"),
    demo-diagram(tokens.space-between-shapes, tokens.space-between-ranks),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("airy (60, 50)"),
    demo-diagram(60pt, 50pt),
  ),
)
