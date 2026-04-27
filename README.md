# diagrams

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./ingredients/labels-and-encapsulation/encapsulation-pattern-dark.svg">
  <img src="./ingredients/labels-and-encapsulation/encapsulation-pattern-light.svg" alt="encapsulation — client edges into a runtime container's api node; worker edges out to an external store" width="100%">
</picture>

Authoring workspace for the TAU ecosystem's architecture and signal-flow diagrams. The toolkit underneath — `ingredients/` (the visual vocabulary) and `design/` (foundation values) — is platform-agnostic, built on [Typst](https://github.com/typst/typst), [CeTZ](https://github.com/cetz-package/cetz), and [Fletcher](https://github.com/Jollywatt/typst-fletcher). Output is dual-theme SVG pairs (light + dark) embedded via GitHub's `<picture>` element so diagrams track the reader's theme.

## Philosophy

This workspace is a **composable toolkit**, not a rulebook. The design layer defines the foundation values (typography, palette, whitespace); each ingredient is described with its visual weight and useful applications; each diagram composes what makes sense for its scenario. There is no canonical "shape X means concept Y" mapping — the ingredients reference shows what's available and how each option reads.

## Layout

```
diagrams/
├── design/                              # foundation — pure values + thin helpers
│   ├── tokens.typ                       # whitespace, typography, stroke, geometry
│   └── theme.typ                        # palette + divider() + _hue() constructor
├── ingredients/                         # visual vocabulary — see ingredients/README.md
│   ├── README.md                        # index — overview + 5 axes with essence diagrams
│   ├── text-and-space/                  # typography + whitespace primitives
│   ├── color-and-glyphs/                # palette + Nerd Font glyph families
│   ├── shapes-and-variants/             # shape vocabulary + variant mechanisms
│   ├── edges-and-marks/                 # edge routing + mark inventory
│   └── labels-and-encapsulation/        # label patterns + container pattern
├── .claude/skills/                      # authoring guidance — see Skills below
│   ├── typst-diagrams/                  # Typst + CeTZ + Fletcher stack conventions
│   ├── diagram-design-system/           # design-layer patterns (tokens + palette)
│   ├── diagram-ingredients/             # ingredient inventory mirroring ingredients/
│   ├── diagram-authoring/               # design process and critique checklist
│   └── tau-diagrams/                    # TAU's opinionated standard
├── mise.toml                            # render / clean tasks
└── README.md                            # this file
```

Each axis sub-directory under `ingredients/` holds standalone single-concept `.typ` sources, their dual-theme rendered `*-{light,dark}.svg` pairs, an axis-essence `readme.typ`, and a `README.md` that orders the concepts with prose.

> **Ingredients reference**: see [ingredients/README.md](./ingredients/README.md) for a rendered tour of every concept, organized by axis.

## Render

```bash
mise run render    # renders every .typ (except design/), dual theme
mise run clean     # remove all rendered SVGs
```

Single file:

```bash
typst compile --root . --input theme=light ingredients/shapes-and-variants/built-in-shapes.typ out-light.svg
```

A `// render: static` magic comment at the top of a `.typ` file keeps the SVG's fixed `width="..."pt` / `height="..."pt` (good for page-style references designed at a meaningful scale). Without it, those attributes are stripped post-compile so the SVG scales to its container via `<img width="100%">`. Default is responsive; the per-concept `ingredients/` files render responsive.

## Embedding in GitHub Markdown

Dual-theme, responsive:

```markdown
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./path/to/diagram-dark.svg">
  <img src="./path/to/diagram-light.svg" alt="..." width="100%">
</picture>
```

Non-`<picture>` viewers fall back to the light SVG. The `width="100%"` attribute makes the image fill its column; the SVG's viewBox preserves proportions.

## Design system — quick tour

The **design/** directory holds two files. Everything else is composition.

- **`design/tokens.typ`** — pure values. Font name, size scale, weight names, stroke widths, spacing units, edge-label sizing. Colour-free (palette lives in `theme.typ` for clean dual-theme swap).
- **`design/theme.typ`** — palette. Light and dark branches selected via `--input theme=light|dark`. Each chromatic hue exposes a `(stroke, fill, ink, divider)` quad keyed to [GitHub Primer primitives](https://primer.style/primitives/colors); `divider` is a 50/50 mix of fill and stroke so structural rules inside a hue-filled shape stay in the same colour family. The `_hue()` constructor applies that derivation; the exported `divider(hue:)` helper renders a hue-aware horizontal rule.

## Skills

Five skills under `.claude/skills/` cover diagram authoring guidance, layered from the lowest-level conventions to the most opinionated standard.

- **typst-diagrams** — conventions for composing diagrams with the Typst + CeTZ + Fletcher stack: render pipeline patterns, version-specific Fletcher pitfalls, CeTZ closure shapes, label-body composition.
- **diagram-design-system** — patterns for building a design layer: tokens (whitespace, typography scale, stroke, geometry), color-anchored palettes with per-hue stroke/fill/ink/divider quads, and single-font typography with optional Nerd Font integration. Source-agnostic across palette systems (Primer, Pajamas, Tailwind, Radix).
- **diagram-ingredients** — universal inventory of the ingredients available when composing a diagram. Mirrors the `ingredients/` directory; each ingredient is described with its visual weight and useful applications, never as a fixed "this means that" rule.
- **diagram-authoring** — universal process for designing and refining a diagram from user requirements and source materials (source code, written specifications, structured data, prose). Defines a minimal blueprint specification for reusable diagram patterns; blueprints are optional.
- **tau-diagrams** — TAU's opinionated diagram standard: GitHub Primer palette, CaskaydiaMono NFP single-font with Nerd Font glyphs, dual-theme `<picture>` embedding, mise render pipeline. Composes the four skills above.

## Libraries and signal flows

Library-specific diagrams (`protocol/`, `format/`, `provider/`, `agent/`, `orchestrate/`) and cross-library signal flows (`tau/`) will live alongside `ingredients/` once the authoring skill ships. Each diagram imports from `design/`; no shared vocabulary module is required.
