# Phase 02 — skill development

Author the `typst-diagrams` skill at `~/tau/diagrams/.claude/skills/typst-diagrams/`. The skill teaches Claude how to compose Typst+Fletcher diagrams from the `design/` foundation and `catalog/` ingredient reference established in phase 01.

## Bootstrap

1. **`./README.md`** — cross-cutting concerns (toolkit philosophy, design foundation, single font, render pipeline).
2. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md` — non-negotiable framing
   - `project_typst_design_system.md` — token + palette + layout convention reference
   - `project_typst_workspace.md` — paths, render pipeline, Fletcher reference
   - `reference_typst_fletcher_pitfalls.md` — workarounds for known issues
3. **Phase 01 output** — fully-locked `~/tau/diagrams/design/` and `~/tau/diagrams/catalog/`. The skill draws every example and convention from these files.
4. **The skill-creator skill** — invoke via `Skill skill-creator:skill-creator` to bootstrap structure. Skill-creator gives optimal frontmatter (description with explicit triggers, allowed-tools), the SKILL.md + `references/*.md` layering pattern, and skill quality criteria.

## Current state

Not started. Phase 01 must be done (catalog locked, design-system audit clean, user signed off).

## Approach

### 1. Use skill-creator to scaffold

Invoke the `skill-creator:skill-creator` skill at session start. Tell it:

- **What the skill does**: helps Claude compose Typst+Fletcher diagrams using the TAU diagrams design system.
- **Triggers**: when the user asks to create, modify, render, or critique a Typst-based architectural / signal-flow / reference diagram in or referencing the TAU diagrams workspace; when files in `~/tau/diagrams/catalog/`, `~/tau/diagrams/design/`, or any `*.typ` under TAU repos are involved.
- **Where it lives**: `~/tau/diagrams/.claude/skills/typst-diagrams/`.
- **Layering needs**: scoped reference docs that load only what's needed for a given task (typography vs. shapes vs. edges, etc.).

Follow skill-creator's recommendations on frontmatter and structure; do not improvise.

### 2. Distribute conventions into `references/*.md`

The catalog has 10 files and `design/` has 2. The skill's `references/*.md` partition should mirror the catalog's conceptual axes so Claude loads only what each task needs:

| Suggested reference file | Source catalog/design files | Scope |
|---|---|---|
| `references/foundation.md` | `design/tokens.typ`, `design/theme.typ` | Tokens, palette structure (color-anchored), per-hue ink, render-mode marker |
| `references/typography.md` | `catalog/typography.typ` | Size scale, weight, style, decoration, tracking, mixed runs, raw tinting |
| `references/spacing.md` | `catalog/spacing.typ` | Inset, corner radius, gutters, Fletcher diagram spacing |
| `references/palette.md` | `catalog/palette.typ` | Hue ladders, semantic color groups (illustrative), example assignments |
| `references/glyphs.md` | `catalog/glyphs.typ` | Nerd Font symbology by family, composition patterns, codepoint links |
| `references/shapes.md` | `catalog/shapes.typ` | 16 built-ins, composite (Typst body composition), custom (Fletcher CeTZ closure) |
| `references/marks.md` | `catalog/marks.typ` | Head/tail primitives, stroke styles, edge-kind encodings |
| `references/edges.md` | `catalog/edges.typ` | Bend, waypoints, self-loops, label positioning, mid-edge marks |
| `references/labels.md` | `catalog/labels.typ` | Single-line, stacked, field list, divider, icon, math, mixed runs |
| `references/variants.md` | `catalog/variants.typ` | Mechanisms for shape differentiation |
| `references/composition.md` | `catalog/encapsulation.typ` + cross-cutting layout patterns | Containers with named inner nodes, cross-boundary edges, layout strategies |
| `references/pitfalls.md` | `memory/reference_typst_fletcher_pitfalls.md` | Known Typst+Fletcher bugs + workarounds |
| `references/render-pipeline.md` | `mise.toml`, `~/tau/typst-responsive-svgs.md` | Static vs responsive marker, embedding patterns, upstream contribution context |

These are suggestions — let skill-creator validate the partition and adjust based on the skill quality criteria.

### 3. SKILL.md content

The top-level SKILL.md should be short and orienting:

- One-line description (the trigger surface).
- Toolkit-not-ruleset framing as the first guiding principle.
- Pointer to `references/foundation.md` as always-load context.
- Decision tree: "if the task is about typography, load `references/typography.md`; if about shapes, load `references/shapes.md`; …".
- Invariants: tokens-first; no inline `pt` / hex; respect `// render: static` markers; mise for rendering.
- Pointer to phase 03 (`03-core-tau-diagrams.md`) if the user wants to actually generate a diagram suite, since process design lives there.

Do not duplicate catalog content into SKILL.md — references are loaded on-demand.

### 4. Validation

The skill is done when Claude can:

- Read SKILL.md and an appropriately-scoped reference file (e.g., `references/shapes.md`) and produce a syntactically-correct Typst diagram that renders cleanly via `mise run render`.
- Refuse to fabricate prescribed mappings (e.g., not invent "code group is purple" — pick hues based on the diagram's content).
- Defer to skill-creator's quality measurement (it has eval/benchmark capabilities).

## Done criteria

- [ ] Skill scaffolded under `~/tau/diagrams/.claude/skills/typst-diagrams/` per skill-creator's structural recommendations.
- [ ] SKILL.md frontmatter includes triggers, allowed-tools, and any other skill-creator-recommended fields.
- [ ] `references/*.md` files distribute design + catalog conventions so context loads progressively.
- [ ] Skill-creator's quality criteria pass (run skill-creator's measurement / eval flow).
- [ ] Manual test: invoke the skill in a fresh session, ask it to draft a small diagram, render successfully.

## Hand-off to phase 03

When the skill is validated: start a fresh session with `03-core-tau-diagrams.md`. The skill becomes the primary tool for everything in phases 03 and 04.
