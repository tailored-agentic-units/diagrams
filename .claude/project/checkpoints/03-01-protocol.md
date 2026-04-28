# Phase 03 checkpoint — after protocol

## Just completed

`protocol/` library, 2-tier (collapsed):

- `protocol/core/readme.typ` — stakeholder essence (4-layer stack: agent / provider / format / protocol with capability pills inside protocol)
- `protocol/specification/readme.typ` — package architecture across three conceptual levels (level 0 primitives → level 1 output shapes → level 2 model runtime)
- `protocol/specification/response-shapes.typ` — response architecture (discriminated union via sealed `ContentBlock`, parallel `StreamingResponse`, structurally separate `EmbeddingsResponse`)
- `protocol/README.md` — H1 essence + stakeholder prose, H2 Specification + package diagram + dev prose, H3 Response Structures + response-shapes diagram + dev prose

All renders produced dual-theme SVG pairs.

## Next

`format/` library — 3-tier with sub-modules `openai` and `converse`.

Start the authoring loop at step 1: invoke `technical-writer` subagent against `~/tau/format`. Then sub-module loops for `openai` and `converse` after the parent.

## Toolkit deltas since previous checkpoint

All applied; details in the project doc's `## Toolkit refinements applied` section under "Protocol pilot."

- `technical-writer` subagent: tightened to require structural-role articulation
- `mise` pipeline: added `render-file <path>` for single-diagram iteration
- bootstrap convention: subagent symlink documented for `~/tau`-rooted sessions
- `typst-diagrams` skill: `shape: none` pitfall added to `fletcher-pitfalls.md`
- `tau-diagrams` skill: retired global purple raw-tint convention; removed from 28 ingredient sources
- `diagram-design-system` skill: documented `ink`-vs-neutral usage in `palette-pattern.md`
- memory: `feedback_prose_terminology.md` — standard programming terminology in technical prose

## Open threads

- Hue-quad `text-on-fill` slot was considered. Resolved by documenting the convention (use neutral `palette.ink` for body content on hue fills) rather than extending the quad. If body-text-on-hue patterns recur during `format`/`provider` and the convention proves awkward, revisit and codify a fifth slot.

## Resume protocol

1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
3. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
4. Skim `~/tau/diagrams/protocol/README.md` to anchor on current voice and pattern.
5. Confirm with user before resuming the authoring loop on `format/`.
