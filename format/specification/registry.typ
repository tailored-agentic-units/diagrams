// format / specification — registry mechanics (developer voice).
// The three exported functions and how they interact with the internal registry singleton:
// Register stores a Factory under a name; Create retrieves and invokes the Factory; ListFormats
// reads the names. Factory is the type alias every implementation supplies.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card primitives.
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(
  size: tokens.size-label,
  weight: tokens.weight-light,
  fill: on-hue,
  style: "italic",
  "(" + s + ")",
)
#let _fields(..items) = grid(
  columns: (auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  ..items.pos().map(s => raw(s)),
)
#let _card-body(hue, type-name, kind-text, body) = {
  show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
  stack(
    dir: ttb,
    spacing: tokens.gap-structured-text,
    _title(type-name),
    _kind(kind-text, hue.ink),
    divider(hue: hue),
    align(left, body),
  )
}
#let card(pos, hue, type-name, kind-text, body) = node(pos,
  _card-body(hue, type-name, kind-text, body),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Function signature card — minimal boxed signature in monospace.
#let func-card(pos, sig) = node(pos,
  {
    show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
    raw(sig)
  },
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  // Top row — three exported functions.
  func-card((0, 0), "Register(name string, factory Factory)"),
  func-card((1, 0), "Create(name string) (Format, error)"),
  func-card((2, 0), "ListFormats() []string"),

  // Middle — internal registry singleton (private package state).
  card((1, 1), palette.purple, "registry", "internal singleton",
    _fields(
      "factories", "map[string]Factory",
      "mu", "sync.RWMutex",
    ),
  ),

  // Side — Factory type alias.
  card((3, 1), palette.purple, "Factory", "type alias",
    raw("func() (Format, error)"),
  ),

  // Edges: orthogonal paths that converge on the registry — Register enters from the left,
  // Create from the top, ListFormats from the right. Labels ride the horizontal segments.
  edge((0, 0), (0, 1), (1, 1), "->", lbl("stores"), label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (1, 1), "->", lbl("retrieves & invokes"), label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 0), (2, 1), (1, 1), "->", lbl("reads keys"), label-side: left, label-fill: palette.surface, stroke: edge-stroke),
)
