#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: 640pt, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, size: tokens.size-body, fill: palette.ink)
#show raw: r => text(fill: palette.purple.stroke, r)

#stack(dir: ttb, spacing: tokens.gap-structured-text * 2,
  [Regular text with #text(weight: "semibold")[a bold word] and #text(style: "italic")[an italic phrase].],
  [Code inside prose: call #raw("Client.Chat(ctx, req)") on the client.],
  [Inline math: the sum #text(fill: palette.green.stroke)[$sum_(i=0)^n i = n(n+1)/2$] in continuous flow.],
  [Icon + label: #text(fill: palette.blue.stroke, "\u{F015}")  home-hosted · #text(fill: palette.blue.stroke, "\u{F0C2}")  cloud-hosted.],
  [Decorated run: we've #strike[dropped] #underline[added] this capability.],
)
