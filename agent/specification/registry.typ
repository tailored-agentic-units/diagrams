// agent / specification — registry mechanics (developer voice).
// Registry is an instance type (created via NewRegistry, not a package singleton like
// format / provider's registry) that manages named agent configurations with lazy
// instantiation. Two maps partition the state: `configs` holds AgentConfig values written
// at registration time; `agents` caches constructed Agent instances built lazily on first
// Get. The diagram emphasizes that lifecycle: Get's cache-miss path threads through
// provider.Create, format.Create, and agent.New before writing back into the agents map.
// The other five methods (Register / Replace / Unregister / List / Capabilities) appear
// in a compact ledger card with their effect on state, since their relationship to
// Registry is uniformly "modify or read" without the cross-package construction flow.
//
// Layout: Operations ledger and NewRegistry occupy the same row above Registry. Get is
// pushed one row below Registry on the right so its incoming edge can L-shape upward and
// inward to Registry's right edge. Both wide labels ("modify configs / agents",
// "reads agents (cache hit)") sit on the vertical segments of the L-shaped edges,
// occupying the empty rectangles between the source cards and Registry rather than
// squeezing between cards on the same row.

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
#let _section(s, on-hue) = text(
  size: tokens.size-label,
  weight: tokens.weight-light,
  fill: on-hue,
  style: "italic",
  s,
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

// Function signature card — minimal boxed signature in monospace, blue treatment matching
// format / provider registry function-cards.
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

// Registry state body — two-section card body listing the two maps and the mutex. The
// top section names the two maps (the design's defining feature); the bottom section
// names the mutex that gates concurrent access to both.
#let _registry-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("state — two-map design", hue.ink),
  _fields(
    "configs", "map[string]config.AgentConfig",
    "agents",  "map[string]agent.Agent",
  ),
  v(tokens.gap-cell / 2),
  _section("concurrency", hue.ink),
  _fields(
    "mu", "sync.RWMutex",
  ),
)

// Operations ledger body — the five non-Get methods listed with their effect on the two
// maps. Compact form: signature on the left, effect in italic-muted on the right. Keeps
// the visual focus on Get + cache-miss path while still showing the full method surface.
#let _ops-ledger-body = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("methods — effect on state", palette.ink-muted),
  grid(
    columns: (auto, auto),
    column-gutter: tokens.gap-cell * 1.5,
    row-gutter: tokens.gap-structured-text,
    raw("Register(name, cfg)"),    text(style: "italic", fill: palette.ink-muted, "writes configs"),
    raw("Replace(name, cfg)"),     text(style: "italic", fill: palette.ink-muted, "writes configs · invalidates agents[name]"),
    raw("Unregister(name)"),       text(style: "italic", fill: palette.ink-muted, "deletes from both"),
    raw("List()"),                 text(style: "italic", fill: palette.ink-muted, "reads configs"),
    raw("Capabilities(name)"),     text(style: "italic", fill: palette.ink-muted, "reads configs"),
  ),
)

#let ops-ledger(pos) = node(pos,
  {
    show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
    align(left, _ops-ledger-body)
  },
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// NewRegistry constructor — small muted node anchored above Registry.
#let constructor-card(pos) = node(pos,
  raw("NewRegistry() *Registry"),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#diagram(
  spacing: (tokens.space-between-shapes * 3.5, tokens.space-between-ranks * 1.5),

  // Top row — Operations ledger and NewRegistry both at row 0. fletcher auto-expands the
  // col distance to fit the ledger's width regardless of the spacing parameter, so the
  // ledger sits flush against its content's natural extent and Registry follows directly
  // beyond. Tightened spacing keeps everything else compact.
  ops-ledger((0, 0)),
  constructor-card((2, 0)),

  // Middle row — Registry struct (focal). Purple matches format / provider registry
  // hue conventions for the registry-pattern type, reinforcing cross-library
  // consistency.
  card((2, 1), palette.purple, "Registry", "struct", _registry-body(palette.purple)),

  // Pushed down — Get(name) one row below Registry on the right (col 4, row 2). The
  // L-shape edge can travel up to row 1 then turn left into Registry's right edge,
  // freeing the vertical segment to carry the "reads agents (cache hit)" label.
  func-card((4, 2), "Get(name) (Agent, error)"),

  // Cache-miss path — three native-dep references that Get calls in sequence on the miss
  // branch, before writing the constructed agent back into Registry.agents. Stacked
  // vertically below Get on col 4.
  extern((4, 3), "provider.Create"),
  extern((4, 4), "format.Create"),
  extern((4, 5), "agent.New"),

  // Constructor flow: NewRegistry → Registry, vertical "creates".
  edge((2, 0), (2, 1), "->", lbl("creates"), label-fill: palette.surface, stroke: edge-stroke),

  // Operations ledger → Registry: L-shape with vertical down then horizontal right.
  // Label sits on the vertical segment with label-side: left (east relative to a
  // downward edge) — landing in the empty rectangle between ledger (col 0) and
  // Registry (col 2). label-pos kept low so the label rides the short vertical
  // segment near the bend rather than sliding far along the horizontal run.
  edge((0, 0), (0, 1), (2, 1), "->", lbl("modify configs / agents"),
    label-pos: 0.18, label-side: left, label-fill: palette.surface, stroke: edge-stroke),

  // Get → Registry: L-shape with vertical up then horizontal left. Label sits on the
  // vertical segment with label-side: left (west relative to an upward edge) — landing
  // in the empty rectangle between Get (col 4) and Registry (col 2).
  edge((4, 2), (4, 1), (2, 1), "->", lbl("reads agents (cache hit)"),
    label-pos: 0.18, label-side: left, label-fill: palette.surface, stroke: edge-stroke),

  // Get's cache-miss path: trunk down through the three native deps in sequence. Each
  // step is its own edge so the sequencing reads top-to-bottom; the leading edge carries
  // the "on cache miss" label.
  edge((4, 2), (4, 3), "->", lbl("on cache miss"), label-fill: palette.surface, stroke: edge-stroke),
  edge((4, 3), (4, 4), "->", stroke: edge-stroke),
  edge((4, 4), (4, 5), "->", stroke: edge-stroke),

  // Cache-miss tail: agent.New's result is stored into Registry.agents — closes the
  // loop back to Registry. Routed (4, 5) → (2, 5) → (2, 1): horizontal left under the
  // diagram, then vertical up at col 2 to Registry's bottom edge. Label sits on the
  // vertical segment with label-side: right (east relative to upward edge) — landing
  // in the empty corridor between Registry's lower-right (col 2) and the cache-miss
  // column (col 4).
  edge((4, 5), (2, 5), (2, 1), "->", lbl("writes agents"),
    label-pos: 0.78, label-side: right, label-fill: palette.surface, stroke: edge-stroke),
)
