#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

#let node-demo(body, hue: palette.purple) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), body,
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("purple group"), col-header("blue group"), col-header("orange group"),

  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Request"), _kind("structure", palette.purple.ink)))),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("api"), _kind("compute", palette.blue.ink)),
    hue: palette.blue)),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("planner"), _kind("agent", palette.orange.ink)),
    hue: palette.orange)),
)
