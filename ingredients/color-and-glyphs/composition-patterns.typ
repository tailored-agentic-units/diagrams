#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Pattern 1 — in-label (icon next to text)
#let p1 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    grid(columns: (auto, auto), column-gutter: tokens.gap-cell, align: (left + horizon, left + horizon),
      text(size: 18pt, fill: palette.blue.stroke, "\u{F1C0}"),
      stack(dir: ttb, spacing: tokens.gap-structured-text,
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, "users"),
        text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "(persistence)"),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// Pattern 2 — corner badge
#let p2 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      grid(columns: (1fr, auto), column-gutter: tokens.gap-cell, align: (left + horizon, right + horizon),
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, "api"),
        text(size: tokens.size-body, fill: palette.blue.stroke, "\u{F0C2}"),
      ),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "(compute · cloud)"),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// Pattern 3 — standalone icon (node is an icon)
#let p3 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    align(center + horizon, stack(dir: ttb, spacing: 4pt,
      text(size: 26pt, fill: palette.orange.stroke, "\u{F007}"),
      text(size: tokens.size-label, fill: palette.orange.ink, "user"),
    )),
    shape: fletcher.shapes.pill,
    fill: palette.orange.fill,
    stroke: tokens.stroke-default + palette.orange.stroke,
    inset: tokens.pad-inside-shape,
  ),
)

// Pattern 4 — edge marker (glyph in label)
#let p4 = diagram(
  spacing: (120pt, 0pt),
  node((0, 0), "api",  shape: fletcher.shapes.rect, fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke, inset: tokens.pad-inside-shape, corner-radius: tokens.radius-shape),
  node((1, 0), "auth", shape: fletcher.shapes.rect, fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke, inset: tokens.pad-inside-shape, corner-radius: tokens.radius-shape),
  edge((0, 0), (1, 0), "->",
    stroke: (paint: palette.green.stroke, thickness: tokens.stroke-default),
    label-fill: palette.surface, label-side: center, label-sep: 4pt,
    text(size: tokens.label-size, weight: tokens.weight-bold, fill: palette.ink,
      text(fill: palette.green.stroke, "\u{F023} ") + "authorised"),
  ),
)

#grid(
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),

  col-header("in-label"),
  col-header("corner badge"),
  col-header("standalone"),
  col-header("edge marker"),

  p1, p2, p3, p4,

  note("glyph to the left of a\ntwo-line label"),
  note("glyph right-aligned\nalongside the name"),
  note("glyph is the primary\nvisual element"),
  note("glyph colours the\nedge-label text"),
)
