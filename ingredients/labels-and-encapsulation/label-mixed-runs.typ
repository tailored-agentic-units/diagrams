#import "@preview/fletcher:0.5.8" as fletcher: diagram, node
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette, divider

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

#diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _title("planner"),
      _kind("agent", palette.orange.ink),
      divider(hue: palette.orange),
      grid(columns: 2, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text * 2,
        text(fill: palette.ink-muted, "model:"),  raw("claude-sonnet-4.6"),
        text(fill: palette.ink-muted, "tools:"),  raw("web_search, execute_code"),
        text(fill: palette.ink-muted, "status:"), text(fill: palette.green.stroke, "\u{F00C} ready"),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.orange.fill,
    stroke: tokens.stroke-default + palette.orange.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)
