// provider/bedrock / core — overview diagram (combined non-developer voice).
// The bedrock sub-module as the focus slab inside the parent provider library; a single "calls"
// edge reaches the AWS Bedrock external. Three streaming-marked capability pills (chat, vision,
// tools); embeddings is genuinely unsupported by the Converse API and omitted entirely from the
// pill row — matching what the source code actually exposes rather than introducing a muted
// "unsupported" pill variant. Cloud glyph on the external matches the parent provider/core
// convention for managed cloud APIs.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let _slab-w = 40em

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

#let provider-parent = node((0, 0),
  box(width: _slab-w,
    align(center, text(
      size: tokens.size-title,
      weight: tokens.weight-body,
      fill: palette.ink-muted,
      "provider",
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let bedrock-slab = node((0, 1),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "bedrock"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "transport adapter for AWS Bedrock Converse API",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("chat", streaming: true),
        cap("vision", streaming: true),
        cap("tools", streaming: true),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

// External AWS Bedrock — dashed bordered, muted neutral, prefixed with the cloud glyph
// (nf-fa-cloud) for a managed cloud API.
#let ext-bedrock = node((1, 1),
  text(size: tokens.size-body, weight: tokens.weight-body, fill: palette.ink-muted,
    "\u{F0C2}  AWS Bedrock"),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  provider-parent,
  bedrock-slab,
  ext-bedrock,

  edge((0, 1), (1, 1), "->", lbl("calls"), label-fill: palette.surface, stroke: edge-stroke),
)
