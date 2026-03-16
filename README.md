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
