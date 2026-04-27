#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let endpoint(pos, label) = node(pos,
  box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
      radius: tokens.radius-shape, inset: 6pt,
      text(size: tokens.size-label, fill: palette.ink, label)),
)

#diagram(
  spacing: (160pt, 0pt),
  endpoint((0, 0), "client"),
  endpoint((1, 0), "server"),
  edge((0, 0), (1, 0), "->", bend: +25deg,
    stroke: tokens.stroke-default + palette.green.stroke,
    label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "request"),
    label-side: left, label-sep: 4pt,
  ),
  edge((0, 0), (1, 0), "->", bend: -25deg,
    stroke: (paint: palette.yellow.stroke, thickness: tokens.stroke-default, dash: "dashed"),
    label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "notify"),
    label-side: left, label-sep: 4pt,
  ),
)
