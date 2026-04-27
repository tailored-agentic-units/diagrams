# Blueprint specification

A blueprint encodes a recurring diagram pattern as a reusable template — a single Markdown file with YAML frontmatter that an author opts into when starting a diagram. The format is descriptive: an instance inherits the structural intent and adapts where its content doesn't fit cleanly.

A blueprint encodes:

- **What the pattern is for** (the concept this kind of diagram expresses).
- **The structural rules** an instance must satisfy.
- **The variation points** authors choose per instance.
- **One example** an instance can reference.

## The format

```markdown
---
name: <kebab-case>
description: <one sentence: what concept this blueprint expresses>
---

## Intent

<what this blueprint is for. 1-3 sentences. Concrete enough that an
author can decide "yes this fits my diagram" or "no it doesn't".>

## Structural rules

<bulleted constraints any instance must satisfy. Keep these visible
and few. Each rule should be something an author could violate, not
something every diagram has by default.>

- <rule 1>
- <rule 2>
- <rule 3>

## Variation points

<what authors choose per instance. Bulleted, with brief notes on
the choice space.>

- <variation 1>: <choice notes>
- <variation 2>: <choice notes>

## Example

<absolute path to one rendered .typ source that exemplifies this
blueprint. If no example exists yet, write "none yet".>
```

## Field-by-field

### `name`

Kebab-case. Matches the filename (e.g., `layered-architecture.md` → `name: layered-architecture`).

### `description`

One sentence. Captures the concept the blueprint expresses, not the visual appearance.

> Good: "A layered architecture with components grouped into horizontal tiers, vertical inter-layer dependencies, and optional cross-cutting concerns."
>
> Less good: "A diagram with rectangles arranged horizontally."

The description is what an agent reads to decide if this blueprint applies to a request.

### `## Intent`

1–3 sentences that an author reads to decide "yes, this blueprint applies" or "no, it doesn't." Concrete; avoids vague pattern-language ("a flexible system…").

### `## Structural rules`

Bulleted list of constraints any instance must satisfy. Keep this short — long rule lists become rule books, which violates toolkit-not-ruleset framing.

A good structural rule is **violatable**: an author could ignore it and still produce *something*, but doing so would break the blueprint's claim. Examples:

> "Layers stack top-to-bottom; dependencies flow downward only."
> "Cross-cutting concerns sit on the right edge, dashed-bordered."

Default behavior — what every diagram in the stack already does — does not belong as a structural rule; it adds noise without distinguishing the blueprint.

### `## Variation points`

Bulleted list of choices authors make per instance. Each variation point names what's free to vary and notes the choice space.

> "Layer count: 3–6 typical, 7+ becomes hard to read."
> "Hue assignment per layer: pick from the palette; consistency within instance more important than which hue."
> "Cross-cutting bar position: right-edge default; bottom-edge if vertical layout is constrained."

Variation points are explicit so authors don't feel locked into a rigid template.

### `## Example`

Absolute path to one rendered `.typ` source that exemplifies the blueprint. The example serves as a reference — not a template to copy. An instance of the blueprint doesn't have to look identical to the example; it needs to satisfy the structural rules.

If no example exists yet (the blueprint was authored before its first instance), write "none yet" and add the path when an instance lands.

## Authoring discipline

A blueprint is worth authoring when:

1. **The pattern has recurred at least twice across real diagrams.** First occurrence: write the diagram fresh. Second: notice the pattern. Third (or after): extract the blueprint.
2. **The recurrences share more than just *some* ingredients.** Two diagrams that both happen to use blue rectangles aren't a blueprint. Two diagrams that share *layout intent + structural rules* are.
3. **The author can articulate the intent in 1–3 sentences.** If the intent is hand-wavy, the blueprint will be too.

A blueprint extracted from one diagram is almost always overfit. Wait for the second.

## Storage

Three storage tiers, in priority order at load time:

1. Path(s) the user supplies during initialization.
2. `<project>/.claude/blueprints/*.md` for project-specific patterns.
3. Any directories the user has registered for blueprints in their environment.

Blueprints are discoverable but not auto-loaded. The authoring skill asks the user before loading.

## Lifecycle

Blueprints evolve. When an instance reveals a blueprint structural rule is wrong:

1. **First, check if the instance is the outlier or the rule is.** If only this one instance violates the rule, document the violation as a per-instance choice, leave the rule.
2. **If multiple instances drift from a rule**, the rule is wrong. Either weaken it (move to a variation point) or remove it.
3. **If a new variation appears that was previously assumed fixed**, add a variation point.
4. **If the blueprint itself doesn't fit anymore**, deprecate it. Don't keep adding exceptions.

Blueprints that grow exception lists faster than they encode patterns are signaling that the underlying pattern is fragmenting. Let them retire.
