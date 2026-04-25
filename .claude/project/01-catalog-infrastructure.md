# Phase 01 — catalog infrastructure

Lock down `~/tau/diagrams/catalog/*` and `~/tau/diagrams/design/*` as the foundational ingredient reference for the entire diagrams ecosystem. Catalog must be visually correct, conceptually consistent (toolkit-not-ruleset framing), and structurally clean (every catalog file uses `design/` natively, not single-use hacks).

## Bootstrap

Read in this order before doing anything:

1. **`./README.md`** (this directory) — cross-cutting concerns: tool selection, `design/` foundation, single-font convention, render pipeline, toolkit philosophy.
2. **Memory files** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md` — non-negotiable framing
   - `project_typst_design_system.md` — token + palette + layout-pattern conventions
   - `project_typst_workspace.md` — paths, render pipeline, Fletcher 0.5.8 reference
   - `reference_typst_fletcher_pitfalls.md` — workarounds for known Typst+Fletcher bugs
   - `feedback_one_diagram_one_concept.md`, `feedback_shape_vs_text.md` — universal diagramming conventions
3. **Workspace files**:
   - `~/tau/diagrams/design/tokens.typ` and `design/theme.typ` — the foundation layer
   - `~/tau/diagrams/catalog/*.typ` — the 10 catalog source files
   - `~/tau/diagrams/catalog/*-{light,dark}.svg` — current rendered output
   - `~/tau/diagrams/mise.toml` — render pipeline
4. **`~/tau/typst-responsive-svgs.md`** — context for the static/responsive marker mechanism.

## Status: COMPLETE

Six rounds of user critique applied. Catalog locked. Design-layer audit run; all findings actioned or deliberately deferred. Ready for phase 02.

### Catalog inventory

10 catalog files at `~/tau/diagrams/catalog/`. All render dual-theme. 9 are static (page-style references); `encapsulation.typ` is responsive (visualization-style example).

| File | Concept | Render mode | Key sections |
|---|---|---|---|
| `typography.typ` | text controls | static | size scale, weight, style, decoration, tracking, mixed runs, raw, color hierarchy |
| `spacing.typ` | whitespace primitives | static | inset, corner radius, stack spacing, grid gutters, Fletcher diagram spacing, token inventory |
| `palette.typ` | color | static | hue ladders × 9 hues, semantic color groups (illustrative), example assignments |
| `glyphs.typ` | Nerd Font symbology | static | status, actions, infra, people, files, control, relationships, brands, composition patterns |
| `shapes.typ` | shape vocabulary | static | 16 Fletcher built-ins (4×4 grid), composite shapes, custom shapes (CeTZ closure API) |
| `marks.typ` | edge mark primitives | static | head/tail primitives, stroke styles, edge-kind encodings (illustrative) |
| `edges.typ` | edge composition | static | bend, waypoints, self-loops, label positioning, mid-edge marks, parallel edges, layer order |
| `labels.typ` | node body content | static | single-line, stacked, field list, divider, icon, math, mixed runs |
| `variants.typ` | shape differentiation | static | tri-state anchor (illustrative), 4×3 mechanism catalog (stroke / colour / fill / geometry / overlay / fade) |
| `encapsulation.typ` | container with named inner nodes | **responsive** | runtime container with cross-boundary edges, parameterised label-pos |

### Round-by-round summary

- **Round 1** — initial catalog scaffolding. Established 10 files. Ran into the auto-page-height ↔ self-loop circular extent bug (edges.typ rendered as ~10¹⁷pt-tall blank SVG); fixed by wrapping self-loops in a fixed-size box.
- **Round 2** — major architectural pivot per user direction: removed `entities.typ` (prescribed shape→concept vocabulary), renamed `schema/` → `design/`, refactored `theme.typ` to color-anchored tokens (`palette.{hue}.{stroke,fill,ink}`), added per-hue `ink` for chromatic contrast on tinted fills, added `// render: static` magic comment + mise pipeline support, expanded catalog (typography, spacing, palette, glyphs, edges, labels, composite shapes, custom shapes via CeTZ), reframed marks/variants/shapes captions to stance-neutral.
- **Round 3** — bug fixes + targeted refinements: variants.typ render bug (let-rebind inside if-block didn't propagate), glyph codepoint truncation (`repr().slice(3,7)` → `slice(4, len-2)`), edges.typ 180° self-loop missing (clip + sized box), encapsulation edge label position (parameterised `label-pos`), labels.typ row-gutter bumps + ICON-LEFT sizing, glyphs link styling rule, marks Section C reframed as illustrative, palette page width reduced + Section B retitled "semantic color groups" + Section C reframed to "example assignments", shapes main grid restructured to single-hue + namespace caption, composite shapes fixed (header bar horizontal, corner ribbon point at top-right, icon block padding + radius), custom shapes contiguous tabbed-rect + quatrefoil from SVG path.
- **Round 4** — `variants.typ` extrude default `()` → `(0,)` (Fletcher's own default; empty tuple suppressed all strokes); `edges.typ` Section C self-loop range pinned to `(115°, 160°)` after discovering 180° is a Fletcher degeneracy (loop diameter → ∞); `encapsulation.typ` `persist` label re-centred at 0.5 and `lookup` semantically + visually moved to `worker → cache`; `labels.typ` reconstructed after a sed mishap nuked the file and `row-gutter` switched to `gap-cell` (was `space-between-ranks * 1.5` = 54pt); `palette.typ` description gained Primer + GitHub Brand Toolkit links; `shapes.typ` HEADER BAR restructured to title → divider → body block (UML separator pattern), CORNER RIBBON rewritten as `curve()` with bezier-rounded apex.
- **Round 5** — universal: typography scale +1pt across every size token; per-hue `divider` colour added via `_hue()` helper in `theme.typ` (50/50 mix of fill and stroke); blue + underline `#show link` rule added to `palette.typ`; `glyphs.typ` Sections A–H glyphs wrapped in neutral rounded rects with breathing room for codepoint + name; `shapes.typ` CORNER RIBBON fixed flush via `inset: 0pt` on the host node + inner block carrying its own padding (matched ICON BLOCK pattern); `variants.typ` `faded` rewritten as `color.mix(... → palette.surface)` so dark-mode fills don't lighten themselves into prominence; `variants.typ` anchor section now demonstrates extruded + `nf-oct-server` badge for self-hosted, faded + `nf-fa-cloud` for external.
- **Round 6** — universal: all edge labels switched from custom `box(fill: surface, ...)` wrappers to Fletcher's native `label-fill: palette.surface` (the white border in dark mode came from Fletcher's auto-wrap rendering at hardcoded white *outside* the custom box; the native param eliminates the double-layer); `spacing.typ` Section E edges given explicit theme-aware `palette.ink` stroke; `typography.typ` Section A `row-gutter` bumped to `gap-cell`.
- **Audit** — design-layer idiomatic audit run via Explore subagent. Twelve checklist items evaluated against Typst + Fletcher + CeTZ conventions and the catalog patterns. Approved actions: lifted `_divider(hue:)` from `labels.typ` to `design/theme.typ` as `divider(hue:)` (Item 4); also pulled into `shapes.typ` HEADER BAR for consistency. Show-rule lift (Item 11) declined — Typst show rules are document-scoped and don't survive a function wrapper, so per-file 1-liner repetition remains the idiomatic pattern. Diagram-default helper (Item 5) deferred to phase 02 (skill-layer concern). All other items kept as-is with rationale documented.

### Done

All criteria met:

- [x] Round 4–6 critique cycles complete; user signed off on every catalog SVG.
- [x] Design-layer audit complete; conclusions actioned or documented as deferred.
- [x] `design/tokens.typ` + `design/theme.typ` cleanly accommodate every catalog scenario; `theme.typ` now exports `palette` + `divider` + `_hue` helper.
- [x] `mise run clean && mise run render` produces all 20 SVGs (10 files × 2 themes) without errors.
- [x] No prescribed vocabulary lock-ins; palette is colour-anchored, no domain tokens.
- [x] Self-loop fixed-box, render-mode magic comment, and `label-fill: palette.surface` documented as catalog conventions.

## Hand-off to phase 02

When the catalog is locked: update `memory/project_typst_design_system.md` with any new tokens added during the audit (for universal-convention discoverability), then start a fresh session with `02-skill-development.md`.
