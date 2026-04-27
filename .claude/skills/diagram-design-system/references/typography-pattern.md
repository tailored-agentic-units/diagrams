# Typography pattern

A diagram design system uses **one font family** and expresses hierarchy through **weight and size**, not through font choice. This file covers the pattern, the rationale, and the additional concerns when the design system needs Nerd Font glyphs.

## One family carries the diagram

Mixing fonts to express hierarchy (a sans-serif for headings, a mono for code) is fragile and noisy:

- Different fonts have different metrics; spacing visibly shifts when the rendering host substitutes a fallback.
- Multi-font documents read more visually busy than they should — the reader's eye registers the family change as new information.
- Typst's font-finding looks up by name; if the system doesn't have your secondary family, it falls back silently, often to a different metric profile.

The reliable pattern: **one family**. The family carries everything — prose labels, code-style content via `raw()`, and (optionally) icon glyphs.

## Hierarchy via weight + size

A 5-step size scale plus 3 weights covers the typical diagram:

| Token | Pt range | Role |
|---|---|---|
| `size-label` | 8–10pt | kind annotations, footnotes, captions on small elements |
| `size-caption` | 9–11pt | container titles, metadata, notes |
| `size-body` | 10–12pt | default label text, field names, enum values |
| `size-title` | 12–14pt | entity names in bold |
| `size-heading` | 14–16pt | diagram titles |

Weights:

| Token | Value | Role |
|---|---|---|
| `weight-light` | "light" | de-emphasized annotations |
| `weight-body` | "regular" | default body text |
| `weight-bold` | "semibold" | titles and emphasis |

Most fonts ship "light", "regular", and "semibold" cuts that are visually distinct without being noisy. "Thin" is often unrenderable at small sizes; "black" reads as aggressive at body sizes.

The size-and-weight matrix gives 15 distinct visual roles. A typical diagram uses 5–7; using all 15 within one diagram fragments the visual hierarchy.

## Color hierarchy reinforces typography

Three levels of ink (`palette.ink`, `palette.ink-muted`, `palette.ink-subtle`) layered on top of the size-and-weight matrix gives smooth de-emphasis paths:

| Use | Size | Weight | Color |
|---|---|---|---|
| Primary entity name | `size-title` | `bold` | `palette.ink` |
| Kind annotation | `size-label` | `light` | `hue.ink` (chromatic) |
| Field row label | `size-body` | `regular` | `palette.ink-muted` |
| Field row value | `size-body` | `regular` | `palette.ink` |
| Caption / metadata | `size-caption` | `regular` | `palette.ink-muted` |

Italic style overlays orthogonally — useful for kind annotations, notes, instance counts.

## Font choice

The design system pattern doesn't lock a specific font. Common viable choices:

- **CaskaydiaMono NFP** — Nerd Font Patched Cascadia Mono. Proportional Nerd Font; ships glyphs in the Unicode Private Use Area; reads cleanly at body sizes. Patched variant required for glyphs.
- **Geist Mono NFP** — Vercel's Geist with Nerd Fonts patching. Slightly tighter metrics, modern feel.
- **JetBrains Mono NFP** — JetBrains' programmer-friendly monospace, patched. Very legible at small sizes.
- **Inter** — proportional sans, no glyphs. Use when you don't need Nerd Font symbology.
- **Atkinson Hyperlegible** — accessibility-focused proportional sans, no glyphs. Maximum legibility for low-vision readers.

Pick by:

1. **Glyph need.** If diagrams use icons inline with prose, you need a Nerd Font variant (see below).
2. **Metric coverage.** Does the font have light, regular, semibold cuts? If not, your weight scale collapses.
3. **Aesthetic alignment.** A diagram in a brutalist data-vis context wants different metrics than one in a friendly product context.

## Single-font tinting for code

When prose and code share the same font family, `raw()` content is visually indistinguishable from prose. A `show raw:` rule that applies a fill color tints code spans:

```typst
#show raw: r => text(fill: palette.accent.stroke, r)
```

The hue choice is per-diagram, not per-design-system — different diagrams can tint code differently based on their visual content.

## Nerd Font orientation

A **Nerd Font** is a font that has been **patched** to include thousands of icon glyphs in the Unicode Private Use Area (codepoints `\u{E000}` through `\u{F8FF}` and the supplementary range). The glyphs come from established icon sets — Font Awesome, Codicons, Octicons, Devicons, Material Icons, and others — combined into one font file. Project home: nerdfonts.com.

Why a Nerd Font, not just an icon font:

- **Inline composition.** Glyphs render in the same flow as prose text, with the same `size:`, `weight:`, and `fill:`. A label can be `"Δ users (db)"` with the Δ as a Nerd Font glyph and the rest as normal text.
- **Single-font convention.** If the diagram's design system uses one font family, that family must carry the glyphs too. Otherwise icons need a separate icon-font dependency, which breaks the single-font invariant.

When a Nerd Font is **required**:

- The design system uses inline glyphs (status indicators, infrastructure markers, brand badges, edge-kind decorations).
- Glyphs need to size and color the same way as text.

When a Nerd Font is **not required**:

- The design system uses no inline glyphs, or only uses them sparingly via a separate icon library / SVG sprite.
- The diagrams are pure shape + text + color.

If a Nerd Font is required, the design system's font token points at a patched variant. Distribution names typically suffix the variant kind (`NFP` for the proportional patch, `NF` for the standard patch):

```
font: "CaskaydiaMono NFP"
font: "Geist Mono NFP"
font: "JetBrains Mono NFP"
```

Glyphs are accessed via Unicode escape strings:

```typst
text(size: 14pt, fill: palette.blue.stroke, "\u{F015}")  // home
text(size: 14pt, fill: palette.blue.stroke, "\u{F0C2}")  // cloud
```

**Codepoint reference:** the Nerd Fonts cheat sheet (nerdfonts.com/cheat-sheet) and the Nerd Fonts wiki (github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points). The wiki is authoritative when codepoints disagree.

## Tracking (letter-spacing)

Default kerning works for most label sizes. Two cases benefit from explicit tracking:

- **All-caps captions.** Default kerning between capitals reads tight; `tracking: 0.05em` to `0.10em` opens it up.
- **Very small labels (≤8pt).** Slight tracking improves legibility; `tracking: 0.05em` is usually enough.

Tracking is a per-call adjustment. Encoding it as a token (e.g., `caption-tracking`) over-couples the token system to one use case.
