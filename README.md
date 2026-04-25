# diagrams

Authoring workspace for the TAU ecosystem's architecture and signal-flow diagrams. The toolkit underneath — `catalog/` (visual specification) and `design/` (foundation values) — is platform-agnostic, built on [Typst](https://github.com/typst/typst), [CeTZ](https://github.com/cetz-package/cetz), and [Fletcher](https://github.com/Jollywatt/typst-fletcher). Output is dual-theme SVG pairs (light + dark) embedded via GitHub's `<picture>` element so diagrams track the reader's theme.

## Philosophy

This workspace is a **composable toolkit**, not a rulebook. The design layer defines the ingredients (typography, palette, whitespace, shapes, edges, glyphs); each diagram composes what makes sense for its scenario. There is no canonical "shape X means concept Y" mapping — the catalog shows what's available and how each option reads.

## Layout

```
diagrams/
├── design/                    # foundation — pure values + thin helpers
│   ├── tokens.typ             # whitespace, typography, stroke, geometry
│   └── theme.typ              # palette + divider() + _hue() constructor
├── catalog/                   # visual specification — see catalog/README.md
│   ├── README.md              # rendered tour of every catalog entry
│   ├── typography.typ         # size scale, weight, style, decoration, tracking
│   ├── spacing.typ            # insets, corner radius, gutters, Fletcher spacing
│   ├── palette.typ            # full hue ladders + candidate semantic readings
│   ├── glyphs.typ             # Nerd Font symbology + composition patterns
│   ├── shapes.typ             # 16 Fletcher built-ins + composite + custom (CeTZ)
│   ├── marks.typ              # head/tail primitives, stroke styles, edge kinds
│   ├── edges.typ              # bends, waypoints, self-loops, label positioning
│   ├── labels.typ             # single-line, stacked, field list, icon, math
│   ├── variants.typ           # 4×3 mechanism catalog + tri-state anchor example
│   ├── encapsulation.typ      # container with named inner nodes (responsive)
│   └── *-{light,dark}.svg     # rendered artifacts
├── mise.toml                  # render / clean tasks
└── README.md                  # this file
```

> **Catalog reference**: see [catalog/README.md](./catalog/README.md) for a rendered tour of every catalog entry, theme-aware via GitHub's `<picture>`.

## Render

```bash
mise run render    # renders every .typ (except design/), dual theme
mise run clean     # remove all rendered SVGs
```

Single file:

```bash
typst compile --root . --input theme=light catalog/shapes.typ catalog/shapes-light.svg
```

A `// render: static` magic comment at the top of a `.typ` file keeps the SVG's fixed `width="..."pt` / `height="..."pt` (good for page-style references designed at a meaningful scale). Without it, those attributes are stripped post-compile so the SVG scales to its container via `<img width="100%">`. Default is responsive; nine of the ten catalog files are static.

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

## Libraries and signal flows

Library-specific diagrams (`protocol/`, `format/`, `provider/`, `agent/`, `orchestrate/`) and cross-library signal flows (`tau/`) will live alongside `catalog/` once the authoring skill ships. Each diagram imports from `design/`; no shared vocabulary module is required.
