# Phase 03 checkpoint — after provider

## Just completed

`provider/` library, 3-tier with sub-modules `ollama`, `azure`, and `bedrock`:

- `provider/core/readme.typ` — overview (full TAU stack with `provider` as the blue focus slab carrying three transport-mechanic pills `endpoints` / `auth` / `streaming`; a single forked `calls` edge reaches three external services with cloud / server glyphs distinguishing managed APIs from self-hosted runtimes)
- `provider/operational/readme.typ` — module dependency graph (`provider` root with emphasized stroke and inner `streaming/` sub-package annotation; `ollama`, `azure`, `bedrock` as satellite go.mod sub-module cards with explicit `Register()` lines, auth-mode pills, and external-SDK notes; `protocol` shown at single-shape resolution as the native dep)
- `provider/specification/readme.typ` — `Provider` interface card with seven methods grouped into identity (supplied by BaseProvider embedding) and transport (implementation provides) sections; `protocol.Protocol` and `protostreaming.StreamReader` as muted single-shape native-dep references
- `provider/specification/types.typ` — vertical stack of BaseProvider, Provider (compact reference), and Request, with right-side labels carrying the supply / produce relationships
- `provider/specification/registry.typ` — three exported functions converging orthogonally on the internal `registry` singleton; `Factory` type alias as a satellite; `config.ProviderConfig` rendered above `Create` as the native-dep input flowing in
- `provider/README.md` — H1 + metadata + stakeholder prose; H2 Operational + operator prose; H2 Specification + dev prose; H3 Types + H3 Registry; H2 Implementations

`provider/ollama/` sub-module, 2-tier (collapsed):

- `provider/ollama/core/readme.typ` — adapter slab inside parent `provider` (single-shape native dep above); `Ollama runtime` external with server glyph (self-hosted) and `calls` edge; four capability pills with streaming markers on `chat` / `vision` / `tools`, no marker on `embeddings`
- `provider/ollama/specification/readme.typ` — two dispatch cards: `Endpoint` collapses Chat | Vision | Tools onto `/chat/completions` and routes Embeddings to `/embeddings`; `SetHeaders` is a conditional no-op with bearer / api_key / (absent) branches
- `provider/ollama/README.md` — H1 + metadata + non-developer prose; H2 Specification + dev prose

`provider/azure/` sub-module, 2-tier (collapsed) — first sub-module to introduce a second specification diagram:

- `provider/azure/core/readme.typ` — mirrors `ollama/core` structurally; cloud glyph for managed Azure OpenAI Service; same protocol-pill set (chat / vision / tools streaming-marked, embeddings unmarked)
- `provider/azure/specification/readme.typ` — two dispatch cards: `Endpoint` shows the deployment-keyed path templates with `?api-version=` query parameter inline in the row data; `SetHeaders` carries three real auth branches (api_key, bearer, managed_identity) with token-source distinctions in the right-side strings
- `provider/azure/specification/token-source.typ` — `AzureTokenSource` card with grouped construction / runtime sections; dashed external SDK boundary (`azcore.TokenCredential`) connected by a `delegates to` edge with 4× column spacing for label clearance
- `provider/azure/README.md` — same structure as ollama with H3 Token Source instead of additional dispatch tables; `External dependencies:` field added (`azure-sdk-for-go`)

`provider/bedrock/` sub-module, 2-tier (collapsed) — three specification diagrams (most structurally complex sub-module):

- `provider/bedrock/core/readme.typ` — three streaming-marked pills (chat / vision / tools); embeddings pill omitted entirely because the Converse API does not provide embeddings (genuinely unsupported, not just non-streaming); cloud glyph on the AWS Bedrock external
- `provider/bedrock/specification/readme.typ` — single `Endpoint` card with three rows: non-streaming `/model/{modelId}/converse`, streaming `/model/{modelId}/converse-stream`, embeddings unsupported; footnote section notes `{modelId}` is extracted from the request body. SetHeaders intentionally absent — SigV4 signing is unconditional, so the auth story belongs to credentials.typ
- `provider/bedrock/specification/credentials.typ` — `AWSCredentialSource` with grouped construction (default / static / profile auth_type dispatch) and runtime (numbered SignRequest steps) sections; dashed external SDK boundary (`aws-sdk-go-v2`) with `delegates to` edge
- `provider/bedrock/specification/eventstream.typ` — `EventStreamReader` frame header dispatch (`:message-type == "exception"` vs. data frame); dashed external SDK boundary (`aws-sdk-go-v2/eventstream`) with `decodes frames via` edge
- `provider/bedrock/README.md` — H3 Credentials + H3 Event Stream sections; `External dependencies:` field (`aws-sdk-go-v2`)

All renders produced dual-theme SVG pairs.

## Next

`agent/` library — 3-tier, no sub-modules (per the library order table at `03-core-tau-diagrams.md:181-189`).

Start the authoring loop at step 1: invoke `technical-writer` subagent against `~/tau/agent`.

## Toolkit deltas since previous checkpoint

Captured during provider authoring; full list logged in `03-core-tau-diagrams.md` under [Toolkit refinements applied](../03-core-tau-diagrams.md#toolkit-refinements-applied) → "Provider library (2026-05-05)".

`tau-diagrams` skill (`references/tau-decisions.md`):

- **External SDK / service boundary convention** — extended the "Native dependencies in diagrams" section. External boundaries render at single-shape resolution with a **dashed** border, distinct from native deps' solid thin border. Two visual conventions form a vocabulary: solid thin = "drill into TAU sub-directory for internals"; dashed = "outside TAU's source tree, contents belong to the third party." Examples linked: `azcore.TokenCredential` in azure/token-source.typ, `aws-sdk-go-v2` and `aws-sdk-go-v2/eventstream` in bedrock/credentials.typ and bedrock/eventstream.typ.

`diagram-ingredients` skill:

- **Multi-section card body** (`references/labels-and-encapsulation.md`) — pattern for splitting a single card into labeled sub-sections when it needs to convey multiple structurally distinct facets. Italic-light hue.ink `_section()` headings introduce each block; blocks separate with `v(gap-cell / 2)` rather than a second divider line; section labels read as commentary subordinate to the card title. Useful for lifecycle phases (construction vs. runtime), method groupings (identity vs. transport), or related dispatch tables (non-streaming vs. streaming variants).

- **Vertical-stack layout for verbose edge labels** (`references/edges-and-marks.md`) — when card-to-card relationships need long descriptive labels (e.g., "embedded — supplies Method() · OtherMethod()"), horizontal layouts crowd labels through narrow inter-card gaps. Stacking cards in a single column and using `label-side: right` (or `left`) pushes labels into unobstructed horizontal space beside the vertical edges. Trade-off is taller diagrams; appropriate when 2–3 related cards need verbose labels that can't be shortened. Cross-referenced from the corresponding fletcher pitfall.

`typst-diagrams` skill (`references/fletcher-pitfalls.md`):

- **Edge label position pitfall extended** — added a "label width exceeds segment length" sub-case. When the label is genuinely wider than the inter-shape gap, biasing `label-pos` doesn't help. Three structural fixes documented: increase column spacing (3–5×), switch to a vertical-stack layout (cross-referenced to the new edges-and-marks pattern), or shorten the label and move detail to prose.

## Open threads

Detailed open threads continue carrying forward to phase 04 via the prelude artifact. Phase-03-relevant carry-forwards in summary:

- **Helper module extraction timing** — `cap`, `card`, `_title`, `_kind`, `_fields`, `_card-body`, `lbl`, `edge-stroke`, plus the new `_section` helper introduced this round, are duplicated across many diagrams. Phase 04 should extract to a shared module after the first phase-04 subject confirms signatures generalize. The list of duplicated helpers grew this checkpoint — `_section` joins the set as a multi-section card body primitive.

- **Bend-sign default intuition mismatch** — unchanged; documented in `fletcher-pitfalls.md` with flip-test recommendation. (No bends used in provider diagrams — orthogonal polylines only.)

- **Mark overlay on shape** — unchanged; Fletcher 0.5.x limitation. Not exercised in provider diagrams.

- **Container header overlap with inner shapes** — unchanged; not exercised in provider diagrams (no two-node containers used).

- **Distinct print vs web token sets** — unchanged; phase-04 concern.

## Resume protocol

1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
3. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
4. Skim `~/tau/diagrams/provider/README.md` to anchor on current voice and pattern (most recent, reflects the H2-tier + Native/External dependencies header conventions; the Implementations section linking three sub-modules; multi-section card-body pattern; external SDK boundary visual treatment).
5. Confirm with user before resuming the authoring loop on `agent/`.
