# Edges and marks

Edges connect nodes. Marks are the head/tail glyphs on edges. Together they carry the relationships in a diagram.

## Mark primitives

The visual library of head and tail glyphs Fletcher can render. Each shows in the table below as both a word form (when the parser accepts one) and an alias.

| Word form | Alias | Visual |
|---|---|---|
| `head` | `>` | classic arrowhead |
| `stealth` | `\|>` | filled stealth (default-feeling arrowhead) |
| `straight` | — | straight cap (no triangle) |
| `solid` | — | filled solid arrow |
| `bar` | `\|` | perpendicular bar — terminator / stop |
| `bar @60°` | `/` | tilted bar — slash terminator |
| `hook` | — | curved hook — soft return / yield |
| `circle` (small / large) | `o` / `O` | open circle — connector / association |
| `cross` (small / large) | `x` / `X` | crossbar — break / cancel |
| `square` | — | square block — terminator |
| `diamond` | — | diamond — composition (UML tradition) |
| `parenthesis` | — | parenthesis — soft enclosure |
| `bracket` | — | bracket — hard enclosure |
| `crowfoot` (many) | `n` | crowfoot — "many" cardinality (ER tradition) |

**Reading marks.** Each mark carries a visual signal:

- **`>` / stealth** — classic arrowhead, unambiguous direction.
- **bar (`-|`)** — perpendicular terminator, reads as "stops here" or boundary.
- **circle (`-o`)** — open endpoint, reads as soft connector or association.
- **crowfoot (`-n`)** — many-cardinality glyph from the ER tradition.
- **diamond** — composition / aggregation glyph from the UML tradition.

A typical diagram uses 1–3 mark types. Many distinct marks within one diagram fragments the visual vocabulary; multiple marks justify themselves only when each carries a distinct kind that the diagram needs to differentiate.

## Stroke styles

Five body styles compose with any head/tail:

| Style | Body character | Visual |
|---|---|---|
| `solid` | `-` | solid line — default |
| `double` | `=` | double line — emphasis, primary path |
| `dashed` | `--` | dashed — provisional, async, optional |
| `dotted` | `..` | dotted — most tentative |
| `wavy` | `~` | single tilde — irregular / uncertain |

Note: `~~` is *not* wavy; wavy uses a single `~`.

Combine body + head: `--|>` is dashed body + stealth head; `=>` is double body + plain head; `~>` is wavy body + plain head.

## Edge-kind encodings (illustrative — not rules)

Edges often split into kinds within a diagram. Visual weight (thickness, dash pattern, head, hue) composes to differentiate them. The mappings below are project choices that recur across diagram families; any diagram is free to remap.

| Kind | Encoding |
|---|---|
| query (read) | solid body, plain or stealth head, green hue |
| command (mutate) | thicker body or double body, stealth head, red hue |
| event (async / fire-and-forget) | dashed body, stealth head, yellow hue |
| data flow | solid body, plain head, blue hue, sometimes thicker |

A diagram about CRUD might map the same hues to (read, write, delete, list); a diagram about workflow might use them for (synchronous, async, optional, deprecated). The encoding follows the diagram's content, not a fixed schema.

## Routing

### Straight (default)

`edge(from, to, "->")` draws a straight line between the two endpoints. The default routing.

### Bend

`edge(from, to, "->", bend: 35deg)` curves the line. Positive bends left of a straight line from→to; negative bends right.

| Bend | Visual |
|---|---|
| `0deg` | straight (default) |
| `±15deg` | gentle curve |
| `±35deg` | clear arc |
| `±80deg` | strong arc — almost orthogonal feel |

Bends apply when straight routing collides with intervening nodes, when two parallel edges between the same nodes need to differentiate (one `+25°`, the other `-25°`, reads as bidirectional), or when the relationship has natural curvature (callbacks, returns).

### Waypoints

Pass intermediate coordinate tuples between the source and destination to step orthogonally:

```typst
edge((0, 0), (1, 0), (1, 2), (2, 2), "->", "step")
```

The polyline visits each tuple in order: start → first waypoint → next waypoint → … → destination. Useful for clean flowchart edges where a curved bend would feel out of place.

| Waypoints | Visual |
|---|---|
| `(0,0), (2,0), (2,2)` | right, then down |
| `(0,0), (0,2), (2,2)` | down, then right |
| `(0,0), (1,0), (1,2), (2,2)` | step (right-down-right) |
| `(0,0), (0,1), (2,1), (2,2)` | step (down-right-down) |

Add as many intermediate tuples as the path needs. Each segment between adjacent tuples is rendered as a straight line; consecutive tuples on the same axis produce orthogonal turns.

**Avoid the relative-direction string form** (`edge((0,0), "r,d", (2,2), "->")`) in Fletcher 0.5.x. It parses each direction component as a separate positional argument, which collides with positional labels (the parser confuses the label for an extra direction step) and can produce zero-length segments that trip a `Adjacent vertices must be distinct` assertion. Explicit coordinate tuples are the reliable canonical form. See `typst-diagrams/references/fletcher-pitfalls.md` for the full diagnostic.

### Self-loops

`edge(<r>, <r>, "->", bend: 138deg)` draws a self-loop — an edge from a node back to itself. Reads as cyclic, recursive, or self-referential.

The bend angle range that produces a clean loop: `(115°, 160°)`. Below 115° the loop hides inside the source node; at 180° the geometry diverges. 138° is a balanced midpoint.

### Layer order

Fletcher draws edges in source order. Use `layer: -1` on an edge or node to push it behind others — useful when a background-route edge shouldn't overdraw a foreground endpoint:

```typst
edge(<a>, <d>, "->",
  stroke: stroke-emphasis + palette.red.stroke,
  layer: -1,
  ...)
```

A negative `layer` value renders behind; `0` is default; positive renders on top. Crossing edges, background structural lines, and emphasized edges that need to read above visual chrome use explicit layer values.

## Label placement

Three controls:

| Parameter | Value | Effect |
|---|---|---|
| `label-pos` | `0.0`–`1.0` | position along the edge (0 = source, 1 = destination, 0.5 = midpoint) |
| `label-side` | `left` / `center` / `right` | which side of the line; `center` puts the label *on* the line |
| `label-sep` | distance | how far the label sits from the line |

```typst
edge(from, to, "->",
  text(weight: "bold", "label"),
  label-pos: 0.5,
  label-side: left,
  label-sep: 10pt,
)
```

**`label-pos`** — the default `0.5` collides with endpoints on short edges. `label-pos: 0.7` anchors near the destination; `0.3` near the source.

**`label-side: center`** — places the label on the line itself (the line breaks visually around the label region). Reads as a transformation on the edge ("authorised", "encrypted") rather than as an annotation about it.

**Mirrored label placement** — when two parallel-but-symmetric edges should carry their labels on the same visual side (e.g., two `imports` edges going up into a shared focal node from below-left and below-right), default placement isn't always symmetric. The default chooses a side relative to each edge's walk direction independently, which can put the labels on opposite visual sides. Override one of the two with explicit `label-side: left` (or `label-side: right`) to flip it onto the matching side.

```typst
// Two edges entering format from sub-modules below; both labels on the outside (visual west / east).
edge((0, 2), (0, 1), (1, 1), "->", lbl("imports"), label-side: left, ...)   // override flips to outside
edge((2, 2), (2, 1), (1, 1), "->", lbl("imports"), ...)                      // default already outside
```

The same override resolves "labels stack vertically with one inside the diagram" issues on shared-trunk forked edges — set the label side explicitly on whichever branch landed on the wrong side.

## Label fill

Use Fletcher's native `label-fill: <color>` parameter on the edge, not a custom `box(fill: surface, ...)` wrapper:

```typst
edge(from, to, "->",
  label-fill: palette.surface,
  text(weight: "bold", "label"),
)
```

A custom wrapper produces unwanted artifacts in some themes. Native parameter eliminates the issue.

## Mid-edge marks

A mark placed mid-line, separate from head/tail. The edge carries directionality (via head/tail) and a categorical mid-line hint simultaneously:

```typst
edge((0, 0), (1, 0), "-|>-")
```

The two `-` flank an internal mark (`|>` for stealth, `>` for head, `o` for circle, `|` for bar). Mid-marks differentiate edge kinds within a single routing pattern without shifting the directional indicator.

## Parallel edges

Two edges between the same endpoints, with opposite bends, separate visually so the pair reads as two distinct relationships:

```typst
edge((0, 0), (1, 0), "->", bend: +25deg, label-fill: palette.surface,
  text(weight: "bold", "request"))
edge((0, 0), (1, 0), "->", bend: -25deg, label-fill: palette.surface,
  text(weight: "bold", "response"),
  stroke: (paint: palette.yellow.stroke, dash: "dashed"))
```

The bend separation reads as bidirectional — one relationship in each direction. Without the separation, two edges between the same endpoints overlap and the visual collapses.

## Vertical fan-out from a focal node

When a focal node writes to (or reads from) several destinations in parallel — a service writing to both a blob store and a database, a registry handling reads from three callers — stack the destinations vertically at the same x-coord and let edges fan out from the source's shared anchor. Fletcher routes each edge to its destination's y without crossings.

```typst
// Focal node at (0, 0); destinations stacked at column 1.
node((0, 0), "service",   <svc>)
node((1, -1), "blob",     <blob>)
node((1,  0), "database", <db>)
node((1,  1), "queue",    <queue>)

edge(<svc>, <blob>,  "->", "store object")
edge(<svc>, <db>,    "->", "persist record")
edge(<svc>, <queue>, "->", "publish event")
```

The destinations' divergent y-positions force the edges to take distinct paths; they share the source anchor so the fan-out reads as "one origin, many sinks" cleanly. Works equally well with the source on the right and destinations to its left (mirrored).

## Conditional fork-and-rejoin

State graphs with branches use stroke style to differentiate unconditional from conditional transitions:

- **Solid** body for unconditional transitions (state `A` always proceeds to state `B`).
- **Dashed** body for conditional fork branches (state `A` proceeds to either `B` or `C` depending on a guard).
- A short label on each conditional edge names the guard (`if any flagged`, `if no flag`).

```typst
edge(<analyze>, <classify>, "->", "")                    // unconditional next
edge(<analyze>, <re-render>, "-->", "if any flagged")    // conditional fork
edge(<analyze>, <classify>,  "-->", "if no flag")        // conditional fork
```

When two conditional edges share endpoints, give one of them a slight `bend: 25deg` so the labels don't collide at the midpoint.

## Return-edge pattern

For acknowledgements, responses, or callbacks that shouldn't compete visually with the forward flow they answer, use a dashed body, a slight bend, and corner anchors that route the edge below (or above) the forward edge:

```typst
edge(<client>, <server>, "->", "request")
edge(<server>.south-east, <client>.south-west, "-->", "ack",
  bend: 25deg, label-fill: palette.surface)
```

The dashed body marks the edge as a return rather than a forward step; the bend pulls it visually clear of the forward edge it pairs with; the corner anchors (`south-east` / `south-west`) route the curve cleanly below the nodes rather than overlapping their bodies. The bend sign convention is: positive bends toward larger y (down on the default top-origin canvas); flip-test on first render.
