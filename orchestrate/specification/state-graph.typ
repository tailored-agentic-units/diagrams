// orchestrate / specification / state-graph — graph execution engine (developer voice).
// Five entities define the engine: StateGraph (the interface the developer composes against),
// State (the immutable map-based value that flows through execution, split into Data + Secrets
// partitions), StateNode (the computation contract), Edge (the typed transition with optional
// predicate), and CheckpointStore (the durability extension point). A muted predicate-combinator
// card lists the building blocks for an Edge's TransitionPredicate. State carries its own
// Observer and execution-provenance metadata (RunID, CheckpointNode, Timestamp); the Secrets
// partition is excluded from json marshalling and observer events.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card primitives — mirror the readme.typ inventory in this directory so the spec tier
// reads as a single visual vocabulary across both diagrams.
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(
  size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic",
  "(" + s + ")",
)
#let _section(s, on-hue) = text(
  size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", s,
)
#let _methods(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  ..lines.pos().map(s => raw(s)),
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
#let card(pos, hue, type-name, kind-text, body, emphasized: false) = node(pos,
  _card-body(hue, type-name, kind-text, body),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: (if emphasized { tokens.stroke-emphasis } else { tokens.stroke-default }) + hue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Muted card — for the predicate-combinator catalog. These are functions producing values
// of the TransitionPredicate type rather than a type definition of their own.
#let muted-card(pos, name, kind-text, body) = node(pos,
  {
    show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _title(name),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
        style: "italic", "(" + kind-text + ")"),
      line(length: 100%, stroke: tokens.stroke-thin + palette.border),
      align(left, body),
    )
  },
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// StateGraph interface body — three sections (structure / execution / recovery) so the
// developer sees how the API groups by purpose rather than as a flat list.
#let _graph-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("structure", hue.ink),
  _methods(
    "AddNode(name string, node StateNode) error",
    "AddEdge(from, to string, p TransitionPredicate) error",
    "SetEntryPoint(node string) error",
    "SetExitPoint(node string) error",
  ),
  v(tokens.gap-cell / 2),
  _section("execution · recovery", hue.ink),
  _methods(
    "Execute(ctx, State) (State, error)",
    "Resume(ctx, runID) (State, error)",
  ),
)

// State body — two partitions named explicitly so the json + observer asymmetry is
// visible at a glance.
#let _state-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("persisted · observable", hue.ink),
  _methods(
    "Data            map[string]any",
    "RunID           string",
    "CheckpointNode  string",
    "Timestamp       time.Time",
  ),
  v(tokens.gap-cell / 2),
  _section("excluded from json + events", hue.ink),
  _methods(
    "Secrets   map[string]any",
    "Observer  observability.Observer",
  ),
  v(tokens.gap-cell / 2),
  _section("immutable — every mutation clones", hue.ink),
  _methods(
    "Set(key, value) State",
    "Merge(other State) State",
    "SetSecret(key, value) State",
    "SetCheckpointNode(node) State",
  ),
)

#let _node-body = _methods(
  "Execute(ctx, State) (State, error)",
)
#let _node-helper = text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
  style: "italic", "NewFunctionNode(fn) StateNode")

#let _edge-body = _methods(
  "From string",
  "To   string",
  "Name string",
  "Predicate TransitionPredicate",
)

#let _ckpt-body = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _methods(
    "Save(state State) error",
    "Load(runID string) (State, error)",
    "Delete(runID string) error",
    "List() ([]string, error)",
  ),
  v(tokens.gap-cell / 2),
  _section("pre-registered: \"memory\"", palette.blue.ink),
)

// Predicate-combinator catalog body — type definition + the producers that return values
// satisfying it. All five combinators plus the always-true convenience are grouped here
// so the developer sees the full predicate vocabulary in one place.
#let _predicates-body = stack(dir: ttb, spacing: tokens.gap-structured-text,
  raw("type TransitionPredicate ="),
  raw("    func(State) bool"),
  v(tokens.gap-cell / 2),
  text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
    style: "italic", "constructors"),
  _methods(
    "AlwaysTransition()",
    "KeyExists(key)",
    "KeyEquals(key, value)",
    "Not(predicate)",
    "And(predicates...)",
    "Or(predicates...)",
  ),
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 2, tokens.space-between-ranks * 1.2),

  // Row 0 — focal StateGraph interface, wide and centered.
  card((1, 0), palette.blue, "StateGraph", "interface", _graph-body(palette.blue),
    emphasized: true),

  // Row 1 — State on the left (the value that flows through Execute) and CheckpointStore
  // on the right (the durability surface that captures State every Interval iterations).
  card((0, 1), palette.blue, "State", "struct · immutable", _state-body(palette.blue)),
  card((2, 1), palette.blue, "CheckpointStore", "interface", _ckpt-body),

  // Row 2 — the three structural ingredients: StateNode (computation contract), Edge
  // (typed transition), and the predicate-combinator catalog (Edge.Predicate producers).
  card((0, 2), palette.blue, "StateNode", "interface",
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _node-body,
      v(tokens.gap-cell / 2),
      _section("helper", palette.blue.ink),
      raw("NewFunctionNode(fn) StateNode"),
    ),
  ),
  card((1, 2), palette.blue, "Edge", "struct", _edge-body),
  muted-card((2, 2), "predicate combinators",
    "producers → TransitionPredicate",
    _predicates-body),

  // Edges — three relationships worth surfacing as arrows; the rest of the structural
  // composition (StateGraph stores nodes and edges) reads from card content and proximity.
  // Both StateGraph outflows route as L-shapes: horizontal segment leaves the focal card's
  // east/west center face, vertical segment lands on the target card's north face center.
  // Labels pin to label-pos 0.3 so they sit on the horizontal segment (the open whitespace
  // above the row-1 cards) rather than at the L's corner.
  edge((1, 0), (0, 0), (0, 1), "->", lbl("Execute · Resume flow"),
    label-pos: 0.3, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (2, 0), (2, 1), "->", lbl("save every Interval"),
    label-pos: 0.3, label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 2), (2, 2), "->", lbl(".Predicate"),
    label-fill: palette.surface, stroke: edge-stroke),
)
