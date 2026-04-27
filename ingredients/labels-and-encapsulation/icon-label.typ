#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

// Icon-left: leading icon block on left, body content on right.
#let icon-left(hue, glyph, title, kind) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    grid(columns: (auto, auto), column-gutter: 0pt, align: (left + horizon, left + horizon),
      block(fill: hue.stroke, inset: tokens.pad-inside-shape * 1.4,
        radius: (top-left: tokens.radius-shape, bottom-left: tokens.radius-shape),
        text(size: 22pt, fill: hue.fill, glyph)),
      block(inset: tokens.pad-inside-shape * 1.2,
        stack(dir: ttb, spacing: tokens.gap-structured-text,
          _title(title),
          _kind(kind, hue.ink),
        ),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: 0pt,
    corner-radius: tokens.radius-shape,
  ),
)

// Icon-right badge: title with right-aligned glyph alongside.
#let icon-right-badge(hue, glyph, title, kind) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      grid(columns: (1fr, auto), column-gutter: tokens.gap-cell, align: (left + horizon, right + horizon),
        _title(title), text(size: tokens.size-body, fill: hue.stroke, glyph)),
      _kind(kind, hue.ink),
    ),
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// Icon-only: glyph as primary visual, tiny label below.
#let icon-only(hue, glyph, label) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: 22pt, fill: hue.stroke, glyph),
      text(size: tokens.size-label, fill: palette.ink-muted, label),
    ),
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("icon-left"), col-header("icon-right badge"), col-header("icon only"),

  align(center + horizon, icon-left(palette.blue, "\u{F1C0}", "users", "persistence")),
  align(center + horizon, icon-right-badge(palette.blue, "\u{F0C2}", "api", "compute · cloud")),
  align(center + horizon, icon-only(palette.orange, "\u{F007}", "user")),
)
