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

## Current state (end of session 2026-04-25)

Three rounds of user critique have run. Each round's fixes have been applied and re-rendered. Round 4 critique is pending — start there.

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

### Outstanding work

**Round 4 critique pending.** Re-render all 10 SVGs (`mise run clean && mise run render`) and present them for the user's next critique pass. Iterate.

**Required gate before phase 02 — design-system audit pass.** Per user direction: "all of the catalog .typ files should be using the design infrastructure natively and not hacking together single-use fixes to appease the issues that I callout." Audit each `catalog/*.typ` file for violations of the design system:

- Inline `pt` literals (e.g., `inset: 6pt`) that should be tokens
- Inline hex (`rgb("#…")`) outside `design/theme.typ`
- Ad-hoc gutter / inset values that don't pull from `tokens.*`
- Repeated row-gutter / column-gutter overrides that suggest a missing token
- Hard-coded font weights or sizes that should reference tokens
- Fixed-size boxes used as workarounds — document or justify
- Show rules / helpers re-defined per file that should be lifted into a shared convention

For each violation: (a) propose a new token in `design/tokens.typ` or `design/theme.typ`, (b) replace with an existing token, or (c) justify as a documented exception (the self-loop fixed-size box is a known exception — see `reference_typst_fletcher_pitfalls.md`). Update the catalog file to use the token.

This audit is the gate. Phase 02 cannot start until the audit is complete and `design/` cleanly accommodates every catalog scenario.

## Approach

1. Re-render the catalog cleanly (`mise run clean && mise run render`) and present output to the user for round 4 critique.
2. Apply each critique item the user calls out. **Do not hack single-use fixes** — diagnose the root cause; if multiple files would benefit, lift the fix into `design/`.
3. After the user is satisfied with visual output across all 10 files, run the design-system audit pass as a separate explicit step. Report findings, propose `design/` additions, apply them, and re-verify catalog files use the new tokens.
4. Hand off to phase 02 only when the audit is clean and the user signs off.

### Working pattern per round

- Read user critique image-by-image; map each issue to the responsible catalog file.
- Use TaskCreate to track each fix; mark in_progress / completed as you go.
- Render after each file's fixes (`typst compile --root . --input theme=light catalog/<file>.typ catalog/<file>-light.svg`) to catch errors early.
- Final pass: `mise run clean && mise run render` and present.

## Done criteria

- [ ] Round 4+ critique cycles complete; user signs off on every catalog SVG.
- [ ] Design-system audit complete; no inline `pt` / hex outside `design/`; every recurring pattern is tokenised or has a documented exception.
- [ ] `design/tokens.typ` + `design/theme.typ` cleanly accommodate every catalog scenario.
- [ ] `mise run clean && mise run render` produces all 20 SVGs (10 files × 2 themes) without errors.
- [ ] No prescribed vocabulary lock-ins remain (no domain-anchored tokens, no shape→concept fixed mappings).
- [ ] Round 3 changes that haven't been visually verified yet are confirmed.

## Hand-off to phase 02

When the catalog is locked: update `memory/project_typst_design_system.md` with any new tokens added during the audit (for universal-convention discoverability), then start a fresh session with `02-skill-development.md`.
