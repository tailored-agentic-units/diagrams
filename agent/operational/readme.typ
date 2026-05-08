// agent / operational — module wiring (operator voice).
// The agent module is a single go.mod that imports three native TAU modules (protocol, format,
// provider) and one external utility (google/uuid for UUIDv7 identity). Inner sub-packages
// partition the runtime concerns: client/ executes HTTP with a configurable retry policy;
// request/ carries the four protocol request types; registry/ stores named agent
// configurations with lazy instantiation; mock/ supplies test doubles. The retry knobs
// (MaxRetries, InitialBackoff, MaxBackoff, Jitter) on client/ are the operator's primary
// tuning surface.
//
// Layout: client/ + request/ + registry/ form the inner row at columns 0–2 of row 2. mock/
// sits above them at (1.5, 1) — between request/ and registry/ horizontally, in the row
// directly under the agent header — so it stays clear of the import edges that drop straight
// down from the inner row to the native deps. Native deps anchor at columns 0–2 of row 4
// directly below each inner card; their import edges are vertical (no diagonals).
// google/uuid sits at (5, 1) — a wider horizontal gap from the container's right edge so
// the imports label has breathing room on the edge.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Sub-package card — small blue card with name + role + optional knob list.
#let pkg-card(coord, name, role, name-tag: none, knobs: none) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", role),
    ..if knobs != none {
      (
        line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
        knobs,
      )
    } else { () },
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
  ..if name-tag != none { (name: name-tag) } else { (:) },
)

// Dependency box — single-shape resolution, muted neutral. Solid thin border for native deps;
// dashed border for external (third-party) deps per the tau-decisions external SDK / service
// boundary convention.
#let dep(coord, name, name-tag: none, dashed: false) = node(coord,
  text(size: tokens.size-body, fill: palette.ink-muted, name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: if dashed {
    (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed")
  } else {
    tokens.stroke-thin + palette.border
  },
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
  ..if name-tag != none { (name: name-tag) } else { (:) },
)

// RetryConfig knobs rendered as a compact field list inside client/'s card body. The four
// fields are the entirety of the operator's retry-tuning surface.
#let retry-knobs = grid(
  columns: 2,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text,
  raw("MaxRetries"),     raw("int"),
  raw("InitialBackoff"), raw("Duration"),
  raw("MaxBackoff"),     raw("Duration"),
  raw("Jitter"),         raw("bool"),
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Wider vertical rhythm — extra space-between-ranks gives the import edges from the inner
  // row down to the native deps room to breathe and keeps the dep row visually distinct from
  // the module container.
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks * 1.4),

  // Foreground header — sits spatially above the inner sub-packages so the background
  // container's snap:-1 rectangle reads as an enclosure framing them all.
  node((1, 0),
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.ink, "agent"),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
        style: "italic", "go.mod"),
    )),
    shape: fletcher.shapes.rect,
    fill: none, stroke: none, inset: 0pt,
    name: <agent-header>,
  ),

  // mock/ — placed above request/ and registry/ at (1.5, 1) so it stays clear of the import
  // edges from the inner row. mock/ is test-time only and has no runtime imports of its own
  // worth surfacing as edges, so it tucks into the empty space between header and inner row.
  pkg-card((1.5, 1), "mock/", "test doubles for agent + client + provider + format",
    name-tag: <pkg-mock>),

  // Inner sub-package cards — row 2. client/ at col 0 with retry-knob field-list (tall body);
  // request/ + registry/ at cols 1–2. Each card sits directly above its native-dep target so
  // the import edges drop straight down.
  pkg-card((0, 2), "client/",   "HTTP execution + retry",
    name-tag: <pkg-client>, knobs: retry-knobs),
  pkg-card((1, 2), "request/",  "four protocol request types",
    name-tag: <pkg-request>),
  pkg-card((2, 2), "registry/", "named agents + lazy instantiation",
    name-tag: <pkg-registry>),

  // Background container — encloses header + mock/ + inner sub-packages, snap:-1 so it
  // reads as a frame behind the foreground content.
  node(
    enclose: (<agent-header>, <pkg-mock>, <pkg-client>, <pkg-request>, <pkg-registry>),
    [],
    shape: fletcher.shapes.rect,
    fill: palette.surface-muted,
    stroke: tokens.stroke-thin + palette.border,
    inset: tokens.pad-inside-container,
    corner-radius: tokens.radius-container,
    snap: -1,
    name: <agent-container>,
  ),

  // External dep — dashed border per the external SDK / service boundary convention; a single
  // utility import (UUIDv7 generation for agent IDs). Placed at column 5 with columns 3–4
  // empty so the imports edge has horizontal length for its label.
  dep((5, 1), "google/uuid", name-tag: <dep-uuid>, dashed: true),

  // Native deps — solid thin border, single-shape resolution per tau-decisions.md. Placed at
  // row 4 directly below each inner-card column so the import edges drop straight down
  // through the vertical space below the container.
  dep((0, 4), "protocol", name-tag: <dep-protocol>),
  dep((1, 4), "format",   name-tag: <dep-format>),
  dep((2, 4), "provider", name-tag: <dep-provider>),

  // Imports edges. Native deps: anchored from the inner-card row down to each dep sharing
  // the same column — fletcher draws a vertical line between coords at the same x, so the
  // edges read as a clean drop from the agent module straight to its dependency. External
  // uuid: horizontal edge from the container to the right-side uuid box; the empty columns
  // 3–4 give the imports label horizontal breathing room.
  edge((0, 2), (0, 4), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 2), (1, 4), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 2), (2, 4), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge(<agent-container>, <dep-uuid>, "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
)
