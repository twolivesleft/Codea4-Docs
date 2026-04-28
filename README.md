# Codea Docs

**Codea** is a Lua-based engine and IDE for making games and simulations on iOS and macOS.

This repository contains the API reference documentation for Codea 4, built with [Sphinx](https://www.sphinx-doc.org/).

## Building the Docs

```bash
cd docs
pip install -r requirements.txt
make html
```

The output lands in `docs/build/html/`.

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
