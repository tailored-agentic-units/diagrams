# Phase 02 — skill development

Author a layered set of five skills at `~/tau/diagrams/.claude/skills/`. Four lower skills are domain-agnostic (any project using Typst + Fletcher could install them). The fifth, `tau-diagrams`, layers TAU's opinionated decisions on top.

Phases 03 and 04 load `tau-diagrams`, which composes the lower skills.

## Bootstrap

1. **`./README.md`** — cross-cutting concerns (toolkit philosophy, design foundation, single font, render pipeline, dual-theme embedding).
2. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md` — non-negotiable framing
   - `feedback_one_diagram_one_concept.md`, `feedback_shape_vs_text.md` — universal diagramming conventions
   - `project_typst_design_system.md`, `project_typst_workspace.md` — design + workspace patterns
   - `reference_typst_fletcher_pitfalls.md` — distill into `typst-diagrams/references/fletcher-pitfalls.md`
3. **Source material for distillation** (read, do not link to from skill content):
   - `~/tau/diagrams/catalog/*.typ` — ingredient sources for `diagram-ingredients` references
   - `~/tau/diagrams/design/{tokens,theme}.typ` — implementation example for `diagram-design-system` (kept anonymous in the skill — TAU-specific values stay in `tau-diagrams`)
   - `~/tau/diagrams/mise.toml` — render pipeline pattern
4. **The skill-creator skill** — invoke via `Skill skill-creator:skill-creator` when bootstrapping each skill's structure.

## Current state

Not started. Phase 01 is complete (catalog locked, design audit clean).

## Skill graph

```
tau-diagrams                    ← opinionated TAU decisions
├── diagram-authoring           ← universal design process + minimal blueprint spec
├── diagram-ingredients         ← ingredient inventory (text/space, color/glyphs, …)
├── diagram-design-system       ← tokens / palette / typography patterns
└── typst-diagrams              ← Typst + CeTZ + Fletcher stack conventions
```

`diagram-design-system` and `diagram-ingredients` are independent peers above `typst-diagrams`. `diagram-authoring` depends on both. `tau-diagrams` depends on all four.

## Self-sufficiency rule

Skills are self-contained. They distill the knowledge developed in `~/tau/diagrams/catalog/` and `~/tau/diagrams/design/` into their own reference files. They do **not** cross-reference those directories by path.

Reasons:

- Skills must work for non-TAU projects that don't have those directories.
- The catalog and design folders may evolve (phase 05 renames `catalog/` → `ingredients/`); skills shouldn't depend on those paths.
- Distilling the knowledge into the skill forces clarity about what's actually transferable vs. TAU-specific.

When a skill needs concrete examples, it inlines short snippets directly. The canonical implementations remain in `catalog/` and `design/` for human reference and rendering, but skills don't point at them.

## Per-skill anatomy

All under `~/tau/diagrams/.claude/skills/<name>/`. Frontmatter follows Anthropic's spec (capability sentence + "Use when…" trigger clause, ≤1024 chars, third person).

### 1. `typst-diagrams/`

Typst + CeTZ + Fletcher stack conventions, render pipeline patterns, version-specific pitfalls. Not about diagram design or TAU.

- `SKILL.md`
- `references/render-pipeline.md` — `--input theme=…`, `// render: static` marker semantics, dual-theme SVG output, generic task-runner phrasing
- `references/fletcher-pitfalls.md` — self-loop extent, 180° degeneracy, let-rebind, label-fill, raw tinting, edge-label position, mark word-forms, `repr()` slice
- `references/cetz-shapes.md` — closure API for custom anchor-aware shapes; minimal inlined example
- `references/typst-idioms.md` — content composition for label bodies (raw, math, mixed runs), show-rule scoping

**Excludes:** tokens, palette, font choice, design process, TAU specifics, catalog/design path references.

### 2. `diagram-design-system/`

Patterns for authoring a design layer (tokens, palette, typography). Source-agnostic: GitHub Primer + Caskaydia shown alongside non-Primer alternatives so the pattern is visibly reusable.

- `SKILL.md`
- `references/tokens-pattern.md` — what belongs in a tokens file (whitespace, typography scale, stroke, geometry); what doesn't (color, domain semantics)
- `references/palette-pattern.md` — color-anchored vs domain-named palettes, `(stroke, fill, ink, divider)` quad rationale, hue ladders, theme-swap mechanism
- `references/typography-pattern.md` — single-family conventions, hierarchy via weight + size, raw text tinting, multiple valid font choices. **Includes a Nerd Font orientation:** brief explainer (what Nerd Fonts are; the patched glyph PUA; why a Nerd Font variant is required if the design system needs glyph integration). Detailed glyph composition stays in `diagram-ingredients`.

**Excludes:** TAU's specific palette numbers, the Primer-vs-others choice, Caskaydia as canonical, glyph composition patterns.

### 3. `diagram-ingredients/`

Universal inventory of diagram ingredients. Toolkit-not-ruleset framing. Self-contained.

- `SKILL.md`
- `references/text-and-space.md` — typography + spacing
- `references/color-and-glyphs.md` — palette + glyph composition patterns
- `references/shapes-and-variants.md` — shape primitives (built-in / composite / custom) + variant techniques
- `references/edges-and-marks.md` — edge primitives + mark variants
- `references/labels-and-encapsulation.md` — node-body composition + named inner nodes

**Excludes:** verbatim catalog source paths, Fletcher version pin, design-system tokens, authoring process, TAU specifics.

### 4. `diagram-authoring/`

Universal design process for composing diagrams from user requirements and source materials. Blueprints are an **optional enhancement**, not a prerequisite.

- `SKILL.md` — the design process: user provides intent + source materials (source code, written specs, structured data, prose); skill helps elicit information, choose ingredients, draft, critique, and iterate. Blueprints, when supplied, accelerate this.
- `references/blueprint-spec.md` — minimal baseline spec only. Phase 02 ships only the spec; no blueprints are authored.
- `references/critique-checklist.md` — heuristics for self-critique (one-diagram-one-concept, shape-for-identity / text-for-metadata, descriptive-not-prescriptive)
- `references/initialization.md` — how a session starts: gather user intent + identify source materials. Optionally ask whether a blueprint applies. Default path: design without one.

**Excludes:** any concrete blueprint, palette/font/shape decisions, anything domain-named, any assumption that a blueprint is required.

### 5. `tau-diagrams/`

TAU's opinionated lock-in. Short orientation; declares lower-skill dependencies and encodes TAU decisions.

- `SKILL.md` — declares lower-skill load order, encodes TAU decisions
- `references/tau-decisions.md` — GitHub Primer hue assignments, CaskaydiaMono NFP, color-anchored palette (no domain tokens), `mise run render`, `// render: static` semantics
- `references/dual-theme-embedding.md` — GitHub `<picture>` pattern, light/dark sibling SVG pairs

**Excludes:** any blueprint files. No re-explanation of content already covered by the four lower skills.

## Composition model

Project-local skills don't have marketplace `plugin:skill` namespacing. Each upper skill's `SKILL.md` opens with a "Load these skills first" block referencing peer skills by name. Lower skills include a "Composes with" line listing peers.

Example (top of `tau-diagrams/SKILL.md`):

```markdown
This skill layers on four lower skills. Load them in this order before
applying TAU-specific decisions:

1. `typst-diagrams` — Typst + CeTZ + Fletcher stack conventions and pitfalls.
2. `diagram-design-system` — design-layer pattern (tokens, palette, typography).
3. `diagram-ingredients` — ingredient inventory.
4. `diagram-authoring` — universal design process and the blueprint spec.
```

If a later phase packages these as a marketplace plugin, dependency references rename mechanically to `plugin:skill` form.

## Blueprint specification (minimal baseline)

`diagram-authoring/references/blueprint-spec.md` defines the format. Phase 02 ships **only the spec**; no blueprints are authored. The spec stays minimal so the first real blueprint (encountered in a later phase) can drive concrete refinements.

Blueprints are an **optional enhancement** to the authoring process. The skill never requires one — it can compose diagrams directly from user requirements and source materials.

**Storage convention** (documented in the skill, no directories created in this phase):

1. Path(s) the user supplies during initialization (any location).
2. `<project>/.claude/blueprints/*.md` for project-specific patterns.
3. `~/tau/diagrams/blueprints/*.md` for TAU's canonical patterns (peer to `catalog/`/`ingredients/` and `design/`, populated in a later phase).

**Minimal blueprint format** — frontmatter + four sections:

```markdown
---
name: <kebab-case>
description: <one sentence: what concept this blueprint expresses>
---

## Intent
<what this blueprint is for>

## Structural rules
<bulleted constraints any instance must satisfy>

## Variation points
<what authors choose per instance>

## Example
<absolute path to one rendered .typ source, or "none yet">
```

Deliberately omitted from the baseline (revisit at first real use): an `ingredients` block, anti-patterns, applies-to taxonomy, multi-example galleries.

## Layer-leakage guardrails

Each `SKILL.md` includes a "Sanity checks" section:

| Skill | Test |
|---|---|
| `typst-diagrams` | No mention of GitHub Primer, Caskaydia, `mise` (specifically), TAU. Pipeline references say "task runner" generically. No paths to `catalog/` or `design/`. |
| `diagram-design-system` | Every Primer reference paired with a non-Primer alternative; every font reference shows ≥2 valid choices; "color-anchored, never domain-named" stated repeatedly. Nerd Font orientation present in typography reference. |
| `diagram-ingredients` | No Fletcher version pin; no TAU-specific shapes named; no design-system tokens cited; no path references to `catalog/`. |
| `diagram-authoring` | Zero ingredient names (no "rect", no "blue") outside frontmatter examples. Spec only — no concrete blueprints. Process must work without any blueprint loaded. |
| `tau-diagrams` | Short (~200 lines target). If it grows, content has leaked down. Every TAU decision points to its lower-skill pattern. |

**Rename test.** Could this skill be reused unchanged by a non-TAU project using Typst + Fletcher with a different palette/font? "Yes" for skills 1–4. "No" only for `tau-diagrams`.

## Build sequence

`skill-creator` evals as gates between steps:

1. **`typst-diagrams`** — foundation. Distills existing memory + catalog source comments. Smallest content.
2. **`diagram-design-system`** + **`diagram-ingredients`** in parallel — independent peers above the foundation. Ingredients is meatier (5 ref files distilling the catalog). Design-system is thinner (3 ref files of pattern, including the Nerd Font note).
3. **`diagram-authoring`** — depends on both peers. The non-blueprint authoring path is the main flow; minimal blueprint spec is the secondary artifact.
4. **`tau-diagrams`** — pure aggregation + opinionated decisions. Cannot start until 1–3 validate against synthetic non-TAU prompts.
5. **Catalog → ingredients refactor** — first real authoring exercise against the skills. Builds `~/tau/diagrams/ingredients/` alongside the existing `catalog/`, decomposes page-style files into single-concept diagrams, authors per-axis README narratives, and adds an indexed top-level README with overview diagrams. Closes phase 02 and surfaces any final skill updates. Bootstrap a fresh session against [`catalog-to-ingredients.md`](./catalog-to-ingredients.md).

## Done criteria

- [ ] Five skills scaffolded under `~/tau/diagrams/.claude/skills/` per skill-creator's structural recommendations.
- [ ] Each `SKILL.md` frontmatter has the capability + "Use when…" trigger format.
- [ ] Self-sufficiency rule honored — no skill content references `~/tau/diagrams/catalog/` or `~/tau/diagrams/design/` paths.
- [ ] Layer-leakage guardrails pass: rename test holds for skills 1–4; sanity checks documented in each `SKILL.md`.
- [ ] Skill-creator's quality criteria pass for each skill (run skill-creator's measurement / eval flow).
- [ ] Manual test: in a fresh session, load `tau-diagrams` and ask it to draft a small TAU diagram; render successfully via `mise run render`.
- [ ] Catalog → ingredients refactor complete per [`catalog-to-ingredients.md`](./catalog-to-ingredients.md): `~/tau/diagrams/ingredients/` built, rendered, top-level wiring updated, old `catalog/` removed.

## Hand-off to phase 03

When the skills validate and the catalog → ingredients refactor is complete: start a fresh session with `03-core-tau-diagrams.md`. `tau-diagrams` becomes the primary tool for everything in phases 03 and 04.
