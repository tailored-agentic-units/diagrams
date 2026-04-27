#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let endpoint(pos, label) = node(pos,
  box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
      radius: tokens.radius-shape, inset: 6pt,
      text(size: tokens.size-label, fill: palette.ink, label)),
)

#let label-demo(pos, side, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (140pt, 0pt),
    endpoint((0, 0), "from"),
    endpoint((1, 0), "to"),
    edge((0, 0), (1, 0), "->",
      stroke: tokens.stroke-default + palette.green.stroke,
      label-fill: palette.surface,
      text(size: tokens.label-size, weight: tokens.weight-bold, "label"),
      label-pos: pos, label-side: side, label-sep: tokens.label-sep),
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  label-demo(0.1, left,   "pos 0.1 · left"),
  label-demo(0.5, left,   "pos 0.5 · left (default)"),
  label-demo(0.9, left,   "pos 0.9 · left"),
  label-demo(0.5, center, "pos 0.5 · center (on-line)"),
  label-demo(0.5, right,  "pos 0.5 · right"),
  label-demo(0.5, left,   "pos 0.5 · default"),
)
