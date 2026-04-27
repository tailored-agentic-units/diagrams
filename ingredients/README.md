# Ingredients

A composable toolkit for diagram authoring. Each ingredient is described objectively and intentionally not given a canonical mapping of shapes to concepts or hues to meanings; diagrams choose each ingredient based on what their content needs to communicate. The inventory is organized into five topics: text and space, color and glyphs, shapes and variants, edges and marks, and labels and encapsulation. Each topic is independent. You can pull from any of them in any combination when authoring a new diagram.

## [text and space](./text-and-space/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./text-and-space/readme-dark.svg">
  <img src="./text-and-space/readme-light.svg" alt="text and space — labeled cards demonstrating typography hierarchy and whitespace tokens" width="100%">
</picture>

Typography (size, weight, style, decoration, tracking, color) shapes the text inside a label; whitespace primitives (insets, gutters, gaps) shape the space around it. Hierarchy is expressed through weight + size, never through font family.

## [color and glyphs](./color-and-glyphs/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./color-and-glyphs/readme-dark.svg">
  <img src="./color-and-glyphs/readme-light.svg" alt="color and glyphs — four hue-tinted cards each carrying a different glyph" width="100%">
</picture>

Chromatic hues (and their four-attribute quad: stroke, fill, ink, divider) plus Nerd Font glyphs from 13 source families covering languages, frameworks, infrastructure, source control, file types, weather, power, and more. The palette is color-anchored and the glyph inventory is comprehensive — diagrams choose what their content needs.

## [shapes and variants](./shapes-and-variants/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./shapes-and-variants/readme-dark.svg">
  <img src="./shapes-and-variants/readme-light.svg" alt="shapes and variants — four shape primitives across four hues" width="100%">
</picture>

Shape and hue enable separate means of providing visual distinction to diagram nodes.

## [edges and marks](./edges-and-marks/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./edges-and-marks/readme-dark.svg">
  <img src="./edges-and-marks/readme-light.svg" alt="edges and marks — client commands a service, service writes to store, service emits an event to a bus" width="100%">
</picture>

Edges connect nodes; marks are the head/tail glyphs on edges. The mark inventory differentiates kinds; routing primitives (bend, waypoints, self-loops, layer) determine how the line gets drawn.

## [labels and encapsulation](./labels-and-encapsulation/README.md)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./labels-and-encapsulation/readme-dark.svg">
  <img src="./labels-and-encapsulation/readme-light.svg" alt="labels and encapsulation — a stacked api card and a Request structure with field list" width="100%">
</picture>

Content patterns inside nodes (single-line, stacked title+kind, field list, divider, icon, math, mixed runs) plus the container pattern that lets external nodes address inner nodes across a boundary. Labels carry the per-node identity and payload; encapsulation gives the diagram a way to group nodes structurally without breaking edge addressability.
