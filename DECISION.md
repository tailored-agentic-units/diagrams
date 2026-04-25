# DECISION — Typst + Fletcher selected as TAU diagramming tool

**Date**: 2026-04-24
**Status**: committed
**Evaluation brief**: `~/tau/diagram-tool-evaluation.md`

## Outcome

**Typst + Fletcher + CeTZ** is the TAU diagramming tool going forward. The v0 d2 workspace is archived at `~/tau/d2/` as read-only reference.

## Why Typst won

- **Real programming language**: dictionaries, closures, `#import`, `#let`, `sys.inputs` — design tokens are first-class values, not string-substituted pragmas. Each architectural concept is a closure that binds tokens and palette at point-of-use. Variants are parameters, not CSS selectors.
- **Full design-token expressiveness**: every visual attribute (font, stroke, fill, inset, gap, radius, opacity, dash) reaches a token. There is no attribute namespace the tokens can't touch.
- **Independent container orientation**: each Fletcher `diagram()` has its own coordinate system; Typst's document-level `#stack(dir: ttb)` and `#grid` compose containers with independent internal directions. Mixed-orientation diagrams are native, not a hack.
- **Tokenised whitespace control**: `inset`, `outset`, `spacing`, `gap`, `pad` are all real values in a tokens dict. This directly solves d2's shape-level padding gap.
- **Native structured content**: `stack`, `grid`, `text(weight: ...)` handle multi-line labels (method lists, field tables, enum values) without HTML soup or XML tables.
- **Deterministic in practice**: same source + pinned Fletcher/CeTZ versions → stable SVG path output.
- **Cohesive typography via single Nerd Font**: `CaskaydiaMono NFP` covers prose labels, code-style content, and inline icon glyphs (for badges, operator decorations) in one family — no sans/mono split, no icon-asset management.

## Why the finalists lost

**Graphviz + external CSS**. Disqualified during bake-off.
- Any structured content (interface methods, structure fields, enum values) forces HTML-like `<TABLE>` authoring; CELLPADDING, per-cell FONT, and layout-level attributes live in the HTML namespace where design tokens don't reach.
- `rankdir` is graph-level only; arranging disconnected clusters requires invisible-edge anchor hacks or `packmode` heuristics.
- No macro or import system; `cpp -P` preprocessor workaround is brittle.
- Net: authoring cost scales linearly with content density; tokens pay no dividends for rich diagrams.

**Mermaid + themeCSS**. Disqualified during bake-off.
- `classDef` cannot change node shape; `linkStyle` is index-based, not named — the schema's 10 concepts + 3 edge semantics don't map cleanly.
- HTML labels inside nodes truncate at fixed widths; structured content (the 5-method interface, 6-field structure) rendered as "Re test" / "id test" fragments.
- ELK layout under mixed-direction subgraphs laid containers left-to-right in wrong order, with a 1748pt-wide viewport vs. Typst's 820pt for the same content.
- Inline text styles on foreignObject content defeat external CSS for theme-aware text colouring.

**Excalidraw**, **Penrose**. Disqualified in Phase 1.
- Excalidraw: no official headless CLI, non-deterministic output (Rough.js seeds + versionNonce), no style-class system, no design-token layer. Every d2 pain point amplified.
- Penrose: best philosophical match (Domain/Substance/Style trio) but no Docker image, no documented global install, no Style imports, no sequence-diagram prior art, thin LLM training coverage. Would turn Phase 2 into multi-week tool-building.

## Known compromises accepted

- **Pre-1.0 tooling**: Typst 0.14.2, Fletcher 0.5.8, CeTZ 0.3.4 are all pre-1.0. API churn between 0.x minors is documented (e.g., CeTZ 0.4 → 0.5 migration). Mitigation: pin exact versions in package imports; expect periodic refactors as the ecosystem matures.
- **Fletcher single-maintainer bus-factor**: the diagram layer depends on one maintainer's continued work. Mitigation: Fletcher is a thin layer on CeTZ (which is well-maintained) and our authoring conventions are expressible in raw CeTZ if we ever need to drop Fletcher.
- **Dual-render for light/dark**: Typst bakes colours in at compile time; two SVG files per diagram instead of d2's single-file `prefers-color-scheme`. GitHub Markdown's `<picture>` element handles viewer-side swap cleanly so this is not a regression for the target audience.
- **SVG text as glyph paths**: Typst emits text as vector paths, not `<text>` elements. Consequence: diagrams render identically across viewers without font availability, but text is not selectable or copy-pasteable. Acceptable for architecture documentation.
- **Font dependency at build time**: `CaskaydiaMono NFP` must be installed on any host building the diagrams. Local dev: already installed. CI: will need to vendor `.fonts/*.ttf` into the repo and point `TYPST_FONT_PATHS` when CI is wired up.
- **LLM training coverage for CeTZ/Fletcher**: thinner than Mermaid/Graphviz. Mitigation: the skill's reference documentation will carry worked examples so Claude can author diagrams from the skill's conventions rather than training recall.

## Open questions deferred

- **Codegen layer** (schema YAML → Typst source generator): deferred. Typst's native ergonomics are good enough that a generator is not needed for v1. Revisit if authoring cost scales poorly.
- **Hosting model**: local-only for now (no hosted editor). Revisit when team size grows.
- **Custom shape decorations** (module folder-tab, structure header-bar, enum side-stripe): under consideration pending the shape catalog pass. Current state: four concepts share `rect`, differentiated by colour + kind annotation only.
- **Service variant decoration**: stroke-dash pattern works; alternative Nerd Font corner badges (`` house / `` cloud) are the obvious upgrade since the project font already carries the glyphs. To be decided during the shape catalog pass.
