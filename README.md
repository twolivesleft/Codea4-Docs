# Codea Docs

**Codea** is a Lua-based engine and IDE for making games and simulations on iOS and macOS.

The authoritative API reference and usage guides for Codea 4 live in the Codea
app repository at `Probe/Probe/Data/Carbide`, built with [Sphinx](https://www.sphinx-doc.org/).
Make documentation changes in the app first, rebuild its bundled metadata, then
sync the source, assets, and tests to `Codea4-Docs` for web publication. The web
repository is a publishing mirror, not an independent authoring source.

The November 2026 transition reconciled the web repository through `7d59279`
into the app, preserving its newer image, input, and keyboard coverage alongside
the app's guides, runnable examples, and media.

## Published reference

The public reference lives at https://codea.io/reference/. GitHub Pages publishes
only the `redirect/` directory, including a fallback for old documentation URLs.
Sphinx still builds the source as a downloadable CI artifact. Documentation is
authored in the app repository and synced here for review and archival access.

## Building the Docs

```bash
cd docs
pip install -r requirements.txt
make html
```

The output lands in `docs/build/html/`.

## Documentation style

Lead with what someone can draw, build, or change. Use short, direct explanations
and the legacy reference as a guide to tone. Introduce technical terms when they
help explain a task: matrices, shader stages, and coordinate systems belong where
the reader needs them. Avoid implementation labels such as “modern renderer” or
“fluent API” in general introductions; retain version distinctions in migration
instructions and where they affect behavior.

Introduce an example by saying what it does and suggesting a useful change to try.
Keep reference-navigation instructions in the guide to using the reference.
Preserve code formatting, examples, parameter details, and practical limitations.
Remove repeated explanations, development history, and empty placeholder sections.
Editorial notes are instructions for the author, not published content.

## API Authoring Requirements

The API `.rst` files are used by Codea as structured editor metadata, not only as
rendered documentation. The `luadoc` build emits JSON that Codea consumes for
Reference, autocomplete, syntax highlighting, and editor affordances.

### Module Namespacing

Use Sphinx's Lua module context as the source of truth for namespacing.

```rst
.. lua:module:: pasteboard

.. lua:attribute:: name: string
```

This emits `name` with `module: "pasteboard"`, so Codea treats the symbol as
`pasteboard.name`. Reference UI should display the qualified name for module
members.

Rules:

- Use `.. lua:module:: name` once when introducing and documenting a module.
- Use `.. lua:currentmodule:: name` to return to an existing module context
  without creating another module entry.
- Use `.. lua:currentmodule:: None` before globals in a file that previously set
  a module context.
- Do not rely on section headings to imply namespacing. The current Lua module
  context is the authoritative signal.

For mixed files, be explicit:

```rst
.. lua:module:: style

.. lua:function:: fill(<color>)

Constants
*********

.. lua:currentmodule:: None

.. lua:attribute:: LEFT: const

.. lua:currentmodule:: style

.. lua:function:: textAlign(align)
```

Here `style.fill` is namespaced, `LEFT` is global, and later functions return to
the `style` namespace.

### Structural Table Return Types

Use `:rtype: table$private.<name>` when a function returns a generic Lua table
but Codea should understand the specific fields of that returned table for
tooling. Text before `$` is the documentation-facing type. Text after `$` is the
lookup type. `private.<name>` is module-relative, so inside an `objc` module it
becomes `objc.private.<name>` in Codea's JSON.

```rst
.. lua:module:: objc

.. lua:function:: insets(top, left, bottom, right)

   Create a UIEdgeInsets.

   :param top: top value of the UIEdgeInsets
   :type top: number
   :param left: left value of the UIEdgeInsets
   :type left: number
   :param bottom: bottom value of the UIEdgeInsets
   :type bottom: number
   :param right: right value of the UIEdgeInsets
   :type right: number
   :return: The UIEdgeInsets struct.
   :rtype: table$private.insets

.. lua:class:: private.insets

   .. visibility:: private

   .. lua:attribute:: top: number
   .. lua:attribute:: left: number
   .. lua:attribute:: bottom: number
   .. lua:attribute:: right: number
```

The `luadoc` builder emits the return metadata as `type:
"objc.private.insets"` and `displayType: "table"`. Codea uses `type` for
autocomplete and type lookup, and `displayType` for Reference display. The
private class is authored explicitly so function arguments and returned table
fields can differ.

### Constructors

Document constructors as a `lua:staticmethod` nested inside the class, using the
same callable name as the class. The `luadoc` builder treats same-name nested
staticmethods as constructors and emits `kind: "constructor"` in JSON, so Codea
can show constructor rows and infer constructor return types without implying a
`Type.Type()` API.

```rst
.. lua:class:: mesh

   .. lua:staticmethod:: mesh([submeshCount])

      Create an empty mesh.
```

For module-scoped and dotted classes, keep the constructor signature aligned
with the public call:

```rst
.. lua:module:: physics2d

.. lua:class:: world

   .. lua:staticmethod:: world()
```

```rst
.. lua:class:: gesture.tap

   .. lua:staticmethod:: gesture.tap(callback)
```

Rules:

- Use same-name nested staticmethods only for constructors.
- Do not document a true static method with the same name as its type.
- Repeat the same constructor staticmethod with different signatures to document
  overloads.
- Continue using ordinary `lua:staticmethod` entries for real static factories,
  such as `mesh.sphere`, `image.cube`, and `shader.compute`.

### Symbol Annotations

Use `.. symbol::` for syntax-highlighting classifications. Symbol annotations
are inherited by descendant API entries until a more-specific `.. symbol::`
replaces them.

Supported symbol types:

- `api-call`: Codea API call highlighting. This is the default for docs-derived
  functions when no symbol metadata is present.
- `lua-api`: Lua standard library highlighting.
- `const`: Constant highlighting. This maps to Codea's existing constant symbol
  type.

Examples:

```rst
.. symbol:: lua-api

.. lua:function:: print(...)

.. lua:attribute:: pi: const

   .. symbol:: lua-api const
```

```rst
.. lua:attribute:: STANDARD: const

   .. symbol:: const
      :group: viewer-mode
```

The optional `:group:` value is emitted as `symbol.group`. Codea can use this to
identify replaceable symbol sets, such as viewer modes, text alignment values,
bit masks, or other related constants.

Use symbol annotations for semantic coloring and symbol-map behavior. Do not use
them for popover/editor UI features.

### Editor Annotations

Use `.. editor::` for editor affordances only. These roles are emitted as editor
metadata and mapped by Codea to existing `LuaSymbolType` affordance flags.

Supported roles include:

- `color`: color picker affordance
- `sprite`: sprite/image asset affordance
- `text`: text/font-related affordance
- `import`: asset import affordance, for APIs such as `require`
- `sound`: sound asset affordance
- `music`: music asset affordance
- `font`: font picker affordance
- `shader`: shader affordance
- `model`: model asset affordance
- `symbol`: SF Symbol picker affordance, for `image.symbol`

Example:

```rst
.. lua:function:: fill(<color>)

   Sets the fill color.

   .. editor:: color
```

This lets Codea derive `style.fill` as both an API call and a color API call, so
the editor can apply the correct highlighting and show the color interaction.

Keep editor roles separate from symbol classifications:

- Use `.. symbol:: lua-api` for Lua API coloring.
- Use `.. symbol:: const` for constant coloring.
- Use `.. editor:: color`, `sprite`, `import`, etc. only when tapping or editing
  the symbol should expose a special editor interaction.

## Scripts

### Text API documentation

Keep text documentation in the existing chapters:

- `docs/source/api/graphics.rst`: `text`, measurements, rich-text registration,
  formatting callbacks, and glyph modifiers.
- `docs/source/api/style.rst`: font and text-style getters/setters, positioning
  and wrapping, shadows/decorations, and global text constants.
- `docs/source/manual/drawing.rst`: introductory examples and renderer selection.

Native text is the default; atlas examples select `style.textRenderer(style.atlas)`
(or the global `textRenderer` alias). Atlas always parses tags; native strings are
literal. Renderer constants `style.native` and `style.atlas` are string-valued and
use `symbol:: const` with the `text-renderer` group. Keep both getter/setter
signatures documented for the style member and global alias. Document unimplemented bindings as reserved
rather than presenting placeholder return values as working features. Internal
compatibility helpers such as `style._legacyTextAlign` are not public APIs.

Add separate getter/setter signatures with accurate `:type:` and `:rtype:` fields.
Fluent setters return `style`; the compatibility `textMode` and `textWrapWidth`
setters return values. Use `helptext` on every callable, `editor:: font` on font
selection, `editor:: color` on color setters, and `editor:: text` on text drawing.
Alignment constants use `symbol:: const` with the `text-alignment` group.
Functions receive API-call highlighting by default; editor roles are separate.

Build both outputs when changing editor-facing documentation:

```sh
cd docs
make html
make luadoc
```

The app bundles `docs/build/luadoc`; inspect its JSON for module names, optional
parameter names, return types, editor roles, and constant symbol groups. Generated
JSON belongs alongside its RST source changes. Use a flat optional argument group
such as `text(str, x, y[, w, h])`; the current metadata parser does not correctly
extract parameter types from nested optional groups.

Run metadata regression tests after rebuilding JSON:

```sh
python -m unittest discover -s docs/tests
```

### `scripts/check_helptexts.py`

Scans all `.rst` files under `docs/source/` and reports `lua:function` and `lua:method` directives that are missing a `.. helptext::` entry. These helptexts are used to provide short inline descriptions in the Codea IDE.

```bash
python3 scripts/check_helptexts.py
```

To save the report to a file:

```bash
python3 scripts/check_helptexts.py > scripts/missing_helptexts.txt
```

The report lists each missing helptext with an index, file path, line number, directive type, and function signature — making it easy to work through the list systematically.

## Reference presentation

`chapters_config.json` is the curated Probe chapter index. Every `api/*.rst`
source must appear exactly once. The metadata tests check coverage. Manuals are
reading guides: consecutive overview sections become one page with subheadings,
prose, examples and media in source order. Avoid pages whose entire introduction
is a category marker such as `(global)`; namespace/type information already
belongs to the API metadata.

### Deprecated APIs

Use Sphinx's standard directive **inside the API declaration**:

```rst
.. lua:function:: readImage(assetKey)

   Compatibility image loader.

   .. deprecated:: 4.0
      Use ``image.read(assetKey)`` instead.
```

The message is emitted as `deprecation` in JSON. Probe shows a Deprecated badge
in lists and a notice in details. `ReferenceViewModel(includesDeprecated: false)`
hides deprecated items (and descendants of deprecated types); the property can
also be changed later. Filtering does not remove editor/autocomplete metadata.
Document migration behavior, including unsupported stubs, rather than promising
that the compatibility layer reproduces every legacy behavior.

### Runnable examples

Ordinary code blocks remain copyable snippets. Mark a **complete project** with
`codea-example` to offer a Run Example button:

```rst
.. codea-example:: A circle

   function setup()
   end

   function draw()
       background(24, 28, 38)
       style.fill(100, 220, 200).noStroke()
       ellipse(WIDTH / 2, HEIGHT / 2, 80, 80)
   end
```

For multiple tabs or project assets, add `:project: code/My Example.codea`.
Paths are relative to `docs/source`; the builder copies the complete project
into the documentation bundle. Optional `:poster: images/example.png` supplies a
preview image. Run executes the project copy, or `Main.lua` containing the
inline code if no project is provided. Keep projects self-contained. Only
explicitly marked examples are executable; GLSL and partial Lua snippets are not.

The current host is a dismissible sheet. ProbeKit accepts an example-controller
factory and a `ReferenceExampleLifecycle` shutdown hook, keeping presentation
independent of CarbideKit and allowing a future inline player. Probe Browser and
Codea's modern reference install the Carbide example host. Dismissal cancels
loading, shuts down rendering/audio and removes the temporary project.

### Images and video

Standard RST `image` directives are included in Probe output. For captions and
video, use:

```rst
.. codea-media:: images/example_shape.png
   :type: image
   :alt: A filled shape with an outline
   :caption: Fill and stroke can be configured independently.

.. codea-media:: videos/drawing.mp4
   :type: video
   :alt: A circle moving across the screen
   :caption: The example running in Codea.
```

Local paths resolve within `docs/source` and are copied into the generated
bundle. HTTPS image/video URLs are also supported. Videos default to native playback controls. For short, silent illustrations,
add `:playback: preview` to autoplay and loop without controls in the app and
HTML. The app respects Reduce Motion by offering manual controls instead, and
pauses playback when backgrounded or the page disappears. Keep recordings
focused on the project canvas, without viewer chrome or internal product names. Supply useful
alternative text and captions. Rebuild both `luadoc` and HTML after changes.

### Hand-crafted modern examples

`docs/source/code/Modern` contains documentation adaptations of the 17 projects
from `feature/modern-examples` at `7f2da2161`. Their original teaching comments
and author credits are retained. The documentation copies use modern touch
access, local assets, sheet-friendly layouts and bounded default GPU workloads.
The Touches skeleton is completed, the parameter demo focuses on controls, and
reaction diffusion uses separate read/write textures. Compute grids use
`image.pixel()` instead of display-scaled `image()` allocation, and image access
is declared in GLSL rather than passed as an obsolete `setImage` argument. GPU particles omit the
unused older Bloom helper; camera post-processing is covered in the Camera
Effects guide. Runtime metadata lists every Lua tab in load order.

A `codea-example` with only `:project:` displays that project's `Main.lua`
automatically. Other tabs and assets are copied with the project for execution.
Edit these source projects, then rebuild luadoc; generated copies are not the
authoring source.

Runnable projects expose their `parameter` controls through the viewer's Controls
button, which appears only when the inspector has entries. Probe Browser includes
Codea's default HDR environment for `scene.default3d()` lighting.

### Guide sections and navigation audit

Manuals default to the **Guides** section. To group a chapter's manuals into
meaningful sections, put document metadata before the title:

```rst
:reference-section: Project Browser

The project browser
===================
```

API document headings are reader-facing section labels: use `Mesh`, `User
Interface`, or `Objective-C`, while retaining exact lowercase API names inside
Lua declarations. Name the opening overview independently with document metadata:

```rst
:reference-overview: Using Meshes

Mesh
====
```

Give later overview passages real subsection headings (for example, **Storage
Patterns**) so they do not repeat the opening overview's name. Regression tests
reject lowercase section labels and unnamed or same-as-section API overviews.
When an introduction belongs to a module, the browser shows that content on the
module page only. Its editorial overview title does not create a duplicate list
item. Separate reading guides and standalone overviews (such as Using Meshes)
remain visible. The navigation audit compares rendered overview and module
content across every chapter to prevent identical pages from returning.

Keep a guide as one readable page, with task-oriented subheadings. Add its path
in both `index.rst` and the appropriate `chapters_config.json` entry. Using Codea
is the first chapter, with three guides each in Project Browser, Sharing &
Storage, and Tools & Settings. Screenshots in `images/using_codea` are actual
Codea simulator captures; their captions describe controls without depending on
a fixed toolbar position.

The November 2026 audit counts the rendered Probe navigation (including module
pages), rather than raw RST headings:

| Chapter | Sections | Entries |
| --- | ---: | ---: |
| Using Codea | 3 | 9 |
| Graphics | 34 | 304 |
| Scenes & Entities | 20 | 219 |
| Shaders & Meshes | 5 | 93 |
| Physics 2D | 4 | 133 |
| Physics 3D | 2 | 61 |
| Input & Motion | 14 | 263 |
| Sound | 3 | 34 |
| Storage & Assets | 8 | 42 |
| Vector Math | 13 | 136 |
| Display & Viewer | 6 | 65 |
| Animation | 2 | 25 |
| Lua | 13 | 138 |
| Objective-C | 2 | 26 |

The former single-page Getting Started chapter is removed; **How Codea Works**
now introduces Lua alongside its language reference. Physics 3D, Animation, and
Objective-C retain a guide section and a substantial API section: their small
section count does not represent thin content. No chapter contains just one
entry, and no rendered section is empty. Small API sections remain when their
names provide useful navigation to a distinct concept; avoid adding filler
pages or merging unrelated APIs merely to increase section counts.

`ReferenceNavigationAuditTests` checks these structural guarantees and the nine
Using Codea guides. Existing metadata coverage tests ensure that reorganizing
navigation does not drop API source files.
