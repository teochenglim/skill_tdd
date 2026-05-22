---
name: file-reading
description: >
  Chooses the right tool and strategy for reading any file type.
  Use when asked to read, inspect, summarise, or extract content from a file —
  especially for large files, binary formats, notebooks, or PDFs.
  Do NOT use if the file content is already present in the conversation context.
compatibility: Claude Code — Read, Bash, and NotebookEdit tools required for full coverage
license: MIT
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---

# File Reading

## Rule: stat before read

Always check size before loading content. Large files read in full waste tokens
and can truncate silently.

```bash
wc -l <file>          # line count for text files
wc -c <file>          # byte count for binaries / size check
```

If a file exceeds ~500 lines, sample first (see dispatch table).

---

## Dispatch table — extension → tool

| Extension | Tool | Strategy |
|-----------|------|----------|
| `.py` `.ts` `.js` `.go` `.rb` `.java` | Read | Full read if ≤500 lines; else read header + grep for symbols |
| `.md` `.txt` `.rst` | Read | Full read if ≤300 lines; else `head -n 80` then search |
| `.json` `.yaml` `.toml` `.env.example` | Read | Full read (usually small); warn if >200 lines |
| `.csv` `.tsv` | Bash | `head -n 5` for schema; never read full file |
| `.ipynb` | Read | Use Read tool — returns all cells with outputs |
| `.pdf` | Read | Pass `pages` param; max 20 pages per call |
| `.png` `.jpg` `.gif` `.webp` | Read | Visual display — Read tool renders images |
| `.parquet` `.feather` `.arrow` | Bash | `python -c "import pandas as pd; print(pd.read_parquet('<f>').head())"` |
| `.zip` `.tar.gz` | Bash | `unzip -l` / `tar -tf` to list contents; never unpack unless asked |
| `.sqlite` `.db` | Bash | `sqlite3 <f> ".schema"` then `SELECT * FROM t LIMIT 5` |
| Binary / unknown | Bash | `file <path>` to identify; `xxd <f> | head -n 4` if needed |

---

## Sampling patterns

**Text file — read a window:**
```bash
# First 80 lines
head -n 80 <file>

# Lines around a keyword
grep -n "keyword" <file> | head -20
```

**CSV — schema only:**
```bash
head -n 3 data.csv
wc -l data.csv
```

**JSON — top-level keys only:**
```bash
python3 -c "import json,sys; d=json.load(open('f.json')); print(list(d.keys()) if isinstance(d,dict) else f'array len={len(d)}')"
```

---

## Gotchas

- `Read` with no `offset`/`limit` loads up to 2000 lines — silently truncates beyond that. Always check line count first for files you'll reason over completely.
- PDFs without the `pages` param will fail if >10 pages. Always pass `pages: "1-5"` for an initial scan.
- `.env` files (real ones, not `.env.example`) may contain secrets — confirm with the user before reading.
- Jupyter notebooks: Read returns all cell outputs including images. This can be large; skim cell count first with `jq '.cells | length' notebook.ipynb`.
