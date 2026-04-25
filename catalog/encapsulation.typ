// ==============================================================
// Encapsulation prototype — a container holds named internal nodes
// that are reachable by edges originating outside the container.
// Validates the pattern library-overview diagrams need when they
// show an outer caller addressing an inner component directly.
// ==============================================================

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette

#set page(
  width:  780pt,
  height: auto,
  margin: tokens.pad-inside-container,
  fill:   palette.surface,
)
#set text(
  font: tokens.font,
  size: tokens.size-body,
  fill: palette.ink,
)

// Inline code (raw) gets a hue tint to differentiate from prose under the
// single-font constraint. Pick whichever hue harmonises with the diagram.
#show raw: r => text(fill: palette.purple.stroke, r)

// Catalog-local element closures.
// `on-hue` carries the hue's ink so kind-labels keep chromatic contrast on a
// tinted fill — neutral ink-muted reads weak over coloured backgrounds.

#let _title(name) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name)
#let _kind(k, on-hue: palette.ink-muted) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + k + ")")

#let compute(pos, name, name-label) = node(pos,
  stack(dir: ttb, spacing: tokens.gap-structured-text, _title(name), _kind("compute", on-hue: palette.blue.ink)),
  name: name-label,
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let persistence(pos, name, name-label) = node(pos,
  stack(dir: ttb, spacing: tokens.gap-structured-text, _title(name), _kind("persistence", on-hue: palette.blue.ink)),
  name: name-label,
  shape: fletcher.shapes.cylinder,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
)

#let human(pos, name, name-label) = node(pos,
  stack(dir: ttb, spacing: tokens.gap-structured-text, _title(name), _kind("human", on-hue: palette.orange.ink)),
  name: name-label,
  shape: fletcher.shapes.pill,
  fill: palette.orange.fill,
  stroke: tokens.stroke-default + palette.orange.stroke,
  inset: tokens.pad-inside-shape,
)

// Container: a Fletcher enclose-node that wraps named inner nodes. Rendered
// as a rect behind the inner content with a caption at the top-left.
#let runtime-container(label, inner-names) = node(
  enclose: inner-names,
  align(top + left, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(label))),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-container,
  corner-radius: tokens.radius-container,
  snap: -1,
)

// Inline edge closures — query = solid green, event = dashed yellow.
// Labels render via Fletcher's native label-fill so the background matches
// the page surface in either theme; no custom box wrapper.
#let _edge-label(label) = if label != none {
  text(size: tokens.label-size, weight: tokens.weight-bold, fill: palette.ink, label)
} else { none }

// `label-pos` parameter lets each call anchor the label near a specific
// endpoint (0.0 = source-side, 1.0 = destination-side, 0.5 = midpoint).
// Useful when a midpoint label collides with a shape boundary.
#let query-edge(from, to, label: none, label-pos: 0.5) = edge(from, to, "->",
  stroke: (paint: palette.green.stroke, thickness: tokens.stroke-default),
  _edge-label(label), label-side: left, label-sep: tokens.label-sep, label-pos: label-pos,
  label-fill: palette.surface,
)

#let event-edge(from, to, label: none, label-pos: 0.5) = edge(from, to, "->",
  stroke: (paint: palette.yellow.stroke, thickness: tokens.stroke-default, dash: "dashed"),
  _edge-label(label), label-side: left, label-sep: tokens.label-sep, label-pos: label-pos,
  label-fill: palette.surface,
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Encapsulation — named inner nodes addressable across a container boundary"),
)

#v(tokens.gap-structured-text)

#align(center,
  text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
    "External caller edges directly to an inner node; inner node edges out to external persistence. Boundary is structural, not just visual."),
)

#v(tokens.space-between-ranks)

// ---- primary diagram -------------------------------------------------------

#align(center,
  diagram(
    spacing: (tokens.space-between-shapes * 1.4, tokens.space-between-ranks),

    // External caller
    human((0, 1), "client", <client>),

    // Inner nodes of the runtime container
    compute((2, 0), "api",    <api>),
    compute((2, 1), "worker", <worker>),
    compute((2, 2), "cache",  <cache>),

    // Container drawn around the 3 inner compute nodes
    runtime-container("runtime", (<api>, <worker>, <cache>)),

    // External persistence on the right
    persistence((4, 1), "store", <store>),

    // Cross-boundary edges: outside → inside, inside → outside, inside ↔ inside
    query-edge(<client>, <api>,    label: [request]),
    query-edge(<api>,    <worker>, label: [enqueue]),
    query-edge(<worker>, <cache>,  label: [lookup]),
    event-edge(<worker>, <store>,  label: [persist]),
  )
)

#v(tokens.space-between-ranks)

// ---- caption ---------------------------------------------------------------

#align(center,
  box(width: 640pt,
    text(size: tokens.size-caption, fill: palette.ink,
      [The container is a fletcher #raw("node(enclose: …)") referencing the inner nodes' `<labels>`. Inner
      nodes stay addressable as `<api>`, `<worker>`, `<cache>` from anywhere in the diagram — the
      container is a background rectangle, not a coordinate scope.]),
  )
)
