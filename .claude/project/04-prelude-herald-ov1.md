# Phase 04 prelude — captured from herald OV-1 session

## Date / scope

2026-04-29 → 2026-04-30 — herald `core/` OV-1 leadership briefing. Originally scoped to 5 diagrams; converged to **4** during execution (release + cds-release merged into a single multi-domain distribution diagram). Dual-theme SVG renders + a single A4 portrait briefing PDF for email distribution.

This was the first TAU-toolkit application against a **service** subject (vs. libraries) and the first to surface flow / sequence / pipeline diagrams in the rendered corpus. Patterns below are captured as candidates for phase 04 — not contracts.

---

## Conventions established

### Shape and edge vocabulary

- **`kinded` shape helper** — body shape with leading glyph + stack of (title / `(kind)` / divider / description / optional extras). Title and `(kind)` centred via `block(width: 100%, align(center, ...))`; description left-aligned with `palette.ink`. Divider uses hue-aware `hue.divider`. Now identical across all 4 herald diagrams; ready to extract to a shared module after phase 04 surfaces whether the signature stays stable for other subjects. Driven by: `core/readme.typ` iteration 8 (dense diagram with edge-label thrashing).

- **Shape body as semantic carrier vs. edge labels carry semantics** — judge per diagram. Dependency *contexts* (X depends on Y because…) → migrate to shape body, edges become connectors only. Step *names* / handoffs / transitions → edge labels stay load-bearing. `readme.typ` is the former; `upload`, `classification`, `release` are the latter. This is the core decision for any flow vs. architecture diagram.

- **Edge mark vocabulary**:
  - `->` standard data flow / handoff
  - `-O` association / dock (e.g., Herald → Container Apps deployment target)
  - `<->` bidirectional cycle
  - `-->` non-default edge (return / acknowledgement / conditional branch)
  - solid stroke + `tokens.stroke-emphasis` for focal edges (e.g., the cross-domain transfer)

- **`step-label` helper** — `text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)`. Paired with native Fletcher `label-fill: palette.surface` and `label-pos: 0.5, label-side: center` for clean inline labels through edge bodies. Demote the older `lbl()` `box(inset: ...)` helper to fallback.

- **Vertical fan-out pattern** — when a focal node has parallel writes/reads to multiple destinations (e.g., Herald → Blob + PostgreSQL on upload), stack the destinations vertically at the same x and let edges fan out from a shared anchor. Fletcher routes from the same anchor without crossing because the destination y-positions force the divergence.

- **Dashed + bent return-edge pattern** — for response / acknowledgement edges that shouldn't compete with forward flow: `-->` mark + `bend: 25deg` (positive = larger y on default canvas) + `south-*` corner anchors. Visual encoding signals "return semantics" without arrowhead clutter.

- **Conditional fork-and-rejoin** — for state graphs: solid green = unconditional transitions, dashed green = conditional fork branches. `?`-style labels (`if any page flagged` / `if no page flagged`) on the conditional edges. One branch bends to give vertical clearance for label collision avoidance.

### Container patterns

- **Two-node container** (foreground header + background `enclose:`) — when a container needs a header rendered *above* its inner shapes (not behind them as `snap: -1` body content does), split into a foreground header *node* (default layer, may take an opaque `fill` to mask edges crossing through it) + a background `enclose:` *container* with `snap: -1` and an empty body. Header coordinate positions it spatially above inner shapes. Used in `readme.typ` (Azure managed services container) and `release.typ` (three security-domain bands with repo URL headers).

- **Multi-domain band layout** — for diagrams that span security or organizational domains, render each domain as a band (single-node `enclose:` with `surface-muted` fill). All bands share the same neutral fill for visual continuity; the *headers* differentiate. Edges crossing band boundaries naturally communicate domain transitions. Trigger arrows passing through header zones are masked by the header's opaque fill.

### Cross-diagram cohesion

- **Hue assignments stay consistent** across the briefing:
  - Orange — actors (upstream/human)
  - Blue — focal service identity
  - Coral — external services / managed resources / classified destinations
  - Purple — workflow states / automation / interior steps
  - Green stroke — forward edges (variants signal *kind* of relationship, not different palettes)

- **Glyphs stay consistent** for the same entity class:
  - `\u{F007}` (user) — actors
  - `\u{F0AC}` (globe) — service identity
  - `\u{F0A0}` (hard-drive) — object storage
  - `\u{F1C0}` (database) — relational/document database
  - `\u{F0C2}` (cloud) — AI service / cloud-managed
  - `\u{F1B2}` (cube) — runtime/deployment host
  - `\u{F085}` (cogs) — automation pipeline
  - `\u{F49E}` (box-open) — container image / deliverable package
  - `\u{F1EA}` (newspaper) — release notes / publication
  - `\u{F023}` (lock) — sealed/classified destination

- **Cardinal anchors over fractional waypoints** — `<node.east>` etc. are reliable; fractional-coord waypoints inside a shape get clipped at the boundary unpredictably and don't survive content volatility.

### Sensitivity layer (for any subject with restricted content)

- **Public-abstractions-only rule** applied per-diagram. For the merged release diagram, concrete redactions were:
  - Runner identities (`s2va-runners`) → omitted entirely from pipeline node descriptions.
  - Internal action repos (`s2va/cds-manifest@main`) → rendered as the abstraction `cross-domain transfer service` in prose; never named.
  - Storage account / container vars → class abstraction (`government cloud blob storage`); env-var names never appear.
  - Service principals / signing keys → omitted entirely as implementation chrome.
  - Image registry paths → class-named only (`GitHub Container Registry`).
  - Compliance-level labels (IL4 / IL6) — acceptable; standard DoD impact-level terminology, public.
  - Repository URLs (`github.com/JaimeStill/herald`, `github.com/s2va/herald`, `Azure Data Transfer Landing Zone`) — surfaced in band headers per stakeholder direction; treat repo URLs as public unless stakeholder flags.

  **Rule of thumb**: when in doubt, abstract upward. "Secure environment" beats a specific designation; "cross-domain transfer" beats a specific service name. Surface borderline items as open questions during findings review.

### Multi-diagram core/ as a coherent set

- **Five-diagram core/ briefings can converge to four mid-execution.** The original brief locked a 5-diagram inventory; midway through B3d, public-release was identified as too thin to stand alone next to the architecture/upload/classification diagrams. Merging public release + CDS release into a single multi-domain distribution diagram surfaced the *causal chain* ("how does the service reach the secure environment where it runs") that two split diagrams obscured. **Phase-04 implication**: lock the inventory but stay open to mid-execution merge if a candidate diagram lacks load-bearing content.

- **Single-pipeline-stop with fan-out** — alternative composition to the labelled milestone strip when a CI/CD pipeline naturally produces multiple terminal artifacts (image + release notes). One pipeline node + multiple output edges is cleaner at OV-1 than a strict left-to-right strip with side branches.

### OV-1 framing for non-technical leadership

- **Stakeholder voice everywhere** — read prose aloud; flag any Go type names, method signatures, package paths, env-var names, action repository names, runner identifiers. Replace with class abstractions and plain-English action verbs.

- **Forward-state framing in prose** — when a diagram terminates at a known gap (e.g., Herald's chain stops at IL6 secure storage because IL6 GitHub Actions don't yet exist), the prose explicitly names the future state ("Once X becomes available, Y will close the gap; today, manual step Z bridges it"). Without this, the diagram reads as "that's the whole story" — understating planned automation.

- **Stakeholder-meaningful technical detail** — the human gate between public release and CDS proxy (manual tag mirror, not automation) is leadership-relevant *because* it reveals a deliberate human-in-the-loop. Surface these in prose; don't bury them.

---

## Patterns to consider for phase 04

- **Process / flow rendering**:
  - Step-and-actor flow (`upload.typ`) — actors on a baseline, edges carry handoff labels with imperative verbs. Strong when the actor handoff IS the concept.
  - State-graph card with conditional fork-and-rejoin (`classification.typ`) — states as nodes, transitions as edges; solid for unconditional, dashed for conditional with `if X` labels at the fork. Strong when a workflow has a branch worth surfacing.
  - Multi-domain band layout (`release.typ`) — security/organizational domains as horizontal bands; the boundary-crossing is the focal element. Generalizes to any pipeline that crosses environments.

- **CI/deployment-pipeline rendering at OV-1**:
  - The "tag → image → distribution" framing reads cleanly with one pipeline-stop node per stage and multiple terminal artifacts (image + release notes for public; secure storage for IL6 side).
  - Render manual steps explicitly as actor + trigger arrow ("the human gate"); don't hide them in prose.

- **Multi-external-service architecture**:
  - 4 external services + 2 actors + 1 focal service is a comfortable upper bound for an OV-1 architecture picture (`readme.typ`).
  - External services in a single container (`Azure Managed Services` band) reduce the effective shape count and bundle related entities.

- **Per-diagram visual approach selection** — these candidates aren't contracts; the technical-writer surfaces a recommendation per diagram during findings, the user confirms, and the author can compose fresh from ingredients if none fit.

- **Symmetric fan-out from a focal pipeline node** — in `release.typ` (before the merge to multi-domain) the cleanest layout for a single-pipeline-stop with two outputs was symmetric fan-out (terminals at same x, different y). Generalizes.

---

## Toolkit friction noted (apply between phase 03 and phase 04)

These are deferred edits to TAU's skill/reference layer, captured here so phase 04 can apply them as a deliberate first move.

### Diagram-ingredients references

- `~/tau/diagrams/.claude/skills/diagram-ingredients/references/labels-and-encapsulation.md`:
  - **Two-node container variant** for header-above-inner-nodes (foreground header + background `enclose:` with `snap: -1`).
  - **Multi-domain band layout** with opaque-fill headers that mask trigger arrows passing through.
  - **Promote native Fletcher `label-fill`** as the default for edge labels; demote the custom `lbl()` `box` helper to fallback.

- `~/tau/diagrams/.claude/skills/diagram-ingredients/references/edges-and-marks.md`:
  - **Dashed + bent-below return-edge pattern** with the bend-sign convention note.
  - **Vertical fan-out from a focal node** pattern (one-to-many parallel writes; stacked destinations + shared anchor).
  - **Conditional fork-and-rejoin** edge styling (solid unconditional, dashed conditional) with conditional-guard labels.

### Diagram-authoring skill

- `~/tau/diagrams/.claude/skills/diagram-authoring/SKILL.md` (or new reference):
  - **Shape-body-as-semantic** pattern: when to choose body-borne semantics vs. edge labels in dense diagrams.
  - **One-concept decision** when a candidate diagram is thin: merge it with a related diagram if the merge surfaces a richer causal chain.

### Typst-diagrams pitfalls

- `~/tau/diagrams/.claude/skills/typst-diagrams/references/fletcher-pitfalls.md`:
  - **`bend` sign convention** — positive bend curves toward larger y on Fletcher's default top-origin canvas. Counter-intuitive on first try; flip-test on initial render.
  - **Mark overlay on shape (unsolved)** — putting an arrow tip *inside* a shape via literal-coord destination + `layer: 1` produces clipped arrows in 0.5.x. Workaround: use `-O` mark style so the visual sits at the shape boundary naturally.
  - **Header-vs-shape rendering layer (limited)** — the two-node container pattern works only when the header doesn't spatially overlap the inner shapes. For containers where a header must overlap inner shapes vertically, this remains unsolved.
  - **Inset accepts only single value** — Fletcher 0.5.8 does not accept `inset: (x: ..., y: ...)` dictionary form; passing one fails with `dictionary has no method to-absolute`. Use a single absolute value.

### Token system + PDF rendering chain

- **Source-font scale vs. SVG viewBox scale** — bumping diagram source fonts alone does NOT meaningfully improve text legibility on a fixed-width PDF page. The SVG viewBox grows roughly proportionally with text, canceling the bump. To improve the text-to-graphic ratio, **interior spacing tokens must shrink** (`pad-inside-shape`, `gap-cell`, `gap-structured-text`) while font sizes grow — this raises text density in the viewBox so when it's fitted to a fixed page width, displayed text appears larger. External spacing (`space-between-shapes`, `pad-inside-container`) should stay close to original to give edge labels and headers breathing room.

- **PDF chain (pandoc + weasyprint + Primer CSS)** validated end-to-end. Key elements:
  - `mise.toml` task `generate-pdf` flattens `<picture>` blocks via awk (light-only), then runs pandoc with `--pdf-engine=weasyprint`, `--css=github.css`, and `--metadata=pagetitle="..."` (the latter sets PDF window title without adding a body title block).
  - Primer-aligned `github.css` with CSS custom properties, `@page A4` rule, prose-cap via `p:not(:has(> img)) { max-width: 90ch }`, `page-break-before: always` on `<h2>` for clean section pagination.
  - Weasyprint 60+ supports `:has()` selectors and modern CSS — the chain depends on it.

- **Scope concern**: the herald `tokens.typ` was edited in-place to support PDF print legibility; this affects web rendering too. Phase 04 may want to consider whether the design system should support distinct print/web token sets, or whether a single set tuned for PDF is acceptable across both.

### Subagent + brief

- The brief at `~/tau/herald-overview-brief.md` was revised to a 4-diagram inventory mid-session. The phase-04 plan should incorporate "inventory mergeability" as a defaulted convention rather than a special case.

- Technical-writer subagent contract (read-only findings producer) worked well at scoped invocation. No friction surfaced.

---

## Open threads

1. **Mark-overlay-on-shape (Fletcher 0.5.8)** — placing an arrowhead *inside* a shape via literal-coord destination + `layer: 1` remains unsolved. Workaround `-O` (open circle) lands cleanly at boundaries; if a future diagram needs an arrow tip inside a shape (e.g., to point at a specific region), this needs investigation.

2. **Container header overlap with inner shapes** — the two-node container pattern works because header and inner shapes don't spatially overlap. For compact dense containers where the header must overlap inner shapes vertically, this remains unsolved.

3. **Bend-sign default intuition mismatch** — every bent edge in this session needed a flip-test on first render. Documented in `fletcher-pitfalls.md` toolkit update; until then, expect to flip-test.

4. **Distinct print vs. web token sets** — the font + spacing token tuning that improved PDF legibility may be slightly heavy for screen rendering. Phase 04 may benefit from either:
   - A single set of tokens tuned for the harder rendering target (PDF), accepting the screen rendering as "fine enough", or
   - A token-overlay system where print-target subjects can override web-target defaults.

   Current herald approach is the former (single tuned set).

5. **Helper module extraction timing** — `kinded`, `step-label`, edge-stroke constants are now duplicated across 4 diagrams. The signatures have been stable for 3 of the 4. Phase 04 should extract to a shared `_helpers.typ` (or `ingredients/`) early, *after* the first phase-04 subject confirms the signatures generalize to non-herald content.

6. **Inventory-mergeability as a defaulted convention** — the merge of public release + CDS release into one diagram was surfaced mid-execution by the user. Phase 04's planning loop should treat this as a normal step ("which of the locked diagrams, if any, would benefit from merge?") rather than a special pivot.

---

## Critical files

| Path | Role |
|---|---|
| `~/code/herald/_project/ov-1/` | Final session output (4 diagrams + README + briefing PDF + Primer CSS + mise tasks) |
| `~/code/herald/_project/ov-1/core/{readme,upload,classification,release}.typ` | Source diagrams |
| `~/code/herald/_project/ov-1/design/{tokens,theme}.typ` | Design layer (mirrored from TAU `~/tau/diagrams/design/`; tokens tuned for PDF legibility) |
| `~/code/herald/_project/ov-1/github.css` | Primer-aligned pandoc CSS (custom properties, A4 portrait, section page breaks) |
| `~/code/herald/_project/ov-1/mise.toml` | `render`, `render-file`, `generate-pdf`, `clean` tasks |
| `~/code/herald/.claude/context/sessions/2026-04-29-herald-ov1/checkpoint-{1,2}.md` | Per-step session checkpoints (B3a, B3b conventions) |
| `~/code/herald/.claude/context/sessions/2026-04-29-herald-ov1/findings.md` | Technical-writer per-diagram findings |
| `~/tau/herald-overview-brief.md` | Brief (revised to 4-diagram inventory mid-session) |
| `~/tau/diagrams/.claude/project/04-advanced-tau-diagrams.md` | Phase-04 plan; read alongside this prelude |
