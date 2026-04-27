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

#let glyph-grid(entries, cols: 7) = grid(
  columns: (auto,) * cols,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,
  ..entries.map(((c, n)) => glyph-cell(c, n))
)

#glyph-grid((
  ("\u{E73C}", "python"),
  ("\u{E626}", "go"),
  ("\u{E7A8}", "rust"),
  ("\u{E60C}", "typescript"),
  ("\u{E74E}", "javascript"),
  ("\u{E791}", "ruby"),
  ("\u{E738}", "java"),
  ("\u{E61D}", "c"),
  ("\u{E61E}", "c++"),
  ("\u{E635}", "swift"),
  ("\u{E64C}", "kotlin"),
  ("\u{E763}", "css"),
  ("\u{E614}", "sass"),
  ("\u{E73E}", "php"),
))
