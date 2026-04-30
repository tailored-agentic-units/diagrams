// format/openai / specification — wire-type families (developer voice).
// The internal Go structs that mirror OpenAI's JSON shapes, organized into three families:
// non-streaming responses (apiResponse → apiChoice → apiMessage → apiToolCall → apiToolFunction),
// streaming events (streamChunk → streamChoice → apiDelta), and the structurally separate
// embeddings (embeddingsResponse → apiEmbedding). apiUsage is shared between non-streaming and
// embeddings families. All wire types are unexported — internal to the package.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Internal wire-type card — muted neutral; surface-muted fill signals "internal, not public API".
// Field grid renders every (name, type) pair in monospace via raw().
#let wire-card(pos, name, ..fields) = node(pos,
  align(left, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
    line(length: 100%, stroke: tokens.stroke-thin + palette.border),
    {
      show raw: r => text(fill: palette.ink-muted, weight: tokens.weight-body, r)
      grid(
        columns: (auto, auto),
        column-gutter: tokens.gap-cell,
        row-gutter: tokens.gap-structured-text,
        ..fields.pos().map(s => raw(s)),
      )
    },
  )),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke
#let shared-stroke = (paint: palette.green.stroke, thickness: tokens.stroke-default, dash: "dashed")

#diagram(
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks),

  // Non-streaming family — apiResponse → apiChoice → apiMessage → apiToolCall → apiToolFunction.
  wire-card((0, 0), "apiResponse",
    "Choices", "[]apiChoice",
    "Usage",   "*apiUsage",
  ),
  wire-card((1, 0), "apiChoice",
    "Message",      "apiMessage",
    "FinishReason", "string",
  ),
  wire-card((2, 0), "apiMessage",
    "Role",      "string",
    "Content",   "string",
    "ToolCalls", "[]apiToolCall",
  ),
  wire-card((3, 0), "apiToolCall",
    "ID",       "string",
    "Type",     "string",
    "Function", "apiToolFunction",
  ),
  wire-card((4, 0), "apiToolFunction",
    "Name",      "string",
    "Arguments", "string",
  ),

  // Shared leaf — apiUsage between non-streaming (above) and embeddings (below); both flow
  // back into it with clean vertical edges, so its references never cross other shapes.
  wire-card((0, 1), "apiUsage",
    "PromptTokens",     "int",
    "CompletionTokens", "int",
    "TotalTokens",      "int",
  ),

  // Embeddings family — embeddingsResponse → apiEmbedding.
  wire-card((0, 2), "embeddingsResponse",
    "Data",  "[]apiEmbedding",
    "Model", "string",
    "Usage", "*apiUsage",
  ),
  wire-card((1, 2), "apiEmbedding",
    "Embedding", "[]float64",
  ),

  // Streaming family — streamChunk → streamChoice → apiDelta. Doesn't reference apiUsage.
  wire-card((0, 3), "streamChunk",
    "Choices", "[]streamChoice",
  ),
  wire-card((1, 3), "streamChoice",
    "Delta",        "apiDelta",
    "FinishReason", "*string",
  ),
  wire-card((2, 3), "apiDelta",
    "Content", "string",
  ),

  // Composition edges within each family (solid).
  edge((0, 0), (1, 0), "->", stroke: edge-stroke),
  edge((1, 0), (2, 0), "->", stroke: edge-stroke),
  edge((2, 0), (3, 0), "->", stroke: edge-stroke),
  edge((3, 0), (4, 0), "->", stroke: edge-stroke),

  edge((0, 2), (1, 2), "->", stroke: edge-stroke),

  edge((0, 3), (1, 3), "->", stroke: edge-stroke),
  edge((1, 3), (2, 3), "->", stroke: edge-stroke),

  // Shared apiUsage edges (dashed) — vertical, no overlap with other shapes.
  // Both labels placed on the same visual side (west) for symmetry.
  edge((0, 0), (0, 1), "->", lbl("Usage"), label-fill: palette.surface, stroke: shared-stroke),
  edge((0, 2), (0, 1), "->", lbl("Usage"), label-side: left, label-fill: palette.surface, stroke: shared-stroke),
)
