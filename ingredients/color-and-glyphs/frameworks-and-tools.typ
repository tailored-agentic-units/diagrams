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
  ("\u{E7BA}",  "react"),
  ("\u{E7BD}",  "vue"),
  ("\u{E753}",  "angular"),
  ("\u{E71D}",  "django"),
  ("\u{E73D}",  "rails"),
  ("\u{E7B0}",  "nodejs"),
  ("\u{E7B1}",  "express"),
  ("\u{E76E}",  "docker"),
  ("\u{E7B6}",  "postgres"),
  ("\u{E704}",  "mongodb"),
  ("\u{E76D}",  "redis"),
  ("\u{F10FE}", "kubernetes"),
  ("\u{E70F}",  "terraform"),
))
