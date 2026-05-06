// provider/bedrock / specification — endpoint dispatch (developer voice).
// Bedrock's only request-time dispatch lives in URL construction: the three conversational
// protocols share one path template for non-streaming and a different template for streaming;
// embeddings is unsupported. SetHeaders is intentionally absent from this diagram — bedrock
// signs every outbound request with SigV4 unconditionally (no auth_type → header dispatch the
// way ollama and azure have), so the auth story belongs to credentials.typ where the
// construction-time auth_type branching and runtime signing are described together.
// The {modelId} placeholder is extracted from the request body's modelId field — noted as a
// footnote section since it changes how all three rows resolve at call time.

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
#let _section(s, on-hue) = text(
  size: tokens.size-label,
  weight: tokens.weight-light,
  fill: on-hue,
  style: "italic",
  s,
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

#let _endpoint-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _fields(
    "Chat | Vision | Tools (non-streaming)", "→ /model/{modelId}/converse",
    "Chat | Vision | Tools (streaming)",     "→ /model/{modelId}/converse-stream",
    "Embeddings",                            "→ (unsupported — Converse API does not provide embeddings)",
  ),
  v(tokens.gap-cell / 2),
  _section("{modelId} extracted from request body's modelId field", hue.ink),
)

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  card((0, 0), palette.blue, "Endpoint", "protocol → URL path", _endpoint-body(palette.blue)),
)
