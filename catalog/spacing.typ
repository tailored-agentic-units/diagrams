// ==============================================================
// Spacing catalog — the whitespace controls available to diagrams.
// Shape padding, corner radius, block insets, stack/grid gutters,
// Fletcher diagram spacing. All values traced to design/tokens.typ.
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

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Sample: a labelled rect demonstrating a particular parameter value.
#let sample-rect(label, inset: tokens.pad-inside-shape, radius: tokens.radius-shape) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), label,
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: inset,
    corner-radius: radius,
  ),
)

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Spacing — whitespace primitives available to diagrams"),
)
#v(tokens.space-between-ranks)

// ---- SECTION A — shape inset -----------------------------------------------

#section-title("A · shape inset (label ↔ boundary)")
#v(tokens.gap-structured-text)
#note("Fletcher's inset parameter padding between label content and the shape boundary.")
#v(tokens.space-between-shapes)

#let insets = (
  ("0pt",  0pt),
  ("4pt",  4pt),
  ("10pt", tokens.pad-inside-shape),
  ("16pt", 16pt),
  ("24pt", 24pt),
)

#grid(
  columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  col-header("inset"),
  ..insets.map(((label, _)) => col-header(label)),

  align(right + horizon, text(fill: palette.ink-muted, "rendered →")),
  ..insets.map(((_, v)) => align(center + horizon, sample-rect("sample", inset: v))),
)

#v(tokens.space-between-ranks)

// ---- SECTION B — corner radius ---------------------------------------------

#section-title("B · corner radius")
#v(tokens.gap-structured-text)
#note("Shape corner-radius. 0pt = sharp, 6pt = token default, larger = softer.")
#v(tokens.space-between-shapes)

#let radii = (
  ("0pt",   0pt),
  ("3pt",   3pt),
  ("6pt",   tokens.radius-shape),
  ("10pt",  tokens.radius-container),
  ("20pt",  20pt),
)

#grid(
  columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  col-header("radius"),
  ..radii.map(((label, _)) => col-header(label)),

  align(right + horizon, text(fill: palette.ink-muted, "rendered →")),
  ..radii.map(((_, v)) => align(center + horizon, sample-rect("sample", radius: v))),
)

#v(tokens.space-between-ranks)

// ---- SECTION C — stack spacing ---------------------------------------------

#section-title("C · stack spacing (vertical gap between elements)")
#v(tokens.gap-structured-text)
#note("`#stack(dir: ttb, spacing: X)` controls gap between stacked blocks. gap-structured-text is the small default inside labels.")
#v(tokens.space-between-shapes)

#let spacings = (
  ("0pt",    0pt,                              "no gap"),
  ("5pt",    tokens.gap-structured-text,       "inside structured labels"),
  ("14pt",   tokens.gap-cell,                  "between cells in a field grid"),
  ("28pt",   tokens.space-between-shapes,      "between nodes in a Fletcher row"),
  ("36pt",   tokens.space-between-ranks,       "between vertically stacked groups"),
)

#grid(
  columns: (auto, auto, 1fr, 2fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: (left + horizon, right + horizon, left + horizon, left + horizon),

  col-header("label"), col-header("token"), col-header("visual"), col-header("usage"),

  ..spacings.map(((label, v, usage)) => (
    raw(label),
    text(fill: palette.ink-muted, repr(v)),
    stack(dir: ttb, spacing: v,
      sample-rect(text(size: tokens.size-label, "one"),  inset: 6pt),
      sample-rect(text(size: tokens.size-label, "two"),  inset: 6pt),
    ),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", usage),
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION D — grid gutters ----------------------------------------------

#section-title("D · grid gutters (row + column)")
#v(tokens.gap-structured-text)
#note("`#grid(column-gutter: X, row-gutter: Y)` is the primary 2D layout primitive for tables and catalogues.")
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  align(center,
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      col-header("tight (5 / 5)"),
      grid(columns: 3, column-gutter: 5pt, row-gutter: 5pt,
        ..range(9).map(i => sample-rect(text(size: tokens.size-label, str(i)), inset: 4pt))),
    ),
  ),
  align(center,
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      col-header("comfortable (14 / 14)"),
      grid(columns: 3, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-cell,
        ..range(9).map(i => sample-rect(text(size: tokens.size-label, str(i)), inset: 4pt))),
    ),
  ),
  align(center,
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      col-header("airy (28 / 28)"),
      grid(columns: 3, column-gutter: tokens.space-between-shapes, row-gutter: tokens.space-between-shapes,
        ..range(9).map(i => sample-rect(text(size: tokens.size-label, str(i)), inset: 4pt))),
    ),
  ),
)

#v(tokens.space-between-ranks)

// ---- SECTION E — Fletcher diagram spacing ----------------------------------

#section-title("E · Fletcher diagram spacing")
#v(tokens.gap-structured-text)
#note("`diagram(spacing: (x, y))` sets the cell size of Fletcher's coordinate grid. Nodes at (0,0) and (1,0) are spacing.x apart.")
#v(tokens.space-between-shapes)

#let demo-diagram(sx, sy) = diagram(
  spacing: (sx, sy),
  node((0, 0), "a", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((1, 0), "b", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((0, 1), "c", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  node((1, 1), "d", shape: fletcher.shapes.rect, fill: palette.purple.fill, stroke: tokens.stroke-default + palette.purple.stroke, inset: 8pt),
  edge((0, 0), (1, 0), "->", stroke: tokens.stroke-default + palette.ink),
  edge((0, 0), (0, 1), "->", stroke: tokens.stroke-default + palette.ink),
  edge((0, 1), (1, 1), "->", stroke: tokens.stroke-default + palette.ink),
  edge((1, 0), (1, 1), "->", stroke: tokens.stroke-default + palette.ink),
)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("tight (15, 20)"),
    demo-diagram(15pt, 20pt),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("default (28, 36)"),
    demo-diagram(tokens.space-between-shapes, tokens.space-between-ranks),
  ),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    col-header("airy (60, 50)"),
    demo-diagram(60pt, 50pt),
  ),
)

#v(tokens.space-between-ranks)

// ---- SECTION F — token inventory -------------------------------------------

#section-title("F · whitespace tokens — full inventory")
#v(tokens.gap-structured-text)
#note("Every diagram value flows through these tokens. Adding ad-hoc `pt` values defeats the design system.")
#v(tokens.space-between-shapes)

#let whitespace-tokens = (
  ("pad-inside-shape",     tokens.pad-inside-shape,     "label ↔ shape boundary"),
  ("pad-inside-container", tokens.pad-inside-container, "container ↔ inner content"),
  ("space-between-shapes", tokens.space-between-shapes, "horizontal node spacing"),
  ("space-between-ranks",  tokens.space-between-ranks,  "vertical node spacing"),
  ("gap-structured-text",  tokens.gap-structured-text,  "stack lines in a label"),
  ("gap-cell",             tokens.gap-cell,             "columns in a field grid"),
  ("label-sep",            tokens.label-sep,            "edge label ↔ edge line"),
)

#grid(
  columns: (auto, auto, 1fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  align: (left + horizon, right + horizon, left + horizon),

  col-header("token"), col-header("value"), col-header("usage"),

  ..whitespace-tokens.map(((name, v, use)) => (
    raw(name),
    text(fill: palette.ink-muted, repr(v)),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
