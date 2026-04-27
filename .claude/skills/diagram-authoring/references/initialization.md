# Session initialization

How a diagram authoring session starts. The skill works from user intent and source materials — a blueprint is optional, never required.

## Step 1: Gather intent

Open with a short conversation establishing what the diagram is for. The questions to surface:

- **What concept does this diagram express?** Not "what does it look like" — what's the *one* thing it should communicate? (One diagram, one concept.)
- **Who reads it?** A team familiar with the system can absorb more density than a newcomer. Audience scopes the level of abstraction.
- **What's the surrounding context?** Is this a top-level overview, a detail of one component, a cross-section through a flow? Different contexts want different levels of zoom.
- **What's already true?** If this diagram replaces or extends an earlier one, ask for it. Reuse what works; replace what doesn't.

The gathering establishes what the diagram is *for*. Visual decisions and blueprint choices come later, after the intent and source materials are clear.

## Step 2: Identify source materials

The diagram derives from somewhere. Catalog the sources:

- **Source code.** Modules, types, interfaces, function signatures, package boundaries. The structural truth.
- **Written specifications.** Design docs, RFCs, API specs, ADRs. The intentional truth.
- **Structured data.** JSON / YAML / TOML config, schema definitions, deployment manifests. The runtime truth.
- **Prose and notes.** README sections, ticket descriptions, whiteboard photos. The conversational truth.

Some sources contradict each other (the spec says one thing, the code does another, the deployed config does a third). Surface these contradictions explicitly — the diagram will inherit them unless you decide which truth to draw from.

If the user has already produced a sketch (textual outline, hand-drawn whiteboard, prior diagram), treat that as a source too. It encodes their intent more directly than any of the artifacts.

## Step 3: Ask about blueprints (optional)

After gathering intent and sources, ask whether a blueprint applies:

> "Is there a blueprint that applies to this diagram? You can supply a path or a name. If none, we'll design from the ingredients directly."

The user response paths:

1. **Yes, here's the blueprint** — load it (see [blueprint-spec](blueprint-spec.md) for the format), apply its layout and ingredient defaults during composition. The blueprint is descriptive; the instance can adapt where the content doesn't fit cleanly.
2. **No** — proceed without one. The non-blueprint path produces equally good diagrams; it makes composition decisions fresh from the ingredient inventory rather than starting from a pre-encoded layout.
3. **Not sure** — propose two or three plausible patterns from the available pool, with one-sentence descriptions of each. The user picks or declines.

A blueprint is never required for the process to proceed. When no blueprint applies, the compose step picks ingredients fresh; the rest of the process is identical.

## Step 4: Sketch before composing

Before any Typst code, write a textual sketch the user can verify. The sketch covers:

- **Entities.** The named things in the diagram. For each: what's the kind? (Module, service, actor, document, …)
- **Relationships.** The named edges. For each: what's the relationship type? (Calls, contains, returns, depends-on, …)
- **Groupings.** Are some entities clustered? On what basis (deployment, module boundary, ownership, …)?
- **Layout intent.** Top-down? Left-right? Concentric? Specific spatial relationships (north for upstream, south for storage)?

The sketch is small and discardable — a half-page outline, not a design doc. Its purpose is to make the structure explicit so missing pieces and ambiguities surface before any code is written.

Verify with the user when:

- The gathering surfaced ambiguity (two contradictory source materials, a vague intent).
- The sketch implies a structural choice the user didn't directly express ("you said X is upstream of Y; I'm putting X on top — does that match your mental model?").
- The diagram is part of a series (other diagrams are coming; the layout choice affects them too).

Straightforward cases sketch and proceed without verification — the goal is making structure explicit, not gating progress on routine choices.

## Step 5: Compose

Now ingredients enter. Working from the sketch:

1. **Shapes** for each entity kind — visual character (symmetric/directional, soft/hard, weight) reads as the kind.
2. **Hues** for entity groups or state ladders — hue assignment derives from what the sketch identified as the differentiation axis.
3. **Edge encodings** for relationship kinds — stroke, head, hue, dash compose to differentiate.
4. **Label patterns** for what each entity needs to display — single name, stacked title + kind, field list, icon + label.
5. **Coordinates** based on the layout intent from the sketch — adjacent placement groups related elements; the coordinate grid is laid out per the diagramming stack's conventions.

A loaded blueprint pre-decides some of these (typical layout, default shape and edge mappings). The instance overrides the blueprint where the content doesn't fit; blueprints are descriptive, not prescriptive.

## Step 6: Render and critique

Render the draft. Review against the gathering — does the diagram answer the question its intent posed? Apply the [critique checklist](critique-checklist.md). Iterate.

A diagram typically takes two to three iteration cycles before settling. Later cycles are tuning (visual weight, hue, label adjustments), not redesign.

## Cases where the diagram does not earn its place

Some gathering outcomes indicate the diagram should not be drawn:

- The concept doesn't lend itself to spatial representation (a sequence of conditional decisions reads more clearly as prose with code blocks).
- The audience already understands the concept; the diagram would be cosmetic.
- The source materials are unsettled — the system is mid-redesign and a diagram now would lock in a snapshot that ages out in days.

These cases warrant raising the question before proceeding: "I think this might not benefit from a diagram. Here's why; want me to proceed anyway, or describe it as prose?" The user can override; the question prevents producing a diagram nobody needs.
