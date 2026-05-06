// provider / core — overview diagram (stakeholder voice).
// Provider is the focus library in the four-layer TAU stack (agent / provider / format / protocol);
// a single forked "calls" edge reaches three LLM services on the right. Service nodes carry
// Nerd Font glyphs (cloud vs. server) to distinguish managed cloud APIs from self-hosted runtimes.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// All TAU stack layers render to the same outer width so the stack reads as unified.
#let _slab-w = 40em

// Capability pill — purple boxed label rendered inline inside the provider slab body.
#let cap(label) = box(
  inset: (x: 10pt, y: 4pt),
  radius: 1em,
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label),
)

// Muted upper / lower TAU layer — name-only, present but not the focus.
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

// Provider focus slab — blue, carries subtitle + the three transport mechanics it standardizes.
#let provider-slab = node((0, 1),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "provider"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "transport, authentication, and streaming for LLM services",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("endpoints"), cap("auth"), cap("streaming"),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

// External service node — dashed bordered, muted neutral, prefixed with a Nerd Font glyph.
// Cloud glyph (\u{F0C2}) for managed APIs (Azure OpenAI, AWS Bedrock); server glyph (\u{F233})
// for self-hosted runtimes (Ollama).
#let ext(name, glyph, row) = node((2, row),
  text(size: tokens.size-body, weight: tokens.weight-body, fill: palette.ink-muted,
    glyph + "  " + name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Match format/core's rhythm — wide horizontal spacing for the trunk to clear the slab and
  // carry the "calls" label; tighter vertical spacing keeps the TAU stack visually unified.
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  layer("agent",    0),
  provider-slab,
  layer("format",   2),
  layer("protocol", 3),

  ext("Ollama",            "\u{F233}", 0),
  ext("Azure OpenAI",      "\u{F0C2}", 1),
  ext("AWS Bedrock",       "\u{F0C2}", 2),

  // Forked "calls" edge: orthogonal polylines route through fork column 1 at the provider's row.
  // The three trunks share the (0,1)→(1,1) segment; from the fork point each branch turns to its
  // service row. Only the first edge carries the label, placed early on the trunk via label-pos.
  edge((0, 1), (1, 1), (1, 0), (2, 0), "->", lbl("calls"),
    label-pos: 0.2, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 1), (1, 1), (2, 1), "->", stroke: edge-stroke),
  edge((0, 1), (1, 1), (1, 2), (2, 2), "->", stroke: edge-stroke),
)
