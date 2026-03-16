#!/usr/bin/env python3
"""
Scan all RST files under docs/source and report lua:function /
lua:method / lua:staticmethod directives that are missing a `.. helptext::` in their content block.
"""

import re
import sys
from pathlib import Path

DIRECTIVE_RE = re.compile(r'^(\s*)\.\. lua:(function|method|staticmethod)::(.*)')
HELPTEXT_RE  = re.compile(r'\.\. helptext::')

DOCS_DIR = Path(__file__).parent.parent / 'docs' / 'source'


def find_missing(filepath: Path, base: Path) -> list[tuple]:
    """Return list of (rel_path, line_no, directive_type, func_signature)."""
    missing = []
    lines = filepath.read_text(encoding='utf-8').splitlines()
    rel = filepath.relative_to(base)

    i = 0
    while i < len(lines):
        m = DIRECTIVE_RE.match(lines[i])
        if m:
            directive_indent = len(m.group(1))
            dtype = m.group(2)
            func_sig = m.group(3).strip()
            line_no = i + 1  # 1-based

            # Scan the directive's content block looking for helptext.
            # The block runs until a non-blank line whose indentation is
            # <= the directive's own indentation.
            has_helptext = False
            j = i + 1
            while j < len(lines):
                raw = lines[j]
                stripped = raw.strip()
                if stripped == '':
                    j += 1
                    continue
                if len(raw) - len(raw.lstrip()) <= directive_indent:
                    break   # back to same/outer level — block ended
                if HELPTEXT_RE.search(raw):
                    has_helptext = True
                    break
                j += 1

            if not has_helptext:
                missing.append((str(rel), line_no, dtype, func_sig))

        i += 1

    return missing


def main():
    if not DOCS_DIR.exists():
        print(f"Error: {DOCS_DIR} not found", file=sys.stderr)
        sys.exit(1)

    all_missing: list[tuple] = []
    for rst_file in sorted(DOCS_DIR.rglob('*.rst')):
        all_missing.extend(find_missing(rst_file, DOCS_DIR))

    col_file = max((len(r[0]) for r in all_missing), default=4)
    col_file = max(col_file, 4)
    col_sig  = max((len(r[3]) for r in all_missing), default=8)
    col_sig  = max(col_sig, 8)

    header = f"{'#':<6}  {'File':<{col_file}}  {'Line':<6}  {'Type':<10}  Signature"
    print(f"Missing helptexts: {len(all_missing)}\n")
    print(header)
    print('-' * len(header))

    for idx, (rel, line_no, dtype, sig) in enumerate(all_missing, 1):
        print(f"{idx:<6}  {rel:<{col_file}}  {line_no:<6}  {dtype:<10}  {sig}")


if __name__ == '__main__':
    main()
