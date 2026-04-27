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

## Snap and layering

`snap: -1` on the container pushes it below the inner nodes. Without it, the container renders on top and obscures the inner content. Background containers always carry `snap: -1`.

For more general layer control, edges and nodes accept `layer: <int>`. Negative values render below default; positive above. Crossing edges that need explicit ordering (e.g., a "behind" edge differentiated from a "foreground" edge in a pair that cross) use explicit layer values.
