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

## Blueprints

Blueprints encode recurring diagram patterns as reusable templates. A blueprint is descriptive (a pattern an instance opts into), not prescriptive (a contract an instance must satisfy).

The compose step works without a blueprint — fresh ingredient selection from the inventory produces equally good diagrams when no pattern applies. A blueprint is justified once the same pattern has recurred across at least two real diagrams; one-instance extraction usually overfits.

Storage tiers, in priority order at session initialization:

1. Path(s) the user supplies during initialization.
2. `<project>/.claude/blueprints/*.md` for project-specific patterns.
3. Any directories the user has registered for blueprints in their environment.

The format is defined in [blueprint-spec](references/blueprint-spec.md).
