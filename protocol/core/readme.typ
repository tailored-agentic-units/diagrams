#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Every layer renders to the same outer width so the stack reads as unified.
#let _slab-w = 40em

// Capability pill — boxed label rendered inline inside the protocol slab body.
#let cap(label) = box(
  inset: (x: 10pt, y: 4pt),
  radius: 1em,
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label),
)

// Upper layer — present but not the focus.
#let layer(name, row) = node((0, row),
  box(width: _slab-w,
    align(center, text(
      size: tokens.size-title,
      weight: tokens.weight-body,
      fill: palette.ink-muted,
      name,
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Protocol slab — the foundation, carries subtitle + capability pills.
#let protocol = node((0, 3),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "protocol"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "shared types for messages, responses, model capabilities (protocols), and streamed output",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("chat"),
        cap("vision"),
        cap("tools"),
        cap("embeddings"),
        cap("audio"),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

#diagram(
  spacing: (0pt, tokens.gap-structured-text),
  layer("agent",    0),
  layer("provider", 1),
  layer("format",   2),
  protocol,
)
