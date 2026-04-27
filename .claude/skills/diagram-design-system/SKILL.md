---
name: diagram-design-system
description: Patterns for building a design layer for diagrams — tokens (whitespace, typography scale, stroke, geometry), color-anchored palettes with per-hue stroke/fill/ink/divider quads, and single-font typography with optional Nerd Font integration. Source-agnostic: GitHub Primer, GitLab Pajamas, Tailwind, Radix, and others all work as palette sources. Use when establishing or extending a diagram design system, adding new tokens or hues, choosing or migrating a palette source, or auditing a tokens / theme pair for consistency.
---

# Diagram design system

The design layer that diagrams sit on top of: a tokens module (whitespace, typography, stroke, geometry — pure values, no color) and a theme module (palette structure, theme switching).

## Decision tree

| Task | Reference |
|---|---|
| Authoring or extending a tokens file (whitespace, typography scale, stroke widths, geometry) | [tokens-pattern](references/tokens-pattern.md) |
| Picking a palette source, structuring per-hue colors, supporting light/dark themes | [palette-pattern](references/palette-pattern.md) |
| Choosing a font, deciding whether to use a Nerd Font, hierarchy via weight + size | [typography-pattern](references/typography-pattern.md) |

## Design-layer principles

- **Color-anchored, never domain-named.** A palette names hues by color (`blue`, `green`, `accent`, etc.), not by domain semantic (`code-stroke`, `query-edge`). Diagram authors pick a hue based on what their content needs to communicate; the palette doesn't pre-decide.
- **Tokens hold values, not colors.** Whitespace, typography scale, stroke widths, geometry — pure values. Colors live in the theme module so they swap by theme; tokens stay constant across themes.
- **Themes swap at compile time.** Pass the theme as input (`--input theme=…`) so the SVG bakes in the right colors. No JavaScript-driven swap, no double-rendering with CSS overrides.
- **Single font, hierarchy via weight + size.** Mixing fonts to express hierarchy is fragile (font availability varies, fallback rendering shifts spacing) and noisy. One family; weight and size carry hierarchy.
- **Nerd Font integration is conditional.** Diagrams that compose icon glyphs inline with prose require a Nerd Font variant. Diagrams without inline glyphs work with any monospace or proportional font.
