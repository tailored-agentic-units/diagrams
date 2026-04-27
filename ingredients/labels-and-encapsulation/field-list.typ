#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

#diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _title("Request"),
      _kind("structure", palette.purple.ink),
      divider(),
      grid(columns: 2, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text * 2,
        raw("id"),       raw("UUID"),
        raw("messages"), raw("[]Message"),
        raw("model"),    raw("string"),
        raw("stream"),   raw("bool"),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.purple.fill,
    stroke: tokens.stroke-default + palette.purple.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)
