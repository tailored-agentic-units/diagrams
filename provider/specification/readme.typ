// provider / specification — Provider interface (developer voice).
// The interface contract: seven methods grouped into identity accessors (supplied by embedding
// BaseProvider) and transport methods (each implementation provides). Method signatures cross
// into protocol.Protocol and protostreaming.StreamReader from the protocol library — shown as
// muted single-shape native-dep nodes per tau-decisions.md. The supporting struct types
// (BaseProvider, Request) are deferred to types.typ so the interface card can breathe.

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

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

// Method list helper — each line is a single raw() signature.
#let _methods(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  ..lines.pos().map(s => raw(s)),
)

// Provider interface body — two grouped sections separated by extra spacing. Section labels
// use italic-light hue ink to read as commentary on the methods below them.
#let _provider-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("identity — supplied by BaseProvider embedding", hue.ink),
  _methods(
    "Name() string",
    "BaseURL() string",
  ),
  v(tokens.gap-cell / 2),
  _section("transport — implementation provides", hue.ink),
  _methods(
    "Endpoint(p protocol.Protocol) (string, error)",
    "Stream() protostreaming.StreamReader",
    "SetHeaders(ctx context.Context, req *http.Request) error",
    "PrepareRequest(ctx context.Context, p protocol.Protocol, body []byte, headers map[string]string) (*Request, error)",
    "PrepareStreamRequest(ctx context.Context, p protocol.Protocol, body []byte, headers map[string]string) (*Request, error)",
  ),
)

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  card((1, 0), palette.blue, "Provider", "interface", _provider-body(palette.blue)),

  extern((0, 1), "protocol.Protocol"),
  extern((2, 1), "protostreaming.StreamReader"),

  // Orthogonal edges: exit Provider from left/right sides, run horizontally to the externals'
  // columns, then turn down into each external's top edge. Mirrors format/specification/readme.typ.
  edge((1, 0), (0, 0), (0, 1), "->", lbl("uses"), label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (2, 0), (2, 1), "->", lbl("Stream() returns"), label-fill: palette.surface, stroke: edge-stroke),
)
