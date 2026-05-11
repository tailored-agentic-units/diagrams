// tau / core — capstone overview (stakeholder voice).
// TAU is the four-library platform: agent / provider / format / protocol. The capstone
// presents all four as co-equal subjects (each rendered in the focal blue), with an
// application caller on the left and a generic LLM service on the right. Agent is the
// only library application code talks to, and the only one the stakeholder narrative
// names as "talking to" the LLM service — provider, format, and protocol cooperate behind
// it. Specific services (Ollama, Azure OpenAI, AWS Bedrock) and capability matrices
// belong to the operational tier.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// All four library slabs share the same outer width so the stack reads as unified.
#let _slab-w = 40em

// Library slab — blue, name + role line. Uniformly applied to every layer because the
// capstone subject is the platform itself; all four libraries are co-equal subjects.
#let lib-slab(name, role, row) = node((1, row),
  box(width: _slab-w,
    align(center, stack(dir: ttb, spacing: tokens.gap-structured-text * 1.5,
      text(size: tokens.size-title, weight: tokens.weight-bold, fill: palette.blue.ink, name),
      text(
        size: tokens.size-caption,
        weight: tokens.weight-light,
        fill: palette.blue.ink,
        style: "italic",
        role,
      ),
    )),
  ),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Application caller — local, neutral, solid thin border (inside the user's system).
#let caller = node((0, 0),
  text(size: tokens.size-body, weight: tokens.weight-body, fill: palette.ink-muted,
    "\u{F121}  application"),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// External LLM service — dashed border + cloud glyph per the TAU external-service
// boundary convention established in the provider diagrams. Generic name; specific
// services are named in the operational tier.
#let ext-llm = node((2, 0),
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
  // Wide horizontal spacing to carry the caller / LLM service edges and labels;
  // tight vertical spacing keeps the four-layer stack reading as one platform.
  spacing: (4 * tokens.space-between-shapes, tokens.gap-structured-text),

  caller,

  lib-slab("agent",    "the addressable LLM unit application code talks to",                                       0),
  lib-slab("provider", "transport, authentication, and streaming for LLM services",                                1),
  lib-slab("format",   "translates between TAU's protocol types and provider API formats",                         2),
  lib-slab("protocol", "shared types for messages, responses, model capabilities (protocols), and streamed output", 3),

  ext-llm,

  // Application calls the agent (left edge); agent talks to the LLM service (right edge).
  // Both edges sit at the agent's row — agent is the surface the application reaches and
  // the surface the stakeholder narrative names as "talking to" the LLM service. The
  // other three libraries cooperate behind that surface.
  edge((0, 0), (1, 0), "->", lbl("calls"),    label-fill: palette.surface, stroke: edge-stroke),
  edge((1, 0), (2, 0), "->", lbl("talks to"), label-fill: palette.surface, stroke: edge-stroke),
)
