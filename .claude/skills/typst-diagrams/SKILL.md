---
name: typst-diagrams
description: Conventions for composing diagrams with the Typst + CeTZ + Fletcher stack — render pipeline patterns, version-specific Fletcher pitfalls, CeTZ closure shapes, label-body composition. Use when authoring or debugging Typst diagram source, hitting a Fletcher render bug, choosing between Fletcher built-ins and custom CeTZ shapes, setting up a dual-theme render task, or interpreting Fletcher mark shorthand.
---

# Typst diagrams — stack conventions

The three-package stack: **Typst** (typesetting + content), **Fletcher** (graph diagrams), **CeTZ** (drawing primitives).

## Decision tree

| Task | Reference |
|---|---|
| Setting up a render task; deciding static vs responsive output; embedding diagrams in Markdown | [render-pipeline](references/render-pipeline.md) |
| A Fletcher diagram blew up to 4×10¹⁷pt height, a self-loop won't render, mark shorthand errors, code blends into prose | [fletcher-pitfalls](references/fletcher-pitfalls.md) |
| Need a shape Fletcher doesn't ship; building a custom shape via CeTZ | [cetz-shapes](references/cetz-shapes.md) |
| Composing label bodies with raw, math, mixed runs; show-rule scoping; node body using Typst layout primitives | [typst-idioms](references/typst-idioms.md) |

## Stack constraints

- **Version-pinned imports.** Fletcher's mark parser, self-loop math, and shape API change between minor versions. Pin explicitly: `@preview/fletcher:0.5.8`, `@preview/cetz:0.3.4`.
- **Page-height interaction.** Typst's default `set page(height: auto)` creates a circular dependency with Fletcher self-loop extent. Wrap diagrams that use self-loops in a fixed-size `box(width:, height:, clip: true)` rather than altering the page model globally.
- **One source = one rendered artifact.** Imports flow up the tree (tokens, theme, helpers); diagram sources don't import each other. Shared scaffolding factors into helper modules.
- **SVG root always carries fixed pt-dimensions.** Typst emits `<svg width="…pt" height="…pt" viewBox="…">` unconditionally. The viewBox carries aspect ratio; strip width/height post-compile for responsive embeds.
