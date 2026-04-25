# TAU diagrams

Authoring workspace for the TAU ecosystem's architecture and signal-flow diagrams. Sources are [Typst](https://typst.app) with the [Fletcher](https://typst.app/universe/package/fletcher) package; rendered output is dual-theme SVG pairs (light + dark) embedded via GitHub's `<picture>` element so diagrams track the reader's theme.

## Philosophy

This workspace is a **composable toolkit**, not a rulebook. The design system defines the ingredients (typography, palette, whitespace, shape vocabulary, edge vocabulary, glyph symbology); each diagram composes what makes sense for its scenario. There is no canonical "shape X means concept Y" mapping — the catalog shows what's available and how each choice reads.

## Layout

```
diagrams/
├── design/                    # foundation — pure values, no composition
│   ├── tokens.typ             # whitespace, typography, stroke, geometry
│   └── theme.typ              # palette (GitHub Primer light/dark)
├── catalog/                   # ingredient reference — rendered for browsing
│   ├── typography.typ         # size scale, weight, style, decoration, tracking
│   ├── spacing.typ            # insets, corner radius, gutters, Fletcher spacing
│   ├── palette.typ            # full hue ladders + candidate semantic readings
│   ├── glyphs.typ             # Nerd Font symbology (status, actions, infra, …)
│   ├── shapes.typ             # 16 Fletcher shapes × 3 hue recolourings
│   ├── marks.typ              # head/tail primitives, stroke styles, edge kinds
│   ├── edges.typ              # bends, waypoints, self-loops, label positioning
│   ├── labels.typ             # single-line, stacked, field list, icon, math
│   ├── variants.typ           # stroke pattern / badge / both — how to encode a 2nd attribute
│   ├── encapsulation.typ      # container with named inner nodes, cross-boundary edges
│   └── *-{light,dark}.svg     # rendered artifacts
├── DECISION.md                # rationale for Typst selection (Phase 3 memo)
├── mise.toml                  # render / clean tasks
└── README.md                  # this file
```

## Render

```bash
mise run render    # renders every .typ (except design/ modules), dual theme
mise run clean     # remove all rendered SVGs
```

Single file:

```bash
typst compile --root . --input theme=light catalog/shapes.typ catalog/shapes-light.svg
```

The render pipeline post-processes each SVG to strip fixed `width="..."pt` / `height="..."pt` attributes — the viewBox remains. Combined with an `<img width="100%">` host element, diagrams scale responsively to their container.

## Embedding in GitHub Markdown

Dual-theme, responsive:

```markdown
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./path/to/diagram-dark.svg">
  <img src="./path/to/diagram-light.svg" alt="..." width="100%">
</picture>
```

Non-`<picture>` viewers fall back to the light SVG. The `width="100%"` attribute makes the image fill its column; the SVG's intrinsic aspect ratio (from viewBox) preserves proportions.

## Design system — quick tour

The **design/** directory holds two files. Everything else is composition.

- **`design/tokens.typ`** — pure values. Font name, size scale, weight names, stroke widths, spacing units. Color-free (palette lives in theme so dual-theme swap is clean).
- **`design/theme.typ`** — palette. Light and dark branches selected via `--input theme=light|dark`. Colour values traced to [GitHub Primer primitives](https://primer.style/primitives/colors).

The **catalog/** directory is the ingredient reference. Each file renders to an SVG that shows a particular dimension of the design system: what typography controls are available, what the palette looks like, what shapes Fletcher provides, what ways glyphs compose into nodes, and so on. These files are for browsing, not importing.

## Libraries and signal flows

Library-specific diagrams (`protocol/`, `format/`, `provider/`, `agent/`, `orchestrate/`) and cross-library signal flows (`tau/`) will live alongside `catalog/` once the authoring skill ships. Each diagram imports from `design/`; no shared vocabulary module is required.
