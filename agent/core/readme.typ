// agent / core — overview diagram (stakeholder voice).
// Agent is the topmost layer of the four-library TAU stack (agent / provider / format /
// protocol). A single "talks to" edge reaches an external LLM service on the right.
// Capability pills cover the four protocol modes; the streaming marker (nf-oct-pulse)
// distinguishes chat / vision — the two protocols that also expose explicit streaming
// methods (ChatStream, VisionStream) on the Agent interface. Tools and embed are
// non-streaming at the agent layer.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// All TAU stack layers render to the same outer width so the stack reads as unified.
#let _slab-w = 40em

// Capability pill — purple boxed label; an optional streaming marker (nf-oct-pulse)
// appended after the label distinguishes streaming-capable protocols.
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

// Muted lower TAU layer — name-only, present but not the focus.
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

// Agent focus slab — blue, carries subtitle + the four protocol-mode pills.
#let agent-slab = node((0, 0),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, "agent"),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        "the addressable LLM unit application code talks to",
      ),
      stack(dir: ltr, spacing: tokens.gap-cell,
        cap("chat", streaming: true),
        cap("vision", streaming: true),
        cap("tools"),
        cap("embed"),
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape * 1.5,
  corner-radius: tokens.radius-shape,
)

// External LLM service node — dashed bordered, muted neutral, prefixed with the cloud
// glyph. The agent is provider-agnostic, so this overview names the destination
// generically; specific services (Ollama, Azure OpenAI, AWS Bedrock) belong to provider/core.
#let ext-llm = node((1, 0),
  text(size: tokens.size-body, weight: tokens.weight-body, fill: palette.ink-muted,
    "\u{F0C2}  LLM service"),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Match provider/core rhythm — wide horizontal spacing carries the "talks to" label;
  // tighter vertical spacing keeps the TAU stack visually unified.
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  agent-slab,
  layer("provider", 1),
  layer("format",   2),
  layer("protocol", 3),

  ext-llm,

  edge((0, 0), (1, 0), "->", lbl("talks to"), label-fill: palette.surface, stroke: edge-stroke),
)
