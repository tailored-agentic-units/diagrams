// provider / specification — supporting types (developer voice).
// The two TAU-owned structs that orbit the Provider interface: BaseProvider is the helper struct
// concrete impls embed to inherit the identity accessors; Request is the prepared output that
// PrepareRequest and PrepareStreamRequest both produce. Provider itself is shown as a compact
// reference card (full method list lives in readme.typ) so the relationships read clearly without
// duplicating the interface body.

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

// Reference card — title + kind only, no body. Used here for Provider so the interface's
// presence is visible without re-listing its methods (which live in readme.typ).
#let ref-card(pos, hue, type-name, kind-text) = node(pos,
  {
    show raw: r => text(fill: palette.ink, weight: tokens.weight-body, r)
    stack(
      dir: ttb,
      spacing: tokens.gap-structured-text,
      _title(type-name),
      _kind(kind-text, hue.ink),
    )
  },
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks),

  // Vertical stack: BaseProvider on top, Provider (reference) in the middle, Request at the
  // bottom. Each edge is a single vertical segment, leaving the entire right side of the diagram
  // open horizontal space for the relationship labels — no obstructions from neighbouring cards.
  card((0, 0), palette.purple, "BaseProvider", "struct",
    _fields(
      "name", "string",
      "baseURL", "string",
    ),
  ),

  ref-card((0, 1), palette.blue, "Provider", "interface"),

  card((0, 2), palette.purple, "Request", "struct",
    _fields(
      "URL", "string",
      "Headers", "map[string]string",
      "Body", "[]byte",
    ),
  ),

  // BaseProvider's methods flow down into Provider's contract via embedding. Label sits on the
  // right of the vertical edge so the descriptive prose has unobstructed horizontal space.
  edge((0, 0), (0, 1), "->", lbl("embedded — supplies Name() · BaseURL()"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),

  // Provider's two Prepare* methods both return *Request as the prepared HTTP-ready payload.
  edge((0, 1), (0, 2), "->", lbl("Prepare* methods produce *Request"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
)
