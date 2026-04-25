// ==============================================================
// Labels catalog — content patterns inside nodes. From the bare
// minimum (single string) through stacked title+kind, field lists,
// dividers, icon glyphs, math expressions, and mixed-style runs.
// Every section pins one mechanism the diagram author can reach for
// when a node needs more than just a name.
// ==============================================================
// render: static

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette, divider

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

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s)    = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s)          = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

// Inline code gets a hue tint to differentiate from prose under the
// single-font convention.
#show raw: r => text(fill: palette.purple.stroke, r)

// Body-content helpers used across sections.
#let _title(s) = text(size: tokens.size-body, weight: tokens.weight-bold, fill: palette.ink, s)
#let _kind(s, on-hue: palette.purple.ink) = text(size: tokens.size-label, weight: tokens.weight-light, fill: on-hue, style: "italic", "(" + s + ")")

// Default demo node — purple unless overridden via stroke-color/fill-color.
#let node-demo(body, stroke-color: palette.purple.stroke, fill-color: palette.purple.fill) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0), body,
    shape: fletcher.shapes.rect,
    fill: fill-color,
    stroke: tokens.stroke-default + stroke-color,
    inset: tokens.pad-inside-shape,
    corner-radius: tokens.radius-shape,
  ),
)

// ---- title -----------------------------------------------------------------

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Labels — content patterns inside nodes"),
)
#v(tokens.space-between-ranks)

// ---- SECTION A — single-line ----------------------------------------------

#section-title("A · single-line")
#v(tokens.gap-structured-text)
#note("The minimum. A plain string is content; it renders as-is.")
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("plain"), col-header("bold title"), col-header("code literal"),

  align(center + horizon, node-demo("planner")),
  align(center + horizon, node-demo(_title("planner"))),
  align(center + horizon, node-demo(raw("ChatService"))),
)

#v(tokens.space-between-ranks)

// ---- SECTION B — stacked (title + kind) -----------------------------------

#section-title("B · stacked — title + kind")
#v(tokens.gap-structured-text)
#note("Two-line pattern: prominent title, de-emphasised kind annotation below. The workhorse for most shape-bearing entities.")
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("purple group"), col-header("blue group"), col-header("orange group"),

  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Request"), _kind("structure", on-hue: palette.purple.ink)))),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("api"), _kind("compute", on-hue: palette.blue.ink)),
    stroke-color: palette.blue.stroke, fill-color: palette.blue.fill)),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("planner"), _kind("agent", on-hue: palette.orange.ink)),
    stroke-color: palette.orange.stroke, fill-color: palette.orange.fill)),
)

#v(tokens.space-between-ranks)

// ---- SECTION C — field list -----------------------------------------------

#section-title("C · field list (grid of name : type)")
#v(tokens.gap-structured-text)
#note([A node whose body is a grid — two columns, gutter set by `gap-cell`. `row-gutter: gap-structured-text` gives field rows breathing room.])
#v(tokens.space-between-shapes)

#align(center,
  node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Request"),
    _kind("structure", on-hue: palette.purple.ink),
    divider(),
    grid(columns: 2, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text * 2,
      raw("id"),       raw("UUID"),
      raw("messages"), raw("[]Message"),
      raw("model"),    raw("string"),
      raw("stream"),   raw("bool"),
    ),
  )),
)

#v(tokens.space-between-ranks)

// ---- SECTION D — divider --------------------------------------------------

#section-title("D · divider (header separator)")
#v(tokens.gap-structured-text)
#note("A horizontal rule between the title block and the body block. Echoes UML class notation without inheriting UML's verbosity.")
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Client"),
    _kind("interface", on-hue: palette.purple.ink),
    divider(),
    raw("Chat(ctx, req)"),
    raw("Vision(ctx, req)"),
    raw("Tools(ctx, req)"),
    raw("Close()"),
  ))),

  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("Role"),
    _kind("enum", on-hue: palette.purple.ink),
    divider(),
    text("SYSTEM"),
    text("USER"),
    text("ASSISTANT"),
    text("TOOL"),
  ))),
)

#v(tokens.space-between-ranks)

// ---- SECTION E — icon + label ---------------------------------------------

#section-title("E · icon + label")
#v(tokens.gap-structured-text)
#note([A Nerd Font glyph inline with the title, or floating as a corner badge. See `glyphs.typ` for the symbology inventory.])
#v(tokens.space-between-shapes)

// E1 — icon block on the left; matches the convention from shapes.typ.
#let icon-left(hue, glyph, title, kind) = diagram(
  spacing: (0pt, 0pt),
  node((0, 0),
    grid(columns: (auto, auto), column-gutter: 0pt, align: (left + horizon, left + horizon),
      block(fill: hue.stroke, inset: tokens.pad-inside-shape * 1.4,
        radius: (top-left: tokens.radius-shape, bottom-left: tokens.radius-shape),
        text(size: 22pt, fill: hue.fill, glyph)),
      block(inset: tokens.pad-inside-shape * 1.2,
        stack(dir: ttb, spacing: tokens.gap-structured-text,
          _title(title),
          _kind(kind, on-hue: hue.ink),
        ),
      ),
    ),
    shape: fletcher.shapes.rect,
    fill: hue.fill,
    stroke: tokens.stroke-default + hue.stroke,
    inset: 0pt,
    corner-radius: tokens.radius-shape,
  ),
)

// E2 — title with right-aligned badge glyph.
#let icon-right-badge(hue, glyph, title, kind) = node-demo(
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    grid(columns: (1fr, auto), column-gutter: tokens.gap-cell, align: (left + horizon, right + horizon),
      _title(title), text(size: tokens.size-body, fill: hue.stroke, glyph)),
    _kind(kind, on-hue: hue.ink),
  ),
  stroke-color: hue.stroke, fill-color: hue.fill,
)

// E3 — icon-as-identity, tiny label below.
#let icon-only(hue, glyph, label) = node-demo(
  stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: 22pt, fill: hue.stroke, glyph),
    text(size: tokens.size-label, fill: palette.ink-muted, label),
  ),
  stroke-color: hue.stroke, fill-color: hue.fill,
)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("icon-left"), col-header("icon-right badge"), col-header("icon only"),

  align(center + horizon, icon-left(palette.blue, "\u{F1C0}", "users", "persistence")),
  align(center + horizon, icon-right-badge(palette.blue, "\u{F0C2}", "api", "compute · cloud")),
  align(center + horizon, icon-only(palette.orange, "\u{F007}", "user")),
)

#v(tokens.space-between-ranks)

// ---- SECTION F — math -----------------------------------------------------

#section-title("F · math")
#v(tokens.gap-structured-text)
#note([Typst math mode `$ ... $` renders inside any content. Useful when a node represents a formula, capacity, or rate expression.])
#v(tokens.space-between-shapes)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: tokens.space-between-shapes,
  row-gutter: tokens.gap-cell,
  align: center + horizon,

  col-header("inline math"), col-header("rate expression"), col-header("summation"),

  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("batch"),
    $n = 64$,
    _kind("parameter", on-hue: palette.purple.ink),
  ))),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("throttle"),
    $r <= 100 "req/s"$,
    _kind("rate-limit", on-hue: palette.purple.ink),
  ))),
  align(center + horizon, node-demo(stack(dir: ttb, spacing: tokens.gap-structured-text,
    _title("cost"),
    $sum_(i=0)^n t_i$,
    _kind("aggregate", on-hue: palette.purple.ink),
  ))),
)

#v(tokens.space-between-ranks)

// ---- SECTION G — mixed runs -----------------------------------------------

#section-title("G · mixed runs")
#v(tokens.gap-structured-text)
#note([A single node combining text, code, and coloured runs. `row-gutter` keeps the field rows from crowding.])
#v(tokens.space-between-shapes)

#align(center,
  node-demo(
    stack(dir: ttb, spacing: tokens.gap-structured-text,
      _title("planner"),
      _kind("agent", on-hue: palette.orange.ink),
      divider(hue: palette.orange),
      grid(columns: 2, column-gutter: tokens.gap-cell, row-gutter: tokens.gap-structured-text * 2,
        text(fill: palette.ink-muted, "model:"),  raw("claude-sonnet-4.6"),
        text(fill: palette.ink-muted, "tools:"),  raw("web_search, execute_code"),
        text(fill: palette.ink-muted, "status:"), text(fill: palette.green.stroke, "\u{F00C} ready"),
      ),
    ),
    stroke-color: palette.orange.stroke, fill-color: palette.orange.fill,
  ),
)
