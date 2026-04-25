// ==============================================================
// Palette catalog — GitHub Primer hue ladders + candidate
// semantic readings. Source reference for how colour can carry
// meaning in diagrams. Numbers traced to primer/primitives base.
// ==============================================================
// render: static

#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette

#set page(
  width:  880pt,
  height: auto,
  margin: tokens.pad-inside-container,
  fill:   palette.surface,
)
#set text(
  font: tokens.font,
  size: tokens.size-body,
  fill: palette.ink,
)

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Universal link styling: blue + underline (matches glyphs.typ convention).
#show link: it => text(fill: palette.blue.stroke, underline(offset: 1.5pt, it))

// Swatch: a small rect filled with the given colour, hex label underneath.
#let swatch(c, step) = stack(dir: ttb, spacing: 4pt,
  rect(width: 52pt, height: 28pt, fill: c, stroke: tokens.stroke-thin + palette.border-muted, radius: 3pt),
  text(size: 7pt, fill: palette.ink-muted, step),
  text(size: 7pt, fill: palette.ink-subtle, upper(c.to-hex().slice(0, 7))),
)

// Hue ladder: 10 swatches across steps 0..9, preceded by a hue name.
#let hue-ladder(name, colors) = grid(
  columns: (80pt,) + (auto,) * 10,
  column-gutter: 4pt,
  align: (right + horizon,) + (center + horizon,) * 10,

  text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
  ..colors.enumerate().map(((i, c)) => swatch(c, str(i))),
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Palette — GitHub Primer ladder + semantic readings"),
)
#v(tokens.gap-structured-text)
#align(center,
  note([Hex values traced to #link("https://primer.style/")[Primer]'s #raw("primer/primitives") #raw("base.color.<hue>.<step>") tokens; the eight-hue selection mirrors the #link("https://brand.github.com/")[GitHub Brand Toolkit] color anchors. Steps 0-9 run lightest → darkest. Light-theme values shown; dark-theme inverts surface/ink and typically uses steps 3-4 for stroke accents.]))
#v(tokens.space-between-ranks)

// ---- SECTION A — hue ladders -----------------------------------------------

#section-title("A · hue ladders")
#v(tokens.gap-structured-text)
#note("Each hue spans 10 steps. Primer convention: 0-1 for subtle fills, 3-4 for dark-mode strokes, 5 for light-mode strokes, 9 for deep/emphatic fills.")
#v(tokens.space-between-shapes)

#let neutral = (
  rgb("#ffffff"), rgb("#f6f8fa"), rgb("#eaeef2"), rgb("#d0d7de"), rgb("#8c959f"),
  rgb("#6e7781"), rgb("#57606a"), rgb("#424a53"), rgb("#32383f"), rgb("#24292f"),
)
#let blue = (
  rgb("#ddf4ff"), rgb("#b6e3ff"), rgb("#80ccff"), rgb("#54aeff"), rgb("#218bff"),
  rgb("#0969da"), rgb("#0550ae"), rgb("#033d8b"), rgb("#0a3069"), rgb("#002155"),
)
#let green = (
  rgb("#dafbe1"), rgb("#aceebb"), rgb("#6fdd8b"), rgb("#4ac26b"), rgb("#2da44e"),
  rgb("#1a7f37"), rgb("#116329"), rgb("#044f1e"), rgb("#003d16"), rgb("#002d11"),
)
#let yellow = (
  rgb("#fff8c5"), rgb("#fae17d"), rgb("#eac54f"), rgb("#d4a72c"), rgb("#bf8700"),
  rgb("#9a6700"), rgb("#7d4e00"), rgb("#633c01"), rgb("#4d2d00"), rgb("#3b2300"),
)
#let orange = (
  rgb("#fff1e5"), rgb("#ffd8b5"), rgb("#ffb77c"), rgb("#fb8f44"), rgb("#e16f24"),
  rgb("#bc4c00"), rgb("#953800"), rgb("#762c00"), rgb("#5c2200"), rgb("#471700"),
)
#let red = (
  rgb("#ffebe9"), rgb("#ffcecb"), rgb("#ffaba8"), rgb("#ff8182"), rgb("#fa4549"),
  rgb("#cf222e"), rgb("#a40e26"), rgb("#82071e"), rgb("#660018"), rgb("#4c0014"),
)
#let purple = (
  rgb("#fbefff"), rgb("#ecd8ff"), rgb("#d8b9ff"), rgb("#c297ff"), rgb("#a475f9"),
  rgb("#8250df"), rgb("#6639ba"), rgb("#512a97"), rgb("#3e1f79"), rgb("#271052"),
)
#let pink = (
  rgb("#ffeff7"), rgb("#ffd3eb"), rgb("#ffadda"), rgb("#ff80c8"), rgb("#e85aad"),
  rgb("#bf3989"), rgb("#99286e"), rgb("#772057"), rgb("#611347"), rgb("#4d0336"),
)
#let coral = (
  rgb("#fff0eb"), rgb("#ffd6cc"), rgb("#ffb4a1"), rgb("#fd8c73"), rgb("#ec6547"),
  rgb("#c4432b"), rgb("#9e2f1c"), rgb("#801f0f"), rgb("#691105"), rgb("#510901"),
)

#stack(dir: ttb, spacing: tokens.space-between-shapes,
  hue-ladder("neutral", neutral),
  hue-ladder("blue",    blue),
  hue-ladder("green",   green),
  hue-ladder("yellow",  yellow),
  hue-ladder("orange",  orange),
  hue-ladder("red",     red),
  hue-ladder("purple",  purple),
  hue-ladder("pink",    pink),
  hue-ladder("coral",   coral),
)

#v(tokens.space-between-ranks)

// ---- SECTION B — semantic color groups -------------------------------------

#section-title("B · semantic color groups")
#v(tokens.gap-structured-text)
#note([Palette colors can be assigned semantic meaning within a visualization group. These are not strictly defined and are established during diagram design.])
#v(tokens.space-between-shapes)

// Sample node: a labelled swatch communicating a reading in context.
#let reading(hue-5, label, reading-note) = stack(dir: ttb, spacing: 4pt,
  rect(width: 110pt, height: 40pt, fill: hue-5.lighten(70%), stroke: 1.2pt + hue-5, radius: 4pt,
    inset: 8pt,
    text(size: tokens.size-body, weight: tokens.weight-bold, fill: hue-5.darken(20%), label),
  ),
  text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", reading-note),
)

// Example 1 — a severity ladder (the GitHub Primer functional convention).
#col-header("example: severity")
#v(tokens.gap-structured-text)
#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  reading(blue.at(5),    "accent",    "default informational"),
  reading(green.at(5),   "success",   "completed, ok"),
  reading(yellow.at(5),  "attention", "caution, heads-up"),
  reading(orange.at(5),  "severe",    "elevated concern"),
  reading(red.at(5),     "danger",    "error, blocking"),
)

#v(tokens.space-between-shapes * 1.2)

// Example 2 — pipeline status, illustrating that the same hues can carry
// different meaning when the diagram's content is about state rather than severity.
#col-header("example: pipeline status")
#v(tokens.gap-structured-text)
#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  reading(green.at(5),   "passing",   "tests green, build ok"),
  reading(yellow.at(5),  "pending",   "queued, running"),
  reading(red.at(5),     "failing",   "tests red, build broken"),
  reading(neutral.at(5), "unknown",   "no signal yet"),
)

#v(tokens.space-between-ranks)

// ---- SECTION C — example assignments ---------------------------------------

#section-title("C · example assignments")
#v(tokens.gap-structured-text)
#note([Groups (entity classes) and edges (relationships) can be assigned encoded colours. The values shown here are examples of potential assignments — actual mappings are chosen during diagram design based on what the diagram needs to communicate.])
#v(tokens.space-between-shapes)

// Sample chip: hue swatch + label, used to show a group→hue or edge→hue map.
#let chip(hue, label) = box(
  fill: hue.fill,
  stroke: tokens.stroke-default + hue.stroke,
  radius: 4pt,
  inset: (x: 8pt, y: 4pt),
  text(size: tokens.size-label, weight: tokens.weight-bold, fill: hue.ink, label),
)

#let edge-chip(hue, label, dash: none) = {
  let stroke-spec = if dash != none {
    (paint: hue.stroke, thickness: 1.6pt, dash: dash)
  } else {
    1.6pt + hue.stroke
  }
  align(center + horizon, stack(dir: ttb, spacing: 4pt,
    line(length: 70pt, stroke: stroke-spec),
    text(size: tokens.size-label, weight: tokens.weight-bold, fill: hue.ink, label),
  ))
}

#col-header("example: group → hue")
#v(tokens.gap-structured-text)
#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  align(center + horizon, chip(palette.purple, "code")),
  align(center + horizon, chip(palette.blue,   "service")),
  align(center + horizon, chip(palette.orange, "operator")),
  align(center + horizon, chip(palette.coral,  "infra")),
  align(center + horizon, chip(palette.green,  "data")),
)

#v(tokens.space-between-shapes * 1.2)

#col-header("example: edge kind → hue")
#v(tokens.gap-structured-text)
#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  align: center + horizon,

  edge-chip(palette.green,  "query"),
  edge-chip(palette.red,    "command"),
  edge-chip(palette.yellow, "event",   dash: "dashed"),
  edge-chip(palette.blue,   "data-flow"),
)
