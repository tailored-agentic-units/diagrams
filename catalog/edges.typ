// ==============================================================
// Edge composition catalog — structural primitives beyond
// marks.typ's head/tail/stroke inventory. Bends, waypoints,
// self-loops, label positioning, mid-edge marks.
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

// Small endpoint node helper for compact demos.
#let endpoint(pos, label, name-label: none) = node(pos,
  box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
      radius: tokens.radius-shape, inset: 6pt,
      text(size: tokens.size-label, fill: palette.ink, label)),
  name: name-label,
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Edges — structural composition primitives"),
)
#v(tokens.space-between-ranks)

// ---- SECTION A — bend ------------------------------------------------------

#section-title("A · bend")
#v(tokens.gap-structured-text)
#note("Fletcher's `bend: Ndeg`. Positive bends left of the line; negative right. Useful for readable routing when straight lines collide.")
#v(tokens.space-between-shapes)

#let bend-demo(angle, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (110pt, 0pt),
    endpoint((0, 0), "a"),
    endpoint((1, 0), "b"),
    edge((0, 0), (1, 0), "->", bend: angle,
      stroke: tokens.stroke-default + palette.green.stroke),
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  bend-demo(0deg,    "0° · straight"),
  bend-demo(15deg,   "+15°"),
  bend-demo(35deg,   "+35°"),
  bend-demo(-35deg,  "-35°"),
  bend-demo(80deg,   "+80° · arc"),
)

#v(tokens.space-between-ranks)

// ---- SECTION B — waypoints -------------------------------------------------

#section-title("B · waypoints (orthogonal routing)")
#v(tokens.gap-structured-text)
#note(
  [Instead of a single `(from, to)` pair, pass a routing string `\"r,d,l\"` to route right, then down, then left. Useful for clean orthogonal flowchart edges.])
#v(tokens.space-between-shapes)

#let waypoint-demo(direction-str, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (80pt, 50pt),
    endpoint((0, 0), "a"),
    endpoint((2, 2), "b"),
    edge((0, 0), direction-str, (2, 2), "->",
      stroke: tokens.stroke-default + palette.green.stroke),
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  waypoint-demo("r,d",    "right-then-down · \"r,d\""),
  waypoint-demo("d,r",    "down-then-right · \"d,r\""),
  waypoint-demo("r,d,r",  "step · \"r,d,r\""),
  waypoint-demo("d,r,d",  "step · \"d,r,d\""),
)

#v(tokens.space-between-ranks)

// ---- SECTION C — self-loops ------------------------------------------------

#section-title("C · self-loops")
#v(tokens.gap-structured-text)
#note([Edge from a node back to itself using `bend`. The loop arcs out and back; bend magnitude sets loop size. Loop diameter approaches infinity as bend → 180°. Select from values in `(115°, 160°)` — below 115° the loop collapses into the node; above 160° it grows past any practical cell.])
#v(tokens.space-between-shapes)

// Fixed-size + clip box breaks the auto-page-height ↔ self-loop-extent
// circular dependency: with `height: auto` on the page, Fletcher's loop
// bounds and the page height become mutually recursive and diverge.
// Larger box + clip so all bend angles render uniformly within the cell.
#let loop-demo(bend-deg, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  box(width: 260pt, height: 240pt, clip: true,
    align(center + horizon,
      diagram(
        spacing: (60pt, 60pt),
        endpoint((0, 0), "reading", name-label: <r>),
        edge(<r>, <r>, "->", bend: bend-deg,
          stroke: tokens.stroke-default + palette.green.stroke,
          label-fill: palette.surface,
          text(size: tokens.label-size, weight: tokens.weight-bold, "read()")),
      ),
    ),
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  loop-demo(115deg, "115°"),
  loop-demo(138deg, "138°"),
  loop-demo(160deg, "160°"),
)

#v(tokens.space-between-ranks)

// ---- SECTION D — label positioning -----------------------------------------

#section-title("D · label positioning")
#v(tokens.gap-structured-text)
#note("Three controls: `label-pos` (0..1 along the edge), `label-side` (left/center/right), `label-sep` (distance from line).")
#v(tokens.space-between-shapes)

#let label-demo(pos, side, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (140pt, 0pt),
    endpoint((0, 0), "from"),
    endpoint((1, 0), "to"),
    edge((0, 0), (1, 0), "->",
      stroke: tokens.stroke-default + palette.green.stroke,
      label-fill: palette.surface,
      text(size: tokens.label-size, weight: tokens.weight-bold, "label"),
      label-pos: pos, label-side: side, label-sep: tokens.label-sep),
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  label-demo(0.1, left,   "pos 0.1 · left"),
  label-demo(0.5, left,   "pos 0.5 · left (default)"),
  label-demo(0.9, left,   "pos 0.9 · left"),
  label-demo(0.5, center, "pos 0.5 · center (on-line)"),
  label-demo(0.5, right,  "pos 0.5 · right"),
  label-demo(0.5, left,   "pos 0.5 · default"),
)

#v(tokens.space-between-ranks)

// ---- SECTION E — mid-edge marks --------------------------------------------

#section-title("E · mid-edge marks")
#v(tokens.gap-structured-text)
#note("A mark placed mid-line (rather than at head/tail). Useful for flow annotations — the edge carries directionality AND a categorical hint at midpoint.")
#v(tokens.space-between-shapes)

#let mid-demo(mark-str, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  diagram(
    spacing: (110pt, 0pt),
    endpoint((0, 0), "a"),
    endpoint((1, 0), "b"),
    edge((0, 0), (1, 0), mark-str,
      stroke: tokens.stroke-default + palette.green.stroke),
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  mid-demo("-|>-",      "stealth middle"),
  mid-demo("->-",       "head middle"),
  mid-demo("-o-",       "circle middle"),
  mid-demo("-|-",       "bar middle"),
)

#v(tokens.space-between-ranks)

// ---- SECTION F — parallel edges --------------------------------------------

#section-title("F · parallel edges (same endpoints, different semantics)")
#v(tokens.gap-structured-text)
#note("Two edges between the same nodes with opposite bends give a clean bidirectional feel where the pair carries separate meaning.")
#v(tokens.space-between-shapes)

#align(center,
  diagram(
    spacing: (160pt, 0pt),
    endpoint((0, 0), "client"),
    endpoint((1, 0), "server"),
    edge((0, 0), (1, 0), "->", bend: +25deg,
      stroke: tokens.stroke-default + palette.green.stroke,
      label-fill: palette.surface,
      text(size: tokens.label-size, weight: tokens.weight-bold, "request"),
      label-side: left, label-sep: 4pt,
    ),
    edge((0, 0), (1, 0), "->", bend: -25deg,
      stroke: (paint: palette.yellow.stroke, thickness: tokens.stroke-default, dash: "dashed"),
      label-fill: palette.surface,
      text(size: tokens.label-size, weight: tokens.weight-bold, "notify"),
      label-side: left, label-sep: 4pt,
    ),
  )
)

#v(tokens.space-between-ranks)

// ---- SECTION G — crossing / layer ------------------------------------------

#section-title("G · crossing + layer order")
#v(tokens.gap-structured-text)
#note(
  [Fletcher draws edges in source order. Use `layer: -1` on an edge or node to push it behind others — useful when a background-route edge shouldn't overdraw a foreground endpoint.])
#v(tokens.space-between-shapes)

#align(center,
  diagram(
    spacing: (80pt, 80pt),
    endpoint((0, 0), "a", name-label: <a>),
    endpoint((2, 0), "b", name-label: <b>),
    endpoint((0, 1), "c", name-label: <c>),
    endpoint((2, 1), "d", name-label: <d>),
    // Crossing edges — one rendered behind via layer
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
)
