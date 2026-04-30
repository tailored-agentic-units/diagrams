// format / core — overview diagram (stakeholder voice).
// Format is the focus library in the four-layer TAU stack (agent / provider / format / protocol);
// a single forked "translates to" edge reaches the external API destinations on the right, with
// dashed muted boundaries + cloud glyphs to signal "external cloud service we translate toward."

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// All TAU stack layers render to the same outer width so the stack reads as unified.
#let _slab-w = 40em

// Capability pill — purple boxed label rendered inline inside the format slab body.
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

// Format focus slab — blue, carries subtitle + capability pills.
#let format-slab = node((0, 2),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "format"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "translates between TAU's protocol types and provider API formats",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("chat"), cap("vision"), cap("tools"), cap("embeddings"),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

// External API format node — dashed bordered, muted neutral. Dashed boundary signals
// "outside TAU's source tree." No glyph: these nodes name wire-format specifications, not
// cloud services, so iconography like a cloud would misrepresent the subject.
#let ext(name, row) = node((2, row),
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
  // Tight vertical spacing matches the protocol/core stack rhythm; wider horizontal spacing
  // gives the trunk room to clear the format slab and carry the "translates to" label.
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  layer("agent",    0),
  layer("provider", 1),
  format-slab,
  layer("protocol", 3),

  ext("OpenAI API", 1),
  ext("AWS Bedrock Converse API", 3),

  // Forked translates-to edge: orthogonal four-vertex polylines route through fork column 1.
  // The two trunks (segment one) overlap visually; the two vertical halves (segment two) meet
  // at the fork point — together they read as one trunk + spine + horizontal arms.
  // Only the first edge carries the label, placed on the trunk via label-pos.
  edge((0, 2), (1, 2), (1, 1), (2, 1), "->", lbl("translates to"),
    label-pos: 0.2, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 2), (1, 2), (1, 3), (2, 3), "->", stroke: edge-stroke),
)
