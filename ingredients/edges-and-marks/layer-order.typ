#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let endpoint(pos, label, name-label: none) = node(pos,
  box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
      radius: tokens.radius-shape, inset: 6pt,
      text(size: tokens.size-label, fill: palette.ink, label)),
  name: name-label,
)

#diagram(
  spacing: (80pt, 80pt),
  endpoint((0, 0), "a", name-label: <a>),
  endpoint((2, 0), "b", name-label: <b>),
  endpoint((0, 1), "c", name-label: <c>),
  endpoint((2, 1), "d", name-label: <d>),
  edge(<a>, <d>, "->",
    stroke: (paint: palette.red.stroke, thickness: tokens.stroke-emphasis),
    layer: -1,
    label-side: center, label-sep: 4pt, label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "behind")),
  edge(<c>, <b>, "->",
    stroke: tokens.stroke-default + palette.green.stroke,
    label-side: center, label-sep: 4pt, label-fill: palette.surface,
    text(size: tokens.label-size, weight: tokens.weight-bold, "foreground")),
)
