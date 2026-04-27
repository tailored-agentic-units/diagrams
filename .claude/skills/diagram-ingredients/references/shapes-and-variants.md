# Shapes and variants

The shape vocabulary an author picks from when assigning visual identity to entities, and the mechanisms for differentiating instances of the same shape.

## Built-in shapes

Fletcher ships a working inventory. Every built-in is `fletcher.shapes.<name>`:

| Shape | Visual character |
|---|---|
| `rect` | the default — neutral, fits anywhere, no implied semantics |
| `circle` | symmetric, no directional bias — good for terminal / boundary nodes |
| `ellipse` | softer than rect, less neutral than circle |
| `pill` | rounded ends — actor-like; reads softer than rect |
| `parallelogram` | implied direction; data-flow / transformation steps |
| `trapezium` | wider at top or bottom — funnel / aggregation |
| `diamond` | decision / branch (workflow tradition) |
| `triangle` | strong directional anchor — entry / exit |
| `house` | document-like / source artifact |
| `chevron` | one-way step in a sequence |
| `hexagon` | engineering / structural — reads "container of related capability" |
| `octagon` | stop / blocking — strong attention |
| `cylinder` | persistent storage (database / disk tradition) |
| `brace` | grouping fence (left/right pair) |
| `bracket` | grouping fence (square pair) |
| `paren` | grouping fence (curved pair) |

`brace`, `bracket`, `paren` are fence glyphs, typically used as group annotations rather than as primary entity shapes.

**Reading the shape catalog.** The shape vocabulary differentiates along three orthogonal axes:

- **Symmetric vs directional** — circle, rect, hexagon are symmetric (no preferred direction); parallelogram, chevron, triangle, house imply direction.
- **Soft vs hard** — pill, ellipse, rect with high corner radius read as soft; rect with sharp corners, octagon read as hard.
- **Visual weight** — octagon and large diamond claim attention; pill and rect with subtle radius recede.

`rect` is the lowest-weight, most neutral shape and lets other ingredients (color, label structure, edges) carry the meaning when shape itself is not the primary signal.

## Composite shapes

A **composite shape** keeps the Fletcher built-in but composes the *node body* from multiple visual elements. The shape parameter stays a built-in (typically `fletcher.shapes.rect`); the body uses Typst layout primitives (`stack`, `block`, `grid`, `place`) to combine elements.

Three workhorse composites:

### Header bar

A title block on top, separator rule, body block below. Mirrors UML class notation:

```typst
node((0, 0),
  box(width: 150pt,
    stack(dir: ttb, spacing: 0pt,
      block(width: 100%, inset: pad-inside-shape,
        stack(dir: ttb, spacing: gap-structured-text,
          text(weight: "bold", "users"),
          text(style: "italic", fill: hue.ink, "(service)"),
        ),
      ),
      divider(hue: hue),
      block(width: 100%, inset: pad-inside-shape,
        text(fill: palette.ink-muted, "body content"),
      ),
    ),
  ),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: stroke-default + hue.stroke,
  inset: 0pt,
  corner-radius: radius-shape,
)
```

The host node uses `inset: 0pt` so the inner blocks fill edge-to-edge; each inner block carries its own padding. The hue-aware `divider()` keeps the rule in the same color family.

Reads as a node with a title section and a payload section visually separated — useful for modules with internal capability lists, classes with method lists, services with field schemas.

### Corner ribbon

A right-triangle that nests into the host's top-right rounded corner, marking state or flag:

```typst
node((0, 0),
  box(
    block(inset: pad-inside-shape,
      stack(dir: ttb, spacing: gap-structured-text,
        text(weight: "bold", "Request"),
        text(style: "italic", fill: hue.ink, "(structure)"),
      ),
    ) + place(top + right, corner-ribbon(14pt, radius-shape, palette.red.stroke)),
  ),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: stroke-default + hue.stroke,
  inset: 0pt,
  corner-radius: radius-shape,
)
```

The ribbon outline is a small custom shape (a quarter-arc + lines, drawn via `curve(...)`) that slots flush into the rounded corner. Reads as a corner flag, marking a single node as distinct from its peers.

### Icon block

A leading icon block on one side, body content on the other:

```typst
grid(columns: (auto, auto), column-gutter: 0pt, align: (left + horizon, left + horizon),
  block(fill: hue.stroke, inset: pad-inside-shape * 1.4,
    radius: (top-left: radius-shape, bottom-left: radius-shape),
    text(size: 22pt, fill: hue.fill, glyph)),
  block(inset: pad-inside-shape * 1.2,
    stack(dir: ttb, spacing: gap-structured-text,
      text(weight: "bold", title),
      text(style: "italic", fill: hue.ink, "(" + kind + ")"),
    ),
  ),
)
```

Wrapped in a `node(... shape: fletcher.shapes.rect, inset: 0pt, corner-radius: radius-shape, ...)` host so the outer outline rounds and stitches cleanly. The icon block's own corners match the host's radius for a clean left-edge join. The glyph anchors the node identity — actor, brand, infrastructure type.

## Custom shapes

A **custom shape** is a Fletcher shape function: `(node, extrude) → cetz.draw.*`. The shape's outline is defined directly via CeTZ primitives.

Custom shapes apply when the silhouette of the node is part of the visual signal:

- **Tabbed rectangle** — folder-tab on top-left, single contiguous outline. Reads as "package" or "labeled artifact."
- **Notched rectangle** — rectangle with one corner clipped. Reads as "i/o document" or "message."
- **Quatrefoil / asymmetric polygon** — concave dents on each side. Reads as "decision node" or "complex transformation."

Composite shapes (above) and custom shapes are not interchangeable. Composite content rides on top of an existing outline; custom shapes change the outline. A "rect with a header bar" is composite; a "rect with a folder tab" is custom because the tab extends the silhouette beyond a rect.

## Variants

Same shape, differentiated for state. Fletcher exposes several mechanisms; visual weight differs across them.

### Stroke variations

| Mechanism | Visual |
|---|---|
| `stroke-dash: "dashed"` | dashed outline — pending, optional, conceptual |
| `stroke-dash: "dotted"` | finer dashed — even more provisional |
| `stroke-thickness: emphasis` | thicker — primary, emphasized |
| `stroke-thickness: thin` | thinner — supporting, de-emphasized |
| `stroke-color: hue.ink` | deeper hue — promoted state |

### Color and fill

| Mechanism | Visual |
|---|---|
| `fill-color: surface` | no fill, just stroke — wireframe / open |
| `fill-color: <other-hue>.fill` | different hue family — different group within the same shape |

### Geometry

| Mechanism | Visual |
|---|---|
| `corner-radius: 0pt` | sharp corners — formal / technical |
| `corner-radius: 16pt` | rounded — soft / informal |
| `extrude: (0, 3)` | double-stroke outline — self-hosted / extruded |

### Overlay

| Mechanism | Visual |
|---|---|
| corner badge (Nerd Font glyph) | adds a state or kind hint without changing the shape |
| stripe / band overlay (place pattern) | marks a span across the node body |

### Fade

```typst
let s-color = if faded { color.mix((base-stroke, 40%), (palette.surface, 60%)) } else { base-stroke }
let f-color = if faded { color.mix((base-fill,   40%), (palette.surface, 60%)) } else { base-fill }
```

Mixing toward the surface (not lightening) works in both light and dark themes — lightening a dark-mode fill made it more prominent, the opposite of "faded." Reads as de-emphasized, external, or archived.

## Combining variants

Variants compose. Two variant signals on one node read as either reinforcing (both signals agree on the differentiation) or conflicting (each signal points at a different distinction). Three or more variant signals on one node usually indicate the diagram needs to decompose rather than escalate visual treatment.

A useful check on a draft variant: removing the signal — does the diagram still answer the question it's asking? If yes, the signal was decoration. If no, the signal carries meaning; the remaining check is whether other signals on the same node compete with it.

## Shape + hue: orthogonal axes

Shape and hue compose orthogonally. Three structural options:

- **One shape, many hues** — entities are uniformly the same kind but split into groups (modules within a system, all rendered as `rect`, hue per group).
- **Many shapes, one hue** — entities differ in kind but cluster as one group (a single library's surface: pill for actor, rect for service, cylinder for storage, all in `palette.blue.fill`).
- **Many shapes, many hues** — both kind and group differ. The diagram carries two visual axes simultaneously; it must justify both, since the cognitive load doubles.
