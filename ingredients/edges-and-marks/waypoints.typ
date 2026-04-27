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

#let waypoint-demo(direction-str, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (80pt, 50pt),
    endpoint((0, 0), "a"),
    endpoint((2, 2), "b"),
    edge((0, 0), direction-str, (2, 2), "->",
      stroke: tokens.stroke-default + palette.green.stroke),
  ),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  waypoint-demo("r,d",    "right-then-down · \"r,d\""),
  waypoint-demo("d,r",    "down-then-right · \"d,r\""),
  waypoint-demo("r,d,r",  "step · \"r,d,r\""),
  waypoint-demo("d,r,d",  "step · \"d,r,d\""),
)
