// ==============================================================
// Arrow-mark catalog — head/tail primitives, stroke styles, and
// a palette of edge-kind encodings. Ingredients, not rules.
// ==============================================================
// render: static

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette

#set page(
  width:  900pt,
  height: auto,
  margin: tokens.pad-inside-container,
  fill:   palette.surface,
)
#set text(
  font: tokens.font,
  size: tokens.size-body,
  fill: palette.ink,
)

// ---- helpers ---------------------------------------------------------------

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let column-title(s) = align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s)))
#let mono-code(s) = raw(s)

// Render an edge as a standalone diagram. Uses abstract endpoint nodes so the
// edge itself is the subject of attention.
#let edge-demo(edge-str, stroke-color: palette.ink, stroke-weight: tokens.stroke-default) = diagram(
  spacing: (90pt, 0pt),
  node-stroke: none,
  node-fill: none,
  node((0, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "from")),
  ),
  node((1, 0),
    box(fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, radius: tokens.radius-shape,
        inset: 6pt, text(size: tokens.size-label, fill: palette.ink-muted, "to")),
  ),
  edge((0, 0), (1, 0), edge-str, stroke: (paint: stroke-color, thickness: stroke-weight)),
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Arrow-marks — primitives, stroke styles, edge-kind encodings"),
)

#v(tokens.space-between-ranks)

// ---- SECTION A — head/tail primitives --------------------------------------

#section-title("A · head / tail primitives")

#v(tokens.gap-structured-text)

#text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
  "Each primitive rendered as the head of a solid edge. Alias column shows the single-char shorthand, if any.")

#v(tokens.space-between-shapes)

#let primitives = (
  // (mark-string, primitive-name, alias)
  ("->",              "head",         ">"),
  ("-|>",             "stealth",      "|>"),
  ("-straight",       "straight",     "—"),
  ("-solid",          "solid",        "—"),
  ("-|",              "bar",          "|"),
  ("-/",              "bar @60°",     "/"),
  ("-hook",           "hook",         "—"),
  ("-o",              "circle",       "o"),
  ("-O",              "circle lg",    "O"),
  ("-x",              "cross",        "x"),
  ("-X",              "cross lg",     "X"),
  ("-square",         "square",       "—"),
  ("-diamond",        "diamond",      "—"),
  ("-parenthesis",    "parenthesis",  "—"),
  ("-bracket",        "bracket",      "—"),
  ("-crowfoot",       "crowfoot",     "—"),
  ("-n",              "crowfoot many","n"),
)

#grid(
  columns: (auto, auto, auto, 1fr),
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

#v(tokens.space-between-ranks)

// ---- SECTION B — stroke styles ---------------------------------------------

#section-title("B · stroke styles")

#v(tokens.gap-structured-text)

#text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
  "Same head (stealth) across every style; body symbol varies.")

#v(tokens.space-between-shapes)

#let strokes = (
  ("-|>",         "solid"),
  ("=|>",         "double"),
  ("--|>",        "dashed"),
  ("..|>",        "dotted"),
  ("~|>",         "wavy"),
)

#grid(
  columns: (auto, auto, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (right + horizon, left + horizon, center + horizon),

  column-title("style"), column-title("string"), column-title("rendered"),

  ..strokes.map(((s, name)) => (
    text(fill: palette.ink, name),
    mono-code(s),
    edge-demo(s),
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION C — edge-kind encodings ---------------------------------------

#section-title("C · edge-kind encodings")

#v(tokens.gap-structured-text)

#text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
  "query / command / event are illustrative — actual edge kinds vary per diagram, derived from the relationships the diagram is communicating. Each cell shows how visual weight (thickness, dash pattern, head style) composes with hue to distinguish edge classes.")

#v(tokens.space-between-shapes)

#let candidates = (
  // (group, string, stroke-weight, color, note)
  ("query",   "->",       tokens.stroke-default,   palette.green.stroke,   "solid body · plain head"),
  ("query",   "-|>",      tokens.stroke-default,   palette.green.stroke,   "solid body · stealth head"),
  ("query",   "-straight", tokens.stroke-default,  palette.green.stroke,   "solid body · straight head"),

  ("command", "=>",       tokens.stroke-emphasis, palette.red.stroke, "double body · plain head"),
  ("command", "=|>",      tokens.stroke-emphasis, palette.red.stroke, "double body · stealth head"),
  ("command", "-|>",      tokens.stroke-emphasis, palette.red.stroke, "solid body · stealth head"),

  ("event",   "--|>",     tokens.stroke-default,   palette.yellow.stroke,   "dashed · stealth head"),
  ("event",   "->",       tokens.stroke-default,   palette.yellow.stroke,   "solid plain (kind by colour alone)"),
  ("event",   "~>",       tokens.stroke-default,   palette.yellow.stroke,   "wavy body · plain head"),
)

#grid(
  columns: (auto, auto, 1fr, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (right + horizon, left + horizon, center + horizon, left + horizon),

  column-title("kind"), column-title("string"), column-title("rendered"), column-title("note"),

  ..candidates.map(((group, s, weight, color, note)) => (
    text(fill: color, weight: tokens.weight-bold, group),
    mono-code(s),
    edge-demo(s, stroke-color: color, stroke-weight: weight),
    text(size: tokens.size-label, fill: palette.ink-muted, note),
  )).flatten()
)
