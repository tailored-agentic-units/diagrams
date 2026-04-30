# Labels and encapsulation

Content patterns inside nodes (the label) and the container pattern that lets external nodes address inner nodes across a boundary (encapsulation).

## Label patterns

A node body in Fletcher is content — anything that evaluates to content can be the body. Five patterns cover most use cases.

### Single-line

The minimum. A plain string or a single `text(...)` call:

```typst
node((0, 0), "planner")                         // plain
node((0, 0), text(weight: "bold", "planner"))   // bold
node((0, 0), raw("ChatService"))                // code-style
```

Reads as the bare identity of the node — a single short name. When the label content needs more than a name, the next pattern (stacked) carries it.

### Stacked: title + kind

A two-line pattern: prominent title, de-emphasized kind annotation below. The workhorse for shape-bearing entities:

```typst
node((0, 0),
  stack(dir: ttb, spacing: gap-structured-text,
    text(weight: "bold", "Request"),
    text(style: "italic", fill: hue.ink, "(structure)"),
  ),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: stroke-default + hue.stroke,
)
```

The kind annotation in italic + parentheses + `hue.ink` reads as "metadata about this node" without competing with the title for attention. The pattern carries an identity (title) and a category (kind) within one node body.

### Field list

A grid of `name : type` rows. Useful for record-like entities, schemas, enums:

```typst
node((0, 0),
  stack(dir: ttb, spacing: gap-structured-text,
    text(weight: "bold", "Request"),
    text(style: "italic", fill: hue.ink, "(structure)"),
    divider(),
    grid(columns: 2, column-gutter: gap-cell, row-gutter: gap-structured-text * 2,
      raw("id"),       raw("UUID"),
      raw("messages"), raw("[]Message"),
      raw("model"),    raw("string"),
      raw("stream"),   raw("bool"),
    ),
  ),
)
```

`row-gutter: gap-structured-text * 2` keeps field rows from crowding. `column-gutter: gap-cell` separates name from type comfortably.

A field list past roughly six rows starts competing with the diagram's other content for attention. Decomposing into multiple nodes or moving detailed fields into surrounding prose keeps the diagram itself focused.

### Divider (header separator)

A horizontal rule between the title block and the body block. Echoes UML class notation without the verbosity:

```typst
stack(dir: ttb, spacing: gap-structured-text,
  text(weight: "bold", "Client"),
  text(style: "italic", fill: hue.ink, "(interface)"),
  divider(hue: hue),                  // hue-aware rule in same color family
  raw("Chat(ctx, req)"),
  raw("Vision(ctx, req)"),
  raw("Tools(ctx, req)"),
  raw("Close()"),
)
```

The hue-aware `divider()` keeps the rule in the same color family as the surrounding fill so it doesn't clash with neutral grey.

The divider pattern reads as a node split into identity (above) and payload (below) — interfaces with method lists, classes with field lists, services with field schemas.

### Icon + label

Three placements (glyph inventory in [color-and-glyphs](color-and-glyphs.md)):

- **Icon-left** — leading icon block on the left, body content on the right. The glyph anchors identity.
- **Icon-right (corner badge)** — title with right-aligned glyph alongside. The glyph adds a state or kind hint without claiming the central position.
- **Icon-only** — glyph as primary visual; tiny label below. The glyph carries the identity; the label captions it.

### Math expressions

Math content (`$ ... $`) embeds anywhere content is expected. Useful when a node represents a formula, capacity, or rate:

```typst
node((0, 0),
  stack(dir: ttb, spacing: gap-structured-text,
    text(weight: "bold", "throttle"),
    $r <= 100 "req/s"$,
    text(style: "italic", "(rate-limit)"),
  ),
)
```

Wrap with `text(fill: ...)` for color.

### Mixed runs

A single node combining text, code, math, and colored runs:

```typst
node((0, 0),
  stack(dir: ttb, spacing: gap-structured-text,
    text(weight: "bold", "planner"),
    text(style: "italic", fill: hue.ink, "(agent)"),
    divider(hue: hue),
    grid(columns: 2, column-gutter: gap-cell, row-gutter: gap-structured-text * 2,
      text(fill: palette.ink-muted, "model:"),  raw("claude-sonnet-4.6"),
      text(fill: palette.ink-muted, "tools:"),  raw("web_search, execute_code"),
      text(fill: palette.ink-muted, "status:"), text(fill: palette.green.stroke, "\u{F00C} ready"),
    ),
  ),
)
```

The constraint on a mixed-run node is legibility — does the composed body read at a glance — rather than what the layout primitives allow.

## Encapsulation: containers with named inner nodes

Fletcher's `enclose:` parameter draws a container shape behind named inner nodes. The pattern lets external edges address inner nodes directly across the container boundary.

### The pattern

1. Give each inner node a name: `node((2, 0), "api", name: <api>)`.
2. Define a container node that lists the inner names: `node(enclose: (<api>, <worker>, <cache>), ...)`.
3. Edges from outside the container address inner nodes by name: `edge(<client>, <api>, ...)`.

```typst
diagram(
  spacing: (space-between-shapes * 1.4, space-between-ranks),

  // External caller
  human((0, 1), "client", <client>),

  // Inner nodes
  compute((2, 0), "api",    <api>),
  compute((2, 1), "worker", <worker>),
  compute((2, 2), "cache",  <cache>),

  // Container
  node(
    enclose: (<api>, <worker>, <cache>),
    align(top + left, text(weight: "bold", fill: palette.ink-muted, upper("RUNTIME"))),
    shape: fletcher.shapes.rect,
    fill: palette.surface-muted,
    stroke: stroke-thin + palette.border,
    inset: pad-inside-container,
    corner-radius: radius-container,
    snap: -1,
  ),

  // External persistence on the right
  persistence((4, 1), "store", <store>),

  // Cross-boundary edges
  query-edge(<client>, <api>,    label: [request]),
  query-edge(<api>,    <worker>, label: [enqueue]),
  query-edge(<worker>, <cache>,  label: [lookup]),
  event-edge(<worker>, <store>,  label: [persist]),
)
```

### Reading the container

The container is a **background rectangle, not a coordinate scope**. Inner nodes stay addressable from anywhere in the diagram by their `<name>` labels — the container is a visual hint that the names belong together, not a namespace.

This means:

- An edge from an external node to an inner node renders as one line crossing the container boundary. There's no automatic re-routing.
- Inner nodes can edge to other inner nodes; the edge stays inside the container visually.
- An inner node can edge to an external node; the edge crosses out.

### Container styling

Three things distinguish the container from a regular node:

| Parameter | Typical value |
|---|---|
| `fill` | `palette.surface-muted` — slightly off-canvas |
| `stroke` | `stroke-thin + palette.border` — thin and unobtrusive |
| `inset` | `pad-inside-container` — generous (~20pt) |
| `corner-radius` | `radius-container` — softer than entity nodes (~10pt) |
| `snap: -1` | renders behind the inner nodes — required so the container reads as background |

The container's body is typically a corner caption (`align(top + left, ...)`) labeling the container kind ("RUNTIME", "PIPELINE", "DEPLOYMENT").

### Cross-boundary edges

Edges that cross the container boundary render identically to edges that don't. The container is a background rectangle; edge styling depends on the relationship it carries, not on whether it crosses a boundary.

## Two-node container variant: header above inner shapes

The standard container pattern places the body content (the corner caption) *inside* the rect with `snap: -1`. That works for compact captions (a single short label like `RUNTIME`). It fails when the header content is rich enough — a glyph + title row + a description line — to be tall enough to land in the same vertical band as the inner shapes: with `snap: -1` the entire container, body included, renders behind the inner shapes, so the inner shapes paint over the header text.

**Workaround.** Split the container into two nodes that share inner-node membership:

1. **Foreground header** — a regular node at default layer, positioned spatially *above* the inner shapes. Body carries the header content. `fill: none, stroke: none, inset: 0pt` so it has no visible chrome of its own.
2. **Background container** — `enclose:` includes the header AND the inner shapes, body is empty (`[]`), `fill: <surface-muted>`, `snap: -1`. This draws the container rectangle behind everything, with its bounding box encompassing both the header and the shapes.

```typst
// Foreground header — sits at default layer above the inner shapes
node((header-x, header-y),
  stack(dir: ttb, spacing: gap-structured-text,
    grid(columns: (auto, auto), column-gutter: gap-cell, align: (left + horizon, left + horizon),
      text(size: 18pt, fill: palette.ink-muted, glyph),
      text(size: size-body, weight: weight-bold, fill: palette.ink, "Container Title"),
    ),
    text(size: size-label, fill: palette.ink, "Container description line."),
  ),
  shape: fletcher.shapes.rect,
  fill: none, stroke: none, inset: 0pt,
  name: <container-header>,
)

// Background container — fill only, snap behind, encloses header + inner nodes
node(
  enclose: (<container-header>, <inner-1>, <inner-2>, <inner-3>),
  name: <container>,
  [],
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: none,                       // fill-only treatment is common here
  inset: pad-inside-container,
  corner-radius: radius-container,
  snap: -1,
)
```

The header's coord (`header-x, header-y`) must place it spatially above the inner shapes — they don't overlap in y. The container's `enclose:` makes its bounding box span both, and `snap: -1` puts the rect behind every node, so the header text renders above the rect (foreground) and beside (not over) the inner shapes.

External edges that cross into the container can still address the inner nodes by name (or address the container via `<container>` for a "bundled to the group" semantic).

**When to use this variant**: header content is more than a single short label, or you specifically want the visible structure `[ Title / Description / inner shapes ]` rather than a corner caption. The standard pattern (body inside `snap: -1` container) remains correct for small corner captions.

**Limitation.** The two-node container works only when the header doesn't spatially overlap the inner shapes — the `snap: -1` container renders behind everything, so a header positioned in the same vertical band as the inner shapes ends up hidden behind them. If a future container needs a header that overlaps inner shapes vertically (a compact form factor), this remains an open thread; for now, give the header its own y-band above the inner content.

## Multi-domain band layout

When a diagram spans multiple security or organizational domains — public / IL4 transit / IL6 destination, or dev / staging / prod, or any pipeline that crosses environments — render each domain as a horizontal band using the two-node container pattern stacked. The boundary-crossing between bands becomes the focal element of the diagram.

```typst
// Each band: foreground header + background container with snap: -1.
// All bands share surface-muted fill for visual continuity; headers carry the band identity.

// Public band header
node((0, 0),
  stack(dir: ttb, spacing: gap-structured-text,
    text(weight: weight-bold, fill: palette.ink, "Public"),
    text(size: size-label, fill: palette.ink-muted, "github.com/example/project"),
  ),
  fill: none, stroke: none, inset: 0pt, name: <public-header>,
)
// inner shapes for public band at (1, 0), (2, 0), …
node(enclose: (<public-header>, <public-1>, <public-2>),
  [], fill: palette.surface-muted, stroke: none, snap: -1,
  inset: pad-inside-container, corner-radius: radius-container,
)

// IL4 transit band — same structure at row 2
// IL6 destination band — same structure at row 4
```

**Reading the bands.**

- All bands share `palette.surface-muted` fill so adjacent bands read as one diagram, not as competing regions. The visual continuity is what makes a single edge crossing two bands feel like a domain transition rather than a teleport.
- Headers differentiate bands. Title (band name) + a sub-label (the domain identifier — repository URL, environment name, security level) is the typical structure.
- Edges that cross band boundaries are the focal element. Trigger arrows passing *through* a header zone get masked by the header's opaque fill if the header has one; an `enclose:`-only header (no fill) lets the edge pass cleanly.
- Compliance-level labels (IL4, IL6, public) are standard public terminology for DoD impact levels — surface them when relevant; they are not sensitive content.

This generalizes to any pipeline that crosses environments, security perimeters, or organizational ownership boundaries. The `core/release.typ` diagram in the herald OV-1 briefing uses this pattern across three security-domain bands.

## Inline pills with optional discriminator marker

A pill-style inline element (rounded rectangle, hue-tinted, short label) is a compact way to surface a capability, attribute, or kind tag inside a node's body. When some pills carry an additional discriminating attribute (e.g., "this protocol supports streaming"), an optional inline glyph appended after the label distinguishes them without adding new pill colors or shapes.

```typst
#let cap(label, marker: false) = box(
  inset: (x: 10pt, y: 4pt),
  radius: 1em,
  fill: hue.fill,
  stroke: stroke-thin + hue.stroke,
  if marker {
    stack(dir: ltr, spacing: 6pt,
      text(size: size-label, weight: weight-body, fill: hue.ink, label),
      text(size: size-label, fill: hue.ink, glyph),  // e.g., "\u{F469}" for nf-oct-pulse
    )
  } else {
    text(size: size-label, weight: weight-body, fill: hue.ink, label)
  },
)
```

Usage:

```typst
stack(dir: ltr, spacing: gap-cell,
  cap("chat",       marker: true),    // marked
  cap("vision",     marker: true),    // marked
  cap("tools",      marker: true),    // marked
  cap("embeddings"),                  // no marker — discriminator absent
)
```

The marker glyph is the only visual difference between marked and unmarked pills; the label, hue, and shape stay constant. This keeps the inventory readable as one set with a sub-class, rather than two visually distinct sets the reader must reconcile.

**Choose a glyph that signals the attribute semantically.** `nf-oct-pulse` (`\u{F469}`) reads as "live data flow" / "streaming"; `\u{F00C}` (check) reads as "supported" / "enabled"; `\u{F0E7}` (bolt) reads as "fast" / "real-time". The glyph is a discriminator, not decoration — pick one whose silhouette communicates the attribute at a glance.

**Pills without markers stay pills, not omissions.** When a discriminator doesn't apply (the attribute is genuinely absent for that capability), render the pill without the marker rather than omitting it from the row entirely. Omission communicates "this capability isn't supported"; a markerless pill communicates "this capability is supported but lacks the discriminating attribute". The two are different signals; choose the one matching reality.

## Snap and layering

`snap: -1` on the container pushes it below the inner nodes. Without it, the container renders on top and obscures the inner content. Background containers always carry `snap: -1`.

For more general layer control, edges and nodes accept `layer: <int>`. Negative values render below default; positive above. Crossing edges that need explicit ordering (e.g., a "behind" edge differentiated from a "foreground" edge in a pair that cross) use explicit layer values.
