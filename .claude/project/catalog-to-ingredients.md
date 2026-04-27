# Catalog → ingredients refactor

Final task of phase 02. Builds `~/tau/diagrams/ingredients/` as the new home for the diagram inventory — aligned with the axis structure of the `diagram-ingredients` skill, decomposed into single-concept diagrams, with sub-directory READMEs carrying the narrative.

`~/tau/diagrams/catalog/` stays in place as the reference source throughout the build. It is removed only after `ingredients/` is fully constructed, rendered, and reviewed.

This refactor is the first real authoring exercise against the skills built in phase 02. Issues surfaced by the work feed back into skill updates before phase 02 closes.

## Context

The current catalog has 10 source files. Each is a multi-section "page-style reference" rendering many concepts inside one SVG (typography.typ has 7 sections; glyphs.typ has 9; etc.). Page-style references work as a quick visual inventory, but they violate the **one diagram, one concept** principle the `diagram-authoring` skill encodes: each diagram source produces one rendered artifact at full resolution, focused on one concept.

The refactor:

1. Builds `ingredients/` as a new directory alongside the existing `catalog/`, structured into 5 axis sub-directories matching the `diagram-ingredients` skill's reference layout.
2. Decomposes each catalog file's sections into standalone single-concept diagrams under the appropriate sub-directory.
3. Moves narrative, link references, and explanatory prose into per-sub-directory README files (Markdown handles the documentation; diagrams handle the visuals).
4. Adds a top-level `ingredients/README.md` that indexes the sub-directories with purpose-built essence diagrams.
5. Removes `catalog/` only after `ingredients/` is fully built, rendered, and verified — keeping the old structure available as a reference throughout the work.

The result: every diagram earns its place by carrying one concept; the README narrative carries everything that belongs in prose; the visual / textual responsibilities separate cleanly.

## Bootstrap

Read in this order before starting work:

1. **`./README.md`** (this directory) — cross-cutting concerns: tool selection, design foundation, single-font convention, render pipeline, dual-theme embedding, toolkit philosophy.
2. **Skills** at `~/tau/diagrams/.claude/skills/`:
   - `typst-diagrams` — Typst + CeTZ + Fletcher stack conventions and pitfalls.
   - `diagram-design-system` — design-layer pattern (tokens, palette, typography).
   - `diagram-ingredients` — ingredient inventory; **the authority on axis content** (each reference file maps to one sub-directory below).
   - `diagram-authoring` — universal design process and critique checklist.
   - `tau-diagrams` — TAU's specific lock-ins (Primer palette, CaskaydiaMono NFP, mise render task).
3. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_one_diagram_one_concept.md`
   - `feedback_diagram_toolkit_not_ruleset.md`
   - `feedback_shape_vs_text.md`
   - `reference_typst_fletcher_pitfalls.md`
   - `reference_github_picture_dual_theme.md`
4. **Source material to decompose** at `~/tau/diagrams/catalog/`:
   - `typography.typ` — 7 sections (size, weight, style+decoration, tracking, mixed runs, raw, color hierarchy)
   - `spacing.typ` — 6 sections (inset, radius, stack, grid, fletcher diagram spacing, token inventory)
   - `palette.typ` — 3 sections (hue ladders, semantic groups, example assignments)
   - `glyphs.typ` — 9 sections (status, actions, infra, people, files, control, relationships, brands, composition patterns)
   - `shapes.typ` — 3 sections (built-ins grid, composite shapes, custom shapes)
   - `marks.typ` — 3 sections (head/tail primitives, stroke styles, edge-kind encodings)
   - `edges.typ` — 7 sections (bend, waypoints, self-loops, label-pos, mid-edge, parallel, layer order)
   - `labels.typ` — 7 sections (single-line, stacked, field list, divider, icon, math, mixed)
   - `variants.typ` — 2 sections (anchor tri-state example, mechanism catalog)
   - `encapsulation.typ` — 1 diagram
5. **Foundation** at `~/tau/diagrams/design/` — `tokens.typ` and `theme.typ` are the imports every diagram uses.
6. **Render pipeline** at `~/tau/diagrams/mise.toml` — `mise run render` walks `.typ` files and produces dual-theme SVGs.

## Target layout

```
~/tau/diagrams/ingredients/
├── README.md                              ← index page (overview + per-axis essence)
├── text-and-space/
│   ├── README.md                          ← narrative ordering the diagrams below
│   ├── *.typ                              ← standalone single-concept diagrams
│   └── *-{light,dark}.svg                 ← rendered output (dual-theme)
├── color-and-glyphs/
│   ├── README.md
│   ├── *.typ
│   └── *-{light,dark}.svg
├── shapes-and-variants/
│   ├── README.md
│   ├── *.typ
│   └── *-{light,dark}.svg
├── edges-and-marks/
│   ├── README.md
│   ├── *.typ
│   └── *-{light,dark}.svg
└── labels-and-encapsulation/
    ├── README.md
    ├── *.typ
    └── *-{light,dark}.svg
```

The five axes match the `diagram-ingredients` skill reference files exactly:

| Sub-directory | Catalog sources to decompose |
|---|---|
| `text-and-space/` | `typography.typ` + `spacing.typ` |
| `color-and-glyphs/` | `palette.typ` + `glyphs.typ` |
| `shapes-and-variants/` | `shapes.typ` + `variants.typ` |
| `edges-and-marks/` | `edges.typ` + `marks.typ` |
| `labels-and-encapsulation/` | `labels.typ` + `encapsulation.typ` |

## Decomposition principle

Each section of a current catalog file becomes its own standalone diagram. A current `typography.typ` Section A (size scale demonstration) becomes a single `.typ` file rendering only that concept — sized to fit the concept, with a focused subject, no other concepts crowding it. The README in the sub-directory then orders that diagram alongside its siblings with prose that ties the topic together.

A standalone diagram rendering one concept:

- Carries one focused subject (one demonstration, one comparison grid, one mechanism).
- Sized to the subject, not to a 900pt page width.
- Renders responsively unless legibility genuinely depends on a fixed scale (most diagrams here render responsive; the magic comment `// render: static` is opt-in for the few that need it).
- Has no section titles inside the diagram — the surrounding README provides the headings, descriptions, and cross-references.

Naming convention: kebab-case files named for the concept, not the section letter. `typography.typ` Section A becomes `text-and-space/size-scale.typ`; Section B becomes `text-and-space/weight.typ`; and so on. The README ties them together.

## Per-sub-directory README structure

Each sub-directory's `README.md` carries the topic narrative and embeds each standalone diagram inline:

```markdown
# <axis name>

<2-4 sentence overview of what this axis covers and why each ingredient matters.>

## <concept 1>

<1-2 sentences describing what the concept is and how to read it.>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./<concept-1>-dark.svg">
  <img src="./<concept-1>-light.svg" alt="<concept 1>" width="100%">
</picture>

<additional descriptive prose, links, references — anything that belongs in
prose rather than inside the diagram.>

## <concept 2>

…
```

The order of concepts within a README is editorial — pick an order that reads progressively (foundational concepts first, compositions last; primitives before patterns). Cross-references between concepts use Markdown links rather than text inside the diagram.

The dual-theme `<picture>` pattern matches the convention in [the typst-diagrams render-pipeline reference](../../.claude/skills/typst-diagrams/references/render-pipeline.md).

## Top-level `ingredients/README.md`

The index page provides an overview of the ingredients philosophy and links to each sub-directory README. Each sub-directory entry includes a small **essence diagram** — a purpose-built thumbnail whose only job is to summarize the sub-topic at a glance.

Structure:

```markdown
# Ingredients

<2-3 paragraph overview: what ingredients are, the toolkit-not-ruleset
philosophy, how the sub-directories organize the inventory.>

## [text and space](./text-and-space/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./text-and-space/_essence-dark.svg">
  <img src="./text-and-space/_essence-light.svg" alt="text and space essence" width="100%">
</picture>

<2-3 sentence description of what this axis covers.>

## [color and glyphs](./color-and-glyphs/README.md)

…
```

The essence diagrams (one per axis, five total) are intentional small visualizations distinct from the standalone diagrams inside each sub-directory. Conventions:

- Named `_essence.typ` (leading underscore signals the index role) inside the sub-directory it summarizes.
- Compact — fits a typical README width without scaling, even responsive.
- Captures the *essence* of the axis: a small visual that reads as "this is what text-and-space is about." Specifics belong inside the sub-directory; the essence is the gestalt.
- Renders dual-theme like everything else.

## Process per sub-directory

A consistent rhythm for each of the five axes:

1. **Read the corresponding `diagram-ingredients` reference file** for the axis. It is the authority on what concepts live in this axis and what each concept covers.
2. **Identify the standalone diagrams** by mapping each section of the source catalog file(s) to its own concept. Resist the temptation to keep two related sections in one file — the principle is one diagram, one concept.
3. **Author each standalone `.typ`**. Imports come from `~/tau/diagrams/design/`. Apply the critique checklist from `diagram-authoring` before considering a diagram done.
4. **Author the sub-directory README**. The narrative orders the standalone diagrams; prose carries the description and any cross-references.
5. **Author the essence diagram** for the axis. Compact, summary, one visual.
6. **Render** — `mise run render` produces dual-theme SVGs.
7. **Critique** — open the rendered README in a Markdown preview (or render it on GitHub locally) and verify the narrative + diagram pairing reads cleanly.

When a critique pass surfaces a gap or inaccuracy in the `diagram-ingredients` skill, update the skill — the refactor is partly a validation pass.

## Build order

1. Construct each axis sub-directory under `ingredients/`, working through the five axes one at a time. `catalog/` stays untouched and serves as the reference source for content during this period — `mise run render` will render both directories' `.typ` files in parallel, which is fine for verification.
2. Author the top-level `ingredients/README.md` with the index + essence diagrams.
3. Render the full `ingredients/` tree and verify all SVGs produce cleanly.
4. Update `~/tau/diagrams/README.md` to point at `ingredients/` instead of `catalog/`.
5. Update `~/tau/diagrams/.claude/project/README.md` to reflect the rebuilt structure.
6. Verify `~/tau/diagrams/mise.toml` picks up the new sub-directory `.typ` files unchanged (the existing `find . -type f -name '*.typ'` walk should work as-is; verify).
7. Remove `~/tau/diagrams/catalog/` once `ingredients/` is fully reviewed and the top-level wiring is updated.

## Done criteria

- [ ] `~/tau/diagrams/ingredients/` exists with the 5 axis sub-directories.
- [ ] Each sub-directory contains a `README.md` plus standalone single-concept `.typ` sources (one per concept), with rendered dual-theme SVGs.
- [ ] Each sub-directory has an `_essence.typ` (with rendered SVGs) representing the axis at a glance.
- [ ] Top-level `~/tau/diagrams/ingredients/README.md` exists, indexes the five sub-directories with their essence diagrams and short descriptions, and links to each sub-directory README.
- [ ] `mise run render` produces all SVGs without errors.
- [ ] All five sub-directory READMEs render cleanly when previewed (light + dark themes both display correctly).
- [ ] `~/tau/diagrams/catalog/` removed after content is fully migrated and verified.
- [ ] `~/tau/diagrams/README.md` and any other top-level references point at `ingredients/`.
- [ ] Skill updates merged for any gaps surfaced during the work.
- [ ] Diagrams repo committed (push only with explicit user authorization per `memory/reference_diagrams_repo.md`).

## Hand-off

When the refactor is complete, phase 02 closes. Start phase 03 with a fresh session pointed at `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
