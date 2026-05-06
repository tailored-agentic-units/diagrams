// provider/ollama / specification — method dispatch (developer voice).
// Two cards capture the dispatch behavior unique to OllamaProvider: Endpoint maps each
// supported protocol to an OpenAI-compatible URL path, coalescing Chat / Vision / Tools onto
// a single conversational path; SetHeaders is a conditional no-op that injects either a bearer
// token or an API-key header when both auth_type and token are present in options. The
// remaining Provider methods (Stream, PrepareRequest, PrepareStreamRequest) follow the parent
// interface specification and don't carry sub-module-specific dispatch worth diagramming.

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

  // Endpoint — three conversational protocols share /chat/completions; embeddings is its own path.
  card((0, 0), palette.blue, "Endpoint", "protocol → URL path",
    _fields(
      "Chat | Vision | Tools", "→ /chat/completions",
      "Embeddings",            "→ /embeddings",
    ),
  ),

  // SetHeaders — auth_type-keyed branching; injects nothing when auth options are absent.
  card((1, 0), palette.blue, "SetHeaders", "auth_type → header",
    _fields(
      "bearer",  "→ Authorization: Bearer <token>",
      "api_key", "→ <auth_header | X-API-Key>: <token>",
      "(absent)", "→ no-op",
    ),
  ),
)
