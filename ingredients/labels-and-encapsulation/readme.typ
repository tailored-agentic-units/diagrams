#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

#let card(hue, body) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), body,
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

#stack(dir: ltr, spacing: tokens.space-between-shapes,
  // Stacked title + kind
  card(palette.blue, stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("api"),
    _kind("service", palette.blue.ink),
  )),
  // Field list with divider
  card(palette.purple, stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Request"),
    _kind("structure", palette.purple.ink),
    divider(),
    grid(columns: 2, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text * 2,
      raw("id"),       raw("UUID"),
      raw("model"),    raw("string"),
    ),
  )),
)
