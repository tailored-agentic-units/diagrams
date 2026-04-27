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

#let glyph-grid(entries, cols: 5) = grid(
  columns: (auto,) * cols,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,
  ..entries.map(((c, n)) => glyph-cell(c, n))
)

#glyph-grid((
  ("\u{F0C1}", "link"),
  ("\u{F126}", "branch"),
  ("\u{F0C5}", "copy"),
  ("\u{F074}", "shuffle"),
  ("\u{F079}", "retweet"),
  ("\u{F1E0}", "share"),
  ("\u{F061}", "arrow-right"),
  ("\u{F063}", "arrow-down"),
  ("\u{F417}", "pull-request"),
  ("\u{F407}", "merge"),
))
