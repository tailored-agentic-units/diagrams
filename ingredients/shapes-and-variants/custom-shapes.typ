#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "@preview/cetz:0.3.4": draw
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

// Custom 1 — tabbed-rect: folder-tab on top-left.
#let tabbed-rect(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let tab-w = w * 0.55
  let tab-h = 7pt
  draw.merge-path(close: true, {
    draw.line(
      (-w, -h), (+w, -h), (+w, +h),
      (-w + tab-w, +h),
      (-w + tab-w * 0.95, +h + tab-h),
      (-w, +h + tab-h),
    )
  })
}

// Custom 2 — notched-rect: rect with a triangle cut from top-right.
#let notched-rect(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let notch = 10pt
  draw.merge-path(close: true, {
    draw.line(
      (-w, -h), (+w, -h),
      (+w, h - notch), (+w - notch, h),
      (-w, h),
    )
  })
}

// Custom 3 — quatrefoil: SVG-derived shape with 4 concave dents.
#let quatrefoil(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let p(x, y) = (x * w / 128 - w, h - y * h / 128)
  draw.merge-path(close: true, {
    draw.bezier(p(78, 0),    p(128, 50),  p(105.614, 0),     p(128, 22.386))
    draw.bezier(p(128, 50),  p(178, 0),   p(128, 22.386),    p(150.386, 0))
    draw.line(  p(178, 0),   p(256, 0))
    draw.line(  p(256, 0),   p(256, 78))
    draw.bezier(p(256, 78),  p(206, 128), p(256, 105.614),   p(233.614, 128))
    draw.bezier(p(206, 128), p(256, 178), p(233.614, 128),   p(256, 150.386))
    draw.line(  p(256, 178), p(256, 256))
    draw.line(  p(256, 256), p(178, 256))
    draw.bezier(p(178, 256), p(128, 206), p(150.386, 256),   p(128, 233.614))
    draw.bezier(p(128, 206), p(78, 256),  p(128, 233.614),   p(105.614, 256))
    draw.line(  p(78, 256),  p(0, 256))
    draw.line(  p(0, 256),   p(0, 178))
    draw.bezier(p(0, 178),   p(50, 128),  p(0, 150.386),     p(22.386, 128))
    draw.bezier(p(50, 128),  p(0, 78),    p(22.386, 128),    p(0, 105.614))
    draw.line(  p(0, 78),    p(0, 0))
    draw.line(  p(0, 0),     p(78, 0))
  })
}

#let custom-cell(shape-fn, hue, title, kind, inset-pad: tokens.pad-inside-shape) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, title),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: hue.ink, style: "italic", "(" + kind + ")"),
    ),
    shape: shape-fn,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: inset-pad,
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  col-header("tabbed-rect"),
  col-header("notched-rect"),
  col-header("quatrefoil"),

  align(center + horizon, custom-cell(tabbed-rect,  palette.purple, "auth",    "module")),
  align(center + horizon, custom-cell(notched-rect, palette.blue,   "request", "doc")),
  align(center + horizon, custom-cell(quatrefoil,   palette.orange, "render",  "node", inset-pad: tokens.pad-inside-shape * 2.2)),

  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "folder tab — packages"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "i/o doc — message"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "SVG path → bezier — node"),
)
