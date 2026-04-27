#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue: palette.ink-muted) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

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

#let _edge-label(label) = if label != none {
  text(size: tokens.label-size, weight: tokens.weight-bold, fill: palette.ink, label)
} else { none }

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

#diagram(
  spacing: (tokens.space-between-shapes * 1.4, tokens.space-between-ranks),

  human((0, 1), "client", <client>),

  compute((2, 0), "api",    <api>),
  compute((2, 1), "worker", <worker>),
  compute((2, 2), "cache",  <cache>),

  runtime-container("runtime", (<api>, <worker>, <cache>)),

  persistence((4, 1), "store", <store>),

  query-edge(<client>, <api>,    label: [request]),
  query-edge(<api>,    <worker>, label: [enqueue]),
  query-edge(<worker>, <cache>,  label: [lookup]),
  event-edge(<worker>, <store>,  label: [persist]),
)
