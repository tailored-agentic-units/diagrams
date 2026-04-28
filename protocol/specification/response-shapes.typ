#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Card sub-elements.
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(
  size: tokens.size-label,
  weight: tokens.weight-light,
  fill: on-hue,
  style: "italic",
  "(" + s + ")",
)

// Multi-row field grid — every (name, type) pair shares the same two columns,
// so types line up vertically across rows even when names differ in length.
#let _fields(..items) = grid(
  columns: (auto, auto),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  ..items.pos().map(s => raw(s)),
)

// Card body — title + kind centered (label-card identity), divider full-width,
// body grid left-anchored so field columns share a clean left edge.
// The scoped `show raw` override switches code text to the global neutral
// (palette.ink) for max contrast on hue-filled card backgrounds; only the
// kind label retains the hue accent as a small italic category badge.
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

#let edge-stroke = tokens.stroke-default + palette.ink-muted
#let uses-label = text(
  size: tokens.label-size,
  weight: tokens.weight-light,
  fill: palette.ink-muted,
  style: "italic",
  "uses",
)

#diagram(
  spacing: (tokens.space-between-shapes * 1.5, tokens.space-between-ranks),

  // ContentBlock — sealed interface (top, centered above the response row).
  card((1, 0), palette.purple, "ContentBlock", "sealed interface",
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      raw("TextBlock"),
      raw("ToolUseBlock"),
    ),
  ),

  // Three response variants (bottom row).
  // Response and StreamingResponse share the ContentBlock discriminator (blue).
  // EmbeddingsResponse is structurally separate (green) — no link to ContentBlock.

  card((0, 1), palette.blue, "Response", "completed output",
    _fields("Content", "[]ContentBlock"),
  ),

  card((1, 1), palette.blue, "StreamingResponse", "in-flight output",
    _fields(
      "Content", "[]ContentBlock",
      "Error", "error",
    ),
  ),

  card((2, 1), palette.green, "EmbeddingsResponse", "separate output kind",
    _fields("Embeddings", "[][]float64"),
  ),

  // Response and StreamingResponse use ContentBlock; EmbeddingsResponse deliberately doesn't.
  edge((0, 1), (1, 0), "->", uses-label, stroke: edge-stroke),
  edge((1, 1), (1, 0), "->", uses-label, stroke: edge-stroke),
)
