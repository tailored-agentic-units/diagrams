#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let chip(hue, label) = box(
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  radius: tokens.radius-shape,
  inset: (x: 8pt, y: 4pt),
  text(size: tokens.size-label, weight: tokens.weight-bold, fill: hue.ink, label),
)

#let edge-chip(hue, label, dash: none) = {
  let stroke-spec = if dash != none {
    (paint: hue.stroke, thickness: 1.6pt, dash: dash)
  } else {
    1.6pt + hue.stroke
  }
  align(center + horizon, stack(dir: ttb, spacing: 4pt,
    line(length: 70pt, stroke: stroke-spec),
    text(size: tokens.size-label, weight: tokens.weight-bold, fill: hue.ink, label),
  ))
}

#stack(dir: ttb, spacing: tokens.space-between-ranks,
  stack(dir: ttb, spacing: tokens.gap-cell,
    col-header("group → hue"),
    grid(
      columns: (auto, auto, auto, auto, auto),
      column-gutter: tokens.space-between-shapes,
      align: center + horizon,

      align(center + horizon, chip(palette.purple, "code")),
      align(center + horizon, chip(palette.blue,   "service")),
      align(center + horizon, chip(palette.orange, "operator")),
      align(center + horizon, chip(palette.coral,  "infra")),
      align(center + horizon, chip(palette.green,  "data")),
    ),
  ),

  stack(dir: ttb, spacing: tokens.gap-cell,
    col-header("edge kind → hue"),
    grid(
      columns: (auto, auto, auto, auto),
      column-gutter: tokens.space-between-shapes,
      align: center + horizon,

      edge-chip(palette.green,  "query"),
      edge-chip(palette.red,    "command"),
      edge-chip(palette.yellow, "event",   dash: "dashed"),
      edge-chip(palette.blue,   "data-flow"),
    ),
  ),
)
