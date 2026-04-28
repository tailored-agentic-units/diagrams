# Palette pattern

The palette module exports the colors a diagram uses. Two non-negotiables: **color-anchored** (named by hue, never by domain) and **theme-swappable** (light/dark via compile-time input).

## Color-anchored vs domain-named

A **color-anchored palette** names hues by their color:

```
palette.blue, palette.green, palette.purple, palette.orange, palette.red, …
```

A **domain-named palette** names entries by what they're used for:

```
palette.code-stroke, palette.query-edge, palette.compute-fill, palette.error, …
```

Color-anchored palettes are the right default. The argument:

- **Diagrams differ in what they communicate.** A "code group is purple" mapping that fits one diagram suite imposes a wrong shape on the next one. Color-anchored palettes let each diagram pick its own hue assignment.
- **Domain names age badly.** When the system grows, "compute" might mean two different things in two diagrams. If the palette pre-assigned the meaning, you can't accommodate both.
- **Color-anchored palettes are interrogable.** A reader sees `fill: palette.blue.fill` in source and immediately knows the visual; with `fill: palette.compute-fill`, they have to look up what color "compute" resolved to today.

If you find yourself wanting a domain-named token, the right move is usually a **diagram-local closure** that wraps the color-anchored palette:

```typst
let _api(pos, name) = node(pos, name,
  fill: palette.blue.fill,
  stroke: tokens.stroke-default + palette.blue.stroke,
  ...
)
```

The diagram stays color-anchored at the palette level; the closure binds a domain to a hue at the diagram level, where it belongs.

## Per-hue structure: the four-attribute quad

Each chromatic hue exposes four colors:

| Attribute | Role |
|---|---|
| `stroke` | The hue's outline / border color. Highest contrast on the surface. |
| `fill` | A subtle background tinted in the hue. Low chroma, light value (light theme) or low value (dark theme). |
| `ink` | A high-contrast text color *within* the hue family, for use on top of `fill`. Restores chromatic harmony lost when labels are colored neutral over a tinted background. |
| `divider` | A tonal midpoint between `fill` and `stroke`. Use for horizontal rules and structural geometry inside a hue-filled shape so the divider stays in the hue family. |

Without `ink`, labels over a tinted fill end up neutral and visually disconnected from the surrounding hue. Without `divider`, internal rules either clash (neutral grey over a tinted fill) or vanish (same as fill). The four-attribute quad is the smallest set that supports both labeled, separated, multi-hue-tinted nodes.

**Use `ink` for accent text, not body text.** `ink` is calibrated for short, hue-coherent labels — kind annotations, category badges, single-word identifiers — where same-hue text reads as a stylistic accent. For longer body content over a hue fill (field grids, type listings, multi-line descriptions), prefer the global neutral `palette.ink` for higher contrast; same-hue text loses readability across a longer run.

## Constructor for the quad

A small helper keeps the quad consistent. The divider can be derived as a 50/50 mix of fill and stroke so authors don't have to pick a fourth value by hand:

```typst
#let _hue(stroke: black, fill: black, ink: black) = (
  stroke:  stroke,
  fill:    fill,
  ink:     ink,
  divider: color.mix((fill, 50%), (stroke, 50%)),
)
```

A theme then declares each hue by passing the three independent values:

```typst
blue: _hue(stroke: rgb("#0969DA"), fill: rgb("#DDF4FF"), ink: rgb("#033D8B")),
```

## Theme structure

A theme module exports the palette in two flavors keyed by an input:

```typst
#let theme-name = sys.inputs.at("theme", default: "light")

#let palette = if theme-name == "dark" {
  (
    // surfaces (neutral)
    surface:          rgb("#…"),
    surface-muted:    rgb("#…"),
    surface-raised:   rgb("#…"),
    surface-emphasis: rgb("#…"),

    // ink (neutral text)
    ink:        rgb("#…"),
    ink-muted:  rgb("#…"),
    ink-subtle: rgb("#…"),

    // borders
    border:       rgb("#…"),
    border-muted: rgb("#…"),

    // chromatic hues
    blue:    _hue(stroke: …, fill: …, ink: …),
    green:   _hue(stroke: …, fill: …, ink: …),
    // …
  )
} else {
  (
    // light-theme equivalents
    // …
  )
}
```

The neutrals (`surface*`, `ink*`, `border*`) carry the page itself; chromatic hues sit on top.

Compile with `--input theme=light` or `--input theme=dark`.

## Light/dark calibration

Light and dark themes invert the relationship between fill and stroke:

| Theme | `stroke` | `fill` | `ink` |
|---|---|---|---|
| Light | mid-saturation hue (~step .5) | very light tint (~step .0) | deep saturation (~step .7) |
| Dark | lighter hue (~step .4) | deep saturation (~step .9) | light tint (~step .2) |

The "step" notation refers to a hue ladder of 10 steps from lightest (.0) to darkest (.9), the convention used by GitHub Primer, GitLab Pajamas, and similar systems. Different palette sources use different ladders, but the inversion principle holds: dark-theme `fill` is the deep step, light-theme `fill` is the shallow step.

## Palette source: examples

Several established palette systems work as a source:

- **GitHub Primer** (primer.style) — eight chromatic hues (blue, green, yellow, orange, red, purple, pink, coral) plus neutrals. Each hue has a 10-step ladder. Color-anchored by design.
- **GitLab Pajamas** (design.gitlab.com) — similar structure with GitLab-specific hues (blue, green, orange, red, purple).
- **Radix Colors** (radix-ui.com/colors) — 12-step ladders with mathematically-validated contrast progression. Slightly different role naming (e.g., step 9/10 for solid colors).
- **Tailwind defaults** (tailwindcss.com) — 11-step ladders, broad hue coverage. Less surgically tuned for UI states than Primer/Pajamas.

Pick whichever source aligns with your project's broader brand. The pattern is identical; only the hex values change.

## Linking to source

When you pick a palette source, document it in the theme module's header so future readers can verify the values:

```typst
// ==============================================================
// Theme — color palette traced to <source name> primitives.
// <Source URL>
//
// Light mode: stroke = .5 (mid)   fill = .0 (subtle)  ink = .7 (deep)
// Dark mode:  stroke = .4         fill = .9           ink = .2
// ==============================================================
```

If you trace from a specific token namespace within the source (e.g., Primer's `primer/primitives base.color.<hue>.<step>`), name it explicitly. The trail back to the source is what makes the palette auditable.

## Universal link styling

Diagrams that include hyperlinks (in rendered output or surrounding documentation) need a consistent link visual. A two-signal convention — color + underline — keeps the affordance readable in both browser-default and accessibility contexts:

```typst
#show link: it => text(fill: palette.blue.stroke, underline(offset: 1.5pt, it))
```

Any hue is valid; blue matches the web convention.

## Palette and tokens are separate

The palette holds anything color-related: surfaces, text colors, borders, hue quads. Tokens are colorless; the palette is colored.

A value that combines both (e.g., a stroke spec like `1.2pt + palette.blue.stroke`) is constructed at point of use, since one component lives in tokens and the other in the palette.
