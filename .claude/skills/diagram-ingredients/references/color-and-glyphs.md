# Color and glyphs

Two ingredient categories that work closely together: chromatic hues (and their four-attribute quad) and Nerd Font glyphs (and the four ways to compose them into a diagram).

## Hue selection

Each chromatic hue exposes four attributes that work together:

| Attribute | Role |
|---|---|
| `stroke` | outline / border color |
| `fill` | subtle tinted background behind a label |
| `ink` | high-contrast text color in the hue family, for use on top of `fill` |
| `divider` | tonal midpoint between fill and stroke, for inner rules and structural geometry |

A diagram chooses hues based on what its content visually needs to differentiate. Two collapses to avoid:

- The same hue used twice for unrelated meanings within one diagram (the visual collapses; readers cannot distinguish).
- Hue assignment locked in by the palette structure (the palette is color-anchored, so each diagram makes its own assignments).

Common patterns the visual differentiation supports:

- **Ordered state** — when states carry intrinsic ordering (success → warning → danger), an ordered hue progression (green → yellow → red) makes the ordering legible.
- **Group differentiation** — when entities cluster into kinds, one hue per kind gives all members of a group shared visual identity.
- **Edge classification** — when relationships split into kinds, edge hue differentiates kinds at a glance.

Two diagrams in the same project can use different hue assignments without conflict.

## Reading the four-attribute quad

A hue-filled, hue-stroked node with chromatic ink reads as a single coherent visual:

```
┌────────────────────┐
│ Title              │  ← palette.ink (neutral)
│ (kind)             │  ← hue.ink (chromatic, lower contrast)
│ ──────────────     │  ← divider in hue family
│ field    : value   │  ← palette.ink-muted / palette.ink
└────────────────────┘
   ^                ^
   stroke = hue.stroke
   fill = hue.fill
```

The `ink` attribute is what keeps kind labels from looking neutrally disconnected from the surrounding hue. Without it, all secondary text drops to neutral grey and the visual cohesion of "this is a blue group" weakens.

## Hue ladder reading (light theme)

If your design system traces a 10-step hue ladder (the GitHub Primer convention, similar in GitLab Pajamas / Tailwind / Radix), the typical attribute placement on the ladder:

| Attribute | Step | Why |
|---|---|---|
| `fill` | .0 | very light tint — supports body text on top |
| `stroke` | .5 | mid-saturation — clear outline against neutral surface |
| `ink` | .7 | deeper saturation — readable text on a `fill` from same hue |

Dark theme inverts: `fill` is the deep step, `ink` is the light step.

## Common hue assignments (illustrative — not rules)

The mappings below are project choices that recur across diagram families. They are reference points, not prescriptions; any diagram is free to remap.

**Severity ladder:**

| Hue | Reading |
|---|---|
| `blue` | accent / informational |
| `green` | success / completed |
| `yellow` | attention / caution |
| `orange` | severe / elevated concern |
| `red` | danger / blocking |

**Pipeline status:**

| Hue | Reading |
|---|---|
| `green` | passing / build ok |
| `yellow` | pending / running |
| `red` | failing / build broken |
| `neutral` | unknown / no signal yet |

**Group (entity class) mappings — example:**

| Hue | Group |
|---|---|
| `purple` | code / module |
| `blue` | service / compute |
| `orange` | operator / human |
| `coral` | infrastructure |
| `green` | data / persistence |

**Edge-kind mappings — example:**

| Hue | Edge kind |
|---|---|
| `green` | query (read) |
| `red` | command (mutate) |
| `yellow`, `dashed` | event |
| `blue` | data flow |

## Inline link styling

Diagrams that include hyperlinks use a two-signal convention — color + underline — so the link reads as a link in both browser-rendered and accessibility contexts:

```typst
#show link: it => text(fill: palette.blue.stroke, underline(offset: 1.5pt, it))
```

Any hue is valid; blue matches the web convention.

## Nerd Font glyphs

A Nerd Font is a **patched** version of a programming font: the original font carries Latin and code glyphs at the standard codepoints, and the patcher overlays icon glyphs from a curated set of source fonts into the Unicode Private Use Area at well-defined codepoint ranges. CaskaydiaMono NFP (the project font) carries all 13 patched ranges; the same icons render identically in any Nerd Font (FiraCode NF, JetBrainsMono NF, Hack NF, …) because the patcher targets the same codepoints.

Glyphs are accessed via Unicode escape strings — they're ordinary text under the hood, so they size, color, and compose the same way any other text does:

```typst
text(size: 14pt, fill: palette.blue.stroke, "\u{F015}")  // home (Font Awesome)
text(size: 14pt, fill: palette.green.stroke, "\u{F408}")  // git-merge (Octicons)
```

**Codepoint reference:** the [Nerd Fonts cheat sheet](https://www.nerdfonts.com/cheat-sheet) (visual search) and the [Nerd Fonts wiki — Glyph Sets and Code Points](https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points) (authoritative source ranges). The wiki is authoritative when codepoints disagree.

## The 13 glyph sources

A Nerd Font patches in 13 source fonts. Each has a distinct visual style and best-fit role. Knowing which source a glyph comes from helps you reason about visual consistency: glyphs from the same source share a stroke weight, optical alignment, and silhouette discipline.

| Source | Code range | Count | Best for |
|---|---|---|---|
| Seti-UI + Custom | U+E5FA – U+E6B7 | ~190 | File-type and editor-sidebar icons |
| Devicons | U+E700 – U+E8EF | ~495 | Programming languages and frameworks |
| Pomicons | U+E000 – U+E00A | ~8 | Pomodoro / focus-session indicators |
| Powerline Symbols | U+E0A0 – U+E0B3 | ~6 | Shell prompt separators |
| Powerline Extra | U+E0A3 – U+E0D7 | ~50 | Extended prompt separators / fillers |
| IEC Power Symbols | U+23FB–U+23FE, U+2B58 | ~5 | Power state, electrical |
| Font Awesome Extension | U+E200 – U+E2A9 | ~170 | Supplementary FA glyphs |
| Weather Icons | U+E300 – U+E3E3 | ~215 | Weather, atmospheric conditions |
| Font Logos (Linux Mono) | U+F300 – U+F381 | ~130 | Linux distros, OSS project marks |
| Octicons | U+F400 – U+F533 | ~200+ | GitHub, version-control operations |
| Material Design Icons | U+F500 – U+FD46 | ~6000+ | Comprehensive general-purpose |
| Font Awesome | U+ED00 – U+F2FF | ~1000+ | UI, social, brands, general |
| Codicons | U+EA60 – U+EC1E | ~450+ | VS Code interface, dev environment |

Total: ~10,000+ glyphs. Names of specific glyphs are typically prefixed in the cheat sheet by source — `nf-fa-home` (Font Awesome), `nf-cod-debug-start` (Codicons), `nf-md-kubernetes` (Material Design), `nf-dev-python` (Devicons), etc.

## Useful glyph families

Glyphs cluster into recognizable families by semantic role. The catalog below names representative codepoints per family; see the wiki for the full inventory of each source.

### Status (Font Awesome + Codicons)

Pass / fail / pending / info — the four axes of an operational state readout.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F00C}` | check | Font Awesome |
| `\u{F00D}` | close / xmark | Font Awesome |
| `\u{F071}` | warning triangle | Font Awesome |
| `\u{F05A}` | info circle | Font Awesome |
| `\u{F059}` | question circle | Font Awesome |
| `\u{F188}` | bug | Font Awesome |
| `\u{F12A}` | exclamation | Font Awesome |
| `\u{F05E}` | ban / blocked | Font Awesome |
| `\u{EAB2}` | pass (filled circle-check) | Codicons |
| `\u{EA6C}` | error | Codicons |
| `\u{EBE6}` | warning | Codicons |
| `\u{EA74}` | issues | Codicons |

### Actions (Font Awesome + Codicons)

Verbs. Useful as icons along process edges or inside action nodes.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F04B}` | play | Font Awesome |
| `\u{F04C}` | pause | Font Awesome |
| `\u{F04D}` | stop | Font Awesome |
| `\u{F021}` | refresh | Font Awesome |
| `\u{F093}` | upload | Font Awesome |
| `\u{F019}` | download | Font Awesome |
| `\u{F1F8}` | trash | Font Awesome |
| `\u{F044}` | edit | Font Awesome |
| `\u{EB9B}` | run-all | Codicons |
| `\u{EAFC}` | debug-start | Codicons |
| `\u{EB52}` | save | Codicons |

### Infrastructure (Font Awesome + Material Design)

Where things run. Useful inside compute / persistence / network nodes to indicate hosting.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F015}` | home | Font Awesome |
| `\u{F0C2}` | cloud | Font Awesome |
| `\u{F233}` | server | Font Awesome |
| `\u{F1C0}` | database | Font Awesome |
| `\u{F120}` | terminal | Font Awesome |
| `\u{F0AC}` | globe | Font Awesome |
| `\u{F0E7}` | bolt / lightning | Font Awesome |
| `\u{F1EB}` | wifi | Font Awesome |
| `\u{F10FE}` | kubernetes | Material Design |
| `\u{F0868}` | server-network | Material Design |
| `\u{F0A0}` | hard-drive | Font Awesome |

### People + communication (Font Awesome)

Operators and messaging.

| Codepoint | Name |
|---|---|
| `\u{F007}` | user |
| `\u{F0C0}` | users (group) |
| `\u{F075}` | comment |
| `\u{F0E6}` | comments |
| `\u{F003}` | envelope |
| `\u{F002}` | search |
| `\u{F0F3}` | bell |
| `\u{F095}` | phone |

### Files + artifacts (Font Awesome + Seti-UI)

Generic file structure (folders, files, archives) plus Seti-UI's editor-sidebar file-type icons (which a programmer recognizes as "the icon next to .json in VS Code's tree").

| Codepoint | Name | Source |
|---|---|---|
| `\u{F07B}` | folder | Font Awesome |
| `\u{F07C}` | folder-open | Font Awesome |
| `\u{F15B}` | file | Font Awesome |
| `\u{F15C}` | file-text | Font Awesome |
| `\u{F1C6}` | archive | Font Awesome |
| `\u{E60B}` | json | Seti-UI |
| `\u{E627}` | yaml | Seti-UI |
| `\u{E609}` | markdown | Seti-UI |
| `\u{E650}` | docker | Seti-UI |
| `\u{E60D}` | html | Seti-UI |

### Control + security (Font Awesome + Codicons)

Locks, keys, settings — for authentication boundaries and configuration.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F023}` | lock | Font Awesome |
| `\u{F09C}` | unlock | Font Awesome |
| `\u{F084}` | key | Font Awesome |
| `\u{F013}` | cog (settings) | Font Awesome |
| `\u{F085}` | cogs | Font Awesome |
| `\u{F132}` | shield | Font Awesome |
| `\u{F06E}` | eye (visible) | Font Awesome |
| `\u{F070}` | eye-slash (hidden) | Font Awesome |
| `\u{EB51}` | shield (Codicons) | Codicons |
| `\u{EB6E}` | gear | Codicons |

### Relationships + flow (Font Awesome + Octicons)

Linkage, branching, versioning. Pairs naturally with edge glyphs.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F0C1}` | link | Font Awesome |
| `\u{F126}` | code-branch | Font Awesome |
| `\u{F0C5}` | copy | Font Awesome |
| `\u{F074}` | shuffle | Font Awesome |
| `\u{F079}` | retweet | Font Awesome |
| `\u{F1E0}` | share | Font Awesome |
| `\u{F061}` | arrow-right | Font Awesome |
| `\u{F063}` | arrow-down | Font Awesome |
| `\u{F417}` | git-pull-request | Octicons |
| `\u{F407}` | git-merge | Octicons |

### Languages (Devicons)

Programming language marks. Devicons is the canonical source for "which language?" identification — every common language has a recognizable mark.

| Codepoint | Name |
|---|---|
| `\u{E73C}` | python |
| `\u{E626}` | go |
| `\u{E7A8}` | rust |
| `\u{E60C}` | typescript |
| `\u{E74E}` | javascript |
| `\u{E791}` | ruby |
| `\u{E738}` | java |
| `\u{E61D}` | c |
| `\u{E61E}` | c++ (cplusplus) |
| `\u{E635}` | swift |
| `\u{E64C}` | kotlin |
| `\u{E763}` | css |
| `\u{E614}` | sass |
| `\u{E73E}` | php |

### Frameworks and tools (Devicons + Material Design)

Web frameworks, databases, infra tools, message queues. The most-touched names; the wiki carries the long tail.

| Codepoint | Name | Source |
|---|---|---|
| `\u{E7BA}` | react | Devicons |
| `\u{E7BD}` | vue | Devicons |
| `\u{E753}` | angular | Devicons |
| `\u{E71D}` | django | Devicons |
| `\u{E73D}` | rails | Devicons |
| `\u{E7B0}` | nodejs | Devicons |
| `\u{E7B1}` | express | Devicons |
| `\u{E76E}` | docker | Devicons |
| `\u{E7B6}` | postgres | Devicons |
| `\u{E704}` | mongodb | Devicons |
| `\u{E76D}` | redis | Devicons |
| `\u{F10FE}` | kubernetes | Material Design |
| `\u{E70F}` | terraform | Devicons |

### Linux distros (Font Logos)

Distribution marks. Useful when a diagram references an OS / runtime environment.

| Codepoint | Name |
|---|---|
| `\u{F303}` | arch |
| `\u{F31B}` | ubuntu |
| `\u{F306}` | debian |
| `\u{F30A}` | fedora |
| `\u{F300}` | alpine |
| `\u{F313}` | nixos |
| `\u{F304}` | centos |
| `\u{F30D}` | gentoo |
| `\u{F312}` | manjaro |
| `\u{F31A}` | tux (linux generic) |

### Source control (Octicons + Codicons)

Git / GitHub operations. Octicons is the canonical source for VCS semantics.

| Codepoint | Name | Source |
|---|---|---|
| `\u{F401}` | repo | Octicons |
| `\u{F403}` | git-branch | Octicons |
| `\u{F407}` | git-merge | Octicons |
| `\u{F408}` | git-pull-request | Octicons |
| `\u{F417}` | git-commit | Octicons |
| `\u{F41B}` | issue-opened | Octicons |
| `\u{F41C}` | issue-closed | Octicons |
| `\u{F41E}` | git-compare (diff) | Octicons |
| `\u{F424}` | git-fork | Octicons |
| `\u{EAFC}` | source-control | Codicons |
| `\u{EAFE}` | git-pull-request (codicons) | Codicons |

### Dev environment (Codicons)

VS Code's UI vocabulary — debug, terminal, output, problem, breakpoint, source-control. Codicons is the canonical source for IDE semantics.

| Codepoint | Name |
|---|---|
| `\u{EAFC}` | debug-start |
| `\u{EAD8}` | breakpoint |
| `\u{EB12}` | output |
| `\u{EBA9}` | terminal-bash |
| `\u{EA74}` | issues |
| `\u{EB81}` | extensions |
| `\u{EA72}` | search |
| `\u{EB6E}` | settings-gear |
| `\u{EB85}` | symbol-class |
| `\u{EA8B}` | symbol-method |

### Brand marks (Font Awesome)

Companies and services not covered by Devicons / Font Logos.

| Codepoint | Name |
|---|---|
| `\u{F09B}` | github |
| `\u{F296}` | gitlab |
| `\u{F1D3}` | git |
| `\u{F308}` | docker |
| `\u{F17C}` | linux |
| `\u{F179}` | apple |
| `\u{F17A}` | windows |
| `\u{F17B}` | android |
| `\u{F2B3}` | firefox-browser |
| `\u{F268}` | chrome |

### Weather (Weather Icons)

Atmospheric conditions, forecasts. Useful in environmental / IoT / climate diagrams.

| Codepoint | Name |
|---|---|
| `\u{E30D}` | day-sunny |
| `\u{E302}` | day-cloudy |
| `\u{E318}` | rain |
| `\u{E31A}` | snow |
| `\u{E300}` | thunderstorm |
| `\u{E33D}` | cloudy-windy |
| `\u{E336}` | thermometer |
| `\u{E373}` | umbrella |
| `\u{E33E}` | fog |
| `\u{E32B}` | sunrise |

### Shell-prompt typography (Powerline + Powerline Extra)

Separator and divider geometry for terminal prompts and shell-style framing. The canonical Powerline glyphs are pure shape primitives — useful as connector chevrons in flow diagrams or as section dividers in terminal-style mockups.

| Codepoint | Name | Source |
|---|---|---|
| `\u{E0B0}` | right-triangle (solid) | Powerline |
| `\u{E0B1}` | right-triangle (line) | Powerline |
| `\u{E0B2}` | left-triangle (solid) | Powerline |
| `\u{E0B3}` | left-triangle (line) | Powerline |
| `\u{E0A0}` | branch | Powerline |
| `\u{E0A2}` | lock | Powerline |
| `\u{E0B4}` | right-half-circle (solid) | Powerline Extra |
| `\u{E0B6}` | left-half-circle (solid) | Powerline Extra |
| `\u{E0BC}` | upper-right-triangle | Powerline Extra |
| `\u{E0BE}` | lower-right-triangle | Powerline Extra |

### Power and session (IEC Power Symbols + Pomicons)

Power state (the universal on/off/standby vocabulary) and Pomodoro session indicators (focus / break cycles). Tiny inventories, distinct visual identity.

| Codepoint | Name | Source |
|---|---|---|
| `\u{23FB}` | power | IEC Power |
| `\u{23FC}` | power-on (line) | IEC Power |
| `\u{23FD}` | power-on (solid) | IEC Power |
| `\u{23FE}` | sleep | IEC Power |
| `\u{2B58}` | power-off (heavy circle) | IEC Power |
| `\u{E000}` | pomodoro-done | Pomicons |
| `\u{E002}` | pomodoro-estimated | Pomicons |
| `\u{E003}` | pomodoro-squashed | Pomicons |
| `\u{E005}` | pomodoro-ticking | Pomicons |

The above entries are curated subsets, not complete inventories. The wiki is the authoritative source for any glyph not listed here.

## Composition patterns

Four ways a glyph enters a diagram. The glyph is ordinary text; these patterns are placement choices.

### In-label

A glyph next to text inside the node body:

```typst
node((0, 0),
  grid(columns: (auto, auto), column-gutter: gap-cell, align: (left + horizon, left + horizon),
    text(size: 18pt, fill: hue.stroke, glyph),
    stack(dir: ttb, spacing: gap-structured-text,
      text(weight: "bold", "users"),
      text(style: "italic", fill: hue.ink, "(persistence)"),
    ),
  ),
  shape: fletcher.shapes.rect,
  fill: hue.fill,
  stroke: stroke-default + hue.stroke,
)
```

Glyph sized larger than body text (e.g., `size-body × 1.5`) so it reads as the visual anchor of the node.

### Corner badge

A glyph aligned to one corner alongside the title:

```typst
grid(columns: (1fr, auto), column-gutter: gap-cell, align: (left + horizon, right + horizon),
  text(weight: "bold", "api"),
  text(fill: hue.stroke, glyph),
)
```

The glyph adds a state or kind hint without claiming the central visual position.

### Standalone

The glyph *is* the node — no text above the glyph; tiny label below:

```typst
node((0, 0),
  align(center + horizon, stack(dir: ttb, spacing: gap-structured-text,
    text(size: 26pt, fill: hue.stroke, glyph),
    text(size: size-label, fill: hue.ink, "user"),
  )),
  shape: fletcher.shapes.pill,
  fill: hue.fill,
  stroke: stroke-default + hue.stroke,
)
```

The glyph carries the node identity; the small label captions it. Reads as actor / human / brand entity at a glance.

### Edge marker

A glyph inside an edge label:

```typst
edge((0, 0), (1, 0), "->",
  stroke: stroke-default + hue.stroke,
  label-fill: palette.surface,
  text(weight: "bold", text(fill: hue.stroke, "\u{F023} ") + "authorised"),
)
```

The glyph colors the edge-label text, marking a category (authorisation, encryption, async) without lengthening the label.
