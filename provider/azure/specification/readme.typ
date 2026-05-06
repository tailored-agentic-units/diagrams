// provider/azure / specification — method dispatch (developer voice).
// Two cards capture the dispatch behavior unique to AzureProvider: Endpoint maps each supported
// protocol to a deployment-keyed URL path with an api-version query parameter; SetHeaders
// branches across three real auth modes — api-key, static bearer, and dynamic managed identity
// (which acquires a token from AzureTokenSource at request time, see token-source.typ).

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

  // Endpoint — three conversational protocols share /chat/completions; embeddings is its own
  // path. The full URL each row produces is `{BaseURL}<path>?api-version=<version>`; the
  // api-version query parameter is part of every URL Endpoint constructs, kept inline in the
  // dispatch values so the row data tells the whole truth.
  card((0, 0), palette.blue, "Endpoint", "protocol → URL path",
    _fields(
      "Chat | Vision | Tools", "→ /deployments/{deployment}/chat/completions?api-version={version}",
      "Embeddings",            "→ /deployments/{deployment}/embeddings?api-version={version}",
    ),
  ),

  // SetHeaders — three real auth branches; static-token branches read from options at
  // construction; managed_identity calls AzureTokenSource.GetToken at request time.
  card((1, 0), palette.blue, "SetHeaders", "auth_type → header",
    _fields(
      "api_key",          "→ api-key: <token>",
      "bearer",           "→ Authorization: Bearer <static token>",
      "managed_identity", "→ Authorization: Bearer <SDK-acquired token>",
    ),
  ),
)
