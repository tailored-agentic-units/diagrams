#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))

// Fixed-size + clip box breaks the auto-page-height ↔ self-loop-extent
// circular dependency: with `height: auto` on the page, Fletcher's loop
// bounds and the page height become mutually recursive and diverge.
#let loop-demo(bend-deg, label) = stack(dir: ttb, spacing: tokens.gap-structured-text,
  col-header(label),
  box(width: 260pt, height: 240pt, clip: true,
    align(center + horizon,
      diagram(
        spacing: (60pt, 60pt),
        node((0, 0),
          box(fill: palette.blue.fill, stroke: tokens.stroke-default + palette.blue.stroke,
              radius: tokens.radius-shape, inset: 6pt,
              text(size: tokens.size-label, fill: palette.ink, "reading")),
          name: <r>),
        edge(<r>, <r>, "->", bend: bend-deg,
          stroke: tokens.stroke-default + palette.green.stroke,
          label-fill: palette.surface,
          text(size: tokens.label-size, weight: tokens.weight-bold, "read()")),
      ),
    ),
  ),
)

#grid(
  columns: (auto, auto, auto),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,

  loop-demo(115deg, "115°"),
  loop-demo(138deg, "138°"),
  loop-demo(160deg, "160°"),
)
