# Phase 03 checkpoint — after format

## Just completed

`format/` library, 3-tier with sub-modules `openai` and `converse`:

- `format/core/readme.typ` — overview (full TAU stack with `format` as the blue focus slab carrying purple capability pills; a single forked `translates to` edge reaches `OpenAI API` and `AWS Bedrock Converse API` externals)
- `format/operational/readme.typ` — module dependency graph (`format` root with emphasized stroke at center; `openai` and `converse` as satellite sub-module cards with go.mod boundaries, exposed `Register()`, and supported-protocol pills; `protocol` shown at single-shape resolution as the native dep)
- `format/specification/readme.typ` — `Format` interface card with all four method signatures; `protocol.Protocol` and `response.StreamingResponse` as muted single-shape native-dep references
- `format/specification/data-types.typ` — four protocol-keyed input structs (`ChatData`, `VisionData`, `ToolsData`, `EmbeddingsData`) in blue; `Image` and `ToolDefinition` as composed helper types in purple, with `composes` edges
- `format/specification/registry.typ` — three exported functions converging orthogonally on the internal `registry` singleton; `Factory` type alias as a satellite
- `format/README.md` — H1 + metadata + stakeholder prose; H2 Operational + operator prose; H2 Specification + dev prose; H3 Data types + H3 Registry; H2 Implementations

`format/openai/` sub-module, 2-tier (collapsed):

- `format/openai/core/readme.typ` — adapter slab inside parent `format` (single-shape native dep above); `OpenAI API` external with `translates to` edge; four capability pills with streaming markers (`nf-oct-pulse`) on `chat`, `vision`, `tools`, no marker on `embeddings`
- `format/openai/specification/readme.typ` — three method dispatch tables (Marshal: four protocol paths; Parse: Chat+Vision coalesced on `parseChat` + `parseTools` + `parseEmbeddings`; ParseStreamChunk: streams non-Embeddings, errors on Embeddings)
- `format/openai/specification/wire-types.typ` — three wire-type families (non-streaming chain `apiResponse → apiChoice → apiMessage → apiToolCall → apiToolFunction`; streaming chain `streamChunk → streamChoice → apiDelta`; embeddings chain `embeddingsResponse → apiEmbedding`); shared `apiUsage` at row 1 with clean vertical dashed `Usage` edges
- `format/openai/README.md` — H1 + metadata + non-developer prose; H2 Specification + dev prose; H3 Wire Types + dev prose

`format/converse/` sub-module, 2-tier (collapsed):

- `format/converse/core/readme.typ` — mirrors `openai/core` structurally; three streaming-marked pills (no `embeddings` — Converse does not support it); `AWS Bedrock Converse API` external
- `format/converse/specification/readme.typ` — three dispatch cards with Converse-specific differences: Marshal has three protocol paths plus an explicit `Embeddings → error`; Parse coalesces all three supported protocols onto `parseResponse`; ParseStreamChunk is event-shape-keyed (`contentBlockDelta`, `messageStop`, `(unknown event) → nil, nil`) rather than protocol-keyed
- `format/converse/specification/wire-types.typ` — two wire-type families (non-streaming `apiResponse → apiOutput → apiMessage → contentBlock` with `toolUse` as a vertical sub-branch; streaming `streamEvent` as discriminated union with `*contentBlockDelta → delta` top branch and `*messageStop` bottom branch); shared `apiUsage` referenced only by `apiResponse`
- `format/converse/README.md` — same structure as openai's

All renders produced dual-theme SVG pairs.

## Next

`provider/` library — 3-tier with sub-modules `ollama`, `azure`, `bedrock`.

Start the authoring loop at step 1: invoke `technical-writer` subagent against `~/tau/provider`. Then sub-module loops for `ollama`, `azure`, `bedrock` after the parent.

## Toolkit deltas since previous checkpoint

This checkpoint absorbs both format-authoring friction and the herald OV-1 prelude (a phase-04 prelude session that ran in parallel and surfaced its own conventions for re-use). Combined into one pass; details by file.

Project doc / README pattern (`~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`):

- README header gained `Native dependencies:` and `External dependencies:` fields. `Native` lists documented TAU dependencies as relative links to sibling diagrams sub-directories; `External` lists third-party dependencies, repo-link preferred, docs/product-site fallback. Both fields omitted when empty — the absence of `External dependencies:` is itself meaningful evidence of TAU's commitment to minimizing external dependencies and supply-chain surface.
- README heading conventions made explicit: H2 names the **tier** (`Operational`, `Specification`, plus the navigational `Implementations`); H3 names the **content domain** of a sub-concept diagram (`Data types`, `Registry`, `Wire Types`). The Core tier has no H2; the leading `core/readme.typ` sits directly under H1.

`tau-diagrams` skill (`references/tau-decisions.md`):

- Added "Native dependencies in diagrams" section — native deps render at single-shape resolution (one shape with input/output edges; never expanded internals). Drilling into a native dep belongs to its own documentation. External (third-party) deps are not bound by the same rule and remain per-diagram decisions.

`typst-diagrams` skill (`references/fletcher-pitfalls.md`):

- **Empty-content node errors** — `node(coord, none, ...)` errors with cetz `array is empty`; use multi-vertex coord polylines instead of an invisible junction node.
- **Bend sign convention** — positive `bend` curves toward larger y on the default top-origin canvas (counter-intuitive on first try; flip-test on initial render).
- **Inset accepts only a single absolute value** — Fletcher 0.5.8 rejects the `inset: (x: ..., y: ...)` dictionary form; use a single value or wrap the body in an inner `box(inset: (x: ..., y: ...), ...)`.
- **Mark overlay on shape (unsolved)** — placing an arrowhead inside a shape's interior produces clipped arrows in 0.5.x; workaround is `-O` or `->` lands at the boundary; remains an open thread.

`diagram-ingredients` skill:

- `references/edges-and-marks.md`:
  - **Mirrored label placement** — explicit `label-side: left` / `right` override needed when two parallel-but-symmetric edges should carry labels on the same visual side.
  - **Vertical fan-out from a focal node** — stack destinations at the same x-coord and let edges fan out from a shared anchor; destinations' y-positions force divergence without crossings.
  - **Conditional fork-and-rejoin** — solid stroke for unconditional transitions, dashed for conditional fork branches; `if X` labels at the fork; bend the colliding branch for clearance.
  - **Return-edge pattern** — dashed body + slight bend + corner anchors for acknowledgement / response edges that shouldn't compete with forward flow.

- `references/labels-and-encapsulation.md`:
  - **Two-node container limitation note** — header and inner shapes must occupy distinct y-bands; overlap is unsolved.
  - **Multi-domain band layout** — security or organizational domains rendered as horizontal bands (each a two-node container); shared `surface-muted` fill carries visual continuity, headers differentiate, edges crossing band boundaries become the focal element.
  - **Inline pills with optional discriminator marker** — pill + appended Nerd Font glyph as an in-pill discriminator; markerless pill ≠ omitted pill (different signals, choose by reality).

`diagram-authoring` skill (`SKILL.md`):

- **Shape-body-as-semantic vs edge-labels-carry-semantics** decision section added (added during the herald OV-1 session); guides the per-diagram choice for dense vs flow content.

Auto-memory at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:

- `feedback_image_conversion_tool.md` — always use `magick` for image conversions (never `rsvg-convert` / legacy `convert` / inkscape).
- `feedback_diagram_review_workflow.md` — render with `mise run render-file` and yield to the user; no self-rasterizing mid-iteration.

Phase-04 prelude artifact:

- `~/tau/diagrams/.claude/project/04-prelude-herald-ov1.md` — captures conventions, patterns, friction, and open threads from the herald OV-1 leadership briefing session. Treated as a phase-04 input rather than phase-03 toolkit; phase 04 begins by reading it alongside `04-advanced-tau-diagrams.md`.

## Open threads

Detailed open threads carry forward to phase 04 via the prelude artifact. Phase-03-relevant carry-forwards in summary:

- **Helper module extraction timing** — `cap`, `card`, `_title`, `_kind`, `_fields`, `_card-body`, `lbl`, `edge-stroke` (and herald's `kinded`, `step-label`) are duplicated across many diagrams. Phase 04 should extract to a shared module after the first phase-04 subject confirms signatures generalize. Naming alignment: phase 03's `lbl()` and herald's `step-label` are functionally identical; pick one canonical name during extraction.
- **Bend-sign default intuition mismatch** — documented in `fletcher-pitfalls.md` with flip-test recommendation; persistent friction until a future Fletcher version exposes a clearer API.
- **Mark overlay on shape** — Fletcher 0.5.x limitation; documented; revisit on next Fletcher upgrade.
- **Container header overlap with inner shapes** — unsolved for compact dense containers; documented as a limitation on the two-node container pattern.
- **Distinct print vs web token sets** — herald's PDF tuning surfaced that font + spacing tokens calibrated for print may be slightly heavy for screen rendering. Phase 04 may benefit from a token-overlay system for print-targeted subjects.

## Resume protocol

1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
3. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
4. Skim `~/tau/diagrams/format/README.md` to anchor on current voice and pattern (most recent, reflects the H2-tier-name convention and the Native-dependencies header pattern).
5. Confirm with user before resuming the authoring loop on `provider/`.
