# Phase 03 — core TAU diagrams

Produce the first opinionated diagram suite consuming the phase 02 toolkit. One sub-directory per core library (`protocol`, `format`, `provider`, `agent`) plus a cross-cutting `tau` capstone. Each sub-directory documents its subject to up to three audience tiers (stakeholders → IT/DevOps → developers) with diagrams + audience-voiced prose. Sub-modules under `format/` and `provider/` are first-class peers, each with their own sub-directory.

This phase is also the validation pass for the design / ingredient / skill / subagent infrastructure. Friction surfaced during authoring is resolved between libraries — the validated toolkit is a parallel deliverable to the diagrams.

## Bootstrap

1. **`./README.md`** — cross-cutting concerns (toolkit philosophy, design foundation, single font, render pipeline, dual-theme embedding).
2. **Memory** at `/home/jaime/.claude/projects/-home-jaime-tau/memory/`:
   - `feedback_diagram_toolkit_not_ruleset.md` — non-negotiable framing
   - `feedback_one_diagram_one_concept.md` — each `.typ` source = one output artifact
   - `feedback_shape_vs_text.md` — shape kind is identity; metadata is structured text
   - `feedback_overview_diagram_naming.md` — `readme.typ` for the leading overview diagram
   - `feedback_general_purpose_skills.md`, `feedback_diagram_toolkit_not_ruleset.md`
   - `project_typst_design_system.md`, `project_typst_workspace.md`, `reference_typst_fletcher_pitfalls.md`
   - `reference_github_picture_dual_theme.md` — embed pattern
3. **Skills** — invoke `tau-diagrams` at session start; it composes the four lower skills (`diagram-authoring`, `diagram-ingredients`, `diagram-design-system`, `typst-diagrams`).
4. **Subagent** — `~/tau/diagrams/.claude/agents/technical-writer.md`. Invoke at the start of every library's authoring loop; receive structured findings before any `.typ` source is written. Sessions running from `~/tau/` discover the agent via a symlink at `~/tau/.claude/agents/technical-writer.md` → the canonical path; the canonical file lives in the diagrams repo, the symlink keeps it discoverable from the parent workspace.
5. **Source libraries** — `~/tau/{protocol,format,provider,agent}/` (READMEs + `doc.go` + package layout). The technical-writer reads these in its own context.

## Current state

Phase 02 complete (five skills + ingredients refactor). No library sub-directories exist under `~/tau/diagrams/` yet. Phase 04 (`orchestrate`, `herald`) is blocked on this phase.

## Approach

One library at a time, in dependency order. `protocol` is the pilot — walk it first; carry refinements forward into the rest.

For each library, the authoring loop is:

1. **Invoke `technical-writer`** subagent against the target library. Receive structured findings: purpose statement, recommended audience tier count (2 or 3), per-tier diagram concept proposals, audience-voiced prose drafts, sub-component inventory, open questions.
2. **Review findings with the user**, resolve open questions, confirm tier count.
3. **Author `readme.typ`** (overview diagram) using `tau-diagrams` skill conventions. Render dual-theme. Write the leading description prose underneath in stakeholder voice.
4. **Author each remaining tier** in order. Per-section pattern: header → `.typ` source → render → prose. Diagram first; prose expands on it.
5. **Verify renders** in GitHub Markdown preview (light + dark theme switching).
6. **Capture toolkit friction** as notes only — do not edit toolkit mid-library. Refine diagrams + README prose freely.
7. **For each sub-module** (`format/openai`, `format/converse`, `provider/{ollama,azure,bedrock}`): repeat steps 1–6 inside the sub-module's directory.
8. **Apply toolkit refinements** between libraries: edit `~/tau/diagrams/{design,ingredients}/`, `~/tau/diagrams/.claude/skills/`, and `~/tau/diagrams/.claude/agents/technical-writer.md` as the captured friction directs. Log each delta under [Toolkit refinements applied](#toolkit-refinements-applied).
9. **Write a checkpoint** at `~/tau/diagrams/.claude/project/checkpoints/03-NN-<library>.md`, then commit + push the diagrams repo. One commit per checkpoint, in the established phase style (`phase 03 <library>: <multi-concern summary>`). User clears session context and resumes with `Initialize: <checkpoint path>`.

## Sub-directory layout

Tiers are sub-directories, not files. Each tier may contain a single diagram or many — complex subjects often need multiple diagrams at the same fidelity level.

```
diagrams/<library>/
├── README.md
├── core/                       # level-1 (stakeholder, or non-dev overview when 2-tier)
│   └── readme.typ              # tier overview — always present
├── operational/                # level-2 (omit entirely when 2-tier)
│   ├── readme.typ              # tier overview
│   └── <name>.typ              # additional diagrams as the subject warrants
└── specification/              # level-3 / technical
    ├── readme.typ              # tier overview
    └── <name>.typ              # additional diagrams
```

Each tier directory's `readme.typ` is its overview (consistent with `feedback_overview_diagram_naming.md`). Additional diagrams within a tier are content-named (`wire-flow.typ`, `registry.typ`, etc.). Whether a tier has one diagram or many is decided per library based on subject complexity.

Sub-modules nest with the same pattern recursively:

```
diagrams/format/
├── README.md
├── core/
│   └── readme.typ
├── operational/
│   └── readme.typ
├── specification/
│   ├── readme.typ
│   └── registry.typ
├── openai/
│   ├── README.md
│   ├── core/
│   │   └── readme.typ
│   └── specification/          # sub-modules likely 2-tier
│       └── readme.typ
└── converse/
    └── ...
```

Renders produce dual-theme pairs (`<tier>/readme-{light,dark}.svg`, `<tier>/<name>-{light,dark}.svg`) per the `tau-diagrams` standard.

## Audience-tier menu

Default: three tier directories.

- **`core/`** — stakeholder overview. What this is and why it exists in TAU. Stakeholder voice.
- **`operational/`** — IT/DevOps view. What it interfaces with, where it runs, what an operator needs to know. Operator voice.
- **`specification/`** — developer specification. Types, methods, composition, registry shape. Developer voice.

Collapsed (when subject doesn't sustain a separate operational view): two tier directories.

- **`core/`** — non-developer overview (combined stakeholder + IT view).
- **`specification/`** — developer specification.

Tier count is decided per library during the technical-writer's findings review. Within each tier, the count of diagrams is also a per-library decision: a simple tier may have only `readme.typ`; a complex tier may have several content-named diagrams alongside it.

Sub-modules are first-class peers: they express platform flexibility/extensibility, which matters at every audience tier. They are not buried inside the parent's `specification/`.

## README pattern

Universal section structure: **header → diagram → prose**. Applied uniformly at H1 (with the level-1 overview from `core/readme.typ`), H2 per tier (with that tier's `readme.typ`), and H3 per additional diagram in a multi-diagram tier. The diagram orients the reader; the prose expands.

```md
# [<subject>](<repository-url>)

<Type>: <github-url-without-https>
Language: <language>
Native dependencies:                          ← only when subject has documented TAU deps
- [<dep>](../<dep>/)                          ← relative link to sibling diagrams sub-directory
External dependencies:                        ← only when subject has third-party deps
- [<package>](<repository-url>)               ← prefer repository; fall back to docs / product site

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./core/readme-dark.svg">
  <img src="./core/readme-light.svg" alt="[subject] — overview" width="100%">
</picture>

[1–2 sentence concise description, stakeholder voice.]

## [Operational heading]   ← omit when 2-tier

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./operational/readme-dark.svg">
  <img src="./operational/readme-light.svg" alt="..." width="100%">
</picture>

[Prose in IT/DevOps voice — expands on the operational tier's leading diagram.]

### [Sub-concept heading]   ← when operational/ has additional diagrams

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./operational/<name>-dark.svg">
  <img src="./operational/<name>-light.svg" alt="..." width="100%">
</picture>

[Operator-voice prose specific to this diagram.]

## [Specification heading]

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./specification/readme-dark.svg">
  <img src="./specification/readme-light.svg" alt="..." width="100%">
</picture>

[Prose in developer voice — expands on the specification tier's leading diagram.]

### [Sub-concept heading]   ← when specification/ has additional diagrams

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./specification/<name>-dark.svg">
  <img src="./specification/<name>-light.svg" alt="..." width="100%">
</picture>

[Developer-voice prose specific to this diagram.]

## Implementations          ← only when sub-modules exist
- [openai](./openai/) — [one-line purpose, stakeholder voice]
- [converse](./converse/) — [one-line purpose]
```

The H1 is a Markdown link to the subject's repository URL. Directly under the H1, a **metadata block** identifies the subject: at minimum, the subject type (`Library:`, `Capability:`, `Service:`, etc.) keyed to its github URL without the `https://` prefix, and `Language:`. Expand the block for more complex subjects (e.g., a capability spanning multiple components, a deployment topology — keys like `Components:`, `Deployment:`, `Interfaces:` apply where they communicate something load-bearing).

**Dependency fields.** Two distinct kinds of dependency get distinct fields:

- **`Native dependencies:`** — dependencies within the TAU ecosystem (libraries and services we own, author, and document). Each entry is a relative link to the sibling diagrams sub-directory (`../<dep>/`); undocumented native imports stay invisible in the header.
- **`External dependencies:`** — third-party dependencies. Each entry links to the package's source repository (preferred), falling back to documentation or product site only when the package is not open-source (rare).

Both fields are **omitted when empty**; the absence of `External dependencies:` is itself meaningful — it makes TAU's commitment to minimizing external dependencies and supply-chain surface visible at a glance.

The "Implementations" section is exempt from the universal rule — it's navigational (links to sub-module sub-directories), not technical content.

**Heading conventions.** H2 headings name the **tier** itself (`## Operational`, `## Specification`, plus `## Implementations` for the navigational section), keeping the audience-tier hierarchy visible and consistent across every library's README. H3 headings within a tier name the **content domain** of the sub-concept diagram (`### Data types`, `### Registry`, `### Response Structures`) — not the audience, and not a re-statement of the tier. The Core tier has no H2 heading; the leading `core/readme.typ` overview sits directly under H1 since it carries the subject's stakeholder framing.

Voice escalates with fidelity (stakeholder at H1 / Core, IT/DevOps under Operational, developer under Specification); within a tier, voice stays consistent across H2 and its H3 children.

## Library order

| # | Subject | Tiers | Sub-modules |
|---|---|---|---|
| 1 | `protocol/` (pilot) | likely 2 | — |
| 2 | `format/` | 3 | `openai`, `converse` |
| 3 | `provider/` | 3 | `ollama`, `azure`, `bedrock` |
| 4 | `agent/` | 3 | — |
| 5 | `tau/` (cross-cutting capstone) | 3 | — |

`tau/` shows the cross-library signal flow (protocol → format → provider → agent for a single request) and is the last subject because it composes vocabulary from the prior four.

## Toolkit refinements applied

Running list. One line per delta: `<layer>: <what changed>`. Filled in between libraries.

### Format library (2026-04-30)

Combined pass — absorbs format-authoring friction and the herald OV-1 prelude session (a phase-04 prelude that ran in parallel and surfaced its own conventions for re-use). Details in `~/tau/diagrams/.claude/project/checkpoints/03-02-format.md` and `~/tau/diagrams/.claude/project/04-prelude-herald-ov1.md`.

- **project doc (this file):** README header gained `Native dependencies:` and `External dependencies:` fields; H2 / H3 heading conventions made explicit (H2 = tier name, H3 = content domain).
- **tau-diagrams skill (`references/tau-decisions.md`):** "Native dependencies in diagrams" — single-shape resolution rule for native deps.
- **typst-diagrams skill (`references/fletcher-pitfalls.md`):** added empty-content node errors, bend sign convention, inset single-value-only, mark overlay on shape (unsolved).
- **diagram-ingredients skill (`references/edges-and-marks.md`):** added mirrored label placement, vertical fan-out, conditional fork-and-rejoin, return-edge pattern.
- **diagram-ingredients skill (`references/labels-and-encapsulation.md`):** added two-node container limitation note, multi-domain band layout, inline pills with optional discriminator marker.
- **diagram-authoring skill (`SKILL.md`):** added shape-body-as-semantic vs edge-labels-carry-semantics decision section (during herald session).
- **memory:** `feedback_image_conversion_tool.md` (use `magick`), `feedback_diagram_review_workflow.md` (render and yield to user).
- **phase-04 prelude artifact:** `04-prelude-herald-ov1.md` written to capture herald-session deltas for phase 04.

### Protocol pilot (2026-04-28)

- **subagent (technical-writer):** Loop step 2 + Purpose-section instructions tightened to require structural-role articulation (what the subject standardizes/orchestrates/mediates/exposes/routes), not just type enumeration.
- **mise pipeline:** added `render-file <path>` task (uses mise's `usage` spec) so single-diagram iteration renders only the target file. Both `render` and `render-file` documented in `tau-decisions.md`.
- **bootstrap (project doc):** Bootstrap section now states the subagent-symlink convention — `~/tau/.claude/agents/<name>.md → ~/tau/diagrams/.claude/agents/<name>.md` — so sessions running from `~/tau/` discover agents that live in the diagrams repo.
- **typst-diagrams skill (`references/fletcher-pitfalls.md`):** added `shape: none` pitfall — fletcher 0.5.8 errors with `expected function, found none`; use `shape: rect, fill: none, stroke: none` for label-only nodes.
- **tau-diagrams skill (`references/tau-decisions.md`):** retired the global purple raw-tint convention; tinting is now local-only. Removed `#show raw: r => text(fill: palette.purple.stroke, r)` from all 28 ingredient sources.
- **diagram-design-system skill (`references/palette-pattern.md`):** documented the hue-quad usage convention — `ink` is for accent text (kind labels, single-word identifiers); body content on a hue fill uses neutral `palette.ink` for higher contrast.

## Checkpoints

After every library completes (artifacts rendered, toolkit refinements applied, READMEs verified in GitHub preview), write a checkpoint and commit + push the diagrams repo. One commit per checkpoint covering all checkpoint-scoped changes (library artifacts + toolkit refinements + checkpoint file + project doc updates). Checkpoint files live at:

```
~/tau/diagrams/.claude/project/checkpoints/
├── 03-01-protocol.md     ← after protocol pilot
├── 03-02-format.md       ← after format + openai + converse
├── 03-03-provider.md     ← after provider + ollama + azure + bedrock
├── 03-04-agent.md
└── 03-05-tau.md          ← phase 03 close
```

Numeric prefix `03-NN-` preserves phase + library order. Sub-modules complete with their parent — no per-sub-module checkpoint.

User resumes with `Initialize: <checkpoint path>`.

**Checkpoint file template:**

```md
# Phase 03 checkpoint — after [library]

## Just completed
- [library/sub-module artifacts produced, one-liners]

## Next
- [next library or step in sequence]

## Toolkit deltas since previous checkpoint
- design / ingredients / skills / subagent: [what changed and why, one-liners]

## Open threads
- [unresolved decisions or notes carrying forward — usually empty]

## Resume protocol
1. Read this checkpoint file.
2. Read `~/tau/diagrams/.claude/project/03-core-tau-diagrams.md`.
3. Read `~/tau/diagrams/.claude/agents/technical-writer.md`.
4. Skim the most recently completed library's `diagrams/<lib>/README.md` to anchor on current voice and pattern.
5. Confirm with user before resuming.
```

**Validation signal.** When a fresh session resumes from a checkpoint and finds gaps — the technical-writer doesn't know about a recent skill change, the project doc lacks a captured decision, the README pattern feels under-specified for the next subject — those gaps become the first friction note of the next library's authoring loop. Clean resumes accumulate as evidence the toolkit is self-contained; painful resumes drive the next between-library refinement.

## Done criteria

- [ ] 5 library sub-directories under `~/tau/diagrams/` (`protocol`, `format`, `provider`, `agent`, `tau`), each with README + rendered dual-theme SVG pairs for all declared tiers.
- [ ] 5 sub-module sub-directories: `format/{openai,converse}`, `provider/{ollama,azure,bedrock}`, each with README + renders.
- [ ] `technical-writer` subagent committed at `~/tau/diagrams/.claude/agents/technical-writer.md`.
- [ ] All diagrams honor `tau-diagrams` skill conventions (palette, font, embed pattern, render-mode marker).
- [ ] READMEs render correctly on GitHub with light/dark theme switching.
- [ ] Toolkit refinements applied; the [Toolkit refinements applied](#toolkit-refinements-applied) section lists every delta.
- [ ] 5 checkpoint files exist under `checkpoints/`. The final checkpoint (`03-05-tau.md`) has been resumed cleanly in a fresh session as the smoke test of infrastructure self-containment.
- [ ] Diagrams repo committed and pushed at every checkpoint (5 commits to `origin/main`, one per library milestone).

## Hand-off to phase 04

Phase 03 establishes the diagram vocabulary, the per-subject README pattern, the `technical-writer` subagent, and the validated toolkit. Phase 04 reuses all of it for `~/tau/orchestrate` and `~/code/herald`. Start a fresh session with `04-advanced-tau-diagrams.md`.
