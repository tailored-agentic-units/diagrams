# Phase 03 — core TAU diagrams + generation process

Two-part scope:

1. **Process design**: identify the diagram generation pipeline Claude moves through in a session — likely planning → generation → validation, but verify the shape against actual practice.
2. **Generation**: produce the core TAU library + signal flow diagrams using that process. Libraries in scope: `protocol/`, `format/`, `provider/`, `agent/`. Signal flow: `tau/`. **`orchestrate/` is phase 04, not here.**

After the suite is generated, evaluate which compositions repeat enough to be promoted into **diagram blueprints** (templates that standardise common layouts without re-deriving them per diagram).

## Bootstrap

1. **`./README.md`** — cross-cutting concerns (tool selection, design foundation, single font, render pipeline, toolkit philosophy, blueprints framing).
2. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md`
   - `feedback_one_diagram_one_concept.md` — each diagram source = one output artifact at full resolution
   - `feedback_shape_vs_text.md` — shape kind = entity identity; metadata is structured text
   - `project_typst_design_system.md`, `project_typst_workspace.md`, `reference_typst_fletcher_pitfalls.md`
   - `reference_diagrams_repo.md` — diagrams repo is at `github.com/tailored-agentic-units/diagrams`
3. **Skill** — `~/tau/diagrams/.claude/skills/typst-diagrams/` is the primary tool. Invoke it at session start.
4. **Reference archive** — `~/tau/d2/` holds the v0 d2 diagrams. Use them to **understand intent** (what was the diagram trying to communicate?) — do **not** treat them as templates to port. The Typst+Fletcher architecture is different in shape and capability; a fresh visualisation strategy is part of this phase's job.

## Current state

Not started. Phase 02 must be done (skill validated).

## Part 1 — process design

Before generating anything, work out the pipeline. Candidate phases:

- **Planning**: gather intent (what does this library do, who reads this diagram, what relationships matter?). Identify entities (modules, services, operators, etc.) and relationships (calls, events, ownership). Decide which catalog ingredients fit (shapes, edges, layout pattern). Produce a written sketch / outline of the diagram before any Typst is written.
- **Generation**: compose the Typst source from `design/` + catalog ingredients per the skill's references. Render dual-theme.
- **Validation**: render → review against the planning intent → critique cycles. Does the diagram answer the question its planning step posed? Is anything redundant? Can the visualisation reduce cognitive load further?

Open questions to resolve as part of process design:

- Are there sub-phases (e.g., is "planning" actually planning + research)? Does the user want to be in the loop at planning, or does Claude propose-and-iterate?
- How is intent captured between planning and generation — a markdown stub committed alongside the `.typ` file?
- What does validation look like when the user is not in the room? (Self-critique against intent? Render and visually inspect via Read tool on the SVG?)
- Does process apply uniformly to library overviews and signal flow diagrams, or do they need distinct sub-processes?

Treat the process design as the first artifact this phase produces. Land it as a doc inside `~/tau/diagrams/` (probably `~/tau/diagrams/PROCESS.md` or similar) before generating any diagrams. The skill from phase 02 may need a small update to reference the process.

## Part 2 — generate the core diagrams

Once the process is defined, run it for each target:

| Target | Type | Notes |
|---|---|---|
| `~/tau/diagrams/protocol/` | library overview | One overview diagram per library — the public surface and key internal structure |
| `~/tau/diagrams/format/` | library overview | Same |
| `~/tau/diagrams/provider/` | library overview | Same |
| `~/tau/diagrams/agent/` | library overview | Same |
| `~/tau/diagrams/tau/` | signal flow | Cross-library request flow showing how a single request traverses the libraries |

For each: planning doc → Typst source → rendered SVGs → validation pass. Embed via the dual-theme `<picture>` pattern in each library's README.

### Reference archive

For each library, before planning, read whatever exists under `~/tau/d2/` (e.g., `~/tau/d2/protocol/`) to understand what the v0 diagram tried to convey. Inputs only — not templates. The Typst architecture supports patterns (composite shapes, custom shapes, encapsulated containers, parallel edges, layered routing) that d2 didn't, so re-deriving the visualisation strategy from intent often beats porting.

## Blueprints — once the suite exists

After the 5-target suite is complete, examine the generated diagrams for recurring compositions:

- Library overviews probably share structure (public-API band on one side, internal modules grouped, dependencies arrowed). If 3+ overviews share a layout, extract it as a blueprint.
- Signal flows may have a consistent header (request entry point) → fan-out → outputs shape. If recognisable, extract.

A **blueprint** is descriptive, not prescriptive — it's a template a diagram can opt into, not a rule it must follow. Blueprints live alongside the design system but are clearly marked as "blueprint, opt-in" not "convention, default-on". Likely location: `~/tau/diagrams/blueprints/` with each blueprint as `<name>.typ` exporting closures + a `<name>.md` documenting the intent.

The blueprints concept carries forward into phase 04 — when herald or orchestrate diagrams overlap with library-overview shape, reuse rather than re-derive.

## Done criteria

- [ ] Process design committed (likely `~/tau/diagrams/PROCESS.md`); user reviews and signs off on the pipeline shape.
- [ ] All 5 targets have planning docs, rendered SVGs (light + dark), and a validation pass.
- [ ] Each library README embeds its overview via the dual-theme `<picture>` pattern.
- [ ] Blueprints evaluated; if any extracted, they live under `~/tau/diagrams/blueprints/` with intent docs.
- [ ] Skill (phase 02) updated if process design surfaces a missing reference / convention.
- [ ] Diagrams repo committed (remote re-attach decision is the user's — do not push without explicit go-ahead per `memory/reference_diagrams_repo.md`).

## Hand-off to phase 04

When core diagrams + blueprints are settled: start a fresh session with `04-advanced-tau-diagrams.md`. Carry the process + blueprints forward to apply against `~/tau/orchestrate` and `~/code/herald`.
