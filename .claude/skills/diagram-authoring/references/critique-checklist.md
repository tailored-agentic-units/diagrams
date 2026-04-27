# Critique checklist

Heuristics for self-critiquing a draft before user review. Apply each check; address failures before showing the user.

## Concept and audience

- **One concept?** Could you summarize the diagram's purpose in a single sentence? If not, it's trying to express two concepts; decompose.
- **Audience-appropriate density?** Could the intended reader absorb everything in 30 seconds? More is too much; less is wasted real estate.
- **Removing the diagram makes the surrounding text harder to follow?** If yes, the diagram earns its keep. If no, the prose is doing the work — the diagram is decoration. Cut it or make it carry weight.

## Identity and metadata

- **Shape carries identity?** Does the kind of each entity register from its shape alone, before reading any text?
- **Text carries metadata?** Names, kinds, fields — these belong inside the shape. Captions outside the shape that should be metadata inside it indicate misallocation.
- **Title vs kind distinguished visually?** Title and kind annotation differ in weight and size, not just position. Merging them into one undifferentiated string flattens the hierarchy.

## Visual weight

- **Heavy elements claim attention proportional to their importance?** If the most important node looks the same as the supporting cast, the diagram's argument flattens. Promote the headline.
- **No element claims attention disproportionately?** Conversely, a node visually dominating without earning it (very thick stroke, very saturated fill) hijacks attention from the diagram's actual point.
- **Hue density appropriate?** A diagram with too many hues looks like a chart of hues, not a map of relationships. Three or four hues is usually enough; five or six start to fragment.

## Edges and routing

- **Each edge kind has a clear visual?** Reader can tell at a glance whether an edge represents a query, command, event, or whatever else without reading labels.
- **Labels readable?** Edge labels don't collide with shapes; positioning and background fill keep them legible against the line and surrounding nodes.
- **Routing doesn't crowd?** No edges crossing more than necessary; no edges piling up parallel to one another without intentional separation.
- **Self-loops render cleanly?** The bend angle is in a range that produces a balanced loop rather than a degenerate one.

## Containers and groupings

- **Container boundary earns its place?** A container is heavy chrome; it earns its place when the boundary itself matters (encapsulation, deployment, runtime). When the only intent is "these belong together," hue grouping carries the same signal at lower visual cost.
- **Inner nodes still addressable?** External edges can cross into the container without the routing breaking down.
- **Container renders behind its members?** Layer order keeps the container as a background, not an occluding overlay.

## Color and theme

- **Both themes render correctly?** Render light and dark; check both. Faded states sometimes look correct in one and wrong in the other.
- **Hue assignments don't conflict within the same diagram?** The same hue used for two unrelated meanings (e.g., red for both "danger" and "command") collapses the visual distinction.
- **Faded states recede in both themes?** A faded state should read as backgrounded in both light and dark; lightening a dark-mode fill makes it more prominent, the opposite of the intent.

## Typography

- **Single font throughout?** No accidental font fallback (check the rendered SVG visually for metric shifts).
- **Code reads distinctly from prose?** When prose and code share a font family, code spans need a visual marker (typically a fill color) to differentiate.
- **Sizes are token-driven?** No inline `pt` literals that bypass the design-system scale.

## Render hygiene

- **Static vs responsive intent matches the embedding?** Diagrams designed at a fixed scale render with their pt-dimensions preserved; diagrams meant to scale to a container have those dimensions stripped.
- **No off-canvas content?** Nothing rendered outside the page bounds (the rendering stack silently clips, but the diagram is incomplete).
- **No stale rendering?** When the source changed, the rendered output reflects it before review.

## Source materials

- **Diagram derives from intent, not from source-code structure?** Five-modules-five-rectangles is rarely the right shape; check that the visual structure reflects what the diagram is *for*, not just what's *there*.
- **Contradictions resolved?** If the gathering surfaced contradicting source materials, the diagram should commit to one truth; don't render both.

## Sketch alignment

- **Diagram matches the sketch?** Every entity, relationship, and grouping from the sketch should be present (or explicitly dropped during composition with reason).
- **No accidental additions?** New entities or relationships introduced during composition that weren't in the sketch — was that intentional? If so, update the sketch; if not, drop them.

## When critique surfaces a problem

Critique findings fall into three remediation levels:

1. **Local fix** — adjust visual weight, hue, label, or routing. The structure is right; presentation needs tuning.
2. **Recompose** — return to the compose step; the structure is right but the ingredient choices don't carry the meaning. Pick different ingredients.
3. **Redesign** — return to sketch; the structure was wrong. Re-gather, re-sketch.

A recompose-level problem patched with a local fix produces an incoherent diagram — details individually plausible, the whole reading muddled. The remediation level matches the problem level.
