// format/openai / specification — method dispatch (developer voice).
// Each card shows one of Format's three interface methods as a protocol-keyed dispatch table:
// the case discriminator on the left, the per-protocol implementation on the right. Parse
// coalesces Chat + Vision onto a single parseChat path; ParseStreamChunk supports streaming
// for non-Embeddings protocols and errors hard on Embeddings.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card primitives — same shared pattern as parent format/specification cards.
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

  // Marshal — four unique dispatch paths, one per protocol.
  card((0, 0), palette.blue, "Marshal", "method dispatch",
    _fields(
      "Chat",       "→ marshalChat",
      "Vision",     "→ marshalVision",
      "Tools",      "→ marshalTools",
      "Embeddings", "→ marshalEmbeddings",
    ),
  ),

  // Parse — Chat and Vision share parseChat (OpenAI returns the same response shape for both).
  card((1, 0), palette.blue, "Parse", "method dispatch",
    _fields(
      "Chat | Vision", "→ parseChat",
      "Tools",         "→ parseTools",
      "Embeddings",    "→ parseEmbeddings",
    ),
  ),

  // ParseStreamChunk — streaming shape shared across non-Embeddings protocols; Embeddings errors.
  card((2, 0), palette.blue, "ParseStreamChunk", "method dispatch",
    _fields(
      "Chat | Vision | Tools", "→ streamChunk shape",
      "Embeddings",            "→ error (no streaming)",
    ),
  ),
)
