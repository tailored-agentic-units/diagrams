# Text and space

Typography controls and whitespace primitives — the substrate every other ingredient sits on.

## Typography axes

A diagram has five text-shaping axes. They compose orthogonally; pick what each label needs.

### Size

Five steps cover the typical diagram:

| Token slot | Role |
|---|---|
| `size-label` | kind annotations, footnotes, captions on small elements |
| `size-caption` | container titles, metadata, notes |
| `size-body` | default label text, field names, enum values |
| `size-title` | entity names in bold |
| `size-heading` | diagram titles |

The size scale is multiplicative: each step ~1.1–1.2× the previous. One size carries the default for body content; adjacent sizes express promotion or de-emphasis.

### Weight

Three cuts:

| Token slot | Role |
|---|---|
| `weight-light` | de-emphasized annotations, kind tags, parenthetical metadata |
| `weight-body` | default body text |
| `weight-bold` | titles and emphasis |

Weight changes emphasis without shifting vertical metrics, so it composes cleanly with size + style without spacing artifacts.

### Style

Italic is a style; combine with weight freely (`text(weight: "semibold", style: "italic", ...)`). Italics work well for kind annotations in parentheses (`(persistence)`, `(human)`) and for inline emphasis without claiming the visual weight of bold.

### Decoration

Underline, overline, strike, highlight. These overlay on any size + weight + style combination. Use sparingly — decoration competes with stroke colors for attention.

- **Underline** is the link-affordance default. Pair with a hue (`palette.<hue>.stroke`) so the link reads as a link in both browser-rendered and accessibility contexts.
- **Strike** indicates removed or deprecated content in change diagrams.
- **Highlight** with a `palette.<hue>.fill` background tints a run, marking a span without restructuring the surrounding content.

### Tracking (letter-spacing)

Default kerning works for most label sizes. Open the tracking up for two cases:

- **All-caps captions** at any size — `tracking: 0.05em` to `0.10em`.
- **Very small labels** (≤8pt) — `tracking: 0.05em` improves legibility.

## Color hierarchy

Three levels of neutral ink layered on top of size + weight give smooth de-emphasis:

| Token slot | Role |
|---|---|
| `palette.ink` | primary — titles, body, must-read content |
| `palette.ink-muted` | secondary — captions, metadata, kind labels in neutral context |
| `palette.ink-subtle` | tertiary — de-emphasis, placeholders, hex values |

When a label sits on a hue-tinted fill, the chromatic ink in the same hue family (`palette.<hue>.ink`) keeps the label inside the hue family — neutral `ink-muted` over a tinted background reads as visually disconnected.

## Mixed-style runs

Inline composition switches style mid-content:

```typst
[Regular text with #text(weight: "semibold")[a bold word] and #text(style: "italic")[an italic phrase].]
```

A single inline emphasis fits as a `#text(...)[...]` switch within the run. Title + kind on separate lines composes via `stack(...)`.

## Inline math

Math content (`$ ... $`) embeds anywhere content is expected. Useful when a node represents a formula, capacity, or rate expression:

```typst
$r <= 100 "req/s"$
$sum_(i=0)^n t_i$
$n = 64$
```

Color a math expression by wrapping in `text(fill: ...)`.

## Inline code

`raw(...)` and backtick spans mark code-style content. When prose and code share a font family, code requires a fill color to read distinctly from prose. The hue choice is per-diagram.

## Whitespace primitives

Whitespace token slots are named by the relationship they govern, not by where they appear. The inventory:

| Token slot | Governs |
|---|---|
| `pad-inside-shape` | label ↔ shape boundary (Fletcher's `inset:` parameter) |
| `pad-inside-container` | container boundary ↔ inner content |
| `space-between-shapes` | horizontal node spacing (Fletcher diagram cell width) |
| `space-between-ranks` | vertical node spacing (Fletcher diagram cell height) |
| `gap-structured-text` | stack lines inside a label (e.g., title + kind) |
| `gap-cell` | columns or rows in a field grid inside a node |
| `label-sep` | edge label ↔ edge line distance |

Relationship constraints between slots:

- `space-between-ranks` ≈ 3–4× `pad-inside-shape` so ranks read as separate visual units.
- `gap-cell` is a within-node gutter, smaller than `space-between-shapes` (a between-node gap).

## Composition primitives

Three primitives compose almost any diagram body:

| Primitive | Use |
|---|---|
| `stack(dir: ttb, spacing: <gap>, ...)` | vertical sequence of items with a uniform gap |
| `grid(columns: ..., column-gutter: ..., row-gutter: ..., ...)` | 2D layout — field tables, name-value pairs |
| `block(width: ..., inset: ..., fill: ..., radius: ..., ...)` | a boxed region with padding / fill / radius — header bars, side panels |

`align(<alignment>, <content>)` aligns content within its containing region; `place(<alignment>, <content>)` positions absolutely without participating in flow. `place` carries corner ribbons and badges that overlay a node body.

`box(width: ..., height: ..., clip: ..., ...)` is the inline equivalent of `block`. Useful when a region needs explicit dimensions — most prominently as the wrapper that breaks Fletcher's self-loop / auto-page-height circular dependency.
