---
name: diagram-ingredients
description: Universal inventory of the ingredients available when composing a diagram — typography and spacing, color and Nerd Font glyphs, shape primitives and variants, edge and mark vocabulary, label composition and named-inner-node containers. Toolkit-not-ruleset framing: each ingredient is described with its visual weight and useful applications, never as a "this means that" rule. Use when picking shapes, edges, marks, or label patterns for a diagram, deciding between a built-in shape and a composite, choosing how to differentiate variants of a shape, or composing a container with named inner nodes addressable across the boundary.
---

# Diagram ingredients

The inventory an author draws from when composing a diagram.

## Decision tree

| Task | Reference |
|---|---|
| Picking sizes, weights, decoration, or whitespace primitives for label content and node spacing | [text-and-space](references/text-and-space.md) |
| Choosing a hue for a node group; reading the four-attribute hue quad; placing inline glyphs (icons, status markers, brand badges) | [color-and-glyphs](references/color-and-glyphs.md) |
| Picking a shape for an entity; differentiating a variant via stroke / fill / geometry / overlay; building a composite node body or a custom CeTZ shape | [shapes-and-variants](references/shapes-and-variants.md) |
| Choosing arrow heads / tails / stroke styles; routing edges with bend, waypoints, or self-loops; positioning labels; mid-edge marks | [edges-and-marks](references/edges-and-marks.md) |
| Composing node body content (single-line, stacked, field list, divider, icon, math, mixed); building a container with named inner nodes addressable across the boundary | [labels-and-encapsulation](references/labels-and-encapsulation.md) |

## Ingredient principles

- **Toolkit, not ruleset.** Ingredients describe what's *achievable* and how each option *reads*. There is no "shape X means concept Y" mapping; each diagram picks ingredients whose visual weight carries the meaning of its content.
- **Visual weight tracks meaning.** The heavier the visual element (thick stroke, saturated fill, large size), the more attention it claims. Visual weight is the dial the author tunes per element relative to that element's importance in the diagram's argument.
- **Color names hues, not concepts.** A hue is chosen for what its visual weight does, not because of a fixed concept-to-color mapping. Two diagrams in the same project can use the same hue for different concepts.
