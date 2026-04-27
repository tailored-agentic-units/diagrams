# Custom shapes via CeTZ

Fletcher ships built-in shapes (`fletcher.shapes.rect`, `fletcher.shapes.circle`, etc.). When none of them fit, you can define a custom shape as a Fletcher shape function backed by CeTZ drawing primitives.

## The shape function contract

A Fletcher shape is a function with the signature `(node, extrude) → cetz.draw.*`.

- `node.size` is a 2-tuple of the node's bounding-box dimensions (computed by Fletcher from the label content + inset).
- `node.corner-radius` is the radius parameter passed to the node, useful for shapes that should respect rounding.
- `extrude` is a per-instance offset added when Fletcher renders multiple stroke layers (e.g., for the `extrude: (0, 3)` variant).

The function returns CeTZ drawing primitives — typically wrapped in `draw.merge-path(close: true, { ... })` so the outline is one continuous closed path with no internal seams between segments.

## Pass the function as `shape:` on a node

```typst
node((0, 0), "label",
  shape: my-custom-shape,
  fill: hue.fill,
  stroke: 1.2pt + hue.stroke,
)
```

Fletcher invokes the function with the node's measured size + extrude, then strokes / fills the returned path.

## Coordinate system

Fletcher's bounding box is centered: x runs from `-w/2` to `+w/2`, y from `-h/2` to `+h/2`. Y is up (CeTZ convention). When porting from an SVG path (origin top-left, y down), you need a coordinate-mapping helper.

## Minimal example: a notched rectangle

```typst
#import "@preview/cetz:0.3.4": draw

#let notched-rect(node, extrude) = {
  let (w, h) = node.size.map(i => i/2 + extrude)
  let notch = 10pt
  draw.merge-path(close: true, {
    draw.line(
      (-w, -h),                  // bottom-left
      (+w, -h),                  // bottom-right
      (+w, h - notch),           // start of notch
      (+w - notch, h),           // notch corner
      (-w, h),                   // top-left
    )
  })
}
```

Each `draw.line(p1, p2, ...)` traces a polygon segment. `merge-path(close: true, ...)` joins the points into one closed outline so the stroke runs the full perimeter without breaks.

## Translating an SVG path

If you have an SVG path you want to reuse, translate each command:

| SVG | CeTZ equivalent |
|---|---|
| `M x y` | move-to (start a new sub-path or set the current point — typically the first point of `merge-path`) |
| `L x y` (or implicit line) | `draw.line((prev), (x, y))` |
| `C cx1 cy1, cx2 cy2, x y` | `draw.bezier((prev), (x, y), (cx1, cy1), (cx2, cy2))` |

For coordinate mapping, define a helper that converts SVG coordinates (origin top-left, y down, scale 0..256 etc.) to Fletcher's centered coordinate system:

```typst
let p(x, y) = (x * w / 128 - w, h - y * h / 128)  // SVG 0..256 → Fletcher centred
```

Then every path point `(x_svg, y_svg)` becomes `p(x_svg, y_svg)`.

## Composite vs custom shapes

A **composite shape** keeps the Fletcher built-in (`shape: fletcher.shapes.rect`) and arranges multiple visual elements *inside the body* via Typst content composition (`stack`, `grid`, `block`, `place`). Header bars, corner badges, and leading icon blocks all compose this way. No custom Fletcher shape function is required.

A **custom shape** redefines the outline itself — folder tabs, asymmetric polygons, paths derived from SVG. The silhouette is part of the visual.

The two are not interchangeable. Composite content rides on top of an existing outline; custom shapes change the outline. A "rect with a header bar" is composite; a "rect with a folder tab" is custom because the tab extends the silhouette beyond a rect.

## Checking your shape

A bug-prone shape will either:

- **Disappear** — the path returned 0-area, or the points were specified outside the bounding box.
- **Stroke incorrectly** — `merge-path` was called with `close: false`, leaving internal seams visible.
- **Render mirrored** — y-axis confusion between SVG and CeTZ.

Sanity-check by rendering the shape with a low-contrast fill on a high-contrast background and looking for breaks in the outline.
