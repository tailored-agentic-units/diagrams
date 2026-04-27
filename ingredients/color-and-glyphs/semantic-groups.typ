#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

#let reading(hue, label, reading-note) = stack(dir: ttb, spacing: 4pt,
  rect(width: 110pt, height: 40pt, fill: hue.fill, stroke: tokens.stroke-default + hue.stroke, radius: tokens.radius-shape,
    inset: 8pt,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: hue.ink, label),
  ),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", reading-note),
)

#stack(dir: ttb, spacing: tokens.space-between-ranks,
  stack(dir: ttb, spacing: tokens.gap-cell,
    col-header("severity"),
    grid(
      columns: (auto, auto, auto, auto, auto),
      column-gutter: tokens.space-between-shapes,
      align: center + horizon,

      reading(palette.blue,    "accent",    "default informational"),
      reading(palette.green,   "success",   "completed, ok"),
      reading(palette.yellow,  "attention", "caution, heads-up"),
      reading(palette.orange,  "severe",    "elevated concern"),
      reading(palette.red,     "danger",    "error, blocking"),
    ),
  ),

  stack(dir: ttb, spacing: tokens.gap-cell,
    col-header("pipeline status"),
    grid(
      columns: (auto, auto, auto, auto),
      column-gutter: tokens.space-between-shapes,
      align: center + horizon,

      reading(palette.green,   "passing",   "tests green, build ok"),
      reading(palette.yellow,  "pending",   "queued, running"),
      reading(palette.red,     "failing",   "tests red, build broken"),
      (stack(dir: ttb, spacing: 4pt,
        rect(width: 110pt, height: 40pt, fill: palette.surface-muted, stroke: tokens.stroke-default + palette.border, radius: tokens.radius-shape,
          inset: 8pt,
          text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink-muted, "unknown"),
        ),
        text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", "no signal yet"),
      )),
    ),
  ),
)
