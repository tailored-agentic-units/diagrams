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

**Mirrored L-shapes with the same first-segment direction.** Fletcher's auto `label-side` for a polyline edge resolves against the *first* segment's tangent θ — the auto-rule is `right` when `|θ| ≥ 90°` (vertical) and `left` otherwise. Two mirrored L-shapes that *start* with the same direction (e.g., both go south, then one turns east and the other turns west) auto-resolve to the same `label-side` value — which is correct for one L but inverted relative to the corner of its mirror. The result: one label sits in the open quadrant outside the L's angle, the other crowds against whatever the L is turning toward. Override the mirror's `label-side` to the opposite value:

```typst
// Provider edge (south → east) — auto picks label-side: right → label sits west of the corner (open NW quadrant).
edge((1, 1.4), (1, 2.4), (2, 2.4), "->", lbl("Create()"), ...)

// Format edge (south → west, mirror of provider) — auto would *also* pick label-side: right,
// landing the label west of *its* corner (crowding the central focal node).
// Override to label-side: left so the label sits east of the corner (open NE quadrant).
edge((3, 1.4), (3, 2.4), (2, 2.4), "->", lbl("Create()"), label-side: left, ...)
```

The rule of thumb: `label-side` describes which side relative to *walking the edge from base to tip*, not absolute image-space. For a mirror, walking direction is the same for both first segments, so the "same side" semantically means *opposite* visual positions of the L's corner.

**Center-overlay when both sides are occupied.** When an edge sits between two other labeled edges (e.g., a straight vertical between two diagonals, all converging on a common target), the left and right sides of the centre edge are both visually claimed by the flanking labels. Use `label-side: center` to place the label directly on the line — Fletcher draws the label-fill underneath, breaking the line visually around the label box. Reads as a passive annotation about the edge rather than a sidecar.

```typst
// cfg flows straight down between two Create() diagonals — left and right are taken;
// the centre overlay keeps the label readable without crowding either flank.
edge((2, 1), (2, 3), "->", lbl("cfg (passed through)"),
  label-side: center, label-fill: palette.surface, ...)
```

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

## Vertical-stack layout for verbose edge labels

When card-to-card relationships need verbose descriptive labels (e.g., `embedded — supplies Method() · OtherMethod()`, `Prepare* methods produce *Output`), a horizontal layout often crowds the labels: each edge runs through the narrow gap between adjacent cards, the label centers on the path, and any text wider than the gap overlaps a neighbour. Stacking the cards in a single column and using `label-side: right` (or `left`) pushes the label into the empty horizontal space beside the vertical edge — no neighbour competes for that space:

```typst
diagram(
  spacing: (space-between-shapes, space-between-ranks),

  card((0, 0), purple, "Source",  "struct",    <fields-A>),
  card((0, 1), blue,   "Focal",   "interface", <fields-F>),
  card((0, 2), purple, "Output",  "struct",    <fields-O>),

  edge((0, 0), (0, 1), "->",
    text(style: "italic", "embedded — supplies Method() · OtherMethod()"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 1), (0, 2), "->",
    text(style: "italic", "OtherMethod produces Output"),
    label-side: right, label-fill: palette.surface, stroke: edge-stroke),
)
```

The trade-off is vertical extent: the diagram grows taller in proportion to the number of cards. For two or three related cards with verbose labels, vertical stacking is cleaner than fighting horizontal space; for many cards or short labels, horizontal layout reads more naturally.

Useful when:

- A focal type has 2–3 related helpers, outputs, or inputs that each need a descriptive relationship label
- Edge labels cannot be shortened without losing semantic content
- The diagram has narrow horizontal columns that can't spare more space for label runs

Pairs with the [`Edge label position` pitfall](../../typst-diagrams/references/fletcher-pitfalls.md) — vertical stacking is one of the structural fixes when labels exceed available segment length.

## Convergent-edges tree (N sources → 1 target via shared trunk)

When N sources share an identical relationship to a single target — N implementations of an interface, N call sites delegating to a shared dependency, N sub-types inheriting from a parent — drawing N independent diagonal edges fans into a tangle that obscures the relationship rather than showing it. Replace with N orthogonal edges that share a *trunk* segment near the target: each edge takes a 4-vertex path (source → leg → rail → trunk → target) and the trunk plus the inner part of the rail overlap pixel-for-pixel across edges, rendering as one tree branching out to N leaves.

```typst
// 4 sources at row 1 (cols 0..3); 1 target at row 0 col 1.5
// Each edge: source → up to rail at row 0.5 → along rail to col 1.5 → up trunk to target
edge((0, 1), (0, 0.5), (1.5, 0.5), (1.5, 0), "-->", lbl("implements"),
  label-pos: 0.85, label-fill: palette.surface, stroke: edge-stroke)
edge((1, 1), (1, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke)
edge((2, 1), (2, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke)
edge((3, 1), (3, 0.5), (1.5, 0.5), (1.5, 0), "-->", stroke: edge-stroke)
```

The shared `(1.5, 0.5) → (1.5, 0)` trunk segment is drawn 4 times by 4 edges; they overlap pixel-for-pixel and read as one line. The rail at row 0.5 overlaps partially across edges — segments closer to the trunk overlap, segments closer to a leg are unique to one edge. Four arrowheads stack at the target's boundary and read as one. Only the leftmost edge carries the shared label; with `label-pos: 0.85` it lands on the trunk where the four edges merge — exactly the point that makes "branches into one trunk" legible.

Tune `label-pos` based on segment lengths: the trunk is segment 3 of 3, so values near `1.0` land on the trunk near the target end, while `0.7`–`0.85` typically sits mid-trunk for balanced spacing between target and rail. Row spacing matters — when the gap between the source row and target row is small, the trunk + rail are short and the label crowds the target; bump row spacing (`* 1.5`–`* 2.5`) until the trunk has room for the label without hugging the target shape.

The pattern works in either direction (sources above target with trunk going down, or sources below target with trunk going up) and applies to any uniform relationship: `implements`, `delegates to`, `extends`, `subscribes to`, `routes through`. When two such relationships exist between the same source set and different targets — e.g., N types `implements` an interface above AND `delegates to` a shared dependency below — draw two independent trees, each with its own line style (dashed / solid) so they read as distinct relationships sharing the same source set.

## L-shape edges with labels in corner whitespace

When a wide label needs to ride an edge between two cards on the same row (or column) and the gap directly between them is narrower than the label, placing the label mid-edge clips its content. An L-shaped edge route opens an unobstructed *corner* whitespace for the label.

Configure the edge as a 3-vertex polyline that exits the source perpendicular to the source-target axis, runs orthogonally to align with the target, then turns toward the target's edge. The two segments form an L; the label rides whichever segment sits in the cleaner corner.

```typst
// Source at (0, 0), target at (2, 1). Edge: vertical down then horizontal right (L-shape).
// Label sits east of the vertical segment, in the corner rectangle between cols 0 and 2.
edge((0, 0), (0, 1), (2, 1), "->", lbl("modifies state"),
  label-pos: 0.18, label-side: left, label-fill: palette.surface, stroke: edge-stroke)
```

`label-pos` controls which segment carries the label. With segment lengths `L1` (vertical) and `L2` (horizontal), `label-pos ≈ L1/(2·(L1+L2))` lands the label mid-vertical; values approaching `1.0` push it onto the horizontal segment. `label-side` then chooses which side of that segment — the rule is "side relative to direction of travel": going *south*, `left` = east; going *north*, `left` = west; going *west*, `left` = south; going *east*, `left` = north. Pick the side that opens onto unoccupied corner whitespace.

Useful when:
- A wide label exceeds the gap directly between source and target cards
- One card in the pair is much taller or wider than the other (mid-edge collides with the larger card's body)
- Multiple cards on the same row force a label into a narrow corridor that clips its text

Trade-off: L-shaped edges read as more deliberate routing than straight edges; reserve for cases where a straight or single-bend edge would clip a label or collide with a card body. Pairs with the [`Edge label position` pitfall](../../typst-diagrams/references/fletcher-pitfalls.md).

**Variant: focal card with row-1 siblings.** A common composition has a focal card spanning row 0 and two or more sibling cards on row 1 to its left and right. Diagonal edges from the focal card to each sibling cross awkwardly through the diagram's center and land at the sibling's top-left or top-right corner; an L-shape that *exits the focal card's east or west center face*, traverses row 0's whitespace horizontally, then turns south at the sibling's column to *land on the sibling's top center face* reads as a deliberate outflow channel and aligns the bends symmetrically when both siblings receive the same kind of edge:

```typst
// StateGraph at (1, 0); siblings State at (0, 1), CheckpointStore at (2, 1).
// Each L goes horizontal-then-vertical via the row-0 bend point in the sibling's column.
edge((1, 0), (0, 0), (0, 1), "->", lbl("Execute · Resume flow"),
  label-pos: 0.3, label-fill: palette.surface, stroke: edge-stroke)
edge((1, 0), (2, 0), (2, 1), "->", lbl("save every Interval"),
  label-pos: 0.3, label-side: left, label-fill: palette.surface, stroke: edge-stroke)
```

`label-pos: 0.3` pins each label to the horizontal segment (the row-0 whitespace) instead of the corner. `label-side` mirrors between the two L's — segment 0 directions are opposite (west vs. east), so the same vertical side (e.g., south) requires opposite `label-side` values on each edge. The pattern reads as a *fan-out from a focal entity into named sibling responsibilities* and pairs naturally with the [Mirrored L-shapes with same first-segment direction](#label-placement) caveat documented above when the two outflows happen to start in the same direction.
