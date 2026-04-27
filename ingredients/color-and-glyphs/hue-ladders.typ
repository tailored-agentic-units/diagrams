#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#let swatch(c, step) = stack(dir: ttb, spacing: 4pt,
  rect(width: 52pt, height: 28pt, fill: c, stroke: tokens.stroke-thin + palette.border-muted, radius: 3pt),
  text(size: 7pt, fill: palette.ink-muted, step),
  text(size: 7pt, fill: palette.ink-subtle, upper(c.to-hex().slice(0, 7))),
)

#let hue-ladder(name, colors) = grid(
  columns: (auto,) + (auto,) * 10,
  column-gutter: 4pt,
  align: (right + horizon,) + (center + horizon,) * 10,

  text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, name),
  ..colors.enumerate().map(((i, c)) => swatch(c, str(i))),
)

#let neutral = (rgb("#ffffff"), rgb("#f6f8fa"), rgb("#eaeef2"), rgb("#d0d7de"), rgb("#8c959f"), rgb("#6e7781"), rgb("#57606a"), rgb("#424a53"), rgb("#32383f"), rgb("#24292f"))
#let blue    = (rgb("#ddf4ff"), rgb("#b6e3ff"), rgb("#80ccff"), rgb("#54aeff"), rgb("#218bff"), rgb("#0969da"), rgb("#0550ae"), rgb("#033d8b"), rgb("#0a3069"), rgb("#002155"))
#let green   = (rgb("#dafbe1"), rgb("#aceebb"), rgb("#6fdd8b"), rgb("#4ac26b"), rgb("#2da44e"), rgb("#1a7f37"), rgb("#116329"), rgb("#044f1e"), rgb("#003d16"), rgb("#002d11"))
#let yellow  = (rgb("#fff8c5"), rgb("#fae17d"), rgb("#eac54f"), rgb("#d4a72c"), rgb("#bf8700"), rgb("#9a6700"), rgb("#7d4e00"), rgb("#633c01"), rgb("#4d2d00"), rgb("#3b2300"))
#let orange  = (rgb("#fff1e5"), rgb("#ffd8b5"), rgb("#ffb77c"), rgb("#fb8f44"), rgb("#e16f24"), rgb("#bc4c00"), rgb("#953800"), rgb("#762c00"), rgb("#5c2200"), rgb("#471700"))
#let red     = (rgb("#ffebe9"), rgb("#ffcecb"), rgb("#ffaba8"), rgb("#ff8182"), rgb("#fa4549"), rgb("#cf222e"), rgb("#a40e26"), rgb("#82071e"), rgb("#660018"), rgb("#4c0014"))
#let purple  = (rgb("#fbefff"), rgb("#ecd8ff"), rgb("#d8b9ff"), rgb("#c297ff"), rgb("#a475f9"), rgb("#8250df"), rgb("#6639ba"), rgb("#512a97"), rgb("#3e1f79"), rgb("#271052"))
#let pink    = (rgb("#ffeff7"), rgb("#ffd3eb"), rgb("#ffadda"), rgb("#ff80c8"), rgb("#e85aad"), rgb("#bf3989"), rgb("#99286e"), rgb("#772057"), rgb("#611347"), rgb("#4d0336"))
#let coral   = (rgb("#fff0eb"), rgb("#ffd6cc"), rgb("#ffb4a1"), rgb("#fd8c73"), rgb("#ec6547"), rgb("#c4432b"), rgb("#9e2f1c"), rgb("#801f0f"), rgb("#691105"), rgb("#510901"))

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
