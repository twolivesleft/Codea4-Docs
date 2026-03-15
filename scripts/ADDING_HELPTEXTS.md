# Adding Missing Helptexts — Agent Guide

This document describes the process for finding and adding missing `.. helptext::` entries to the Codea API documentation. Follow it exactly to maintain consistent quality.

## What is a helptext?

A `.. helptext::` directive provides a short inline description of a function or method, displayed in the Codea IDE autocomplete. It lives inside the content block of a `.. lua:function::` or `.. lua:method::` directive.

Example:

```rst
.. lua:function:: stroke(color)

   Sets the stroke color for vector drawing operations

   .. helptext:: set the stroke color

   :param color: The color to set
   :type color: color
```

---

## Step 1 — Find missing helptexts

Run the check script from the repo root (the repo root is the parent of the `scripts/` directory where this file lives):

```bash
python3 scripts/check_helptexts.py
```

Redirect to a file for easy reference:

```bash
python3 scripts/check_helptexts.py > scripts/missing_helptexts.txt
```

The report lists: index, file path (relative to `docs/source/`), line number, directive type (`function` or `method`), and the function signature.

---

## Step 2 — Look up the legacy helptext

Before writing a new helptext, check the legacy plist for an existing one.

**Ask the user for the location of the Codea app repository.** The plist is always at:

```
<codea-repo>/Jam/Jam/Assets/Settings/CodeaAPITags.plist
```

Look up the **bare function name** (strip parameters) as a `<key>`. Each entry may have:

- `helpText` — used when the function **has parameters** (setter variant)
- `helpTextNoParams` — used when the function **has no parameters** (getter variant)

Example lookup in Python:

```python
import plistlib
with open('codea-mcp/Jam/Jam/Assets/Settings/CodeaAPITags.plist', 'rb') as f:
    data = plistlib.load(f)
entry = data.get('stroke', {})
print(entry.get('helpText', ''))         # → 'set the stroke color'
print(entry.get('helpTextNoParams', '')) # → 'get the stroke color'
```

---

## Step 3 — Choose the helptext

Priority order:

1. **Legacy plist** — use `helpTextNoParams` for no-param signatures, `helpText` for parameterised ones. If both are empty or the key is absent, fall back to option 2.
2. **RST description** — derive a short helptext from the first sentence of the directive's description. Keep it concise (a few words), lowercase, no period.

### Rules for writing a good helptext

- Short: typically 3–7 words
- Lowercase, no trailing period
- Start with a verb: `set`, `get`, `create`, `draw`, `apply`, `return`, etc.
- For get/set overloads: use `set the X` (with params) and `get the X` (no params)
- For destructive methods: `destroy this X`
- Match the tone of existing entries in the plist

---

## Step 4 — Insert the helptext

Place `.. helptext::` at the **end** of the directive's content block, after the description and any `:param:`/`:return:` fields, separated by a blank line:

```rst
.. lua:function:: stroke(gray, alpha)

   Sets the stroke color to the specified grayscale value and alpha

   :param number gray: The grayscale value
   :param number alpha: The alpha value

   .. helptext:: set the stroke color
```

For **methods inside classes**, the indentation is deeper (3 spaces per level):

```rst
.. lua:class:: vec2

   .. lua:method:: normalize()

      Normalize this vector

      .. helptext:: normalize this vector
```

For **empty blocks** (no description), add the helptext as the only content:

```rst
.. lua:method:: clear()

   .. helptext:: clear the buffer
```

---

## Step 5 — Automate with a script

For large batches, use a Python script to insert all helptexts in one pass. Always process entries **bottom-up** (highest line number first) within each file so earlier line numbers stay valid as lines are inserted.

Reference implementation pattern:

```python
from pathlib import Path

# This script lives in scripts/ — docs are one level up
filepath = Path(__file__).parent.parent / "docs/source/api/example.rst"
lines = filepath.read_text().splitlines(keepends=True)

# Map directive line number (1-based) → helptext string
insertions = {
    42: "normalize this vector",
    38: "calculate the dot product with another vector",
    # ...
}

for directive_line in sorted(insertions.keys(), reverse=True):
    helptext = insertions[directive_line]
    directive_idx = directive_line - 1
    directive_indent = len(lines[directive_idx]) - len(lines[directive_idx].lstrip())

    # Find last non-blank content line in the block
    last_content_idx = None
    j = directive_idx + 1
    while j < len(lines):
        raw = lines[j].rstrip('\n')
        if raw.strip() == '':
            j += 1
            continue
        if len(raw) - len(raw.lstrip()) <= directive_indent:
            break  # block ended
        last_content_idx = j
        j += 1

    # Fall back to directive line for empty blocks
    if last_content_idx is None:
        last_content_idx = directive_idx

    content_indent = ' ' * (directive_indent + 3)
    helptext_line = f"{content_indent}.. helptext:: {helptext}\n"
    # Insert blank then helptext (reversed order so blank ends up first)
    lines.insert(last_content_idx + 1, helptext_line)
    lines.insert(last_content_idx + 1, '\n')

filepath.write_text(''.join(lines))
```

---

## Step 6 — Verify

After editing each file, rebuild the docs and confirm no new warnings appear:

```bash
cd docs && make html 2>&1 | grep -E "WARNING|ERROR"
```

**Baseline warnings** (pre-existing, not caused by helptext edits):
- `_static` path missing
- `api/inspector.rst` not in any toctree

Any warning beyond these two indicates a problem — investigate before committing.

Also re-run the check script to confirm the count decreased:

```bash
python3 scripts/check_helptexts.py | head -1
```

---

## Step 7 — Commit

Commit **one file at a time** for clean history and easy rollback:

```bash
git add docs/source/api/example.rst
git commit -m "Add missing helptexts to example.rst (N entries)"
```

After all files are done, update the report and do a final push:

```bash
python3 scripts/check_helptexts.py > scripts/missing_helptexts.txt
git add scripts/missing_helptexts.txt
git commit -m "Update missing_helptexts.txt (0 remaining)"
git push
```

---

## Workflow summary

1. Run `check_helptexts.py` → identify missing entries
2. Group by file; process largest files first
3. For each file:
   - Look up each function name in `CodeaAPITags.plist`
   - Choose helptext (plist → RST description fallback)
   - Insert bottom-up using the script pattern above
   - Build docs, verify only 2 baseline warnings remain
   - Commit
4. Final pass: re-run script, confirm 0 missing, push
