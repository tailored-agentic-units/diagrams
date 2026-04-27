#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

// Composite 1 — title block on top, separator rule, body content below.
#let header-bar-node(hue, title, kind, body) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    box(width: 150pt,
      stack(dir: ttb, spacing: 0pt,
        block(width: 100%, inset: tokens.pad-inside-shape,
          stack(dir: ttb, spacing: tokens.gap-structured-text,
            text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, title),
            text(size: tokens.size-label, weight: tokens.weight-light, fill: hue.ink, style: "italic", "(" + kind + ")"),
          ),
        ),
        divider(hue: hue),
        block(width: 100%, inset: tokens.pad-inside-shape,
          text(size: tokens.size-label, fill: palette.ink-muted, body),
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

// Composite 2 — corner ribbon: a right-triangle that nests into the host's
// top-right rounded corner via a quarter-arc.
#let _kappa = 0.5522847498
#let corner-ribbon(size, radius, color) = {
  let s = size
  let r = radius
  let k = r * _kappa
  curve(
    fill: color, stroke: none,
    curve.move((0pt, 0pt)),
    curve.line((s - r, 0pt)),
    curve.cubic((s - r + k, 0pt), (s, r - k), (s, r)),
    curve.line((s, s)),
    curve.close(),
  )
}

#let ribbon-node(hue, title, kind, ribbon-color) = {
  let stroke-half = tokens.stroke-default / 2
  diagram(
    spacing: (0pt, 0pt),
    node((0, 0),
      box(
        block(inset: tokens.pad-inside-shape,
          stack(dir: ttb, spacing: tokens.gap-structured-text,
            text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, title),
            text(size: tokens.size-label, weight: tokens.weight-light, fill: hue.ink, style: "italic", "(" + kind + ")"),
          ),
        ) + place(top + right,
          dx: stroke-half,
          dy: -stroke-half,
          corner-ribbon(14pt, tokens.radius-shape + stroke-half, ribbon-color),
        ),
      ),
      shape: fletcher.shapes.rect,
      fill: hue.fill,
      stroke: tokens.stroke-default + hue.stroke,
      inset: 0pt,
      corner-radius: tokens.radius-shape,
    ),
  )
}

// Composite 3 — leading icon block.
#let icon-block-node(hue, glyph, title, kind) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    grid(columns: (auto, auto), column-gutter: 0pt, align: (left + horizon, left + horizon),
      block(fill: hue.stroke, inset: tokens.pad-inside-shape * 1.4,
        radius: (top-left: tokens.radius-shape, bottom-left: tokens.radius-shape),
        text(size: 22pt, fill: hue.fill, glyph)),
      block(inset: tokens.pad-inside-shape * 1.2,
        stack(dir: ttb, spacing: tokens.gap-structured-text,
          text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, title),
          text(size: tokens.size-label, weight: tokens.weight-light, fill: hue.ink, style: "italic", "(" + kind + ")"),
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

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  col-header("header bar"),
  col-header("corner ribbon"),
  col-header("icon block"),

  align(center + horizon, header-bar-node(palette.blue, "users", "service", "body content")),
  align(center + horizon, ribbon-node(palette.purple, "Request", "structure", palette.red.stroke)),
  align(center + horizon, icon-block-node(palette.orange, "\u{F007}", "client", "human")),

  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "title-block separator"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "marker for state / flag"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "icon as identity anchor"),
)
