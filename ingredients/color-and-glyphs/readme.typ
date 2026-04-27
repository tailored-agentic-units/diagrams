#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let essence-card(hue, glyph, name, kind) = box(
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  radius: tokens.radius-shape,
  inset: tokens.pad-inside-shape,
  grid(columns: (auto, auto), column-gutter: tokens.gap-cell, align: (left + horizon, left + horizon),
    text(size: 22pt, fill: hue.stroke, glyph),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
      text(size: tokens.size-label, weight: tokens.weight-light, style: "italic", fill: hue.ink, kind),
    ),
  ),
)

#stack(dir: ltr, spacing: tokens.space-between-shapes,
  essence-card(palette.purple, "\u{E73C}", "engine",   "(python)"),
  essence-card(palette.blue,   "\u{F0C2}", "api",      "(service)"),
  essence-card(palette.orange, "\u{F007}", "operator", "(human)"),
  essence-card(palette.coral,  "\u{F1C0}", "store",    "(persistence)"),
)
