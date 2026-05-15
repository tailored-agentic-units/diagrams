// orchestrate / operational — runtime composition (operator voice).
// Two long-running runtime entities — Hub and StateGraph — are constructed from JSON-
// deserializable config structs whose `Merge` semantics support layered configuration
// (defaults → loaded). Hub takes a *slog.Logger directly; StateGraph resolves an Observer
// and a CheckpointStore from orchestrate's two global registries at construction time.
// The bottom row shows those registries with their pre-registered values and the
// Register*() extension points operators call to plug in custom implementations.
//
// Layout: config cards at row 0, constructed runtime entities at row 1 directly below
// their owning config, the two registries at row 2 — observability registry between the
// columns (mid-page) since StateGraph is its sole runtime consumer here, checkpoint-store
// registry beneath StateGraph since only state.NewGraph reads it.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Config card — blue, JSON-deserializable input to a constructor. Body is a 2-column
// field grid (name + type or nested value).
#let cfg-card(coord, name, fields) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", "JSON · Merge"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    fields,
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// Runtime card — blue, focal stroke-emphasis. Name + italic role + divider + body.
#let runtime-card(coord, name, role, body) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", role),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    body,
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-emphasis + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// Registry card — blue, named-resolution surface with pre-registered entries + the
// Register*() function operators call to extend.
#let registry-card(coord, name, presets, register-fn) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", "resolves by name"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    presets,
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    raw(register-fn),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// HubConfig field list.
#let hubcfg-fields = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("Name"),              raw("string"),
  raw("ChannelBufferSize"), raw("int"),
  raw("DefaultTimeout"),    raw("Duration"),
  raw("Logger"),            raw("*slog.Logger"),
)

// GraphConfig field list — Checkpoint sub-config flattened inline so the registry-
// resolved name fields (Observer, Checkpoint.Store) read in a single visual scan.
#let graphcfg-fields = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("Name"),                raw("string"),
  raw("Observer"),            raw("string"),
  raw("MaxIterations"),       raw("int"),
  raw("Checkpoint.Store"),    raw("string"),
  raw("Checkpoint.Interval"), raw("int"),
  raw("Checkpoint.Preserve"), raw("bool"),
)

// Hub runtime body — message-loop lifecycle + operator-facing operations.
#let hub-body = stack(dir: ttb, spacing: tokens.gap-structured-text,
  raw("messageLoop() ↻ goroutine"),
  raw("Shutdown(timeout)"),
  raw("Metrics() → MetricsSnapshot"),
  text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
    "LocalAgents · MessagesSent · MessagesRecv"),
)

// StateGraph runtime body — registry resolutions performed at construction.
#let state-body = stack(dir: ttb, spacing: tokens.gap-structured-text,
  text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
    "resolves at construction"),
  raw("Observer ← cfg.Observer"),
  raw("CheckpointStore ← cfg.Checkpoint.Store"),
  text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic",
    "executes nodes with checkpoint + resume"),
)

// Observer registry pre-registered entries.
#let obs-presets = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("\"noop\""), raw("NoOpObserver"),
  raw("\"slog\""), raw("SlogObserver"),
)

// Checkpoint-store registry pre-registered entries.
#let ckpt-presets = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("\"memory\""), raw("memoryCheckpointStore"),
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks * 1.3),

  cfg-card((0, 0), "HubConfig",   hubcfg-fields),
  cfg-card((2, 0), "GraphConfig", graphcfg-fields),

  runtime-card((0, 1), "Hub",        "long-lived broker",   hub-body),
  runtime-card((2, 1), "StateGraph", "long-lived executor", state-body),

  registry-card((1, 2), "observability registry",
    obs-presets,
    "RegisterObserver(name, Observer)"),
  registry-card((2, 2), "state checkpoint-store registry",
    ckpt-presets,
    "RegisterCheckpointStore(name, CheckpointStore)"),

  // Construction edges (config → runtime). Vertical, one per column.
  edge((0, 0), (0, 1), "->", lbl("hub.New(ctx, cfg)"),
    label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 0), (2, 1), "->", lbl("state.NewGraph(cfg)"),
    label-fill: palette.surface, stroke: edge-stroke),

  // Registry resolutions from StateGraph (only consumer here). GetObserver routes as an
  // L: west across row 1 (through the gap between Hub and StateGraph) then south into
  // the observability registry; its label lands on the horizontal segment, well clear of
  // the GetCheckpointStore label which sits on the vertical edge below StateGraph.
  edge((2, 1), (1, 1), (1, 2), "->", lbl("GetObserver(cfg.Observer)"),
    label-pos: 0.3, label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 1), (2, 2), "->", lbl("GetCheckpointStore(cfg.Checkpoint.Store)"),
    label-fill: palette.surface, stroke: edge-stroke),
)
