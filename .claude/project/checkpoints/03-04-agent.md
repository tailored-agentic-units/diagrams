# Phase 03 checkpoint — after agent

## Just completed

`agent/` library, 3-tier with no sub-modules:

- `agent/core/readme.typ` — overview (full TAU stack with `agent` as the blue focus slab at the top, carrying four protocol pills `chat` / `vision` / `tools` / `embed` with streaming markers on chat and vision; `provider` / `format` / `protocol` muted layer cards below; a single `talks to` edge reaches a generic `LLM service` external with a cloud glyph)
- `agent/operational/readme.typ` — module wiring container (foreground header `agent · go.mod` above; inner sub-package cards `client/` with retry-knob field-list, `request/`, `registry/`, plus `mock/` tucked above the inner row at fractional row 1; native deps `protocol` / `format` / `provider` directly below at row 3 with vertical import edges; external `google/uuid` at column 5, well clear of the container for label breathing room)
- `agent/specification/readme.typ` — `Agent` interface card with multi-section body (5 accessor methods on top, 6 protocol methods on bottom); muted constructor card `New(cfg, provider, format) → Agent` above with `constructs` edge; `protocol.Message` extern on the left; multi-line response group extern on the right listing `response.Response` / `response.StreamingResponse` / `response.EmbeddingsResponse`
- `agent/specification/request-types.typ` — `Request` interface above + four concrete request types (`ChatRequest`, `VisionRequest`, `ToolsRequest`, `EmbeddingsRequest`) in a row + `format.Format` below. Both relationships rendered as **convergent-edges trees**: dashed `implements` tree fanning up to Request, solid `Marshal() delegates to` tree fanning down to format.Format
- `agent/specification/registry.typ` — `Registry` struct (focal, two-section card body for state and concurrency); `NewRegistry()` constructor above with `creates` edge; **operations ledger card** on the left (5 non-Get methods consolidated into a muted 2-column card) with a single umbrella `modify configs / agents` edge; `Get(name)` pushed down on the right with cache-hit edge into Registry; cache-miss path of `provider.Create` → `format.Create` → `agent.New` rendered as a vertical sequence; `agent.New` writes back into Registry's `agents` map via a routed L-shape under the diagram. Both wide labels (`modify configs / agents`, `reads agents (cache hit)`) ride the vertical segments of L-shaped edges, occupying corner whitespace rather than the narrow midline gap between cards.
- `agent/README.md` — H1 + metadata + stakeholder prose; H2 Operational + operator prose; H2 Specification + dev prose covering the Agent interface, New constructor, mergeOptions, and AgentError taxonomy; H3 Request Types + dev prose; H3 Registry + dev prose. No Implementations section (no sub-modules).

All renders produced dual-theme SVG pairs.

## Next

`tau/` cross-cutting capstone — 3-tier, no sub-modules (per the library order table at `03-core-tau-diagrams.md:181-189`). The capstone subject composes vocabulary from all four prior libraries (`protocol`, `format`, `provider`, `agent`) to show cross-library signal flow for a single request.

Start the authoring loop at step 1: invoke `technical-writer` subagent against the conceptual `~/tau/` workspace as the subject, with `~/tau/{protocol,format,provider,agent}/` as input source materials. Note that `tau/` is a cross-library capstone diagram, not a separate Go module — the technical-writer needs explicit framing about that.

## Toolkit deltas since previous checkpoint

Captured during agent authoring; full list logged in `03-core-tau-diagrams.md` under [Toolkit refinements applied](../03-core-tau-diagrams.md#toolkit-refinements-applied) → "Agent library (2026-05-07)".

`diagram-ingredients` skill:

- **Convergent-edges tree pattern** (`references/edges-and-marks.md`) — N sources sharing one relationship label / arrowhead style to a single target render as N orthogonal edges that overlap on a shared trunk + rail. Each edge is a 4-vertex polyline (source → leg → rail → trunk → target); the trunk segment is drawn N times pixel-for-pixel, reading as a single tree branching out to N leaves. Only the leftmost edge carries the shared label; `label-pos: 0.7`–`0.85` lands it mid-trunk. Replaces the N-diagonal fan-in pattern that becomes a tangle for N ≥ 3. The user explicitly endorsed this pattern as "great for diagrams that have converging edges from multiple shapes."

- **L-shape edges with labels in corner whitespace** (`references/edges-and-marks.md`) — when a wide label can't fit in the narrow midline gap between two cards, an L-shaped edge route (3-vertex polyline with one orthogonal turn) opens a corner rectangle for the label. The label rides the segment that sits in the cleaner corner; `label-pos` and `label-side` together determine placement. Includes the "side relative to direction of travel" rule-of-thumb (going south, `left` = east; going north, `left` = west; etc.).

- **Operations ledger card** (`references/labels-and-encapsulation.md`) — when a focal type has 4+ operations with uniform read/write/delete semantics, consolidate them into a single muted card with a 2-column grid (signature → effect) and an umbrella edge to the focal type. Replaces N individual operation cards with N labeled edges, keeping the diagram's structural emphasis on the *one* operation that warrants its own node (e.g., a cache-miss flow with cross-package calls).

## Open threads

Detailed open threads continue carrying forward to phase 04 via the prelude artifact. Phase-03-relevant carry-forwards in summary:

- **Helper module extraction timing** — `cap`, `card`, `_title`, `_kind`, `_section`, `_fields`, `_card-body`, `_methods`, `lbl`, `edge-stroke`, `extern`, `extern-multi`, `func-card`, `ops-ledger`, `constructor-card`, `pkg-card`, `dep`, plus the new `_methods-with-effects` grid pattern, are duplicated across many diagrams. Phase 04 should extract to a shared module after the first phase-04 subject confirms signatures generalize. The set of duplicated helpers continues to grow each round.

- **Bend-sign default intuition mismatch** — unchanged; documented in `fletcher-pitfalls.md` with flip-test recommendation. (No bends used in agent diagrams — all orthogonal polylines.)

- **Mark overlay on shape** — unchanged; Fletcher 0.5.x limitation. Not exercised in agent diagrams.

- **Container header overlap with inner shapes** — used the two-node container variant successfully in `agent/operational/readme.typ`; the variant performed cleanly with the foreground header at row 0 and inner sub-packages at row 1. mock/ at fractional row 1 (positioned above the main inner row) tested the pattern's tolerance for a non-grid-aligned inner node — worked without issue.

- **Distinct print vs web token sets** — unchanged; phase-04 concern.

- **Label-pos calculation friction** — landing labels precisely on a specific segment of multi-vertex polylines required iterative tuning (0.95 hugged the target; 0.85 was close but still a hair high; 0.8 was the user-confirmed sweet spot for the convergent-tree label). Documented in the new convergent-edges section, but a future enhancement could be a helper that computes label-pos given desired position-along-segment.

## Resume protocol

1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
3. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
4. Skim `~/tau/diagrams/agent/README.md` to anchor on current voice and pattern (most recent, no-sub-module 3-tier; convergent-edges tree pattern; operations ledger card; L-shape edges with corner-whitespace labels).
5. Confirm with user before resuming the authoring loop on `tau/` (the cross-cutting capstone — distinct framing needed: not a Go module but a cross-library overview).
