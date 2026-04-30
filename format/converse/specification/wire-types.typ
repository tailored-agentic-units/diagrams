// format/converse / specification — wire-type families (developer voice).
// Two families instead of three: non-streaming responses (apiResponse → apiOutput → apiMessage
// → contentBlock, with toolUse as a sub-branch from contentBlock) and streaming events
// (streamEvent as a discriminated union with *contentBlockDelta → delta and *messageStop as
// parallel branches). apiUsage is referenced by apiResponse only; no embeddings family.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../../design/tokens.typ": tokens
#import "../../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// Internal wire-type card — muted neutral; surface-muted fill signals "internal, not public API".
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

  // Non-streaming family — apiResponse → apiOutput → apiMessage → contentBlock,
  // with toolUse as a sub-branch hanging off contentBlock (the *toolUse pointer field).
  wire-card((0, 0), "apiResponse",
    "Output",     "apiOutput",
    "StopReason", "string",
    "Usage",      "apiUsage",
  ),
  wire-card((1, 0), "apiOutput",
    "Message", "apiMessage",
  ),
  wire-card((2, 0), "apiMessage",
    "Role",    "string",
    "Content", "[]contentBlock",
  ),
  wire-card((3, 0), "contentBlock",
    "Text",    "string",
    "ToolUse", "*toolUse",
  ),

  // Shared leaf — apiUsage referenced by apiResponse only (no embeddings family).
  wire-card((0, 1), "apiUsage",
    "InputTokens",  "int",
    "OutputTokens", "int",
    "TotalTokens",  "int",
  ),

  // toolUse — alternative content variant when contentBlock represents a tool-use entry.
  wire-card((3, 1), "toolUse",
    "ToolUseID", "string",
    "Name",      "string",
    "Input",     "map[string]any",
  ),

  // Streaming family — streamEvent as a discriminated union with two optional pointer
  // fields rendered as parallel branches.
  wire-card((0, 2), "streamEvent",
    "ContentBlockDelta", "*contentBlockDelta",
    "MessageStop",       "*messageStop",
  ),
  wire-card((1, 2), "contentBlockDelta",
    "ContentBlockIndex", "int",
    "Delta",             "delta",
  ),
  wire-card((2, 2), "delta",
    "Text", "string",
  ),
  wire-card((1, 3), "messageStop",
    "StopReason", "string",
  ),

  // Composition edges within each family (solid green).
  edge((0, 0), (1, 0), "->", stroke: edge-stroke),
  edge((1, 0), (2, 0), "->", stroke: edge-stroke),
  edge((2, 0), (3, 0), "->", stroke: edge-stroke),

  // contentBlock → toolUse: vertical sub-branch for the *toolUse alternative.
  edge((3, 0), (3, 1), "->", stroke: edge-stroke),

  // Streaming chain + branching: streamEvent → contentBlockDelta → delta (top branch),
  // streamEvent → messageStop (bottom branch via orthogonal routing).
  edge((0, 2), (1, 2), "->", stroke: edge-stroke),
  edge((1, 2), (2, 2), "->", stroke: edge-stroke),
  edge((0, 2), (0, 3), (1, 3), "->", stroke: edge-stroke),

  // Shared apiUsage edge (dashed) — vertical, no overlap with other shapes.
  edge((0, 0), (0, 1), "->", lbl("Usage"), label-fill: palette.surface, stroke: shared-stroke),
)
