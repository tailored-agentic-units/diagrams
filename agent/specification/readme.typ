// agent / specification — Agent interface (developer voice).
// The interface contract: eleven methods grouped into five accessors (surface the agent's ID
// and its injected dependencies, supplied by New() at construction) and six protocol methods
// (the request lifecycle — Chat / Vision / Tools / Embed plus streaming variants of Chat and
// Vision). Method signatures cross into protocol.Message (the messages every call carries)
// and three response types (response.Response / StreamingResponse / EmbeddingsResponse —
// the three output shapes); both rendered as muted single-shape native-dep references per
// tau-decisions.md. The constructor New is rendered above the Agent card as a muted input
// node with a "constructs" edge — the Agent interface's only entry point.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card primitives — match the provider/specification/readme.typ inventory so multi-section
// cards, externs, and labels read consistently across the suite.
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

// Native-dep — muted single-shape reference for types declared in another TAU library.
#let extern(pos, name) = node(pos,
  raw(name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Native-dep multi-line — muted box listing several related type names from the same
// package. Used here to group the three response output shapes into one shape so the right
// side of the diagram stays compact instead of carrying three near-identical boxes.
#let extern-multi(pos, ..names) = node(pos,
  align(left, stack(dir: ttb, spacing: tokens.gap-structured-text,
    ..names.pos().map(s => raw(s)),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Constructor card — muted, smaller; sits above the Agent interface card with a "constructs"
// edge. Lists the three injected dependencies as fields; the kind line carries the return
// type ("constructor → Agent") so the card communicates input + output without an extra row.
#let constructor-card(pos) = node(pos,
  {
    show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _title("New"),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
        style: "italic", "(constructor → Agent)"),
      line(length: 100%, stroke: tokens.stroke-thin + palette.border),
      _fields(
        "cfg",      "*config.AgentConfig",
        "provider", "provider.Provider",
        "format",   "format.Format",
      ),
    )
  },
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

// Method list helper — each line is a single raw() signature. Signatures are rendered in
// doc.go's abbreviated form (parameter names without explicit types) — full type signatures
// live in the source.
#let _methods(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  ..lines.pos().map(s => raw(s)),
)

// Agent interface body — two grouped sections separated by extra vertical whitespace.
// Section labels are italic-light blue.ink so they read as commentary subordinate to the
// card title, consistent with the multi-section card body pattern documented in the
// labels-and-encapsulation skill.
#let _agent-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("accessors — ID and injected dependencies", hue.ink),
  _methods(
    "ID() string",
    "Client() client.Client",
    "Provider() provider.Provider",
    "Format() format.Format",
    "Model() *model.Model",
  ),
  v(tokens.gap-cell / 2),
  _section("protocol — request lifecycle", hue.ink),
  _methods(
    "Chat(ctx, messages, opts...) (*response.Response, error)",
    "ChatStream(ctx, messages, opts...) (<-chan *response.StreamingResponse, error)",
    "Vision(ctx, messages, images, opts...) (*response.Response, error)",
    "VisionStream(ctx, messages, images, opts...) (<-chan *response.StreamingResponse, error)",
    "Tools(ctx, messages, tools, opts...) (*response.Response, error)",
    "Embed(ctx, input, opts...) (*response.EmbeddingsResponse, error)",
  ),
)

#diagram(
  spacing: (tokens.space-between-shapes * 2.2, tokens.space-between-ranks * 1.25),

  // Constructor — muted card above Agent. Solid "constructs" edge anchors the only
  // construction path (no factory function or registry-side path here; that lives in
  // registry.typ).
  constructor-card((1, 0)),

  // Agent interface — focal, multi-section body. Blue hue matches the interface treatment
  // in protocol / format / provider specification cards.
  card((1, 1), palette.blue, "Agent", "interface", _agent-body(palette.blue)),

  // Native-dep references. protocol.Message on the left as the cross-library input every
  // protocol method carries; the response group on the right as the three output shapes
  // returned by the protocol methods (channel-wrapped for the streaming variants).
  extern((0, 1), "protocol.Message"),
  extern-multi((2, 1),
    "response.Response",
    "response.StreamingResponse",
    "response.EmbeddingsResponse",
  ),

  // Edges. Vertical "constructs" from Constructor to Agent; horizontal "uses" from
  // protocol.Message into Agent (mirrors format/specification and provider/specification);
  // horizontal "returns" from Agent to the response group.
  edge((1, 0), (1, 1), "->", lbl("constructs"), label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 1), (1, 1), "->", lbl("uses"), label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 1), (2, 1), "->", lbl("returns"), label-fill: palette.surface, stroke: edge-stroke),
)
