#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let glyph-cell(codepoint, name) = {
  let r = repr(codepoint)
  let hex = upper(r.slice(4, r.len() - 2))
  stack(dir: ttb, spacing: tokens.gap-cell,
    box(width: 48pt, height: 40pt, fill: palette.surface-muted,
        stroke: tokens.stroke-thin + palette.border-muted,
        radius: tokens.radius-shape, inset: tokens.pad-inside-shape,
      align(center + horizon,
        text(size: 18pt, fill: palette.ink, codepoint))),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      text(size: tokens.size-caption, fill: palette.ink-subtle, "U+" + hex),
      text(size: tokens.size-label, fill: palette.ink-muted, name),
    ),
  )
}

#let glyph-grid(entries, cols: 6) = grid(
  columns: (auto,) * cols,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,
  ..entries.map(((c, n)) => glyph-cell(c, n))
)

#glyph-grid((
  ("\u{F00C}", "check"),
  ("\u{F00D}", "close"),
  ("\u{F071}", "warning"),
  ("\u{F05A}", "info"),
  ("\u{F059}", "question"),
  ("\u{F188}", "bug"),
  ("\u{F12A}", "alert"),
  ("\u{F05E}", "ban"),
  ("\u{EAB2}", "pass"),
  ("\u{EA6C}", "error"),
  ("\u{EBE6}", "warning"),
  ("\u{EA74}", "issues"),
))
