// provider/azure / specification — AzureTokenSource (developer voice).
// AzureTokenSource is the thin wrapper around Azure SDK's ManagedIdentityCredential. The card
// captures both lifecycle moments: construction selects between system-assigned and
// user-assigned managed identity based on whether client_id is present in options; the runtime
// GetToken call delegates to azcore.TokenCredential.GetToken with a default cognitiveservices
// scope. The dashed external node represents the Azure SDK boundary — token caching and
// expiry refresh happen inside the SDK, not in this type.

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

// External SDK boundary — dashed, muted neutral; signals "outside TAU's source tree" the same
// way external service nodes do in core diagrams.
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

#let _token-source-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("construction — identity selection", hue.ink),
  _fields(
    "client_id present", "→ user-assigned (ID = ClientID)",
    "client_id absent",  "→ system-assigned",
  ),
  v(tokens.gap-cell / 2),
  _section("runtime — GetToken(ctx) (string, error)", hue.ink),
  _fields(
    "delegates to", "azcore.TokenCredential.GetToken",
    "default scope", "\"https://cognitiveservices.azure.com/.default\"",
  ),
)

#diagram(
  // Wide column spacing — the edge between AzureTokenSource and the SDK boundary needs enough
  // length for "delegates to" to ride the segment without overlapping either shape.
  spacing: (tokens.space-between-shapes * 4, tokens.space-between-ranks),

  card((0, 0), palette.blue, "AzureTokenSource", "struct", _token-source-body(palette.blue)),

  // azcore.TokenCredential is the Azure SDK interface AzureTokenSource holds and delegates to.
  // Token caching and expiry refresh are handled inside this SDK boundary, not in our wrapper.
  extern-sdk((1, 0), "azcore.TokenCredential"),

  edge((0, 0), (1, 0), "->", lbl("delegates to"),
    label-fill: palette.surface, stroke: edge-stroke),
)
