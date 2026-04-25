# Phase 04 — advanced TAU diagrams

Apply the established skill, design system, and emerging blueprints to two project domains:

- The **orchestrate** library at `~/tau/orchestrate`
- The **herald** project at `~/code/herald`

Continue refining diagram blueprints as recurring patterns surface.

## Bootstrap

1. **`./README.md`** — cross-cutting concerns.
2. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md`
   - `feedback_one_diagram_one_concept.md`
   - `feedback_shape_vs_text.md`
   - `project_typst_design_system.md`, `project_typst_workspace.md`, `reference_typst_fletcher_pitfalls.md`
3. **Skill** — `~/tau/diagrams/.claude/skills/typst-diagrams/`. Primary tool.
4. **Phase 03 outputs**:
   - `~/tau/diagrams/PROCESS.md` (or wherever the process lives) — the planning → generation → validation pipeline.
   - `~/tau/diagrams/blueprints/` — any blueprint templates extracted from the core suite.
   - The five core diagrams (protocol, format, provider, agent overviews + tau signal flow) as composition examples.
5. **Project repos**:
   - `~/tau/orchestrate/` — the orchestrate library.
   - `~/code/herald/` — the herald project (note: under `~/code/`, not `~/tau/`; different ownership context).

## Current state

Not started. Phase 03 must be done (process locked, core suite generated, blueprints — if any — extracted).

## Approach

Run the phase-03 process per project. For each project:

1. **Identify diagram needs** — library overview, signal flow, internal architecture, deployment, sequence, state, whatever the project's content warrants. A project may need more than one diagram. Apply the **one-diagram-one-concept** rule (`feedback_one_diagram_one_concept.md`).
2. **Bootstrap from blueprints if applicable** — if orchestrate's library overview matches the shape of a blueprint extracted in phase 03, opt into it; otherwise compose from primitives. Same for herald.
3. **Run the process**: planning → generation → validation per diagram.
4. **Commit + embed** in the project's README via the dual-theme `<picture>` pattern.

### Project-specific notes

**orchestrate** is a TAU library — its diagram suite likely parallels phase-03 library overviews (public surface, internal modules, dependencies). The natural blueprint candidate. If phase 03 produced a "library overview" blueprint, this is its second test case — refine the blueprint as needed.

**herald** is a separate project with its own architecture; the diagram suite needs more discovery. Examine the codebase first to understand what's worth visualising. herald may surface diagram shapes the core TAU work didn't (different operator topology? richer signal flow?), which is good — those become input to a richer blueprint set.

## Blueprint refinement

As you generate diagrams in this phase, watch for:

- **New blueprint candidates** — patterns that appear in herald or orchestrate but weren't in the phase-03 core. If they recur within phase 04 (e.g., across multiple herald diagrams), extract.
- **Existing-blueprint refinements** — places where a blueprint from phase 03 didn't fit cleanly. Either document the deviation as an opt-out parameter, or split the blueprint into variants.

Blueprints stay descriptive, not prescriptive (toolkit-not-ruleset). A blueprint is something a diagram can opt into, not a contract.

## Done criteria

- [ ] orchestrate has a complete diagram suite covering its key architectural perspectives, embedded in its README.
- [ ] herald has a complete diagram suite covering its key architectural perspectives, embedded in its README.
- [ ] Blueprints refined based on phase-04 findings; any new blueprints documented.
- [ ] Skill updated if phase-04 surfaced gaps in reference content.

## Hand-off

This is the terminal phase as currently scoped. After this:

- The skill is mature and can be applied to any future TAU project ad-hoc.
- Blueprints provide a starting point for new diagrams without re-deriving conventions.
- New phases (05+) can be added under `~/tau/diagrams/.claude/project/` if more project domains come into scope.
