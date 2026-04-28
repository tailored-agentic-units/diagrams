#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: 560pt, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)

#stack(dir: ttb, spacing: tokens.gap-structured-text * 2,
  [Inline raw: #raw("fletcher.shapes.hexagon") appears identical-weight to prose; the purple tint differentiates it.],
  block(
    fill: palette.surface-muted,
    inset: tokens.pad-inside-shape,
    radius: tokens.radius-shape,
    raw(lang: "go", "func (c *Client) Chat(ctx context.Context, req *Request) (*Response, error) {\n    return c.do(ctx, req)\n}"),
  ),
)
