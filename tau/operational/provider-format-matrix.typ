// tau / operational / provider-format-matrix — capability compatibility matrix.
// Rows: provider implementations (ollama, azure, bedrock) paired with their
// format sub-module. Columns: protocol capabilities (Chat, Vision, Tools,
// Embeddings). Cells: blue (supported) with optional streaming glyph
// (nf-oct-pulse, established in agent/core) on Chat and Vision; muted gray
// (unsupported) elsewhere. The matrix answers an operator's question
// "which provider × format pair supports which protocol?" without requiring
// them to read four separate library READMEs. Audio is a defined
// protocol.Protocol value but no current provider implements it; omitted
// from the matrix per strict present-state.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let cell-w = 7em
#let row-label-w = 14em

// Column header — text only, no shape.
#let col-header(coord, label) = node(coord,
  box(width: cell-w, align(center,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, label),
  )),
  shape: fletcher.shapes.rect,
  fill: none, stroke: none, inset: tokens.pad-inside-shape / 2,
)

// Row label — provider name + format annotation (which Format sub-module the
// provider pairs with at construction time).
#let row-label(coord, name, format) = node(coord,
  box(width: row-label-w, align(left, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.ink-muted,
      style: "italic", format + " format"),
  ))),
  shape: fletcher.shapes.rect,
  fill: none, stroke: none, inset: tokens.pad-inside-shape,
)

// Supported cell — blue, with check glyph and optional streaming marker.
#let yes-cell(coord, streaming: false) = node(coord,
  box(width: cell-w, align(center,
    stack(dir: ltr, spacing: tokens.gap-cell / 2,
      text(size: tokens.size-body, fill: palette.blue.ink, "\u{F00C}"),
      if streaming {
        text(size: tokens.size-body, fill: palette.blue.ink, "\u{F469}")
      } else { [] },
    ),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Unsupported cell — muted, with em-dash.
#let no-cell(coord) = node(coord,
  box(width: cell-w, align(center,
    text(size: tokens.size-body, fill: palette.ink-subtle, "—"),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: tokens.stroke-thin + palette.border,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#diagram(
  spacing: (tokens.gap-cell / 2, tokens.gap-cell / 2),

  // Header row (row 0) — protocol names.
  col-header((1, 0), "Chat"),
  col-header((2, 0), "Vision"),
  col-header((3, 0), "Tools"),
  col-header((4, 0), "Embeddings"),

  // ollama row — openai format, full protocol surface, streaming on chat & vision.
  row-label((0, 1), "ollama", "openai"),
  yes-cell((1, 1), streaming: true),
  yes-cell((2, 1), streaming: true),
  yes-cell((3, 1)),
  yes-cell((4, 1)),

  // azure row — openai format, same surface as ollama.
  row-label((0, 2), "azure", "openai"),
  yes-cell((1, 2), streaming: true),
  yes-cell((2, 2), streaming: true),
  yes-cell((3, 2)),
  yes-cell((4, 2)),

  // bedrock row — converse format. Chat / vision / tools supported with streaming
  // on chat & vision; embeddings is not part of the AWS Bedrock Converse API.
  row-label((0, 3), "bedrock", "converse"),
  yes-cell((1, 3), streaming: true),
  yes-cell((2, 3), streaming: true),
  yes-cell((3, 3)),
  no-cell((4, 3)),
)

// Legend rendered AFTER the fletcher diagram as a page-level element so it
// doesn't participate in the matrix's grid sizing (any node placed inside the
// diagram with the legend's natural width would inflate one of the columns).
// Centering against the page width visually balances under the matrix.
#v(tokens.gap-cell)
#align(center,
  stack(dir: ltr, spacing: tokens.gap-cell * 1.5,
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic",
      "\u{F00C} supported"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic",
      "\u{F469} streaming"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic",
      "— not supported"),
  )
)
