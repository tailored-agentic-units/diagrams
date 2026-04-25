// ==============================================================
// TAU theme — colour palette traced to GitHub Primer primitives.
//
// Structure: surfaces + ink + borders use neutral steps. Each
// chromatic hue exposes a `(stroke, fill, ink)` triple keyed to
// Primer's functional convention:
//
//   light mode:  stroke = .5 (mid)   fill = .0 (subtle)  ink = .7 (deep)
//   dark mode:   stroke = .4         fill = .9           ink = .2
//
// `stroke` is the entity outline. `fill` is the subtle background
// behind a label. `ink` is the high-contrast text colour for use
// on top of a `fill` from the same hue family — restores chromatic
// harmony lost when labels are coloured neutral over a tinted bg.
//
// Colour names are the anchors. There are no domain tokens here
// (no `code-stroke`, no `query` edge); diagrams choose a hue by
// name based on what their content needs to communicate.
//
// Full 10-step ladders are reference material; see catalog/palette.typ.
//
// Swap via `--input theme=light|dark` at compile time.
// ==============================================================

#let theme-name = sys.inputs.at("theme", default: "light")

#let palette = if theme-name == "dark" {(
  // ---- surfaces (neutral) ----
  surface:          rgb("#0D1117"),  // neutral.1  — canvas.default
  surface-muted:    rgb("#151B23"),  // neutral.2  — canvas.subtle
  surface-raised:   rgb("#010409"),  // neutral.0  — canvas.inset
  surface-emphasis: rgb("#212830"),  // neutral.3

  // ---- ink (neutral text on neutral surface) ----
  ink:             rgb("#F0F6FC"),   // neutral.12 — fg.default
  ink-muted:       rgb("#9198A1"),   // neutral.9  — fg.muted
  ink-subtle:      rgb("#656C76"),   // neutral.8  — fg.subtle

  // ---- borders (neutral) ----
  border:          rgb("#3D444D"),   // neutral.7  — border.default
  border-muted:    rgb("#2F3742"),   // neutral.6  — border.muted

  // ---- chromatic hues: (stroke, fill, ink) ----
  // dark mode: stroke = .4 lighter, fill = .9 deep, ink = .2 light-on-deep
  blue:    (stroke: rgb("#388BFD"), fill: rgb("#051D4D"), ink: rgb("#80CCFF")),
  green:   (stroke: rgb("#3FB950"), fill: rgb("#003D16"), ink: rgb("#6FDD8B")),
  yellow:  (stroke: rgb("#D29922"), fill: rgb("#4D2D00"), ink: rgb("#EAC54F")),
  orange:  (stroke: rgb("#DB6D28"), fill: rgb("#3D1300"), ink: rgb("#FFB77C")),
  red:     (stroke: rgb("#F85149"), fill: rgb("#660018"), ink: rgb("#FFABA8")),
  purple:  (stroke: rgb("#AB7DF8"), fill: rgb("#271052"), ink: rgb("#D8B9FF")),
  pink:    (stroke: rgb("#FF80C8"), fill: rgb("#611347"), ink: rgb("#FFADDA")),
  coral:   (stroke: rgb("#FD8C73"), fill: rgb("#691105"), ink: rgb("#FFB4A1")),
)} else {(
  // ---- surfaces (neutral) ----
  surface:          rgb("#FFFFFF"),  // neutral.0  — canvas.default
  surface-muted:    rgb("#F6F8FA"),  // neutral.1  — canvas.subtle
  surface-raised:   rgb("#EFF2F5"),  // neutral.2  — canvas.inset
  surface-emphasis: rgb("#E6EAEF"),  // neutral.3

  // ---- ink (neutral text on neutral surface) ----
  ink:             rgb("#1F2328"),   // neutral.13 — fg.default
  ink-muted:       rgb("#59636E"),   // neutral.9  — fg.muted
  ink-subtle:      rgb("#818B98"),   // neutral.8  — fg.subtle

  // ---- borders (neutral) ----
  border:          rgb("#D1D9E0"),   // neutral.6  — border.default
  border-muted:    rgb("#DAE0E7"),   // neutral.5  — border.muted

  // ---- chromatic hues: (stroke, fill, ink) ----
  // light mode: stroke = .5 mid, fill = .0 subtle, ink = .7 deep-on-subtle
  blue:    (stroke: rgb("#0969DA"), fill: rgb("#DDF4FF"), ink: rgb("#033D8B")),
  green:   (stroke: rgb("#1A7F37"), fill: rgb("#DAFBE1"), ink: rgb("#044F1E")),
  yellow:  (stroke: rgb("#9A6700"), fill: rgb("#FFF8C5"), ink: rgb("#633C01")),
  orange:  (stroke: rgb("#BC4C00"), fill: rgb("#FFF1E5"), ink: rgb("#762C00")),
  red:     (stroke: rgb("#CF222E"), fill: rgb("#FFEBE9"), ink: rgb("#82071E")),
  purple:  (stroke: rgb("#8250DF"), fill: rgb("#FBEFFF"), ink: rgb("#512A97")),
  pink:    (stroke: rgb("#BF3989"), fill: rgb("#FFEFF7"), ink: rgb("#772057")),
  coral:   (stroke: rgb("#C4432B"), fill: rgb("#FFF0EB"), ink: rgb("#801F0F")),
)}
