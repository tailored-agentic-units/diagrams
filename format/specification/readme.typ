// format / specification — Format interface (developer voice).
// The interface contract: four methods every implementation must satisfy. Method signatures
// reference protocol.Protocol and response.StreamingResponse from the protocol library —
// shown as muted single-shape native-dependency nodes per tau-decisions.md.

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

// External type — muted single-shape reference for types declared in another TAU library.
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

// Method list — each line is a single raw() signature.
#let _methods(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  ..lines.pos().map(s => raw(s)),
)

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  card((1, 0), palette.blue, "Format", "interface",
    _methods(
      "Name() string",
      "Marshal(p protocol.Protocol, data any) ([]byte, error)",
      "Parse(p protocol.Protocol, body []byte) (any, error)",
      "ParseStreamChunk(p protocol.Protocol, data []byte) (*response.StreamingResponse, error)",
    ),
  ),

  extern((0, 1), "protocol.Protocol"),
  extern((2, 1), "response.StreamingResponse"),

  // Orthogonal edges: exit Format from left/right sides, run horizontally to the externals'
  // columns, then turn down into each external's top edge. L-shaped paths, marks on the externals.
  edge((1, 0), (0, 0), (0, 1), "->", lbl("uses"), label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (2, 0), (2, 1), "->", lbl("uses"), label-fill: palette.surface, stroke: edge-stroke),
)
