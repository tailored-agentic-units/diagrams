// ==============================================================
// Glyph catalog — Nerd Font symbology available in CaskaydiaMono NFP.
// Curated selection from Font Awesome + Codicons. Full reference:
// https://www.nerdfonts.com/cheat-sheet — these are the ones likely
// to carry diagram semantics cleanly at small sizes.
// ==============================================================
// render: static

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette

#set page(
  width:  900pt,
  height: auto,
  margin: tokens.pad-inside-container,
  fill:   palette.surface,
)
#set text(
  font: tokens.font,
  size: tokens.size-body,
  fill: palette.ink,
)

// Convention: links carry the blue hue + an underline. Both signals reinforce
// "this is a link" — colour for scanning, underline for accessibility.
#show link: it => text(fill: palette.blue.stroke, underline(offset: 1.5pt, it))

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Single cell: glyph rendered at 18pt, codepoint underneath, name below.
// repr() of `"\u{XXXX}"` returns the 10-char form `"\u{xxxx}"`; the hex digits
// sit between index 4 (after `"\u{`) and the closing `}"` (last 2 chars).
#let glyph-cell(codepoint, name) = {
  let r = repr(codepoint)
  let hex = upper(r.slice(4, r.len() - 2))
  stack(dir: ttb, spacing: 4pt,
    text(size: 18pt, fill: palette.ink, codepoint),
    text(size: 7pt, fill: palette.ink-subtle, "U+" + hex),
    text(size: tokens.size-label, fill: palette.ink-muted, name),
  )
}

#let glyph-grid(entries) = grid(
  columns: (1fr,) * 8,
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.space-between-shapes,
  align: center + horizon,
  ..entries.map(((c, n)) => glyph-cell(c, n))
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Glyphs — Nerd Font symbology in CaskaydiaMono NFP"),
)
#v(tokens.gap-structured-text)
#align(center,
  box(width: 720pt,
    note([CaskaydiaMono NFP carries 10,390 glyphs across the Nerd Fonts patched ranges. This catalog curates a small subset useful for diagram semantics; full reference at #link("https://www.nerdfonts.com/cheat-sheet")[nerdfonts.com/cheat-sheet] and codepoint sets at #link("https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points")[the Nerd Fonts wiki]. Glyphs render in the same flow as prose, carry palette colour like any text, and size via #raw("size:") like any text.])))
#v(tokens.space-between-ranks)

// ---- SECTION A — status ----------------------------------------------------

#section-title("A · status")
#v(tokens.gap-structured-text)
#note("Pass/fail/pending/info — the four axes of an operational state readout.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F00C}", "check"),
  ("\u{F00D}", "close"),
  ("\u{F071}", "warning"),
  ("\u{F05A}", "info"),
  ("\u{F059}", "question"),
  ("\u{F188}", "bug"),
  ("\u{F12A}", "alert"),
  ("\u{F05E}", "ban"),
))

#v(tokens.space-between-ranks)

// ---- SECTION B — actions ---------------------------------------------------

#section-title("B · actions")
#v(tokens.gap-structured-text)
#note("Verbs. Useful as icons along process edges or inside action nodes.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F04B}", "play"),
  ("\u{F04C}", "pause"),
  ("\u{F04D}", "stop"),
  ("\u{F021}", "refresh"),
  ("\u{F093}", "upload"),
  ("\u{F019}", "download"),
  ("\u{F1F8}", "trash"),
  ("\u{F044}", "edit"),
))

#v(tokens.space-between-ranks)

// ---- SECTION C — infrastructure --------------------------------------------

#section-title("C · infrastructure")
#v(tokens.gap-structured-text)
#note("Where things run. Useful inside compute/persistence nodes to indicate hosting.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F015}", "home"),
  ("\u{F0C2}", "cloud"),
  ("\u{F233}", "server"),
  ("\u{F1C0}", "database"),
  ("\u{F120}", "terminal"),
  ("\u{F0AC}", "globe"),
  ("\u{F0E7}", "bolt"),
  ("\u{F1EB}", "wifi"),
))

#v(tokens.space-between-ranks)

// ---- SECTION D — people + communication ------------------------------------

#section-title("D · people + communication")
#v(tokens.gap-structured-text)
#note("Operators and messaging. Carry the same orange palette as human/agent nodes by default.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F007}", "user"),
  ("\u{F0C0}", "users"),
  ("\u{F075}", "comment"),
  ("\u{F0E6}", "comments"),
  ("\u{F003}", "envelope"),
  ("\u{F002}", "search"),
  ("\u{F0F3}", "bell"),
  ("\u{F05D}", "check-circle"),
))

#v(tokens.space-between-ranks)

// ---- SECTION E — files + artifacts -----------------------------------------

#section-title("E · files + artifacts")
#v(tokens.gap-structured-text)
#note("Structural content. Folders, files, archives, bookmarks.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F07B}", "folder"),
  ("\u{F07C}", "folder-open"),
  ("\u{F15B}", "file"),
  ("\u{F15C}", "file-text"),
  ("\u{F1C6}", "archive"),
  ("\u{F02E}", "bookmark"),
  ("\u{F005}", "star"),
  ("\u{F02D}", "book"),
))

#v(tokens.space-between-ranks)

// ---- SECTION F — control + security ----------------------------------------

#section-title("F · control + security")
#v(tokens.gap-structured-text)
#note("Locks, keys, settings. For authentication boundaries and configuration.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F023}", "lock"),
  ("\u{F09C}", "unlock"),
  ("\u{F084}", "key"),
  ("\u{F013}", "cog"),
  ("\u{F085}", "cogs"),
  ("\u{F132}", "shield"),
  ("\u{F06E}", "eye"),
  ("\u{F070}", "eye-slash"),
))

#v(tokens.space-between-ranks)

// ---- SECTION G — relationships + flow --------------------------------------

#section-title("G · relationships + flow")
#v(tokens.gap-structured-text)
#note("Linkage, branching, versioning. Pairs naturally with edge glyphs.")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F0C1}", "link"),
  ("\u{F126}", "code-branch"),
  ("\u{F0C5}", "copy"),
  ("\u{F074}", "shuffle"),
  ("\u{F079}", "retweet"),
  ("\u{F1E0}", "share"),
  ("\u{F061}", "arrow-right"),
  ("\u{F063}", "arrow-down"),
))

#v(tokens.space-between-ranks)

// ---- SECTION H — brands ----------------------------------------------------

#section-title("H · brand marks (selected)")
#v(tokens.gap-structured-text)
#note("Recognisable service logos. Useful when diagrams reference external-provider identity (GitHub, Docker, language communities).")
#v(tokens.space-between-shapes)

#glyph-grid((
  ("\u{F09B}", "github"),
  ("\u{F296}", "gitlab"),
  ("\u{F1D3}", "git"),
  ("\u{F308}", "docker"),
  ("\u{F17C}", "linux"),
  ("\u{F179}", "apple"),
  ("\u{F17A}", "windows"),
  ("\u{F17B}", "android"),
))

#v(tokens.space-between-ranks)

// ---- SECTION I — composition patterns --------------------------------------

#section-title("I · composition patterns")
#v(tokens.gap-structured-text)
#note("Four ways a glyph can enter a diagram. The glyph is ordinary text under the hood — these patterns are just placement choices.")
#v(tokens.space-between-shapes)

// Pattern 1 — in-label (icon next to text)
// Auto columns + larger icon + gap-cell gutter so neither feels cramped.
#let p1 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    grid(columns: (auto, auto), column-gutter: tokens.gap-cell, align: (left + horizon, left + horizon),
      text(size: 18pt, fill: palette.blue.stroke, "\u{F1C0}"),
      stack(dir: ttb, spacing: tokens.gap-structured-text,
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, "users"),
        text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "(persistence)"),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// Pattern 2 — corner badge
#let p2 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      grid(columns: (1fr, auto), column-gutter: tokens.gap-cell, align: (left + horizon, right + horizon),
        text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, "api"),
        text(size: tokens.size-body, fill: palette.blue.stroke, "\u{F0C2}"),
      ),
      text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink, style: "italic", "(compute · cloud)"),
    ),
    shape: fletcher.shapes.rect,
    fill: palette.blue.fill,
    stroke: tokens.stroke-default + palette.blue.stroke,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// Pattern 3 — standalone icon (node is an icon)
#let p3 = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    align(center + horizon, stack(dir: ttb, spacing: 4pt,
      text(size: 26pt, fill: palette.orange.stroke, "\u{F007}"),
      text(size: tokens.size-label, fill: palette.orange.ink, "user"),
    )),
    shape: fletcher.shapes.pill,
    fill: palette.orange.fill,
    stroke: tokens.stroke-default + palette.orange.stroke,
    inset: tokens.pad-inside-shape,
  ),
)

// Pattern 4 — edge marker (glyph in label)
#let p4 = diagram(
  spacing: (120pt, 0pt),
  node((0, 0), "api",  shape: fletcher.shapes.rect, fill: palette.blue.fill,    stroke: tokens.stroke-default + palette.blue.stroke,  inset: tokens.pad-inside-shape, corner-radius: tokens.radius-shape),
  node((1, 0), "auth", shape: fletcher.shapes.rect, fill: palette.blue.fill,    stroke: tokens.stroke-default + palette.blue.stroke,  inset: tokens.pad-inside-shape, corner-radius: tokens.radius-shape),
  edge((0, 0), (1, 0), "->",
    stroke: (paint: palette.green.stroke, thickness: tokens.stroke-default),
    box(fill: palette.surface-muted, inset: (x: 4pt, y: 1pt), radius: 3pt,
      text(size: tokens.label-size, weight: tokens.weight-bold, fill: palette.ink, text(fill: palette.green.stroke, "\u{F023} ") + "authorised")),
    label-side: center, label-sep: 4pt,
  ),
)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-structured-text,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),

  col-header("in-label"),
  col-header("corner badge"),
  col-header("standalone"),
  col-header("edge marker"),

  p1, p2, p3, p4,

  note("glyph to the left of a\ntwo-line label"),
  note("glyph right-aligned\nalongside the name"),
  note("glyph is the primary\nvisual element"),
  note("glyph colours the\nedge-label text"),
)
