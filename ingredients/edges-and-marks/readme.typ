#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let endpoint(pos, label) = node(pos,
  box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
      radius: tokens.radius-shape, inset: 6pt,
      text(size: tokens.size-label, fill: palette.ink, label)),
)

#diagram(
  spacing: (140pt, 60pt),
  endpoint((0, 0), "client"),
  endpoint((1, 0), "service"),
  endpoint((2, 0), "bus"),
  endpoint((1, 1), "store"),

  edge((0, 0), (1, 0), "->",
    stroke: tokens.stroke-default + palette.red.stroke,
    label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "command"),
    label-side: left, label-sep: 4pt,
  ),
  edge((1, 0), (1, 1), "-|>",
    stroke: tokens.stroke-default + palette.blue.stroke,
    label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "write"),
    label-side: right, label-sep: 4pt,
  ),
  edge((1, 0), (2, 0), "--|>",
    stroke: (paint: palette.yellow.stroke, thickness: tokens.stroke-default, dash: "dashed"),
    label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "event"),
    label-side: left, label-sep: 4pt,
  ),
)
