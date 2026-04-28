#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Level label — text only, right-aligned at the leftmost column.
#let level-label(content, row) = node((0, row),
  align(right, text(
    size: tokens.size-caption,
    weight: tokens.weight-light,
    fill: palette.ink-muted,
    style: "italic",
    content,
  )),
  shape: fletcher.shapes.rect,
  fill: none,
  stroke: none,
)

// Package node — uniform blue rect with bare package name.
// `emphasized` applies a thicker stroke to call out a structural seam (the bridge).
#let pkg(name, col, row, emphasized: false) = node((col, row),
  text(
    size: tokens.size-body,
    weight: tokens.weight-bold,
    fill: palette.blue.ink,
    name,
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: (if emphasized { tokens.stroke-emphasis } else { tokens.stroke-default }) + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Theme-aware import edge — muted ink so it adapts to light/dark.
#let edge-stroke = tokens.stroke-default + palette.ink-muted
#let edge-label = text(
  size: tokens.label-size,
  weight: tokens.weight-light,
  fill: palette.ink-muted,
  style: "italic",
  "imports",
)

#diagram(
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks),

  // Level 2 — model runtime
  level-label("level 2 — model runtime", 0),
  pkg("model", 1, 0, emphasized: true),
  pkg("streaming", 3, 0),

  // Level 1 — output shapes
  level-label("level 1 — output shapes", 1),
  pkg("response", 3, 1),

  // Level 0 — primitives
  level-label("level 0 — primitives", 2),
  pkg("protocol", 1, 2),
  pkg("config", 2, 2),
  pkg("message", 3, 2),

  // model imports protocol (capability constants) and config (ModelConfig).
  // Notably absent: model → message. The bridge is capability + configuration only.
  // model→config uses a right-then-down waypoint so it stays clear of the model→protocol edge + label.
  edge((1, 0), (1, 2), "->", edge-label, stroke: edge-stroke),
  edge((1, 0), "r,d", (2, 2), "->", edge-label, stroke: edge-stroke),
)
