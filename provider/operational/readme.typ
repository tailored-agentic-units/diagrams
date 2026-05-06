// provider / operational — module wiring (operator voice).
// Module dependency graph showing the four Go modules (provider root + three sub-modules) and
// their go.mod boundaries. Each sub-module names its supported authentication modes and any
// external SDK weight it pulls in. The native dep (protocol) renders at single-shape resolution.
// streaming/ appears as an inner sub-package note on the root — part of the root's build graph,
// not its own module.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Auth pill — purple boxed auth-mode label inside a sub-module body.
#let cap(label) = box(
  inset: (x: 8pt, y: 3pt),
  radius: 1em,
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label),
)

// Module rect — composite body: title, go.mod annotation, divider, role line, optional inner-sub
// or external-SDK note, optional auth pills row. The inner-sub note is italicized to signal a
// sub-package within this module's build graph; the SDK note is italicized to signal third-party
// weight pulled in.
#let module-card(coord, name, role, inner: none, sdk: none, pills: (), emphasized: false) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "go.mod"),
    line(length: 100%, stroke: tokens.stroke-thin + palette.blue.divider),
    text(size: tokens.size-caption, fill: palette.blue.ink, role),
    ..if inner != none {
      (text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "+ " + inner),)
    } else { () },
    ..if sdk != none {
      (text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "+ " + sdk),)
    } else { () },
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
  module-card((1, 1), "provider",
    "Provider interface · registry · Request type",
    inner: "streaming/",
    emphasized: true,
  ),

  module-card((0, 2), "ollama", raw("ollama.Register()"),
    pills: (cap("bearer"), cap("api key"))),
  module-card((1, 2), "azure", raw("azure.Register()"),
    sdk: "Azure SDK",
    pills: (cap("api key"), cap("bearer"), cap("managed id"))),
  module-card((2, 2), "bedrock", raw("bedrock.Register()"),
    sdk: "AWS SDK",
    pills: (cap("SigV4 signed"),)),

  // Imports: provider → protocol (vertical); each sub-module → provider (orthogonal up-then-into
  // the side edge of the provider card so entrances stay horizontal rather than diagonal).
  edge((1, 1), (1, 0), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 2), (0, 1), (1, 1), "->", lbl("imports"), label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 2), (1, 1), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
  edge((2, 2), (2, 1), (1, 1), "->", lbl("imports"), label-fill: palette.surface, stroke: edge-stroke),
)
