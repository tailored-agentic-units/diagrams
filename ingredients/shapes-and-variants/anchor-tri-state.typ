#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let _title(s)            = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, h)          = text(size: tokens.size-label, weight: tokens.weight-light, fill: h.ink, style: "italic", "(" + s + ")")
#let _body(h, badge: none) = if badge == none {
  stack(dir: ttb, spacing: tokens.gap-structured-text, _title("api"), _kind("compute", h))
} else {
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    grid(columns: (1fr, auto), column-gutter: tokens.gap-cell, align: (left + horizon, right + horizon),
      _title("api"), text(size: tokens.size-body, fill: h.stroke, badge)),
    _kind("compute", h))
}

#let variant-shape(
  hue: palette.blue,
  stroke-thickness: tokens.stroke-default,
  extrude: (0,),
  faded: false,
  badge: none,
) = {
  let base-stroke = hue.stroke
  let base-fill   = hue.fill
  let s-color = if faded { color.mix((base-stroke, 40%), (palette.surface, 60%)) } else { base-stroke }
  let f-color = if faded { color.mix((base-fill,   40%), (palette.surface, 60%)) } else { base-fill }
  diagram(
    spacing: (0pt, 0pt),
    node((0, 0), _body(hue, badge: badge),
      shape: fletcher.shapes.rect,
      fill: f-color,
      stroke: stroke-thickness + s-color,
      inset: tokens.pad-inside-shape,
      corner-radius: tokens.radius-shape,
      extrude: extrude,
    ),
  )
}

#let variant-cell(sample, mechanism, details) = stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
  align(center + horizon, sample),
  align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink, mechanism)),
  align(center + horizon, text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", details)),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text,
  align: center + horizon,

  variant-cell(
    variant-shape(),
    "owned",
    [default · baseline shape],
  ),
  variant-cell(
    variant-shape(extrude: (0, 3), badge: "\u{F473}"),
    "self-hosted",
    [extruded · #raw("nf-oct-server") badge],
  ),
  variant-cell(
    variant-shape(faded: true, badge: "\u{F0C2}"),
    "external",
    [faded · #raw("nf-fa-cloud") badge],
  ),
)
