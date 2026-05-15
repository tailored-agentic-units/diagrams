# Phase 04 checkpoint — after orchestrate (phase 04 subject 1)

## Just completed

`orchestrate/` cross-cutting library, 3-tier, no sub-modules. Four diagrams:

- `orchestrate/core/readme.typ` — stakeholder overview. Focal `orchestrate` slab (blue) with four interior capability rows (Hub, State Graph, Workflow Patterns, Observability) each in purple with a 2-column grid pinning the glyph to a fixed-width left slot and centering the name + role line in the remaining `1fr` width. Participants (orange, `\u{F0C0}` users glyph) enter from the left with a `register · communicate` edge.
- `orchestrate/operational/readme.typ` — operator-voice runtime composition. Two config cards (`HubConfig`, `GraphConfig`) at row 0 → two emphasized runtime cards (`Hub`, `StateGraph`) at row 1 → two registry cards at row 2 (observability registry between cols 1 and 2, checkpoint-store registry beneath StateGraph). Construction edges labeled `hub.New(ctx, cfg)` / `state.NewGraph(cfg)`; resolution edges labeled `GetObserver(cfg.Observer)` / `GetCheckpointStore(cfg.Checkpoint.Store)` — the latter routed as an L through row-1 whitespace so its label doesn't collide with the `GetCheckpointStore` edge.
- `orchestrate/specification/readme.typ` — developer-voice Hub composition + Workflow patterns + bridge to state graph. Two clusters: top row Participant / Hub (focal, 4-section method body: registration · messaging · publish-subscribe · lifecycle) / MessageHandler with MessageChannel[T] below; bottom row three workflow-pattern cards (ProcessChain, ProcessParallel, ProcessConditional) → three muted bridge wrappers (ChainNode, ParallelNode, ConditionalNode) → single state.StateNode extern via convergent-edges tree at rail row 4.8 → row 5.5. Hub-composition edges use two-line `lbl-multi` labels to fit the narrow vertical slot between the wide Hub card and its row-0 siblings.
- `orchestrate/specification/state-graph.typ` — developer-voice graph execution engine. StateGraph interface focal at row 0 (`structure` + `execution · recovery` method sections); State (with persisted/excluded/immutable-mutation triple section) + CheckpointStore at row 1; StateNode + Edge + predicate-combinator catalog at row 2. StateGraph outflows route as L-shapes from the focal east/west center face through row 0 whitespace to land at the row-1 sibling's north center face.
- `orchestrate/README.md` — standard `Library:` / `External dependencies:` header (Native dependencies field omitted, per the phase-03 omit-when-empty convention; orchestrate's only dep is `google/uuid`). Stakeholder voice under H1, operator voice under `## Operational`, developer voice under `## Specification` + `### State Graph`.

All renders produced dual-theme SVG pairs via `mise run render-file`.

## Next

Phase 04 subject 2: `~/code/herald/`. Per `04-advanced-tau-diagrams.md:24-25` and the herald-OV-1 prelude (`04-prelude-herald-ov1.md`). Herald is a service (vs. orchestrate's library), so the diagram suite shape will likely depart — herald-OV-1's `kinded` helper, multi-domain band layout, dashed-bent return edges, and conditional fork-and-rejoin pattern are candidate ingredients. The first phase-04 subject (orchestrate) reused the phase-03 library inventory cleanly; herald is where the herald-OV-1 conventions get folded in.

A fresh-session resume of this checkpoint is the validation signal that orchestrate's outputs + the two toolkit deltas below survive a context reload.

## Toolkit deltas since previous checkpoint

Captured during orchestrate authoring; both deltas are in `diagram-ingredients`.

- **diagram-ingredients skill (`references/labels-and-encapsulation.md`):** Added *Two-line label for narrow slots* under "Label patterns" — when a horizontal label slot is narrower than the natural phrasing (typically because one flanking card is much wider than the other), wrap the label onto two centered lines via a `lbl-multi` stack helper. Cheaper than moving label-pos around to fit a fixed slot; the line break reads as a soft hyphen. Worked example shipped using the `registered via · Register()` labels in orchestrate/specification/readme.typ.
- **diagram-ingredients skill (`references/edges-and-marks.md`):** Extended *L-shape edges with labels in corner whitespace* with the *focal card with row-1 siblings* variant — the common composition where a focal row-0 card has two siblings on row 1 to its left and right. L-shape edges exit the focal card's east/west center face, traverse row-0 whitespace, and turn south at the sibling's column to land on the sibling's north center face. `label-pos: 0.3` pins each label to the horizontal segment; mirrored L's need opposite `label-side` values because their segment-0 directions are opposite. Worked example shipped using StateGraph → State / CheckpointStore in orchestrate/specification/state-graph.typ.

No `tau-diagrams` / `typst-diagrams` / `diagram-design-system` / `diagram-authoring` deltas this checkpoint.

## Open threads

Carry-forward summary; phase-04 prelude (`04-prelude-herald-ov1.md`) remains the destination for anything that should outlive this phase.

- **Helper module extraction timing** — still deferred, now with one more data point. Orchestrate's specification cards reused the phase-03 helper inventory (`_title`, `_kind`, `_section`, `_methods`, `_card-body`, `card`, `extern`, `lbl`, `edge-stroke`) verbatim and added two new helpers: `bridge-card` (orchestrate-specific muted constructor card variant) and `lbl-multi` (now generalized into `labels-and-encapsulation.md`). The "TAU library specification" signature set is stable across 5 subjects; the open question is whether herald's service-oriented diagrams (which used `kinded`, `step-label`, multi-domain bands in the OV-1 prelude) will share enough surface with the library helpers to justify one shared module, or whether the two should remain distinct. Extract after herald confirms.

- **Bend-sign default intuition mismatch** · **Mark overlay on shape** · **Distinct print vs. web token sets** · **Label-pos calculation friction** — all unchanged from 03-05-tau. No new evidence this checkpoint.

- **Workflow-pattern observability surfacing** — orchestrate's three workflow-pattern functions (`ProcessChain`, `ProcessParallel`, `ProcessConditional`) each resolve an `Observer` via the same registry as `StateGraph`, but they're invocations rather than long-lived constructed entities, so they don't appear in the operational diagram. The prose carries this fact ("the same observer registry is also resolved by ChainConfig, ParallelConfig, and ConditionalConfig"). If herald or future phase-04 subjects also have stateless function-call patterns that resolve registries, this may warrant a dedicated ingredient: "stateless function with name-resolution side effect" — for now, prose alone is sufficient.

## Resume protocol

1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/04-advanced-tau-diagrams.md` (phase 04 master).
3. Read `~/tau/diagrams/.claude/project/04-prelude-herald-ov1.md` (herald-session conventions captured ahead of phase 04).
4. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
5. Skim `~/tau/diagrams/orchestrate/README.md` to anchor on orchestrate's voice and the Library / External-deps header form (Native dependencies omitted convention).
6. Confirm with user before resuming on herald. The herald subject is `~/code/herald/` (note: under `~/code/`, not `~/tau/`).
