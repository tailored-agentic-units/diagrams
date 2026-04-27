#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)

#let node-demo(body) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), body,
    shape: fletcher.shapes.rect,
    fill: palette.purple.fill,
    stroke: tokens.stroke-default + palette.purple.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("plain"), col-header("bold title"), col-header("code literal"),

  align(center + horizon, node-demo("planner")),
  align(center + horizon, node-demo(_title("planner"))),
  align(center + horizon, node-demo(raw("ChatService"))),
)
