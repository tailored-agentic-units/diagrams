#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let _title(s)   = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, h) = text(size: tokens.size-label, weight: tokens.weight-light, fill: h.ink, style: "italic", "(" + s + ")")
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
  stroke-color: none,
  stroke-thickness: tokens.stroke-default,
  stroke-dash: none,
  fill-color: none,
  corner-radius: tokens.radius-shape,
  extrude: (0,),
  faded: false,
  badge: none,
) = {
  let base-stroke = if stroke-color == none { hue.stroke } else { stroke-color }
  let base-fill   = if fill-color   == none { hue.fill   } else { fill-color }
  let s-color = if faded { color.mix((base-stroke, 40%), (palette.surface, 60%)) } else { base-stroke }
  let f-color = if faded { color.mix((base-fill,   40%), (palette.surface, 60%)) } else { base-fill }
  let stroke-spec = if stroke-dash != none {
    (paint: s-color, thickness: stroke-thickness, dash: stroke-dash)
  } else {
    stroke-thickness + s-color
  }
  diagram(
    spacing: (0pt, 0pt),
    node((0, 0), _body(hue, badge: badge),
      shape: fletcher.shapes.rect,
      fill: f-color,
      stroke: stroke-spec,
      inset: tokens.pad-inside-shape,
      corner-radius: corner-radius,
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
  columns: (auto, auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-ranks,
  align: center + horizon,

  // Row 1 — stroke variations
  variant-cell(variant-shape(),                                            "default",          [baseline reference]),
  variant-cell(variant-shape(stroke-dash: "dashed"),                       "dashed stroke",    raw("stroke-dash: \"dashed\"")),
  variant-cell(variant-shape(stroke-dash: "dotted"),                       "dotted stroke",    raw("stroke-dash: \"dotted\"")),
  variant-cell(variant-shape(stroke-thickness: tokens.stroke-emphasis),    "thicker stroke",   raw("thickness: 2pt")),

  // Row 2 — colour + fill
  variant-cell(variant-shape(stroke-thickness: tokens.stroke-thin),        "thinner stroke",   raw("thickness: 0.8pt")),
  variant-cell(variant-shape(stroke-color: palette.blue.ink),              "deeper stroke",    raw("stroke: hue.ink")),
  variant-cell(variant-shape(fill-color: palette.surface),                 "no fill",          raw("fill: surface")),
  variant-cell(variant-shape(extrude: (0, 3)),                             "extruded",         raw("extrude: (0, 3)")),

  // Row 3 — geometry, overlay, fade
  variant-cell(variant-shape(corner-radius: 0pt),                          "sharp corners",    raw("corner-radius: 0pt")),
  variant-cell(variant-shape(corner-radius: 16pt),                         "round corners",    raw("corner-radius: 16pt")),
  variant-cell(variant-shape(badge: "\u{F015}"),                           "corner badge",     [Nerd Font glyph]),
  variant-cell(variant-shape(faded: true),                                 "faded",            [stroke + fill lightened]),
)
