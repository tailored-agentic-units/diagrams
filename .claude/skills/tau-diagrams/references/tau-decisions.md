# TAU decisions

The opinionated choices that turn the four lower skills into a coherent TAU diagram standard. Each decision references the lower-skill pattern it's an instance of.

## Palette: GitHub Primer

TAU's palette traces to **GitHub Primer** primitives (primer.style). Eight chromatic hues + neutrals, color-anchored.

The eight chromatic hues:

| Hue | Light stroke | Light fill | Light ink | Dark stroke | Dark fill | Dark ink |
|---|---|---|---|---|---|---|
| `blue` | `#0969DA` | `#DDF4FF` | `#033D8B` | `#388BFD` | `#051D4D` | `#80CCFF` |
| `green` | `#1A7F37` | `#DAFBE1` | `#044F1E` | `#3FB950` | `#003D16` | `#6FDD8B` |
| `yellow` | `#9A6700` | `#FFF8C5` | `#633C01` | `#D29922` | `#4D2D00` | `#EAC54F` |
| `orange` | `#BC4C00` | `#FFF1E5` | `#762C00` | `#DB6D28` | `#3D1300` | `#FFB77C` |
| `red` | `#CF222E` | `#FFEBE9` | `#82071E` | `#F85149` | `#660018` | `#FFABA8` |
| `purple` | `#8250DF` | `#FBEFFF` | `#512A97` | `#AB7DF8` | `#271052` | `#D8B9FF` |
| `pink` | `#BF3989` | `#FFEFF7` | `#772057` | `#FF80C8` | `#611347` | `#FFADDA` |
| `coral` | `#C4432B` | `#FFF0EB` | `#801F0F` | `#FD8C73` | `#691105` | `#FFB4A1` |

Each hue exposes the four-attribute quad (`stroke`, `fill`, `ink`, `divider`) per the design-system pattern. `divider` derives as a 50/50 mix of fill and stroke; the constructor `_hue(stroke:, fill:, ink:)` lives in `~/tau/diagrams/design/theme.typ`.

Neutrals (light → dark):

| Token | Light value | Dark value |
|---|---|---|
| `surface` | `#FFFFFF` | `#0D1117` |
| `surface-muted` | `#F6F8FA` | `#151B23` |
| `surface-raised` | `#EFF2F5` | `#010409` |
| `surface-emphasis` | `#E6EAEF` | `#212830` |
| `ink` | `#1F2328` | `#F0F6FC` |
| `ink-muted` | `#59636E` | `#9198A1` |
| `ink-subtle` | `#818B98` | `#656C76` |
| `border` | `#D1D9E0` | `#3D444D` |
| `border-muted` | `#DAE0E7` | `#2F3742` |

The full palette implementation: `~/tau/diagrams/design/theme.typ`.

**Color-anchored, never domain-named.** Diagrams pick a hue based on what their content needs to communicate; the palette doesn't pre-assign meaning. Two TAU diagrams may use blue for different concepts; the palette doesn't mind.

## Font: CaskaydiaMono NFP

TAU uses **CaskaydiaMono NFP** — a Nerd Font Patched proportional variant of Microsoft's Cascadia Mono. One family carries:

- Prose labels (titles, captions, kind annotations)
- Code-style content via `raw()` / backticks (method signatures, field types)
- Nerd Font icon glyphs in the Unicode Private Use Area

Embedded by name through Typst's font-finding (system font); no font files committed to the repo. Font is required on the rendering system — install from the Nerd Fonts release archive (`CascadiaCode.zip` → `CaskaydiaMonoNerdFontPropo-*.ttf`).

**Glyph integration is required.** TAU diagrams use inline glyphs (status indicators, infrastructure markers, brand badges, edge-kind decorations); the font must be patched.

**Code tinting:** no global `show raw:` rule. Apply tinting locally where a specific diagram benefits — e.g., a scoped `show raw:` inside a hue-filled card body that re-tints code text to harmonize with the card. A diagram-wide raw tint is incompatible with hue-filled elements (the global hue clashes against any other hue's fill).

## Tokens: ~/tau/diagrams/design/tokens.typ

TAU's tokens calibrate to its render targets (READMEs at typical viewport widths, GitHub-rendered Markdown). The values:

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
  font:           "CaskaydiaMono NFP",
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

When generating a TAU diagram, import these tokens (`#import "../design/tokens.typ": tokens`) rather than inlining values. Adding a new token is a TAU-wide decision, not a per-diagram one — propose changes against `~/tau/diagrams/design/tokens.typ`.

## Render pipeline: `mise run render`

TAU uses **mise** as its task runner.

```bash
mise run render                  # compile every .typ except design/ modules; dual-theme; static/responsive aware
mise run render-file <path.typ>  # compile a single .typ to its dual-theme SVG pair (same render-mode logic as render)
mise run clean                   # remove all rendered SVGs
```

Implementation lives at `~/tau/diagrams/mise.toml`. The task walks the directory tree, compiles each `.typ` source for both `light` and `dark` themes via `--input theme=…`, and conditionally strips fixed pt-dimensions from the SVG root element based on the `// render: static` magic comment.

**Per-file render mode** follows the static / responsive distinction (see [typst-diagrams render-pipeline reference](../../typst-diagrams/references/render-pipeline.md) for the underlying mechanism). TAU's catalog files render static; diagrams embedded in READMEs render responsive.

## Native dependencies in diagrams

When a TAU subject's diagrams reference another TAU subject it depends on (a *native dependency* — a TAU-ecosystem library or service we own, author, and document), the dependency is rendered at **single-shape resolution**: one shape with input/output edges crossing into it, never expanded internals. Drilling into the dependency's internals belongs to *its* documentation, not to the subject's diagrams.

This rule applies at every audience tier — `core/`, `operational/`, and `specification/`. A native dependency that warrants more detail at a tier means the reader should follow its diagrams sub-directory link in the README's `Native dependencies:` header field, not get the detail inline.

External (third-party) dependencies are not bound by the same rule: they have no TAU documentation to drill into, and their treatment in any given diagram is a per-diagram decision rather than a universal convention.

## Repository conventions

- **Diagrams workspace:** `~/tau/diagrams/`. Source of truth for TAU's design layer, catalog, and blueprints.
- **Library diagrams:** colocated with the library they describe (e.g., `~/tau/protocol/protocol.typ` + rendered SVGs).
- **Blueprints:** `~/tau/diagrams/blueprints/` (peer to `catalog/` and `design/`). Populated as patterns recur across the TAU diagram suite.
- **GitHub remote:** `github.com/tailored-agentic-units/diagrams`. The remote is detached pending validation per memory `reference_diagrams_repo.md`; push only with explicit user authorization.
