# Color and glyphs

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-dark.svg">
  <img src="./readme-light.svg" alt="color and glyphs — four hue-tinted cards each carrying a different glyph + label" width="100%">
</picture>

Two ingredient categories that work closely together: chromatic hues (and their four-attribute quad) and Nerd Font glyphs (and the four ways to compose them into a diagram). A diagram chooses a hue for what its content needs to differentiate, then glyphs add semantic identity inside the chromatic frame.

## Color

The palette is **color-anchored**: hues are named (`blue`, `green`, `orange`, …), not function-named (`palette.success`, `palette.error`). Each diagram makes its own hue → meaning assignment based on what it needs to communicate.

### Hue ladders

The Primer 10-step ladder is the source data behind the four-attribute quad each hue exposes (`stroke`, `fill`, `ink`, `divider`). Steps 0-1 supply subtle fills; step 5 supplies the canonical stroke; step 7 supplies the deep ink for chromatic text on tinted fills.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./hue-ladders-dark.svg">
  <img src="./hue-ladders-light.svg" alt="hue ladders — neutral plus eight chromatic hues, each across 10 steps" width="100%">
</picture>

### Semantic groups

Hues can carry meaning within a visualization group. Two illustrative ladders: severity (blue → green → yellow → orange → red, ordered by escalating concern) and pipeline status (green/yellow/red/neutral mapped to passing/pending/failing/unknown).

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./semantic-groups-dark.svg">
  <img src="./semantic-groups-light.svg" alt="semantic groups — severity ladder and pipeline status mapping" width="100%">
</picture>

### Example assignments

Group → hue and edge-kind → hue mappings. These are reference points, not rules — any diagram is free to remap based on its content.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./example-assignments-dark.svg">
  <img src="./example-assignments-light.svg" alt="example assignments — entity classes and edge kinds mapped to hues" width="100%">
</picture>

## Glyphs

A Nerd Font is a **patched** font: original Latin/code glyphs at standard codepoints, plus icon glyphs from 13 source fonts overlaid into the Unicode Private Use Area. CaskaydiaMono NFP carries all 13 patched ranges. Glyphs are ordinary text — they size, color, and compose like any other text.

### Glyph sources

The 13 source families a Nerd Font patches in. Knowing which source a glyph comes from helps reason about visual consistency: glyphs from the same source share stroke weight, optical alignment, and silhouette discipline.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./glyph-sources-dark.svg">
  <img src="./glyph-sources-light.svg" alt="glyph sources — 13 Nerd Font source families with code ranges and best-for descriptions" width="100%">
</picture>

### Composition patterns

Four placement patterns for a glyph entering a diagram. The glyph is ordinary text under the hood — these patterns are layout choices, not separate types.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./composition-patterns-dark.svg">
  <img src="./composition-patterns-light.svg" alt="composition patterns — in-label, corner badge, standalone, edge marker" width="100%">
</picture>

### Status icons (Font Awesome + Codicons)

Pass / fail / pending / info — the four axes of an operational state readout.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./status-icons-dark.svg">
  <img src="./status-icons-light.svg" alt="status icons — check, close, warning, info, question, bug, alert, ban, pass, error, warning, issues" width="100%">
</picture>

### Action icons (Font Awesome + Codicons)

Verbs. Useful as icons along process edges or inside action nodes.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./action-icons-dark.svg">
  <img src="./action-icons-light.svg" alt="action icons — play, pause, stop, refresh, upload, download, trash, edit, run-all, debug-start, save" width="100%">
</picture>

### Infrastructure icons (Font Awesome + Material Design)

Where things run. Useful inside compute / persistence / network nodes to indicate hosting.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./infrastructure-icons-dark.svg">
  <img src="./infrastructure-icons-light.svg" alt="infrastructure icons — home, cloud, server, database, terminal, globe, bolt, wifi, hard-drive, kubernetes, server-net" width="100%">
</picture>

### People and communication (Font Awesome)

Operators and messaging.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./people-communication-dark.svg">
  <img src="./people-communication-light.svg" alt="people and communication — user, users, comment, comments, envelope, search, bell, phone" width="100%">
</picture>

### Files and artifacts (Font Awesome + Seti-UI)

Generic file structure (folders, files, archives) plus Seti-UI's editor-sidebar file-type icons.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./files-artifacts-dark.svg">
  <img src="./files-artifacts-light.svg" alt="files and artifacts — folder, file variants, archive, json, yaml, markdown, docker, html" width="100%">
</picture>

### Control and security (Font Awesome + Codicons)

Locks, keys, settings — for authentication boundaries and configuration.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./control-security-dark.svg">
  <img src="./control-security-light.svg" alt="control and security — lock, unlock, key, cog, cogs, shield, eye, eye-slash, codicon shield, gear" width="100%">
</picture>

### Relationships and flow (Font Awesome + Octicons)

Linkage, branching, versioning. Pairs naturally with edge glyphs.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./relationships-flow-dark.svg">
  <img src="./relationships-flow-light.svg" alt="relationships and flow — link, branch, copy, shuffle, retweet, share, arrow-right, arrow-down, pull-request, merge" width="100%">
</picture>

### Brand marks (Font Awesome)

Companies and services not covered by Devicons / Font Logos.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./brand-marks-dark.svg">
  <img src="./brand-marks-light.svg" alt="brand marks — github, gitlab, git, docker, linux, apple, windows, android, firefox, chrome" width="100%">
</picture>

### Programming languages (Devicons)

Devicons is the canonical source for "which language?" identification — every common language has a recognizable mark.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./languages-dark.svg">
  <img src="./languages-light.svg" alt="programming languages — python, go, rust, typescript, javascript, ruby, java, c, c++, swift, kotlin, css, sass, php" width="100%">
</picture>

### Frameworks and tools (Devicons + Material Design)

Web frameworks, databases, infra tools, message queues. The most-touched names; the wiki carries the long tail.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./frameworks-and-tools-dark.svg">
  <img src="./frameworks-and-tools-light.svg" alt="frameworks and tools — react, vue, angular, django, rails, nodejs, express, docker, postgres, mongodb, redis, kubernetes, terraform" width="100%">
</picture>

### Linux distros (Font Logos)

Distribution marks. Useful when a diagram references an OS / runtime environment.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./distros-dark.svg">
  <img src="./distros-light.svg" alt="Linux distros — arch, ubuntu, debian, fedora, alpine, nixos, centos, gentoo, manjaro, tux" width="100%">
</picture>

### Source control (Octicons + Codicons)

Git / GitHub operations. Octicons is the canonical source for VCS semantics.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./source-control-dark.svg">
  <img src="./source-control-light.svg" alt="source control — repo, branch, merge, pull-request, commit, issue-open, issue-closed, diff, fork" width="100%">
</picture>

### Dev environment (Codicons)

VS Code's UI vocabulary — debug, terminal, output, problem, breakpoint, source-control. Codicons is the canonical source for IDE semantics.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./dev-environment-dark.svg">
  <img src="./dev-environment-light.svg" alt="dev environment — debug-start, breakpoint, output, terminal-bash, issues, extensions, search, settings-gear, symbol-class, symbol-method" width="100%">
</picture>

### Weather (Weather Icons)

Atmospheric conditions, forecasts. Useful in environmental / IoT / climate diagrams.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./weather-dark.svg">
  <img src="./weather-light.svg" alt="weather — day-sunny, day-cloudy, rain, snow, thunderstorm, cloudy-windy, thermometer, umbrella, fog, sunrise" width="100%">
</picture>

### Shell prompt (Powerline + Powerline Extra)

Separator and divider geometry for terminal prompts and shell-style framing. Useful as connector chevrons in flow diagrams or section dividers in terminal-style mockups.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./shell-prompt-dark.svg">
  <img src="./shell-prompt-light.svg" alt="shell prompt — Powerline triangles and half-circles for separators" width="100%">
</picture>

### Power and session (IEC Power Symbols + Pomicons)

Power state (the universal on/off/standby vocabulary) and Pomodoro session indicators (focus / break cycles). Tiny inventories with distinct visual identity.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./power-and-session-dark.svg">
  <img src="./power-and-session-light.svg" alt="power and session — IEC power symbols and Pomodoro indicators" width="100%">
</picture>
