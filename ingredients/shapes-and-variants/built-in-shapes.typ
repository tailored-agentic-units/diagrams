#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let shape-cell(name, shape-fn) = stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
  align(center + horizon,
    diagram(
      spacing: (0pt, 0pt),
      node((0, 0),
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
        shape:          shape-fn,
        fill:           palette.blue.fill,
        stroke:         tokens.stroke-default + palette.blue.stroke,
        inset:          tokens.pad-inside-shape,
        corner-radius:  tokens.radius-shape,
      ),
    ),
  ),
  align(center + horizon,
    text(size: tokens.size-label, fill: palette.ink-muted, raw("fletcher.shapes." + name))),
)

#let shapes = (
  ("rect",          fletcher.shapes.rect),
  ("circle",        fletcher.shapes.circle),
  ("ellipse",       fletcher.shapes.ellipse),
  ("pill",          fletcher.shapes.pill),
  ("parallelogram", fletcher.shapes.parallelogram),
  ("trapezium",     fletcher.shapes.trapezium),
  ("diamond",       fletcher.shapes.diamond),
  ("triangle",      fletcher.shapes.triangle),
  ("house",         fletcher.shapes.house),
  ("chevron",       fletcher.shapes.chevron),
  ("hexagon",       fletcher.shapes.hexagon),
  ("octagon",       fletcher.shapes.octagon),
  ("cylinder",      fletcher.shapes.cylinder),
  ("brace",         fletcher.shapes.brace),
  ("bracket",       fletcher.shapes.bracket),
  ("paren",         fletcher.shapes.paren),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-ranks,
  align: center + horizon,

  ..shapes.map(((name, sh)) => align(center + horizon, shape-cell(name, sh)))
)
