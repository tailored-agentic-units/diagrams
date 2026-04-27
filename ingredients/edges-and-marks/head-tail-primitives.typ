#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let column-title(s) = align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s)))
#let mono-code(s) = raw(s)

#let edge-demo(edge-str) = diagram(
  spacing: (90pt, 0pt),
  node-stroke: none, node-fill: none,
  node((0, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "from"))),
  node((1, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "to"))),
  edge((0, 0), (1, 0), edge-str, stroke: tokens.stroke-default + palette.ink),
)

#let primitives = (
  ("->",           "head",          ">"),
  ("-|>",          "stealth",       "|>"),
  ("-straight",    "straight",      "—"),
  ("-solid",       "solid",         "—"),
  ("-|",           "bar",           "|"),
  ("-/",           "bar @60°",      "/"),
  ("-hook",        "hook",          "—"),
  ("-o",           "circle",        "o"),
  ("-O",           "circle lg",     "O"),
  ("-x",           "cross",         "x"),
  ("-X",           "cross lg",      "X"),
  ("-square",      "square",        "—"),
  ("-diamond",     "diamond",       "—"),
  ("-parenthesis", "parenthesis",   "—"),
  ("-bracket",     "bracket",       "—"),
  ("-crowfoot",    "crowfoot",      "—"),
  ("-n",           "crowfoot many", "n"),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (right + horizon, left + horizon, center + horizon, center + horizon),

  column-title("primitive"), column-title("string"), column-title("alias"), column-title("rendered"),

  ..primitives.map(((s, name, alias)) => (
    text(fill: palette.ink, name),
    mono-code(s),
    mono-code(alias),
    edge-demo(s),
  )).flatten()
)
