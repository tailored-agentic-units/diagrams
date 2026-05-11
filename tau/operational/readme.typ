// tau / operational — runtime composition (operator voice).
// Three-row narrative:
//   Row 0: provider sub-modules (ollama, azure, bedrock) and format sub-modules
//          (openai, converse). Each writes a factory into the corresponding global
//          registry via its Register() function call — opt-in imports at startup time.
//   Row 1: provider.registry and format.registry singletons hold the registered
//          factories, keyed by name.
//   Rows 2-4: agent.Registry.Get(name) resolves provider and format from those
//          registries via Create() (a runtime read), then calls agent.New(cfg, p, f)
//          to materialize an Agent on first request. The constructed Agent's HTTP
//          client carries the retry policy (MaxRetries, InitialBackoff, MaxBackoff,
//          Jitter) — the operator's primary tuning surface.
//
// Phase split is encoded in edge labels: Register() is the startup-time write;
// Create() is the runtime read. The registries bridge the two phases as persistent
// state.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Sub-module card — small blue card with name + Register() annotation. Each is
// opt-in: the application must import the package and invoke its Register() at
// startup to populate the corresponding global registry.
#let submod(coord, name, pkg) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    raw(pkg + ".Register()"),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Registry singleton — blue card, focal, named with its package qualifier.
#let reg(coord, name) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", "factories by name"),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// agent.Registry — central runtime consumer, emphasized stroke. Reads both global
// registries via Create() on first Get(), caches the resolved Agent.
#let agent-registry = node((2, 2.4),
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "agent.Registry"),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
      "lazy instantiation"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    raw("Get(name)"),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-emphasis + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// agent.New constructor — runtime construction step on first Get(name); cached after.
#let agent-new = node((2, 3.6),
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    raw("agent.New(cfg, p, f)"),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
      "constructor"),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Constructed Agent with retry-config field list — operator's primary tuning surface.
#let retry-knobs = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("MaxRetries"),     raw("int"),
  raw("InitialBackoff"), raw("Duration"),
  raw("MaxBackoff"),     raw("Duration"),
  raw("Jitter"),         raw("bool"),
)
#let agent-instance = node((2, 4.8),
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "Agent"),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
      "with client.RetryConfig"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    retry-knobs,
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 1.3, tokens.space-between-ranks),

  submod((0, 0), "ollama",   "ollama"),
  submod((1, 0), "azure",    "azure"),
  submod((2, 0), "bedrock",  "bedrock"),
  submod((3, 0), "openai",   "openai"),
  submod((4, 0), "converse", "converse"),

  reg((1, 1.4), "provider.registry"),
  reg((3, 1.4), "format.registry"),

  agent-registry,
  agent-new,
  agent-instance,

  // Provider sub-modules → provider.registry. Convergent-edges tree: ollama and
  // bedrock route through a shared rail at row 0.5 before turning down the trunk
  // into provider.registry's column; azure drops straight down the trunk. The
  // three trunk segments overlap pixel-for-pixel, reading as one branch from a
  // rail with three leaves.
  edge((0, 0), (0, 0.5), (1, 0.5), (1, 1.4), "->", stroke: edge-stroke),
  edge((1, 0), (1, 1.4), "->", lbl("Register()  · startup"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 0), (2, 0.5), (1, 0.5), (1, 1.4), "->", stroke: edge-stroke),

  // Format sub-modules → format.registry. Same convergent-edges tree shape.
  edge((3, 0), (3, 1.4), "->", lbl("Register()  · startup"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((4, 0), (4, 0.5), (3, 0.5), (3, 1.4), "->", stroke: edge-stroke),

  // Registries → agent.Registry. Create() reads the registered factory at
  // runtime, invokes it with the AgentConfig's provider/format spec to
  // materialize an instance. L-shapes route each registry's edge down then
  // inward to agent.Registry's column. Both edges carry the same label
  // symmetrically since neither shares a trunk with the other.
  edge((1, 1.4), (1, 2.4), (2, 2.4), "->", lbl("Create()  · runtime"),
    label-fill: palette.surface, stroke: edge-stroke),
  // Provider's label auto-resolves to label-side: right, which for the south-
  // travelling first segment places the label WEST of the corner — the open
  // quadrant outside the L's angle. The format edge's first segment is also
  // south-travelling, so the same auto-resolution would also push WEST —
  // toward agent.Registry. Override to label-side: left so the label moves
  // EAST instead, into the open quadrant outside *this* L's angle.
  edge((3, 1.4), (3, 2.4), (2, 2.4), "->", lbl("Create()  · runtime"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),

  // agent.Registry → agent.New → Agent. Construction is the last step of
  // Get(name); subsequent Get(name) calls return the cached Agent without
  // re-running this path.
  edge((2, 2.4), (2, 3.6), "->", stroke: edge-stroke),
  edge((2, 3.6), (2, 4.8), "->", lbl("returns"),
    label-fill: palette.surface, stroke: edge-stroke),
)
