# Render pipeline

Compiling Typst diagram sources into SVGs that work in HTML, Markdown, and GitHub READMEs.

## Compile command

```bash
typst compile --root <project-root> --input theme=<name> source.typ output.svg
```

- `--root` sets the import root. Diagrams typically import design modules from a sibling directory (`../design/tokens.typ`, etc.); compile from a directory that resolves those paths.
- `--input theme=<name>` is the standard mechanism for theme switching at compile time. Read it inside the source via `sys.inputs.at("theme", default: "<fallback>")`.

## Dual-theme output

A diagram intended for both light and dark contexts compiles once per theme, producing sibling SVGs:

```bash
for theme in light dark; do
  typst compile --root . --input theme=$theme source.typ "source-${theme}.svg"
done
```

The `-light` / `-dark` suffix is the convention the embedding pattern relies on. Theme decisions (color values per theme) live inside the source, gated on `sys.inputs.at("theme", ...)`.

## Static vs responsive output

Typst always emits a fixed pt-dimensioned root element:

```xml
<svg viewBox="0 0 900 1234.5" width="900pt" height="1234.5pt" …>
```

The viewBox carries the aspect ratio. The fixed `width` and `height` attributes prevent the SVG from scaling to its container when embedded with `<img width="100%">`.

| Mode | Dimensions | Suits |
|---|---|---|
| **Static** | kept | Diagrams whose legibility depends on a fixed rendering size — full-resolution references where the source tunes the dimensions. |
| **Responsive** | stripped | Diagrams that scale to their embedding container (e.g., embedded in a README that adapts to viewport width). |

**Per-file marker.** A magic comment at the top of a `.typ` source declares static intent:

```typst
// render: static
```

The render task greps for the marker; absence is the default (responsive). Typst does not currently expose a flag to suppress the dimensions at compile time, so the post-process strip is the stable mechanism:

```bash
sed -i -E 's/ width="[0-9.]+pt"//; s/ height="[0-9.]+pt"//' output.svg
```

## Render task

A render task that walks a directory tree, compiles each diagram source for both themes, and applies the static / responsive convention:

```bash
find . -type f -name '*.typ' \
  -not -name 'tokens.typ' -not -name 'theme.typ' \
  | while read -r f; do
    base="${f%.typ}"
    if grep -qE '^//\s*render:\s*static\b' "$f"; then
      mode=static
    else
      mode=responsive
    fi
    for theme in light dark; do
      out="${base}-${theme}.svg"
      typst compile --root . --input theme=${theme} "$f" "$out"
      if [ "$mode" = "responsive" ]; then
        sed -i -E 's/ width="[0-9.]+pt"//; s/ height="[0-9.]+pt"//' "$out"
      fi
    done
done
```

Imported modules (`tokens.typ`, `theme.typ`, helpers) are not standalone diagrams; they are excluded from the walk. With many shared modules, a directory-based exclusion (`-not -path '*/design/*'`) is cleaner than listing each filename. The logic itself is task-runner-agnostic — it works under `mise`, `make`, `just`, npm scripts, or plain shell.

## Embedding

Pair the rendered SVGs in an HTML `<picture>` element so the browser swaps based on the user's color-scheme preference. (GitHub-rendered Markdown honors this.)

```html
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./diagram-dark.svg">
  <img src="./diagram-light.svg" alt="Description of the diagram" width="100%">
</picture>
```

`<source>` matches before `<img>` falls through; the dark sibling renders when the color-scheme query matches, otherwise the light sibling renders.

`width="100%"` takes effect when the SVG has no fixed dimensions on its root element (responsive mode). For static SVGs, omit `width="100%"` so the browser renders at the source-defined size.

**SVG-internal hyperlinks** (`<a xlink:href="…">` inside the SVG) do not render as clickable links when the SVG is embedded via `<img>` on GitHub. Links that need to be clickable belong in surrounding Markdown, not inside the SVG.

## Cleanup

```bash
find . -type f -name '*.svg' -delete
```

When a tree contains non-rendered SVGs (icons, exports), scope the find to known render directories rather than walking the whole tree.
