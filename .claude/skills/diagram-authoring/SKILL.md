---
name: diagram-authoring
description: Universal process for designing and refining a diagram from user requirements and source materials (source code, written specifications, structured data, prose). Defines a minimal blueprint specification for reusable diagram patterns; blueprints are an optional enhancement, never required. Use when starting a new diagram, refining an existing one, critiquing a diagram for clarity, or authoring a reusable blueprint to encode a recurring layout.
---

# Diagram authoring

The design process for diagrams. Given user intent and source materials, the process elicits structure, picks ingredients, drafts, critiques, iterates.

## Decision tree

| Task | Reference |
|---|---|
| Starting a new diagram session — gathering intent and source materials, optionally loading a blueprint | [initialization](references/initialization.md) |
| Authoring a blueprint to encode a recurring pattern | [blueprint-spec](references/blueprint-spec.md) |
| Self-critiquing a draft before user review | [critique-checklist](references/critique-checklist.md) |

## The process

A four-step iteration. Steps are not gated; later steps can return to earlier ones (e.g., critique surfaces a missing ingredient → return to compose → redraft).

1. **Gather** — read the user's intent and source materials. What concept does the diagram express? Who reads it? What is in the source (code, specs, data, prose) that the diagram derives from?
2. **Sketch** — name the entities, relationships, and groupings. Write a textual sketch (a list, an outline, a hand-drawn-style description) before any code. Verify with the user when the gathering surfaced ambiguity.
3. **Compose** — pick ingredients (shapes, edges, hues, label patterns) that map cleanly to the sketch. Draft the source. Render.
4. **Critique** — does the rendered diagram answer the question the gathering posed? Apply the critique checklist. Iterate.

A blueprint, when supplied, slots into step 3 (compose) by pre-deciding layout and ingredient defaults. The other steps run identically. Without a blueprint, the compose step makes those decisions fresh from the available ingredients.

## Authoring principles

- **One diagram, one concept.** Each diagram source produces one output artifact at full resolution. Multiple concepts in one image dilute the visual argument; each concept's diagram is tightly scoped.
- **Shape for identity, text for metadata.** Shape kind distinguishes entity kind (the visual signal at a glance); structured text inside the shape carries the name, kind annotation, and fields (the readable detail).
- **Source materials are inputs, not templates.** Source code, specs, and data clarify *intent*. Mechanically porting them ("five modules, so five rectangles") usually misses the diagram's purpose — the visualization strategy derives from what the diagram needs to communicate, then verifies against the source.
- **Visual weight tracks meaning.** Heavy ingredients (thick stroke, saturated fill, large size) claim attention. The diagram's headline element should be the visually heaviest; supporting cast recedes.

## Where the relationship semantics live: edge labels vs shape body

Two structural choices for carrying *what* a relationship means:

| Pattern | Reads as | Best for |
|---|---|---|
| **Edge-labelled** — relationship name on the edge (`request`, `enqueue`, `translates to`) | "X *does* Y to Z" — verbed, sequential | flows, sequences, pipelines, workflows where the *step name* is the meaningful unit |
| **Shape-body-as-semantic** — relationship described inside the entity's body description; edges are connectors only | "X *is the thing that* …; Y *is the thing that* …" — contextual, reference | dense architecture overviews where the *entity's role* is what matters and edges are context-dependency |

Edge labels are the default and read naturally for low-density diagrams (≤ 3 edges per node, short labels, clear pairwise transitions). They fail when edge density grows: labels collide, label-fill cutouts compete for visual attention, and waypoint geometry has to be tortured to keep labels readable.

The shape-body-as-semantic pattern moves the relationship's *what* into a short description below each shape's title and (kind) annotation. Edges then carry only direction (and, optionally, mark style for relationship-type variation: `->` for data flow, `-O` for association/dock, `<->` for cycles). The shape's body becomes an entity sketch: title + kind + role description.

A typical shape body in this pattern:

```typst
[ glyph
  Title             ← centred
  (kind)            ← centred
  ───────           ← hue-aware divider
  Short role description in one or two lines.  ← left-aligned
]
```

Centre the title and (kind); leave the description left-aligned. Centring requires `block(width: 100%, align(center, ...))` — `align(center, ...)` alone doesn't expand to the stack's natural width.

**Choose shape-body-as-semantic when** the diagram is a hub-and-spoke architecture overview, has 5+ entities and 6+ relationships, has natural language relationship descriptions (longer than 2–3 words), or has a focal node where every edge converges on the same shape (the focal-node body has room to describe the relationship to each peer).

**Stay with edge labels when** the diagram is a flow / sequence / pipeline (the edge IS the step), pairwise relationships are simple and named (`calls`, `triggers`), or the same entity participates in many relationships of distinct kinds that need to be distinguished at the edge (e.g., a workflow node that emits, consumes, and persists — three different verbs on three different edges).

The two patterns are not mutually exclusive in a multi-diagram suite. An OV-1 architecture overview can use shape-body-as-semantic while its operational sequence and release-pipeline diagrams use edge labels — the choice is per-diagram, driven by what the diagram is *for*.

## Blueprints

Blueprints encode recurring diagram patterns as reusable templates. A blueprint is descriptive (a pattern an instance opts into), not prescriptive (a contract an instance must satisfy).

The compose step works without a blueprint — fresh ingredient selection from the inventory produces equally good diagrams when no pattern applies. A blueprint is justified once the same pattern has recurred across at least two real diagrams; one-instance extraction usually overfits.

Storage tiers, in priority order at session initialization:

1. Path(s) the user supplies during initialization.
2. `<project>/.claude/blueprints/*.md` for project-specific patterns.
3. Any directories the user has registered for blueprints in their environment.

The format is defined in [blueprint-spec](references/blueprint-spec.md).
