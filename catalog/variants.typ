// ==============================================================
// Variants catalog — every viable way to differentiate a shape
// from its default state. The default is shown alongside each
// variant so the modification reads at a glance. Mechanisms span
// stroke / fill / geometry / overlay / opacity.
// ==============================================================
// render: static

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette

#set page(
  width:  900pt,
  height: auto,
  margin: tokens.pad-inside-container,
  fill:   palette.surface,
)
#set text(
  font: tokens.font,
  size: tokens.size-body,
  fill: palette.ink,
)

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Inline code gets a hue tint to differentiate from prose.
#show raw: r => text(fill: palette.purple.stroke, r)

// Default-style sample body: title + kind label, optional badge.
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

// Single shape with one variant parameter applied. All other parameters use
// the design-system defaults.
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
  // `extrude: (0,)` matches Fletcher's own default — one stroke at offset 0,
  // i.e. the visible outline. `extrude: ()` would suppress all strokes.
  // Resolve colour bases via expression-form (immutable bindings); reassignment
  // inside function bodies evaluates inconsistently and silently broke cells.
  let base-stroke = if stroke-color == none { hue.stroke } else { stroke-color }
  let base-fill   = if fill-color   == none { hue.fill   } else { fill-color }
  let s-color = if faded { base-stroke.lighten(60%) } else { base-stroke }
  let f-color = if faded { base-fill.lighten(50%)   } else { base-fill }
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

// A catalog cell: variant sample on top, mechanism name + textual details below.
#let variant-cell(sample, mechanism, details) = stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
  align(center + horizon, sample),
  align(center + horizon, text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink, mechanism)),
  align(center + horizon, text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", details)),
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Variants — ways to differentiate a shape from its default"),
)
#v(tokens.gap-structured-text)
#align(center,
  box(width: 720pt,
    note([Each cell shows a single mechanism applied to a baseline rect. Diagrams pick the mechanism whose visual weight matches the meaning of the variation — there's no "right" choice, only suitable ones.])))

#v(tokens.space-between-ranks)

// ============================================================================
// ANCHOR — illustrative tri-state example using stroke pattern.
// ============================================================================

#section-title("anchor · one tri-state example")
#v(tokens.gap-structured-text)
#note([An illustrative scenario: a service might be #raw("owned") (first-party), #raw("self-hosted") (runs on user infrastructure), or #raw("external") (third-party SaaS). Stroke pattern carries the three-state signal here. Any of the mechanisms catalogued below could replace it if the diagram needs different visual weight.])
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text,
  align: center + horizon,

  variant-cell(
    variant-shape(),
    "owned",
    [default · solid stroke],
  ),
  variant-cell(
    variant-shape(stroke-dash: "dashed"),
    "self-hosted",
    raw("stroke-dash: \"dashed\""),
  ),
  variant-cell(
    variant-shape(stroke-dash: "dotted"),
    "external",
    raw("stroke-dash: \"dotted\""),
  ),
)

#v(tokens.space-between-ranks)

// ============================================================================
// CATALOG — every viable variant mechanism, 4 cols × 3 rows.
// ============================================================================

#section-title("catalog · variant mechanisms")
#v(tokens.gap-structured-text)
#note([Same baseline shape, one parameter changed per cell. Hue stays constant (blue) so visual differences read as variant-mechanism only.])
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-ranks,
  align: center + horizon,

  // Row 1 — stroke variations
  variant-cell(
    variant-shape(),
    "default",
    [baseline reference],
  ),
  variant-cell(
    variant-shape(stroke-dash: "dashed"),
    "dashed stroke",
    raw("stroke-dash: \"dashed\"")
  ),
  variant-cell(
    variant-shape(stroke-dash: "dotted"),
    "dotted stroke",
    raw("stroke-dash: \"dotted\"")
  ),
  variant-cell(
    variant-shape(stroke-thickness: tokens.stroke-emphasis),
    "thicker stroke",
    raw("thickness: 2pt"),
  ),

  // Row 2 — colour + fill
  variant-cell(
    variant-shape(stroke-thickness: tokens.stroke-thin),
    "thinner stroke",
    raw("thickness: 0.8pt"),
  ),
  variant-cell(
    variant-shape(stroke-color: palette.blue.ink),
    "deeper stroke",
    raw("stroke: hue.ink"),
  ),
  variant-cell(
    variant-shape(fill-color: palette.surface),
    "no fill",
    raw("fill: surface"),
  ),
  variant-cell(
    variant-shape(extrude: (0, 3)),
    "extruded",
    raw("extrude: (0, 3)"),
  ),

  // Row 3 — geometry, overlay, fade
  variant-cell(
    variant-shape(corner-radius: 0pt),
    "sharp corners",
    raw("corner-radius: 0pt"),
  ),
  variant-cell(
    variant-shape(corner-radius: 16pt),
    "round corners",
    raw("corner-radius: 16pt"),
  ),
  variant-cell(
    variant-shape(badge: "\u{F015}"),
    "corner badge",
    [Nerd Font glyph],
  ),
  variant-cell(
    variant-shape(faded: true),
    "faded",
    [stroke + fill lightened],
  ),
)
