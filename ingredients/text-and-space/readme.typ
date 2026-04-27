#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let card = box(
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  radius: tokens.radius-shape,
  inset: tokens.pad-inside-shape,
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.ink, "users"),
    text(size: tokens.size-label, weight: tokens.weight-light, style: "italic", fill: palette.blue.ink, "(persistence)"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    grid(columns: (auto, auto), column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text,
      text(size: tokens.size-body, fill: palette.ink-muted, "id"),
      text(size: tokens.size-body, fill: palette.ink, "uuid"),
      text(size: tokens.size-body, fill: palette.ink-muted, "name"),
      text(size: tokens.size-body, fill: palette.ink, "string"),
    ),
  ),
)

#let companion = box(
  fill: palette.purple.fill,
  stroke: tokens.stroke-default + palette.purple.stroke,
  radius: tokens.radius-shape,
  inset: tokens.pad-inside-shape,
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.ink, "session"),
    text(size: tokens.size-label, weight: tokens.weight-light, style: "italic", fill: palette.purple.ink, "(cache)"),
  ),
)

#stack(dir: ltr, spacing: tokens.space-between-shapes,
  card,
  companion,
)
