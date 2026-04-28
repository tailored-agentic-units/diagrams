#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let column-title(s) = align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s)))

#let edge-demo(edge-str, stroke-color: palette.ink, stroke-weight: tokens.stroke-default) = diagram(
  spacing: (90pt, 0pt),
  node-stroke: none, node-fill: none,
  node((0, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "from"))),
  node((1, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "to"))),
  edge((0, 0), (1, 0), edge-str, stroke: (paint: stroke-color, thickness: stroke-weight)),
)

#let candidates = (
  ("query",   "->",        tokens.stroke-default,  palette.green.stroke,  "solid body · plain head"),
  ("query",   "-|>",       tokens.stroke-default,  palette.green.stroke,  "solid body · stealth head"),
  ("query",   "-straight", tokens.stroke-default,  palette.green.stroke,  "solid body · straight head"),

  ("command", "=>",        tokens.stroke-emphasis, palette.red.stroke,    "double body · plain head"),
  ("command", "=|>",       tokens.stroke-emphasis, palette.red.stroke,    "double body · stealth head"),
  ("command", "-|>",       tokens.stroke-emphasis, palette.red.stroke,    "solid body · stealth head"),

  ("event",   "--|>",      tokens.stroke-default,  palette.yellow.stroke, "dashed · stealth head"),
  ("event",   "->",        tokens.stroke-default,  palette.yellow.stroke, "solid plain (kind by colour alone)"),
  ("event",   "~>",        tokens.stroke-default,  palette.yellow.stroke, "wavy body · plain head"),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (right + horizon, left + horizon, center + horizon, left + horizon),

  column-title("kind"), column-title("string"), column-title("rendered"), column-title("note"),

  ..candidates.map(((group, s, weight, color, note)) => (
    text(fill: color, weight: tokens.weight-bold, group),
    raw(s),
    edge-demo(s, stroke-color: color, stroke-weight: weight),
    text(size: tokens.size-label, fill: palette.ink-muted, note),
  )).flatten()
)
