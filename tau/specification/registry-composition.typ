// tau / specification / registry-composition — Registry.Get's cross-library
// convergence (developer voice). Where the per-library agent registry diagram
// emphasises agent.Registry's internal state and cache mechanics, this
// capstone view focuses on the cross-package construction path: how
// Get(name) reads a stored AgentConfig, fans out to provider.Create and
// format.Create for the two resolvable dependencies, and converges at
// agent.New to mint the composed Agent value with its concrete fields.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Function-call card — blue, with package qualifier above and the function
// signature in raw monospace below.
#let call-card(coord, pkg, sig, emphasized: false) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", pkg),
    raw(sig),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: (if emphasized { tokens.stroke-emphasis } else { tokens.stroke-default })
    + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Stored-config card — the AgentConfig value Get reads from configs[name].
// Rendered muted (palette.surface-muted, thin border) because it's passive
// state, not a call.
#let cfg-card(coord) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
      style: "italic", "stored value"),
    raw("AgentConfig"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.border),
    align(left, grid(
      columns: 2,
      column-gutter: tokens.gap-cell,
      row-gutter: tokens.gap-structured-text,
      raw("Provider"), raw("config.ProviderConfig"),
      raw("Format"),   raw("string"),
      raw("Model"),    raw("config.ModelConfig"),
      raw("Client"),   raw("config.ClientConfig"),
    )),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// agent.New card — emphasized convergence node. Shows the constructor
// signature in the header and the composed Agent value's fields in the body,
// so the diagram tells the reader exactly what falls out of the call.
#let agent-new-card(coord) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", "agent"),
    raw("New(cfg, p, f) Agent"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", "constructed Agent fields"),
    align(left, grid(
      columns: 2,
      column-gutter: tokens.gap-cell,
      row-gutter: tokens.gap-structured-text,
      raw("id"),       raw("uuid.NewV7()"),
      raw("client"),   raw("client.New(cfg.Client)"),
      raw("provider"), raw("p"),
      raw("fmt"),      raw("f"),
      raw("model"),    raw("model.New(cfg.Model)"),
    )),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-emphasis + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 1.4, tokens.space-between-ranks * 1.3),

  // Row 0: entry point — Get is the only public method that performs the
  // construction path. Emphasized stroke marks it as the focal call.
  call-card((2, 0), "agent.Registry", "Get(name) (Agent, error)", emphasized: true),

  // Row 1: the AgentConfig value Get reads from its configs map.
  cfg-card((2, 1)),

  // Row 2: two parallel cross-library Create calls. Each consults its
  // package's global registry (covered in operational/readme) and returns
  // a constructed instance of its interface type.
  call-card((1, 2), "provider", "Create(cfg.Provider) Provider"),
  call-card((3, 2), "format", "Create(cfg.Format) Format"),

  // Row 3: convergence at agent.New. cfg flows in vertically; p and f flow
  // in from the diagonals.
  agent-new-card((2, 3)),

  // Edges. AgentConfig is read at the top; the two Create calls fan out
  // horizontally; the resolved Provider + Format converge with the original
  // cfg at agent.New. All labels on the same side (left) per the spec-tier
  // convention established in readme.typ.
  edge((2, 0), (2, 1), "->", lbl("reads configs[name]"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 1), (1, 2), "->", lbl("Create(cfg.Provider)"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 1), (3, 2), "->", lbl("Create(cfg.Format)"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 2), (2, 3), "->", lbl("p"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((3, 2), (2, 3), "->", lbl("f"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
  // cfg flows straight down between the two fanning diagonals — label
  // overlays the edge (label-side: center) since both image-sides are
  // already occupied by the Create() labels on the diagonals.
  edge((2, 1), (2, 3), "->", lbl("cfg (passed through)"),
    label-side: center, label-fill: palette.surface, stroke: edge-stroke),
)
