// format/openai / core — overview diagram (combined non-developer voice).
// The openai sub-module as the focus slab inside the parent format library; a single forked
// "translates to" edge reaches the OpenAI API external. Capability pills carry a streaming
// marker (Nerd Font play glyph) on protocols that support streaming; embeddings is unmarked.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let _slab-w = 40em

// Capability pill — purple boxed label; an optional streaming marker (nf-oct-pulse) appended
// after the label distinguishes streaming-capable protocols from non-streaming ones.
#let cap(label, streaming: false) = box(
  inset: (x: 10pt, y: 4pt),
  radius: 1em,
  fill: palette.purple.fill,
  stroke: tokens.stroke-thin + palette.purple.stroke,
  if streaming {
    stack(dir: ltr, spacing: 6pt,
      text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label),
      text(size: tokens.size-label, fill: palette.purple.ink, "\u{F469}"),
    )
  } else {
    text(size: tokens.size-label, weight: tokens.weight-body, fill: palette.purple.ink, label)
  },
)

// Parent format library — single-shape native dep, positioned above the focus slab.
#let format-parent = node((0, 0),
  box(width: _slab-w,
    align(center, text(
      size: tokens.size-title,
      weight: tokens.weight-body,
      fill: palette.ink-muted,
      "format",
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// openai focus slab — blue, carries subtitle + capability pills with streaming markers.
#let openai-slab = node((0, 1),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "openai"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "wire-format adapter for OpenAI-compatible APIs",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("chat", streaming: true),
        cap("vision", streaming: true),
        cap("tools", streaming: true),
        cap("embeddings"),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

// External API destination — dashed bordered, muted neutral; no glyph (these are wire-format
// specifications, not cloud services).
#let ext(name, row) = node((1, row),
  text(size: tokens.size-body, weight: tokens.weight-body, fill: palette.ink-muted, name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Tight vertical spacing keeps the parent format and openai stack reading as unified;
  // wider horizontal spacing gives the "translates to" edge label room to clear.
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  format-parent,
  openai-slab,
  ext("OpenAI API", 1),

  edge((0, 1), (1, 1), "->", lbl("translates to"), label-fill: palette.surface, stroke: edge-stroke),
)
