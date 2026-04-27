---
name: tau-diagrams
description: TAU's opinionated diagram standard — GitHub Primer color palette, CaskaydiaMono NFP single-font with Nerd Font glyphs, dual-theme `<picture>` embedding, mise render pipeline. Source of truth for the TAU diagram standard. Layers on diagram-authoring, diagram-ingredients, diagram-design-system, and typst-diagrams. Use when generating diagrams for TAU repositories (orchestrate, herald, libraries under ~/tau/), embedding diagrams in TAU READMEs, or extending the canonical TAU diagram suite.
---

# TAU diagrams

TAU's opinionated diagram standard, composed from four lower skills.

## Load order

Load these skills in order before applying TAU-specific decisions:

1. `typst-diagrams` — Typst + CeTZ + Fletcher stack conventions and pitfalls.
2. `diagram-design-system` — design-layer pattern (tokens, palette, typography).
3. `diagram-ingredients` — ingredient inventory.
4. `diagram-authoring` — universal design process and the blueprint specification.

## TAU's locks

| Decision | Value | Reference |
|---|---|---|
| Palette source | GitHub Primer (eight chromatic hues + neutrals) | [tau-decisions](references/tau-decisions.md) |
| Font | CaskaydiaMono NFP (Cascadia Mono, Nerd Font Patched, proportional) | [tau-decisions](references/tau-decisions.md) |
| Glyph integration | required (single-font convention; Nerd Font carries icons inline) | [tau-decisions](references/tau-decisions.md) |
| Code tinting hue | purple (project default; per-diagram override permitted) | [tau-decisions](references/tau-decisions.md) |
| Task runner | `mise` | [tau-decisions](references/tau-decisions.md) |
| Render pipeline | `mise run render` walks `.typ` files, dual-theme, `// render: static` aware | [tau-decisions](references/tau-decisions.md) |

## Canonical implementation

The TAU diagram workspace lives at `~/tau/diagrams/`:

- `~/tau/diagrams/design/tokens.typ` — TAU's tokens, calibrated to its render targets.
- `~/tau/diagrams/design/theme.typ` — TAU's palette traced to GitHub Primer primitives.
- `~/tau/diagrams/catalog/` (renamed to `ingredients/` in a later phase) — TAU's ingredient demonstrations.
- `~/tau/diagrams/mise.toml` — TAU's render task implementation.
- `~/tau/diagrams/blueprints/` — TAU's canonical blueprints (populated in a later phase).

TAU diagram sources import from `~/tau/diagrams/design/tokens.typ` and `~/tau/diagrams/design/theme.typ` so values flow through TAU's design layer.

## Scope

This skill applies to:

- Generating diagrams for TAU repositories (libraries under `~/tau/`, orchestrate, herald at `~/code/herald`).
- Embedding diagrams in TAU READMEs via the dual-theme `<picture>` pattern.
- Extending the canonical TAU diagram suite.
