// provider/bedrock / specification — EventStreamReader (developer voice).
// The bedrock-specific streaming bridge replaces the shared streaming/SSEReader the other
// sub-modules use, decoding AWS's binary event-stream wire format instead of SSE text. The
// card shows the header dispatch each frame goes through: :message-type discriminates
// exception frames from data frames, and :event-type becomes the JSON envelope key for the
// re-emitted payload. Goroutine plumbing and context-cancellation are implementation detail
// and stay out of this diagram. Binary frame decoding itself lives in the AWS SDK boundary.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

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

#let extern-sdk(pos, name) = node(pos,
  raw(name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes * 4, tokens.space-between-ranks),

  card((0, 0), palette.blue, "EventStreamReader", "frame header dispatch",
    _fields(
      ":message-type == \"exception\"", "→ emit StreamLine{Err: payload}",
      "otherwise (data frame)",         "→ emit StreamLine{Data: {<event-type>: payload}}",
    ),
  ),

  // The aws-sdk-go-v2/aws/protocol/eventstream package owns the binary frame decoder;
  // EventStreamReader iterates Decode() in a goroutine and dispatches on the headers each
  // decoded message exposes.
  extern-sdk((1, 0), "aws-sdk-go-v2/eventstream"),

  edge((0, 0), (1, 0), "->", lbl("decodes frames via"),
    label-fill: palette.surface, stroke: edge-stroke),
)
