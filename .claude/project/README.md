# TAU diagrams — phase orchestration

Multi-phase work on the TAU diagramming infrastructure. Each phase is its own Claude Code session — start a fresh session in plan mode and point the assistant at the matching phase doc. Memory carries universal conventions; phase docs carry session-scoped goals + state.

## Phases

| # | File | Status | Goal |
|---|---|---|---|
| 01 | [`01-catalog-infrastructure.md`](./01-catalog-infrastructure.md) | **complete** | Lock down the catalog and `design/*` as the foundational ingredient reference. Audit catalog files for design-system violations. |
| 02 | [`02-skill-development.md`](./02-skill-development.md) | **complete** | Author a layered set of five skills (`typst-diagrams`, `diagram-design-system`, `diagram-ingredients`, `diagram-authoring`, `tau-diagrams`) at `~/tau/diagrams/.claude/skills/`. Closed with the catalog → ingredients refactor: `catalog/` decomposed into `ingredients/` (5 axis sub-directories, 57 standalone single-concept diagrams, 5 axis overview diagrams, 6 narrative READMEs). |
| 03 | [`03-core-tau-diagrams.md`](./03-core-tau-diagrams.md) | pending | Design the diagram generation process (planning → generation → validation), then build core TAU library + signal flow diagrams (protocol/, format/, provider/, agent/, tau/). Seed the blueprints concept. |
| 04 | [`04-advanced-tau-diagrams.md`](./04-advanced-tau-diagrams.md) | pending | Apply skills + blueprints to `~/tau/orchestrate` and `~/code/herald`. |

Phases run in sequence — phase N depends on phase N-1 being substantively done.

## Cross-cutting concerns

These apply to every phase. Treat them as preconditions, not negotiables.

### Tool selection: Typst + Fletcher + CeTZ

Decision recorded 2026-04-24 (`memory/project_typst_selected.md`). Bake-off rationale at `~/tau/diagrams/DECISION.md`. Do not resurrect d2 patterns (ELK flags, `@import`, theme slots). Versions:

- `@preview/fletcher:0.5.8` — graph diagrams
- `@preview/cetz:0.3.4` — drawing primitives (pulled by Fletcher)

### Foundation: `design/`

Two files, pure values, no composition vocabulary:

- `~/tau/diagrams/design/tokens.typ` — whitespace, typography, stroke, geometry tokens
- `~/tau/diagrams/design/theme.typ` — palette traced to GitHub Primer primitives. Light/dark via `--input theme=light|dark`. **Color-anchored**: `palette.{blue,green,yellow,orange,red,purple,pink,coral}.{stroke,fill,ink}` plus neutral `surface*`, `ink`, `border*`. No domain tokens (no `palette.code-stroke`, no `palette.query`).

Every diagram pulls from these. No inline `pt` literals, no inline hex outside `design/`. Conventions in `memory/project_typst_design_system.md`.

### Single font: CaskaydiaMono NFP

A Nerd Font Patched proportional variant of Cascadia Mono. One family carries:

- Prose labels (titles, captions)
- Code-style content via `raw()` / backticks (method signatures, field types)
- Nerd Font icon glyphs (status, infrastructure, brand marks, etc.) in the Unicode Private Use Area

Embedded by-name through Typst's font-finding (system font); no font files committed. Font is required on the rendering system — install from the Nerd Fonts release archive (`CascadiaCode.zip` → `CaskaydiaMonoNerdFontPropo-*.ttf`).

**Glyph access:**

- Use Unicode escape strings: `"\u{F015}"` for nf-fa-home, `"\u{F0C2}"` for nf-fa-cloud, etc.
- Codepoint reference: [nerdfonts.com/cheat-sheet](https://www.nerdfonts.com/cheat-sheet) and [Nerd Fonts wiki — Glyph Sets and Code Points](https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points). The wiki is authoritative when codepoints disagree.
- The ingredients sub-directory `~/tau/diagrams/ingredients/color-and-glyphs/` carries the per-source glyph inventory (status, actions, infrastructure, people, files, control, relationships, brands, languages, frameworks, distros, source-control, dev-environment, weather, shell-prompt, power-and-session) plus the 13-source overview at `glyph-sources.typ`.

**Inline-code tinting (single-font convention):** because prose and `raw()` share the same font family, inline code needs colour to differentiate visually. Each diagram declares a `#show raw: r => text(fill: palette.<hue>.stroke, r)` rule. Purple (the default) is the project convention; any hue works. Without this rule, code blends into prose.

### Render pipeline: `mise.toml`

```bash
mise run render   # compiles every .typ except design/ modules; dual-theme; static/responsive aware
mise run clean    # removes all rendered SVGs
```

**Static vs responsive per-file**: a `// render: static` magic comment at the top of a `.typ` file keeps the SVG's fixed `width="…pt"` / `height="…pt"` (good for page-style references designed at a meaningful scale). Without it, those attributes are stripped post-compile so the SVG scales to its container via `<img width="100%">`. Default is responsive.

This is an interim workaround — Typst doesn't natively support responsive SVG output. Upstream contribution memo at `~/tau/typst-responsive-svgs.md`.

### Embedding diagrams in GitHub Markdown

```markdown
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./path/diagram-dark.svg">
  <img src="./path/diagram-light.svg" alt="…" width="100%">
</picture>
```

`<picture>` swaps theme; `<img width="100%">` scales the SVG via its viewBox. Pattern recorded in `memory/reference_github_picture_dual_theme.md`.

### Task runner: mise (not Make)

`memory/feedback_task_runner.md`. New task automation goes into `mise.toml`, never `Makefile`.

### Toolkit-not-ruleset philosophy

The skill, the ingredients reference, and every diagram are **composable toolkits**, not ruleset enforcers. The ingredients reference describes what's *achievable* and how each option *reads*. There's no canonical "shape X means concept Y" mapping. `memory/feedback_diagram_toolkit_not_ruleset.md` is the canonical statement.

If a pattern recurs across many diagrams, describe it as a **blueprint** (template) — don't formalise it into the foundation. Blueprints are descriptive, not prescriptive. The blueprints concept is seeded in phase 03 and developed across phases 03 + 04.

## References

- `~/tau/d2/` — archived v0 d2 workspace. Reference for what historically existed; does NOT inform Typst patterns.
- `~/tau/typst-responsive-svgs.md` — discussion seed for an upstream Typst contribution about responsive SVG output.
- `~/tau/diagrams/DECISION.md` — Phase 3 memo, rationale for selecting Typst.
- `/home/jaime/.claude/projects/-home-jaime-tau/memory/MEMORY.md` — index of universal conventions; every phase doc bootstraps from here.
