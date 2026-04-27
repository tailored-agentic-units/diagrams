# Fletcher pitfalls

Version-specific gotchas in Fletcher 0.5.x and the patterns that work around them. Reach here when something doesn't render the way the source suggests it should.

## Self-loop circular extent (auto-page-height blow-up)

**Symptom.** A diagram with `edge((0,0), (0,0), bend: …)` inside a document that uses `set page(height: auto)` produces a wildly oversized SVG (page height around 4×10¹⁷pt). Visible content is compressed to invisibility; the file looks blank.

**Cause.** Fletcher computes self-loop extent relative to the page height; `height: auto` makes the page height a function of content height; the two diverge in fixed-point iteration.

**Workaround.**

1. Give the loop endpoint a name: `node((0, 0), [reading], name: <r>)`, then `edge(<r>, <r>, "->", bend: …)`. Self-loops via positional `(0, 0) → (0, 0)` don't reliably resolve.
2. Wrap the loop's `diagram(...)` inside a fixed-size `box(width: …, height: …, clip: true)`. The fixed dimensions break the circular dependency.

```typst
box(width: 240pt, height: 180pt, clip: true,
  diagram(
    spacing: (60pt, 60pt),
    node((0, 0), [reading], name: <r>),
    edge(<r>, <r>, "->", bend: 150deg),
  ),
)
```

## Self-loop bend angle range

**Symptom.** A self-loop with `bend: 180deg` collapses (loop diameter approaches infinity); at very small bends (<115°) the loop hides inside the source node.

**Workaround.** Stay in the practical range `(115°, 160°)`. The midpoint (~138°) gives a balanced loop.

## `repr()` of unicode-escape strings

**Symptom.** `repr("\u{F00C}").slice(3, 7)` returns `{f00`, not `f00c`.

**Cause.** `repr()` on a single-codepoint string returns a 10-char form `"\u{f00c}"` (literal quotes + `\u{` + 4 hex + `}`). Indices 0–2 are `"\u`, index 3 is `{`, the hex starts at index 4, the closing `}"` is the last 2 chars.

**Workaround.** Slice from index 4 to `len() - 2` for robustness across hex lengths:

```typst
let r = repr(codepoint)
let hex = upper(r.slice(4, r.len() - 2))
```

## let-rebind inside an if-block

**Symptom.** A `#let` variable conditionally reassigned inside `if … { x = … }` doesn't propagate the new value when read later in the same function body. Cells that depend on the rebound value silently render in their pre-condition state.

**Workaround.** Use immutable conditional bindings instead of mutation:

```typst
// Don't:
let s-color = base-color
if faded { s-color = base-color.lighten(60%) }

// Do:
let s-color = if faded { base-color.lighten(60%) } else { base-color }
```

Reach for this any time a cell renders in the wrong state — it's almost always a mutation that didn't propagate.

## Fletcher mark word-form coverage

**Symptom.** `edge(a, b, "-round")` errors with `Invalid marks shorthand`.

**Cause.** Fletcher's mark parser accepts word forms only for primitives explicitly registered with that name. Defined primitives `round` and `origin` are accessible only via aliases, not word form.

**Word forms that parse:** `head`, `straight`, `solid`, `stealth`, `bar`, `hook`, `circle`, `square`, `diamond`, `cross`, `bracket`, `parenthesis`, `crowfoot`.

**Aliases:** `>` head, `<` rev-head, `|>` stealth, `<|` rev-stealth, `|` bar, `/` bar@60°, `o` / `O` circle small/large, `x` / `X` cross small/large, `n` crowfoot-many.

**Stroke-body characters:** `-` solid, `=` double, `--` dashed, `..` dotted, `~` wavy. `~~>` does **not** parse — wavy uses a single `~`.

## `show raw:` rules are document-scoped

**Symptom.** A `show raw: ...` rule placed inside a function body or a `let` binding doesn't apply to raw spans rendered outside that scope.

**Cause.** Typst show rules apply only within their lexical scope. They don't survive a function boundary.

**Workaround.** Declare `show raw:` rules at the top level of the document (or wherever scope encompasses every raw span the rule should affect):

```typst
#show raw: r => text(fill: palette.accent.stroke, r)
```

This pattern is also the typical way to differentiate `raw()` content from prose when both render in the same font family — a tinting rule on raw spans gives code a visual marker.

## Edge label position can collide with endpoints

**Symptom.** With `label-pos: 0.5` (default) on a short edge between adjacent shapes, the label visually sits inside or overlaps one of the endpoint shapes.

**Workaround.** Parameterize `label-pos` per call site so each edge can position its label appropriately. `label-pos: 0.7` anchors near the destination; `0.3` near the source.

```typst
let event-edge(from, to, label: none, label-pos: 0.5) = edge(from, to, "->",
  stroke: …,
  text(weight: "bold", label),
  label-side: left,
  label-sep: 10pt,
  label-pos: label-pos,
)
```

`label-sep` below 6pt produces visible crowding between the label and the edge line.

## Edge label fill: native parameter, not a custom box

**Symptom.** Wrapping an edge label in a `box(fill: surface, ...)` produces an unwanted white border in dark mode. The wrapper renders correctly, but Fletcher's auto-wrap renders an outer rectangle at hardcoded white *outside* the custom box.

**Workaround.** Use Fletcher's native `label-fill: surface` parameter on the edge, not a custom box:

```typst
edge(from, to, "->",
  label-fill: palette.surface,
  text(weight: "bold", "label"),
)
```

## Typst SVG always emits fixed pt dimensions

Typst's `compile … out.svg` always emits `<svg viewBox="…" width="900pt" height="1234.5pt" …>`. The fixed dimensions prevent responsive scaling when embedded via `<img width="100%">`; the viewBox carries the aspect ratio. See [render-pipeline](render-pipeline.md) for the strip pattern and the static / responsive distinction.
