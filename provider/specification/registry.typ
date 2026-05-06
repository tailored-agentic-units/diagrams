// provider / specification — registry mechanics (developer voice).
// The three exported functions and how they interact with the internal registry singleton:
// Register stores a Factory under a name; Create looks up the Factory by ProviderConfig.Name
// and invokes it with the config; ListProviders reads the registered names. Factory is the type
// alias every implementation supplies. config.ProviderConfig is the native dep flowing into
// Create (and through it, the Factory) — shown at single-shape resolution per tau-decisions.md.

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

// Native-dep — muted single-shape reference for types declared in another TAU library.
#let extern(pos, name) = node(pos,
  raw(name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  // Top row — config.ProviderConfig as the native-dep input flowing into Create.
  extern((1, 0), "config.ProviderConfig"),

  // Middle row — three exported functions.
  func-card((0, 1), "Register(name string, factory Factory)"),
  func-card((1, 1), "Create(c *config.ProviderConfig) (Provider, error)"),
  func-card((2, 1), "ListProviders() []string"),

  // Bottom row — internal registry singleton (private package state).
  card((1, 2), palette.purple, "registry", "internal singleton",
    _fields(
      "factories", "map[string]Factory",
      "mu", "sync.RWMutex",
    ),
  ),

  // Side — Factory type alias.
  card((3, 2), palette.purple, "Factory", "type alias",
    raw("func(c *config.ProviderConfig) (Provider, error)"),
  ),

  // ProviderConfig flows down into Create as its single argument.
  edge((1, 0), (1, 1), "->", lbl("input"),
    label-fill: palette.surface, stroke: edge-stroke),

  // Edges: orthogonal paths converge on the registry — Register enters from the left,
  // Create from the top, ListProviders from the right. Labels ride the horizontal segments.
  edge((0, 1), (0, 2), (1, 2), "->", lbl("stores"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 1), (1, 2), "->", lbl("retrieves & invokes"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 1), (2, 2), (1, 2), "->", lbl("reads keys"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
)
