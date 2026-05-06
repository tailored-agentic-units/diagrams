// provider/bedrock / specification — AWSCredentialSource (developer voice).
// Both lifecycle moments captured in one card: construction selects a credentials provider
// from one of three auth_type branches (default chain, static keys, named profile); runtime
// SignRequest performs three sequential steps — hash body, retrieve credentials, sign with
// SigV4 — then delegates the actual signing to the AWS SDK boundary. The dashed external node
// represents the SDK; credential caching, refresh, and the SigV4 algorithm itself live there.

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

#let _credentials-body(hue) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  _section("construction — auth_type dispatch", hue.ink),
  _fields(
    "default | (empty)", "→ config.LoadDefaultConfig",
    "static",            "→ credentials.NewStaticCredentialsProvider",
    "profile",           "→ config.LoadDefaultConfig + WithSharedConfigProfile",
  ),
  v(tokens.gap-cell / 2),
  _section("runtime — SignRequest(ctx, req, service)", hue.ink),
  _fields(
    "1.", "hash request body (SHA-256)",
    "2.", "retrieve credentials",
    "3.", "delegate to v4.Signer.SignHTTP",
  ),
)

#diagram(
  // Wide column spacing so the "delegates to" edge has room for its label clear of either shape.
  spacing: (tokens.space-between-shapes * 4, tokens.space-between-ranks),

  card((0, 0), palette.blue, "AWSCredentialSource", "struct", _credentials-body(palette.blue)),

  // aws-sdk-go-v2 owns the credential providers, the v4 signer, and credential caching/refresh.
  // AWSCredentialSource is a thin wrapper that selects the provider and orchestrates the call.
  extern-sdk((1, 0), "aws-sdk-go-v2"),

  edge((0, 0), (1, 0), "->", lbl("delegates to"),
    label-fill: palette.surface, stroke: edge-stroke),
)
