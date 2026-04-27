# Tokens pattern

A tokens module is a single source of truth for **non-color** design values. Diagrams import it and reference values by name; no inline `pt` literals, no hard-coded hex colors anywhere outside the design layer.

## Token scope

A tokens file holds four categories of pure value:

- **Whitespace** — paddings, gaps, separations between visual elements.
- **Typography scale** — font name, size scale, weight names.
- **Stroke widths** — thin, default, emphasis.
- **Geometry** — corner radii, label-to-line separation, anything dimensioned.

Color sits in the theme module rather than the tokens file so it can swap by theme.

Tokens are role-named (`stroke-emphasis`, `pad-inside-shape`), not use-named (`headline-stroke`, `code-padding`). A use-named token binds a value to a domain meaning, which doesn't transfer across projects.

Composition rules are not tokens. "Every shape uses `inset = pad-inside-shape`" is a convention enforced at point of use, not a value inside the tokens dictionary.

## Naming pattern

Pair a category prefix with a role suffix. The result reads as a value, not as a directive:

| Category | Examples |
|---|---|
| `pad-` | `pad-inside-shape`, `pad-inside-container` — interior padding |
| `space-` | `space-between-shapes`, `space-between-ranks` — space between sibling elements |
| `gap-` | `gap-structured-text`, `gap-cell` — fine-grained gaps inside structured content |
| `size-` | `size-label`, `size-caption`, `size-body`, `size-title`, `size-heading` — typography scale |
| `weight-` | `weight-light`, `weight-body`, `weight-bold` — typography weights |
| `stroke-` | `stroke-thin`, `stroke-default`, `stroke-emphasis` — stroke widths |
| `radius-` | `radius-shape`, `radius-container` — corner radii |
| `label-` | `label-sep`, `label-size` — edge label specifics |

The naming is descriptive (what this token *is*) rather than prescriptive (where it *must be used*). Diagram authors can repurpose `pad-inside-shape` for any padding-inside-a-shape context, even if their shape isn't the canonical "shape."

## Module shape

A single dictionary export keeps the import surface tight:

```typst
#let tokens = (
  // ---- whitespace ----
  pad-inside-shape:       10pt,
  pad-inside-container:   20pt,
  space-between-shapes:   28pt,
  space-between-ranks:    36pt,
  gap-structured-text:    5pt,
  gap-cell:               14pt,

  // ---- typography ----
  font:           "<font name>",
  size-label:     9pt,
  size-caption:   10pt,
  size-body:      11pt,
  size-title:     13pt,
  size-heading:   15pt,
  weight-light:   "light",
  weight-body:    "regular",
  weight-bold:    "semibold",

  // ---- stroke widths ----
  stroke-thin:      0.8pt,
  stroke-default:   1.2pt,
  stroke-emphasis:  2pt,

  // ---- shape geometry ----
  radius-shape:     6pt,
  radius-container: 10pt,

  // ---- edge labels ----
  label-sep:        10pt,
  label-size:       9.5pt,
)
```

Diagrams import as `#import "../design/tokens.typ": tokens` and reference as `tokens.pad-inside-shape`.

## Calibration

Token values are tuned to the diagram density and target output medium. A few heuristics:

- **`pad-inside-shape`** in the 8–12pt range reads as "comfortable but not loose" for typical label sizes. Below 6pt feels cramped; above 16pt feels balloon-y.
- **`space-between-ranks`** should be ~3–4× `pad-inside-shape` so the eye registers separate ranks rather than one continuous block.
- **`gap-cell`** in the 12–16pt range works for typical field-list grids. Tighter than `space-between-shapes` because it's gutters within a node, not between nodes.
- **`label-sep`** at 10pt keeps edge labels from kissing the line. Below 6pt the label crowds; above 14pt it floats too far.

These are starting points. Calibrate against actual rendered diagrams, not against pixel counts.

## Adding a token

When a diagram needs a value the tokens file doesn't expose, the order of operations is:

1. If the value is a color, it belongs in the theme module, not tokens.
2. If an existing token covers the role, use the existing one. New tokens whose role overlaps an existing one fragment the system; the fix for "this rank-spacing felt wrong" is usually elsewhere (label size, fill contrast), not a new token.
3. A new token is justified once the value recurs across multiple diagrams. A one-off uses an inline literal with a comment naming the reason.
4. Name by what the value *is*, not where it's used. `radius-corner-soft` describes the value; `radius-cluster-header` describes a use site.

A useful check on a candidate token: would a different project reusing this design system also want it? If yes, the token belongs in the foundation. If no, it's a project-specific value and stays in the project.

## Pure values, not behavior

A tokens file should never contain functions, conditionals, or imports of other modules. It's a static dictionary. If you find yourself wanting `if theme == "dark" { 1pt } else { 0.8pt }`, you're conflating tokens with theme — restructure so tokens hold values and the theme decides which value to apply.
