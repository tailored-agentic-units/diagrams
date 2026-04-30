// format / specification — input data types (developer voice).
// The four protocol-keyed input structs that flow into Format.Marshal as the `data any`
// parameter, plus the two compositional helper types embedded inside them. Each card
// shows its field list; field types use raw() for code-style identity.

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

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks),

  // Top row — the four protocol-keyed input types passed to Format.Marshal as `data any`.
  card((0, 0), palette.blue, "ChatData", "chat input",
    _fields(
      "Model", "string",
      "Messages", "[]protocol.Message",
      "Options", "map[string]any",
    ),
  ),
  card((1, 0), palette.blue, "VisionData", "vision input",
    _fields(
      "Model", "string",
      "Messages", "[]protocol.Message",
      "Images", "[]Image",
      "VisionOptions", "map[string]any",
      "Options", "map[string]any",
    ),
  ),
  card((2, 0), palette.blue, "ToolsData", "tools input",
    _fields(
      "Model", "string",
      "Messages", "[]protocol.Message",
      "Tools", "[]ToolDefinition",
      "Options", "map[string]any",
    ),
  ),
  card((3, 0), palette.blue, "EmbeddingsData", "embeddings input",
    _fields(
      "Model", "string",
      "Input", "any",
      "Options", "map[string]any",
    ),
  ),

  // Bottom row — compositional helper types embedded as fields in the parents above.
  card((1, 1), palette.purple, "Image", "vision attachment",
    _fields(
      "Data", "[]byte",
      "Format", "string",
      "URL", "string",
    ),
  ),
  card((2, 1), palette.purple, "ToolDefinition", "tool descriptor",
    _fields(
      "Name", "string",
      "Description", "string",
      "Parameters", "map[string]any",
    ),
  ),

  edge((1, 0), (1, 1), "->", lbl("composes"), label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 0), (2, 1), "->", lbl("composes"), label-fill: palette.surface, stroke: edge-stroke),
)
