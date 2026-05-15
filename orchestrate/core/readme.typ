// orchestrate / core — overview diagram (stakeholder voice).
// Orchestrate is TAU's coordination layer above the four phase-03 libraries: it routes
// messages between any participants (Hub), sequences workflows through a directed state
// graph (StateGraph), and composes work via generic patterns (Workflow Patterns), with
// observability wired through every step. The three capabilities render as peer rows
// inside a single focal orchestrate slab; participants enter from the left. The diagram
// communicates "orchestrate coordinates participants" without naming agents — orchestrate
// has no TAU dependency, and the participant interface accepts anything with an ID.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Match the prior library cores' slab width so the corpus reads as unified across
// repositories — orchestrate's focal slab carries three capability rows instead of one.
#let _slab-w = 40em

// Capability row inside the orchestrate slab — glyph + name + role line, all in purple
// to read as orchestrate's interior subsystems (distinct from the blue identity of the
// containing library). A two-column grid pins the glyph in a fixed-width left slot so
// the icon column stays vertically anchored across rows regardless of each glyph's own
// left-bearing; the text column spans the remaining width with its name + role centered.
#let cap-row(glyph, name, role) = box(
  width: 100%,
  inset: (x: tokens.pad-inside-shape * 0.6, y: tokens.pad-inside-shape * 0.7),
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  radius: tokens.radius-shape,
  grid(
    columns: (1.5em, 1fr),
    column-gutter: tokens.gap-structured-text,
    align: horizon,
    text(size: tokens.size-title, fill: palette.purple.ink, glyph),
    align(center + horizon, stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.purple.ink, name),
      text(
        size: tokens.size-label,
        weight: tokens.weight-light,
        fill: palette.ink,
        style: "italic",
        role,
      ),
    )),
  ),
)

// Focal orchestrate slab — blue identity, three capability rows + observability footer.
// The observability footer is a thin muted band so it visually wraps everything above it
// (the "wired through every step" claim) without competing for primary attention.
#let orchestrate-slab = node((1, 0),
  box(width: _slab-w,
    stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
        text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "orchestrate"),
        text(
          size: tokens.size-caption,
          weight: tokens.weight-light,
          fill: palette.blue.ink,
          style: "italic",
          "coordinates how participants exchange messages, sequence work, and compose patterns",
        ),
      )),
      v(tokens.gap-structured-text),
      cap-row("\u{F362}", "Hub",               "routes messages between participants (request-response, broadcast, pub-sub)"),
      cap-row("\u{F0E8}", "State Graph",       "sequences workflows through directed nodes with checkpoint and resume"),
      cap-row("\u{F085}", "Workflow Patterns", "composes work as sequential chains, parallel fan-out, or conditional routes"),
      cap-row("\u{F06E}", "Observability",     "emits OTel-aligned events at every routing, transition, and pattern step"),
    ),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.2,
  corner-radius: tokens.radius-shape,
)

// Participants — orange (actor convention from herald-OV-1), generic class abstraction.
// The "ID() string" sub-line surfaces orchestrate's load-bearing decoupling: anything
// with an identity can participate; no agent, type, or framework assumption is made.
#let participants = node((0, 0),
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    stack(dir: ltr, spacing: tokens.gap-cell,
      text(size: tokens.size-title, fill: palette.orange.ink, "\u{F0C0}"),
      text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.orange.ink, "participants"),
    ),
    text(
      size: tokens.size-label,
      weight: tokens.weight-light,
      fill: palette.ink,
      style: "italic",
      "any type with an ID()",
    ),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.orange.fill,
  stroke: tokens.stroke-default + palette.orange.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Wide horizontal spacing carries the "register · communicate" edge label without
  // either shape clipping it; single-row layout keeps the focal slab and its
  // participants visually paired.
  spacing: (7 * tokens.space-between-shapes, tokens.space-between-ranks),

  participants,
  orchestrate-slab,

  // The edge lands at the hub capability semantically (top row), but Fletcher anchors
  // to the slab's east edge; the label "register · communicate" names both lifecycle
  // moments orchestrate exposes to participants.
  edge((0, 0), (1, 0), "->", lbl("register · communicate"), label-fill: palette.surface, stroke: edge-stroke),
)
