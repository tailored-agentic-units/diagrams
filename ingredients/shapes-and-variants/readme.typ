#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let shape-tile(name, shape-fn, hue) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
    shape:          shape-fn,
    fill:           hue.fill,
    stroke:         tokens.stroke-default + hue.stroke,
    inset:          tokens.pad-inside-shape,
    corner-radius:  tokens.radius-shape,
  ),
)

#stack(dir: ltr, spacing: tokens.space-between-shapes,
  shape-tile("rect",     fletcher.shapes.rect,     palette.blue),
  shape-tile("pill",     fletcher.shapes.pill,     palette.orange),
  shape-tile("cylinder", fletcher.shapes.cylinder, palette.green),
  shape-tile("hexagon",  fletcher.shapes.hexagon,  palette.purple),
)
