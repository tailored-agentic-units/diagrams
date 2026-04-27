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

#let mid-demo(mark-str, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (110pt, 0pt),
    endpoint((0, 0), "a"),
    endpoint((1, 0), "b"),
    edge((0, 0), (1, 0), mark-str,
      stroke: tokens.stroke-default + palette.green.stroke),
  ),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  mid-demo("-|>-", "stealth middle"),
  mid-demo("->-",  "head middle"),
  mid-demo("-o-",  "circle middle"),
  mid-demo("-|-",  "bar middle"),
)
