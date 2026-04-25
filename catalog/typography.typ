// ==============================================================
// Typography catalog — the text controls available to diagrams.
// Size scale, weight, style, decoration, tracking, color, and
// mixed-style runs. Source of truth for "what text can do" is
// Typst's #text() function and the tokens defined in design/.
// ==============================================================
// render: static

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

#let section-title(s) = text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink, s)
#let col-header(s) = text(size: tokens.size-caption, weight: tokens.weight-bold, fill: palette.ink-muted, upper(s))
#let note(s) = text(size: tokens.size-caption, fill: palette.ink-muted, style: "italic", s)

#align(center,
  text(size: tokens.size-heading, weight: tokens.weight-bold, fill: palette.ink,
    "Typography — what diagram text can do"),
)
#v(tokens.space-between-ranks)

// ---- SECTION A — size scale ------------------------------------------------

#section-title("A · size scale")
#v(tokens.gap-structured-text)
#note("Tokenised sizes. Labels → captions → body → titles → headings. Hierarchy via size + weight, never via family.")
#v(tokens.space-between-shapes)

#let sizes = (
  ("size-label",   tokens.size-label,   "kind annotations · (module) · (interface)"),
  ("size-caption", tokens.size-caption, "container titles · metadata · notes"),
  ("size-body",    tokens.size-body,    "default label text · field names · enum values"),
  ("size-title",   tokens.size-title,   "entity names in bold"),
  ("size-heading", tokens.size-heading, "diagram titles"),
)

#grid(
  columns: (auto, auto, 1fr, 2fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-cell,
  align: (left + horizon, right + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("pt"), col-header("sample"), col-header("usage"),

  ..sizes.map(((name, sz, use)) => (
    raw(name),
    raw(repr(sz)),
    text(size: sz, fill: palette.ink, "The quick brown fox jumps over the lazy dog"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION B — weight ----------------------------------------------------

#section-title("B · weight")
#v(tokens.gap-structured-text)
#note("Tokenised weights map to CaskaydiaMono NFP's available cuts. Weight emphasises within a size, not across.")
#v(tokens.space-between-shapes)

#let weights = (
  ("weight-light", tokens.weight-light, "de-emphasised annotations"),
  ("weight-body",  tokens.weight-body,  "default body text"),
  ("weight-bold",  tokens.weight-bold,  "titles and emphasis"),
)

#grid(
  columns: (auto, auto, 1fr, 2fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("value"), col-header("sample"), col-header("usage"),

  ..weights.map(((name, w, use)) => (
    raw(name),
    raw("\"" + w + "\""),
    text(size: tokens.size-body, weight: w, fill: palette.ink, "The quick brown fox"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION C — style + decoration ----------------------------------------

#section-title("C · style and decoration")
#v(tokens.gap-structured-text)
#note("Italic is a style; underline/overline/strike are decorations. Highlight is a filled background behind the run.")
#v(tokens.space-between-shapes)

#let samples = (
  ("plain",      [The quick brown fox]),
  ("italic",     text(style: "italic", [The quick brown fox])),
  ("bold",       text(weight: "semibold", [The quick brown fox])),
  ("bold italic", text(weight: "semibold", style: "italic", [The quick brown fox])),
  ("underline",  underline([The quick brown fox])),
  ("overline",   overline([The quick brown fox])),
  ("strike",     strike([The quick brown fox])),
  ("highlight",  highlight(fill: palette.blue.fill, [The quick brown fox])),
  ("colored",    text(fill: palette.red.stroke, [The quick brown fox])),
)

#grid(
  columns: (auto, 1fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon),

  col-header("style"), col-header("sample"),

  ..samples.map(((name, s)) => (
    raw(name),
    s,
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION D — tracking --------------------------------------------------

#section-title("D · tracking (letter-spacing)")
#v(tokens.gap-structured-text)
#note("Useful for all-caps captions and small label text where default kerning reads too tight.")
#v(tokens.space-between-shapes)

#let trackings = (
  ("0em",     0em),
  ("0.05em",  0.05em),
  ("0.10em",  0.10em),
  ("0.20em",  0.20em),
)

#grid(
  columns: (auto, 1fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon),

  col-header("tracking"), col-header("sample"),

  ..trackings.map(((label, t)) => (
    raw(label),
    text(size: tokens.size-body, tracking: t, upper("diagram caption example")),
  )).flatten()
)

#v(tokens.space-between-ranks)

// ---- SECTION E — mixed-style runs ------------------------------------------

#section-title("E · mixed-style runs")
#v(tokens.gap-structured-text)
#note("Compose multiple styles within a single text run — Typst's content model handles inline switches cleanly.")
#v(tokens.space-between-shapes)

#stack(dir: ttb, spacing: tokens.gap-structured-text * 2,
  [Regular text with #text(weight: "semibold")[a bold word] and #text(style: "italic")[an italic phrase].],
  [Code inside prose: call #raw("Client.Chat(ctx, req)") on the client.],
  [Inline math: the sum #text(fill: palette.green.stroke)[$sum_(i=0)^n i = n(n+1)/2$] in continuous flow.],
  [Icon + label: #text(fill: palette.blue.stroke, "\u{F015}")  home-hosted · #text(fill: palette.blue.stroke, "\u{F0C2}")  cloud-hosted.],
  [Decorated run: we've #strike[dropped] #underline[added] this capability.],
)

#v(tokens.space-between-ranks)

// ---- SECTION F — raw (code) ------------------------------------------------

#section-title("F · raw / code blocks")
#v(tokens.gap-structured-text)
#note("Single font means raw() visually matches prose text. Use raw for semantic correctness, not visual differentiation.")
#v(tokens.space-between-shapes)

#stack(dir: ttb, spacing: tokens.gap-structured-text * 2,
  [Inline raw: #raw("fletcher.shapes.hexagon") appears identical-weight to prose.],
  block(
    fill: palette.surface-muted,
    inset: tokens.pad-inside-shape,
    radius: tokens.radius-shape,
    raw(lang: "go", "func (c *Client) Chat(ctx context.Context, req *Request) (*Response, error) {\n    return c.do(ctx, req)\n}"),
  ),
)

#v(tokens.space-between-ranks)

// ---- SECTION G — color hierarchy -------------------------------------------

#section-title("G · color hierarchy")
#v(tokens.gap-structured-text)
#note("palette.ink / ink-muted / ink-subtle carry 3 levels of prominence within the same weight.")
#v(tokens.space-between-shapes)

#let inks = (
  ("palette.ink",        palette.ink,        "primary — titles, body, must-read"),
  ("palette.ink-muted",  palette.ink-muted,  "secondary — captions, metadata"),
  ("palette.ink-subtle", palette.ink-subtle, "tertiary — de-emphasis, placeholders"),
)

#grid(
  columns: (auto, 1fr, 2fr),
  column-gutter: tokens.gap-cell,
  row-gutter: tokens.gap-structured-text * 2,
  align: (left + horizon, left + horizon, left + horizon),

  col-header("token"), col-header("sample"), col-header("usage"),

  ..inks.map(((name, c, use)) => (
    raw(name),
    text(size: tokens.size-body, fill: c, "The quick brown fox jumps over"),
    text(size: tokens.size-label, fill: palette.ink-muted, style: "italic", use),
  )).flatten()
)
