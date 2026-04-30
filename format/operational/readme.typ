// format / operational — module wiring (operator voice).
// Module dependency graph showing the three Go modules (format root, openai, converse) and
// their go.mod boundaries; each sub-module names the protocols its implementation supports.
// The native dep (protocol) renders at single-shape resolution per the TAU diagram standard.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Capability pill — purple boxed protocol name inside a sub-module body.
#let cap(label) = box(
  inset: (x: 8pt, y: 3pt),
  radius: 1em,
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label),
)

// Module rect — composite body: title, go.mod annotation, divider, role + (optional) protocol pills.
// Emphasized stroke calls out the central format root that the others import.
#let module-card(coord, name, role, pills: (), emphasized: false) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "go.mod"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    text(size: tokens.size-caption, fill: palette.blue.ink, role),
    ..if pills.len() > 0 {
      (stack(dir: ltr, spacing: tokens.gap-cell / 2, ..pills),)
    } else { () },
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: (if emphasized { tokens.stroke-emphasis } else { tokens.stroke-default }) + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// Native dep — protocol shown at single-shape resolution per tau-decisions.md.
#let protocol-dep = node((1, 0),
  text(size: tokens.size-body, fill: palette.ink-muted, "protocol"),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks),

  protocol-dep,
  module-card((1, 1), "format", "Format interface · registry · data types", emphasized: true),
  module-card((0, 2), "openai", raw("openai.Register()"),
    pills: (cap("chat"), cap("vision"), cap("tools"), cap("embeddings"))),
  module-card((2, 2), "converse", raw("converse.Register()"),
    pills: (cap("chat"), cap("vision"), cap("tools"))),

  // Imports: format → protocol (vertical); sub-modules → format (orthogonal: up then turn into
  // format's side edge so each sub-module enters the format card horizontally rather than diagonally).
  edge((1, 1), (1, 0), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 2), (0, 1), (1, 1), "->", lbl("imports"), label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 2), (2, 1), (1, 1), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
)
