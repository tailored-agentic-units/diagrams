// agent / specification — request type family (developer voice).
// The four concrete request types (ChatRequest, VisionRequest, ToolsRequest, EmbeddingsRequest)
// and the Request interface they all satisfy. Each concrete card lists the protocol-specific
// payload fields that distinguish it from its siblings; the four shared dependency fields
// (prov, fmt, mdl, options) are common to every type and live in README prose. All four types
// delegate Marshal() to format.Format, passing a protocol-keyed format data struct
// (&format.ChatData, &format.VisionData, etc.).

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

// Method list — used by the Request interface card.
#let _methods(..lines) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  ..lines.pos().map(s => raw(s)),
)

#diagram(
  spacing: (tokens.space-between-shapes * 1.6, tokens.space-between-ranks * 2.3),

  // Request interface — reference card (blue, matches sibling interface treatment) centered
  // above the four concrete-type implementations. Five method signatures form the contract
  // each concrete type must satisfy.
  card((1.5, 0), palette.blue, "Request", "interface",
    _methods(
      "Protocol() protocol.Protocol",
      "Headers() map[string]string",
      "Marshal() ([]byte, error)",
      "Provider() provider.Provider",
      "Model() *model.Model",
    ),
  ),

  // Four concrete request types (purple, matching format/data-types.typ's helper-type hue
  // since these are protocol-payload carriers). Each card lists only the distinctive fields
  // that vary across the protocol family; the four shared deps (prov, fmt, mdl, options)
  // are common to all and would just visually repeat across cards.
  card((0, 1), palette.purple, "ChatRequest", "chat",
    _fields(
      "messages", "[]protocol.Message",
    ),
  ),
  card((1, 1), palette.purple, "VisionRequest", "vision",
    _fields(
      "messages",      "[]protocol.Message",
      "images",        "[]format.Image",
      "visionOptions", "map[string]any",
    ),
  ),
  card((2, 1), palette.purple, "ToolsRequest", "tools",
    _fields(
      "messages", "[]protocol.Message",
      "tools",    "[]format.ToolDefinition",
    ),
  ),
  card((3, 1), palette.purple, "EmbeddingsRequest", "embeddings",
    _fields(
      "input", "any",
    ),
  ),

  // format.Format — single-shape native-dep reference; the target every Marshal()
  // implementation calls into.
  extern((1.5, 2), "format.Format"),

  // Implements tree — each concrete type traces an L-shape: up from its row 1 position to
  // a shared horizontal rail at row 0.5, along the rail to column 1.5, then up the shared
  // trunk to Request. The trunk segment (1.5, 0.5)→(1.5, 0) and the rail segment between
  // (1.5, 0.5) and each leg's column overlap visually across all four edges, rendering as
  // one tree branching out to four leaves. Only the leftmost edge carries the "implements"
  // label; label-pos:0.95 lands it on the trunk near Request, where the four edges merge.
  edge((0, 1), (0, 0.5), (1.5, 0.5), (1.5, 0), "-->", lbl("implements"), label-pos: 0.8, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 1), (1, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke),
  edge((2, 1), (2, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke),
  edge((3, 1), (3, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke),

  // Marshal-delegates tree — same orthogonal pattern, going down. Each concrete type's
  // Marshal() builds a protocol-keyed format data struct (&format.ChatData, &format.VisionData,
  // &format.ToolsData, &format.EmbeddingsData) and calls format.Marshal(protocol, data).
  // Solid stroke distinguishes this relationship from the dashed implements tree above.
  edge((0, 1), (0, 1.5), (1.5, 1.5), (1.5, 2), "->", lbl("Marshal() delegates to"), label-pos: 0.8, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 1), (1, 1.5), (1.5, 1.5), (1.5, 2), "->", stroke: edge-stroke),
  edge((2, 1), (2, 1.5), (1.5, 1.5), (1.5, 2), "->", stroke: edge-stroke),
  edge((3, 1), (3, 1.5), (1.5, 1.5), (1.5, 2), "->", stroke: edge-stroke),
)
