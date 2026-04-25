// ==============================================================
// Shape catalog — every Fletcher 0.5.8 built-in shape, plus
// composite (multi-element node body) and custom (CeTZ-defined
// shape function) extensions. Each diagram picks the shape + hue
// pairing that carries its intent; this is the vocabulary, not
// the contract.
// ==============================================================
// render: static

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.3.4": draw
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette, divider

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

// Catalog cell: shape rendered with its name as the body label, namespace
// caption underneath. Single hue across all cells so the visual focus is
// shape geometry, not colour.
#let shape-cell(name, shape-fn) = stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
  align(center + horizon,
    diagram(
      spacing: (0pt, 0pt),
      node((0, 0),
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
        shape:          shape-fn,
        fill:           palette.blue.fill,
        stroke:         tokens.stroke-default + palette.blue.stroke,
        inset:          tokens.pad-inside-shape,
        corner-radius:  tokens.radius-shape,
      ),
    ),
  ),
  align(center + horizon,
    text(size: tokens.size-label, fill: palette.ink-muted, raw("fletcher.shapes." + name))),
)

#let shapes = (
  ("rect",          fletcher.shapes.rect),
  ("circle",        fletcher.shapes.circle),
  ("ellipse",       fletcher.shapes.ellipse),
  ("pill",          fletcher.shapes.pill),
  ("parallelogram", fletcher.shapes.parallelogram),
  ("trapezium",     fletcher.shapes.trapezium),
  ("diamond",       fletcher.shapes.diamond),
  ("triangle",      fletcher.shapes.triangle),
  ("house",         fletcher.shapes.house),
  ("chevron",       fletcher.shapes.chevron),
  ("hexagon",       fletcher.shapes.hexagon),
  ("octagon",       fletcher.shapes.octagon),
  ("cylinder",      fletcher.shapes.cylinder),
  ("brace",         fletcher.shapes.brace),
  ("bracket",       fletcher.shapes.bracket),
  ("paren",         fletcher.shapes.paren),
)

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Shapes — Fletcher built-ins"),
)

#v(tokens.space-between-ranks)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-ranks,
  align: center + horizon,

  ..shapes.map(((name, sh)) => align(center + horizon, shape-cell(name, sh)))
)

#v(tokens.space-between-ranks)

#align(center,
  text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
    "brace / bracket / paren are fence glyphs — included for completeness."),
)

#v(tokens.space-between-ranks)

// ============================================================================
// COMPOSITE SHAPES — multiple visual elements in a single node body.
// The shape stays a Fletcher built-in; the body composes via Typst layout
// primitives (block, stack, place) for richer visual structure.
// ============================================================================

#text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
  "Composite shapes — node body composes multiple visuals")

#v(tokens.gap-structured-text)
#text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
  "Same Fletcher rect, but the body splits across a header / divider / body block, overlays a corner ribbon, or grafts an icon block onto the leading edge. Composition lives at the Typst content level — no custom shape function required.")
#v(tokens.space-between-shapes)

// Composite 1 — title block on top, separator rule, body content below.
// Mirrors UML class notation: identity above, payload below. The hue-aware
// `divider()` helper keeps the rule in the same colour family as the host.
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
// top-right rounded corner. The apex (where the top and right edges meet)
// is replaced by a quarter-arc whose radius matches the host's corner-radius,
// so the ribbon slots flush into the corner instead of overshooting it.
#let _kappa = 0.5522847498  // bezier approximation of a quarter circle
#let corner-ribbon(size, radius, color) = {
  let s = size
  let r = radius
  let k = r * _kappa
  curve(
    fill: color, stroke: none,
    curve.move((0pt, 0pt)),                                                       // top-left along host top edge
    curve.line((s - r, 0pt)),                                                     // top edge up to arc start
    curve.cubic((s - r + k, 0pt), (s, r - k), (s, r)),                            // quarter-arc apex
    curve.line((s, s)),                                                            // right edge down to bottom-right
    curve.close(),
  )
}

// Same trick as icon-block-node: node inset is 0pt so the body content fills
// the node edge-to-edge, the title block carries its own padding, and the
// ribbon's place(top + right) lands on the host's actual top-right corner
// instead of being inset by pad-inside-shape.
#let ribbon-node(hue, title, kind, ribbon-color) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    box(
      block(inset: tokens.pad-inside-shape,
        stack(dir: ttb, spacing: tokens.gap-structured-text,
          text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, title),
          text(size: tokens.size-label, weight: tokens.weight-light, fill: hue.ink, style: "italic", "(" + kind + ")"),
        ),
      ) + place(top + right, corner-ribbon(14pt, tokens.radius-shape, ribbon-color)),
    ),
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: 0pt,
    corner-radius: tokens.radius-shape,
  ),
)

// Composite 3 — leading icon block. Generous padding; icon block's left
// corners match the host's corner-radius for a clean left-edge join.
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
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("header bar")),
  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("corner ribbon")),
  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("icon block")),

  align(center + horizon, header-bar-node(palette.blue, "users", "service", "body content")),
  align(center + horizon, ribbon-node(palette.purple, "Request", "structure", palette.red.stroke)),
  align(center + horizon, icon-block-node(palette.orange, "\u{F007}", "client", "human")),

  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "title-block separator"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "marker for state / flag"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "icon as identity anchor"),
)

#v(tokens.space-between-ranks)

// ============================================================================
// CUSTOM SHAPES — a Fletcher shape function is just (node, extrude) → CeTZ.
// Define the outline directly via cetz.draw primitives. Use as `shape: my-fn`.
// ============================================================================

#text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
  "Custom shapes — Fletcher shape API via CeTZ")

#v(tokens.gap-structured-text)
#text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic",
  [A Fletcher shape is a function `(node, extrude) → cetz.draw.*`. `node.size` and `node.corner-radius` drive layout; `extrude` is added for stroke-extruded outlines. Pass the function as #raw("shape: my-fn") on a node.])
#v(tokens.space-between-shapes)

// Custom 1 — tabbed-rect: folder-tab on top-left, single contiguous outline.
// The path traces tab + body as one closed polygon so there's no internal
// stroke between them.
#let tabbed-rect(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let tab-w = w * 0.55
  let tab-h = 7pt
  draw.merge-path(close: true, {
    draw.line(
      (-w, -h),                           // bottom-left
      (+w, -h),                           // bottom-right
      (+w, +h),                           // top-right of body
      (-w + tab-w, +h),                   // top edge to where tab starts going up
      (-w + tab-w * 0.95, +h + tab-h),    // diagonal up to tab top-right
      (-w, +h + tab-h),                   // tab top-left
    )
  })
}

// Custom 2 — notched-rect: rect with a triangle cut from top-right.
// Useful for "i/o document" style messaging.
#let notched-rect(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let notch = 10pt
  draw.merge-path(close: true, {
    draw.line(
      (-w, -h),
      (+w, -h),
      (+w, h - notch),
      (+w - notch, h),
      (-w, h),
    )
  })
}

// Custom 3 — quatrefoil: SVG-derived shape with 4 concave dents in each edge.
// The 256×256 SVG path is mapped to fletcher's centred coordinate system
// via `p()`. Each cubic bezier from the source `C cx1 cy1, cx2 cy2, x y`
// becomes `draw.bezier(start, end, ctrl1, ctrl2)`.
#let quatrefoil(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  // SVG (0..256, y down)  →  CeTZ (-w..+w, -h..+h, y up)
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
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text * 2,
  align: center + horizon,

  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("tabbed-rect")),
  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("notched-rect")),
  text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper("quatrefoil")),

  align(center + horizon, custom-cell(tabbed-rect,  palette.purple, "auth",    "module")),
  align(center + horizon, custom-cell(notched-rect, palette.blue,   "request", "doc")),
  // Quatrefoil needs more inset so the label sits inside the central body
  // rather than under one of the concave dents.
  align(center + horizon, custom-cell(quatrefoil,   palette.orange, "render",  "node", inset-pad: tokens.pad-inside-shape * 2.2)),

  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "folder tab — packages"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "i/o doc — message"),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "SVG path → bezier — node"),
)
