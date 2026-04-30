// format/converse / specification — method dispatch (developer voice).
// Three dispatch tables for Format's interface methods. Departures from format/openai:
// Marshal has only three protocol paths (no Embeddings); Parse coalesces all three onto
// a single parseResponse (Converse returns the same response shape for every supported
// protocol); ParseStreamChunk is event-shape-keyed rather than protocol-keyed — it ignores
// the protocol argument and dispatches on which optional field of streamEvent is non-nil.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
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

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  // Marshal — three unique dispatch paths. Embeddings errors hard.
  card((0, 0), palette.blue, "Marshal", "method dispatch",
    _fields(
      "Chat",       "→ marshalChat",
      "Vision",     "→ marshalVision",
      "Tools",      "→ marshalTools",
      "Embeddings", "→ error (not supported)",
    ),
  ),

  // Parse — every supported protocol lands on parseResponse; Bedrock Converse returns
  // the same output.message.content shape for Chat, Vision, and Tools alike.
  card((1, 0), palette.blue, "Parse", "method dispatch",
    _fields(
      "Chat | Vision | Tools", "→ parseResponse",
      "Embeddings",            "→ error (not supported)",
    ),
  ),

  // ParseStreamChunk — event-shape-keyed. Ignores the protocol argument; dispatches
  // on which optional field of streamEvent is non-nil.
  card((2, 0), palette.blue, "ParseStreamChunk", "event-shape dispatch",
    _fields(
      "contentBlockDelta", "→ TextBlock",
      "messageStop",       "→ StopReason",
      "(unknown event)",   "→ nil, nil (silent skip)",
    ),
  ),
)
