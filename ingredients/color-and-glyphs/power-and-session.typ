#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

// IEC Power Symbols are below the Unicode Private Use Area (U+23FB etc.),
// so the usual `repr(codepoint).slice(...)` hex trick fails. Pass the hex
// explicitly as a third tuple element to keep the helper bulletproof.
#let glyph-cell(codepoint, name, hex) = stack(dir: ttb, spacing: tokens.gap-cell,
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

#let glyph-grid(entries, cols: 5) = grid(
  columns: (auto,) * cols,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,
  ..entries.map(((c, n, h)) => glyph-cell(c, n, h))
)

#glyph-grid((
  ("\u{23FB}", "power",           "23FB"),
  ("\u{23FC}", "power-on-line",   "23FC"),
  ("\u{23FD}", "power-on-solid",  "23FD"),
  ("\u{23FE}", "sleep",           "23FE"),
  ("\u{2B58}", "power-off",       "2B58"),
  ("\u{E000}", "pomo-done",       "E000"),
  ("\u{E002}", "pomo-estimated",  "E002"),
  ("\u{E003}", "pomo-squashed",   "E003"),
  ("\u{E005}", "pomo-ticking",    "E005"),
))
