# Typst idioms

Composition primitives and content-model patterns that come up when writing diagram source.

## Content as a value

Typst content is a first-class value. Anywhere a parameter expects content (a node body, an edge label, a function argument), you can pass any expression that evaluates to content — including the result of `text(...)`, `stack(...)`, `grid(...)`, `box(...)`, `block(...)`, `align(...)`, `raw(...)`, math `$...$`, or a literal `[...]` block.

This means a node body isn't restricted to a string. Anything works:

```typst
node((0, 0),
  stack(dir: ttb, spacing: 5pt,
    text(weight: "bold", "Title"),
    text(style: "italic", "(kind)"),
  ),
  shape: fletcher.shapes.rect,
)
```

## `stack` vs `grid` vs `block`

| Primitive | Use for |
|---|---|
| `stack(dir: ttb, spacing: <gap>, a, b, c)` | Vertical (or horizontal) sequence of items with a uniform gap. The default for two-line "title + kind" labels and field rows. |
| `grid(columns: ..., column-gutter: ..., row-gutter: ..., ...)` | 2D layout with explicit column widths and gutters. Use for field tables, named-value pairs, anything tabular. |
| `block(width: ..., inset: ..., fill: ..., ...)` | A boxed region with padding / fill / radius. Useful inside composite shapes for header bars and side panels. |
| `box(...)` | Inline-mode equivalent of `block`. Constrains a region to fixed dimensions; the foundation of the self-loop workaround. |
| `place(<alignment>, <content>)` | Position content at a relative anchor (`top + right`, etc.) without participating in layout flow. Useful for corner ribbons and badges that overlay a node body. |

`align(<alignment>, <content>)` aligns content within its containing region — different from `place`, which positions absolutely within a parent.

## `raw` for code-style content

`raw("text")` (or backticks `` `text` ``) marks a span as code. When prose and `raw()` content share a font family, both render identically — a `show raw:` rule that applies styling (typically a fill color) gives raw spans a visual marker:

```typst
#show raw: r => text(fill: palette.accent.stroke, r)
```

The rule applies to every raw span within its scope; declared at the document top, it covers the whole source.

For multi-line code blocks with language highlighting:

```typst
raw(lang: "go", "func (c *Client) Chat(ctx, req) (*Response, error) {\n    return c.do(ctx, req)\n}")
```

The `lang:` parameter activates Typst's syntax highlighter when configured.

## Mixed-style runs

Inline composition of multiple text styles in a single content expression:

```typst
[Regular text with #text(weight: "semibold")[a bold word] and #text(style: "italic")[an italic phrase].]
```

The `#text(...)[...]` form is the inline-style switch. It applies a single emphasis without breaking the surrounding run into a stack.

## Math expressions in node bodies

Typst math mode `$ ... $` is content; it composes anywhere content is expected:

```typst
node((0, 0),
  stack(dir: ttb, spacing: 5pt,
    text(weight: "bold", "throttle"),
    $r <= 100 "req/s"$,
  ),
)
```

Useful when a node represents a formula, capacity, or rate expression.

## Show rules and their scope

`#show <selector>: <transform>` rewrites every match of the selector inside the *current scope*. At the top level of a Typst document, scope is the document. Inside a block or function, scope is that block.

This means **show rules don't survive a function boundary**. If you write:

```typst
let my-diagram(body) = {
  show raw: r => text(fill: palette.accent.stroke, r)  // doesn't apply outside the function
  body
}
```

…the show rule applies only to content evaluated *inside* the function's scope. Document-wide show rules must be declared at the document top.

## `repr()` for debugging

`repr(value)` returns a string representation of any value. Useful for rendering the resolved value of a token or expression alongside its name:

```typst
text(repr(tokens.size-body))  // → "11pt"
```

`repr()` on Unicode-escape strings has a slicing gotcha — see [fletcher-pitfalls](fletcher-pitfalls.md).

## Imports

Type the import path relative to the source file, or absolute from the `--root` argument:

```typst
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.3.4": draw
#import "../design/tokens.typ": tokens
#import "../design/theme.typ": palette
```

Only import what you use — `diagram, node, edge` from Fletcher is the typical minimum.

## Page setup

Diagrams typically run with `set page(width: <fixed>, height: auto)`. The fixed width sets the rendering canvas; `height: auto` lets the page grow to fit content.

```typst
#set page(
  width:  900pt,
  height: auto,
  margin: 20pt,
  fill:   palette.surface,
)
```

For diagrams that should fill a fixed-size box (e.g., when the self-loop workaround forces a fixed height), use a fixed-size `box` or `block` inside the diagram instead of changing the page model.

## Content vs. text

Two related but distinct types:

- **`text(...)`** — a function that returns styled-text content. Takes parameters like `size`, `weight`, `fill`, `style`. Pass a content body as the last positional argument or with bracket syntax.
- **Content blocks** — `[...]` literals are content. They can contain markup syntax (`*bold*`, `_italic_`, `\` for line break) and inline expressions (`#expr`).

Content composes; text styles wrap content. The typical pattern is to write the body as content (`[...]`) and wrap with `text(...)` only where style overrides are needed.
