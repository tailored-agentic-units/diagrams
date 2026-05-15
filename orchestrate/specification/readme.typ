// orchestrate / specification — Hub composition + Workflow patterns (developer voice).
// Two clusters in one diagram. Top: the Hub interface and the three types that compose with
// it — Participant (the only contract a registrant must satisfy), MessageHandler (the
// closure each registrant supplies), and MessageChannel[T] (the per-participant buffered
// transport Hub owns under the hood). Bottom: the three generic workflow-pattern functions
// (ProcessChain, ProcessParallel, ProcessConditional) and the three integration wrappers
// (ChainNode, ParallelNode, ConditionalNode) that adapt each pattern into a state.StateNode
// — the seam between this library and the state-graph engine detailed in state-graph.typ.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card primitives — mirror the agent / format / provider specification inventory so
// multi-section cards, externs, and labels read consistently across the suite.
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
#let card(pos, hue, type-name, kind-text, body) = node(pos,
  _card-body(hue, type-name, kind-text, body),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Bridge card — muted treatment for the three integration wrappers (ChainNode,
// ParallelNode, ConditionalNode). They are functions that *return* state.StateNode, not
// interfaces themselves, so they read as constructors. Kind line carries the return.
#let bridge-card(pos, name, kind-text, body) = node(pos,
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

// Extern — single-shape native-dep reference per tau-decisions.md.
#let extern(pos, name, name-tag: none) = node(pos,
  raw(name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
  ..if name-tag != none { (name: name-tag) } else { (:) },
)

// Hub interface body — nine methods grouped into four sections so the contract reads as
// a layered surface rather than a flat list.
#let _hub-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("registration", hue.ink),
  _methods(
    "Register(p Participant, handler MessageHandler) error",
    "Unregister(participantID string) error",
  ),
  v(tokens.gap-cell / 2),
  _section("messaging", hue.ink),
  _methods(
    "Send(ctx, from, to, data) error",
    "Request(ctx, from, to, data) (*Message, error)",
    "Broadcast(ctx, from, data) error",
  ),
  v(tokens.gap-cell / 2),
  _section("publish · subscribe", hue.ink),
  _methods(
    "Subscribe(participantID, topic) error",
    "Publish(ctx, from, topic, data) error",
  ),
  v(tokens.gap-cell / 2),
  _section("lifecycle", hue.ink),
  _methods(
    "Metrics() MetricsSnapshot",
    "Shutdown(timeout) error",
  ),
)

// MessageChannel[T] body — the channel surface a participant's buffered queue exposes.
#let _channel-body = _methods(
  "Send(ctx, T) error",
  "Receive(ctx) (T, error)",
  "TryReceive() (T, bool)",
  "Close()",
  "BufferSize() int",
  "QueueLength() int",
)

// Workflow-pattern card bodies — type-parameter line + the function's essential
// characterization, kept compact so the three patterns stay legible side-by-side.
#let _chain-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  raw("[TItem, TContext]"),
  _section("sequential fold · fail-fast", hue.ink),
  _methods(
    "items []TItem",
    "initial TContext",
    "processor StepProcessor",
    "→ ChainResult[TContext]",
  ),
)
#let _parallel-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  raw("[TItem, TResult]"),
  _section("worker pool · fail-fast | collect-all", hue.ink),
  _methods(
    "items []TItem",
    "processor TaskProcessor",
    "MaxWorkers · WorkerCap",
    "→ ParallelResult[TItem, TResult]",
  ),
)
#let _conditional-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  raw("[TState]"),
  _section("predicate-routed · optional default", hue.ink),
  _methods(
    "predicate RoutePredicate[TState]",
    "routes Routes[TState]",
    "→ TState",
  ),
)

// Bridge-card bodies — each wraps the pattern function in a FunctionNode satisfying
// state.StateNode.Execute(ctx, State) (State, error). The body lists what the caller
// supplies and what the wrapper returns.
#let _chain-bridge-body = _methods(
  "cfg ChainConfig",
  "items, processor",
  "→ state.StateNode",
)
#let _parallel-bridge-body = _methods(
  "cfg ParallelConfig",
  "items, processor",
  "aggregator(results, state)",
  "→ state.StateNode",
)
#let _conditional-bridge-body = _methods(
  "cfg ConditionalConfig",
  "predicate, routes",
  "→ state.StateNode",
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
// Multi-line label — wraps long phrasing onto two lines so the edge label slot stays
// narrow horizontally. Used for the Hub-composition edges where the wide Hub card eats
// most of the horizontal room.
#let lbl-multi(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text / 2,
  ..lines.pos().map(s => align(center, text(
    size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s,
  ))),
)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 4, tokens.space-between-ranks * 1.2),

  // Row 0 — Hub composition cluster.
  card((0, 0), palette.blue, "Participant", "interface",
    _methods("ID() string"),
  ),
  card((1, 0), palette.blue, "Hub", "interface",
    _hub-body(palette.blue),
  ),
  card((2, 0), palette.blue, "MessageHandler", "func",
    _methods(
      "func(ctx, *Message,",
      "     *MessageContext)",
      "    → (*Message, error)",
    ),
  ),

  // Row 1 — MessageChannel below Hub.
  card((1, 1), palette.blue, "MessageChannel[T]", "buffered channel",
    _channel-body,
  ),

  // Row 3 — workflow patterns (gap row 2 left empty for visual breathing room).
  card((0, 3), palette.blue, "ProcessChain", "func", _chain-body(palette.blue)),
  card((1, 3), palette.blue, "ProcessParallel", "func", _parallel-body(palette.blue)),
  card((2, 3), palette.blue, "ProcessConditional", "func", _conditional-body(palette.blue)),

  // Row 4 — integration wrappers (muted bridge cards).
  bridge-card((0, 4), "ChainNode",       "wrapper → state.StateNode", _chain-bridge-body),
  bridge-card((1, 4), "ParallelNode",    "wrapper → state.StateNode", _parallel-bridge-body),
  bridge-card((2, 4), "ConditionalNode", "wrapper → state.StateNode", _conditional-bridge-body),

  // Row 5.5 — state.StateNode extern (single-shape, native-dep reference per
  // tau-decisions.md; full interface defined in state-graph.typ). The fractional row
  // gives the convergent-edges trunk extra vertical length so the "returns" label and
  // the L-shape inflows have breathing room before they meet the extern.
  extern((1, 5.5), "state.StateNode", name-tag: <state-node>),

  // Hub composition edges. Two-line labels keep the slot narrow horizontally so the
  // wide Hub card doesn't push the label into clipped territory.
  edge((0, 0), (1, 0), "->", lbl-multi("registered via", "Register()"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 0), (1, 0), "->", lbl-multi("registered via", "Register()"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (1, 1), "->", lbl("owns per participant"),
    label-fill: palette.surface, stroke: edge-stroke),

  // Workflow → bridge edges (vertical, per column).
  edge((0, 3), (0, 4), "->", lbl("wrapped by"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 3), (1, 4), "->", lbl("wrapped by"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 3), (2, 4), "->", lbl("wrapped by"),
    label-fill: palette.surface, stroke: edge-stroke),

  // Bridge → state.StateNode convergent edges. Side columns route through a shared rail
  // at row 4.8 (further down than the default mid-gap, so the convergence sits lower in
  // the visual rhythm) before turning into state.StateNode's column at row 5.5 — the
  // three trunk segments overlap so the fan-in reads as one branch from a rail with
  // three leaves, with the "returns" label sitting in the trunk segment below the rail.
  edge((0, 4), (0, 4.8), (1, 4.8), (1, 5.5), "->", stroke: edge-stroke),
  edge((1, 4), (1, 5.5), "->", lbl("returns"),
    label-pos: 0.7, label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 4), (2, 4.8), (1, 4.8), (1, 5.5), "->", stroke: edge-stroke),
)
