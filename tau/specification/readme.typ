// tau / specification / readme — cross-library trace of a single Chat call
// (developer voice). One vertical pipeline showing every cross-library call
// the request crosses on its way from application code to the LLM service
// and back. Each node is a single function call or external participant;
// edge labels carry the data type or operation handed off between them.
//
// The streaming variant forks at client.ExecuteStream (covered in prose);
// the static trace below is the canonical non-streaming path.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../../design/tokens.typ": tokens
#import "../../design/theme.typ": palette

#set page(width: auto, height: auto, margin: tokens.pad-inside-container, fill: palette.surface)
#set text(font: tokens.font, fill: palette.ink)

// External participant — neutral muted card with dashed border + Nerd Font glyph.
#let ext-card(coord, name, glyph) = node(coord,
  text(size: tokens.size-body, fill: palette.ink-muted, glyph + "  " + name),
  shape: fletcher.shapes.rect,
  fill: palette.surface-muted,
  stroke: (paint: palette.border, thickness: tokens.stroke-default, dash: "dashed"),
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

// Library call card — blue, with package qualifier above and the function/type
// in raw monospace below. Optional emphasis stroke for orchestrator entries
// (agent.Chat, client.Execute).
#let call-card(coord, pkg, call, emphasized: false) = node(coord,
  align(center, stack(dir: ttb, spacing: tokens.gap-structured-text,
    text(size: tokens.size-label, weight: tokens.weight-light, fill: palette.blue.ink,
      style: "italic", pkg),
    raw(call),
  )),
  shape: fletcher.shapes.rect,
  fill: palette.blue.fill,
  stroke: (if emphasized { tokens.stroke-emphasis } else { tokens.stroke-default })
    + palette.blue.stroke,
  inset: tokens.pad-inside-shape,
  corner-radius: tokens.radius-shape,
)

#let lbl(s) = text(size: tokens.label-size, weight: tokens.weight-light, fill: palette.ink-muted, style: "italic", s)
#let edge-stroke = tokens.stroke-default + palette.green.stroke

#diagram(
  // Wider vertical spacing gives the edge labels breathing room above and
  // below each shape; horizontal spacing is unused (single column).
  spacing: (tokens.space-between-shapes, tokens.space-between-ranks * 1.6),

  // Entry: application code reaches the agent's protocol method.
  ext-card((0, 0), "application", "\u{F121}"),

  // agent.Chat: merges per-protocol options, constructs a ChatRequest via
  // request.NewChat, then hands off to client.Execute. Emphasized because this
  // is the protocol-method entry point that the application talks to.
  call-card((0, 1), "agent", "Chat(ctx, msgs, opts...)", emphasized: true),

  // request.NewChat bundles provider + format + model + messages + options
  // into a typed ChatRequest. The transient value passed into client.Execute.
  call-card((0, 2), "request", "NewChat(p, f, m, msgs, opts)"),

  // client.Execute: the orchestrator. Wraps the next four steps in
  // doWithRetry (MaxRetries / InitialBackoff / MaxBackoff / Jitter). Emphasized.
  call-card((0, 3), "client", "Execute(ctx, req)", emphasized: true),

  // req.Marshal() delegates to the request's bound format.Format.Marshal,
  // passing a protocol-keyed ChatData struct (built from the request's
  // messages/options). Returns the wire-format request body.
  call-card((0, 4), "format.Format", "Marshal(Chat, &ChatData{...})"),

  // provider.PrepareRequest builds the *http.Request (URL, body, base
  // headers); provider.SetHeaders applies auth (bearer / api-key / SigV4).
  call-card((0, 5), "provider.Provider", "PrepareRequest + SetHeaders"),

  // HTTP roundtrip: client.HTTPClient().Do dispatches the signed request;
  // the LLM service is the external dashed boundary.
  ext-card((0, 6), "LLM service · HTTP POST + response", "\u{F0C2}"),

  // format.Format.Parse converts the response bytes back into the typed
  // response value the caller expects (protocol-keyed).
  call-card((0, 7), "format.Format", "Parse(Chat, body)"),

  // Returning entity — the typed response that surfaces back through client →
  // agent → application. Rendered as a ref card (smaller, no qualifier) to
  // signal "this is the value handed back," not a new call.
  call-card((0, 8), "response", "*response.Response"),

  ext-card((0, 9), "application", "\u{F121}"),

  // Outbound edges (top to bottom) — each carries the data type or operation
  // crossing the library boundary. All labels anchored on the same side
  // (label-side: left → west of south-travelling vertical edge = image-left)
  // so the reader's eye traces a consistent left margin down the pipeline
  // rather than jumping between sides per-edge.
  edge((0, 0), (0, 1), "->", lbl("Chat(ctx, []protocol.Message, opts...)"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 1), (0, 2), "->", lbl("constructs"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 2), (0, 3), "->", lbl("client.Execute(ctx, req)"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 3), (0, 4), "->", lbl("req.Marshal() delegates to format"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 4), (0, 5), "->", lbl("[]byte (wire body)"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 5), (0, 6), "->", lbl("*http.Request (signed)"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 6), (0, 7), "->", lbl("response body []byte"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 7), (0, 8), "->", lbl("returns"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
  edge((0, 8), (0, 9), "->", lbl("up through client → agent → caller"),
    label-side: left, label-fill: palette.surface, stroke: edge-stroke),
)
