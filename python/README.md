# TDD Lab — Shopping Cart

Practice the agentic TDD loop using the `tw-tdd` skill in VS Code + Claude Code.

## Files

```
python/
├── prd.md        ← PRD — Claude reads this to generate tests
├── cart.py       ← stub — Claude implements this to pass the tests
├── original/
│   ├── cart.py   ← reset source — never edit this
│   └── prd.md    ← reset source — never edit this
└── solution/
    ├── cart.py      ← complete implementation — peek if truly stuck
    └── test_cart.py ← reference tests — peek if truly stuck
```

> `test_cart.py` does not exist yet — Claude generates it in Step 3.
> Do not open `solution/` until you have completed the lab.

---

## Step 0 — Install the skill

From the **repo root** (`skill_tutorial/`), copy `tw-tdd` into your Claude skills library:

```bash
cp -r ./skills/tw-tdd ~/.claude/skills/
```

Verify Claude sees it — type this in the Claude Code chat panel:

```
When would you use the tw-tdd skill?
```

You should get a crisp answer quoting the PRD → red → green loop. If it's vague, the copy didn't land.

---

## Step 1 — Set up the Python environment

Open the VS Code terminal (`Ctrl+`` ` or `Terminal → New Terminal`), then:

```bash
cd python
uv sync
```

`pyenv` picks up `3.12.9` from `.python-version` automatically. `uv sync` creates `.venv` and installs `pytest`.

---

## Step 2 — Trigger the TDD loop in Claude Code

Open the Claude Code chat panel in VS Code and paste:

```
TDD this from the PRD in prd.md. Use cart.py as the implementation file.
```

Claude activates `tw-tdd` and runs the full loop:

**RED** — Claude reads `prd.md`, writes `test_cart.py`, runs tests → 5 FAILED:
```
FAILED test_cart.py::test_total_returns_0_when_cart_is_empty
FAILED test_cart.py::test_total_returns_price_times_quantity_for_single_item
FAILED test_cart.py::test_total_sums_multiple_items
FAILED test_cart.py::test_apply_discount_reduces_total_by_percentage
FAILED test_cart.py::test_clear_removes_all_items
```

**GREEN** — Claude implements `cart.py`, runs tests again → 5 PASSED:
```
PASSED test_cart.py::test_total_returns_0_when_cart_is_empty
PASSED test_cart.py::test_total_returns_price_times_quantity_for_single_item
PASSED test_cart.py::test_total_sums_multiple_items
PASSED test_cart.py::test_apply_discount_reduces_total_by_percentage
PASSED test_cart.py::test_clear_removes_all_items
```

If any test still fails, Claude runs the fix loop automatically. If it asks for help:

```
Tests still failing. Fix the implementation only — do not change the tests.
```

---

## Step 3 — Verify yourself

Confirm the result in the VS Code terminal:

```bash
uv run pytest test_cart.py -v
```

Expected: 5 passed.

---

## Step 4 — Adversarial pattern (advanced)

Run the loop across two separate Claude Code sessions to prevent the agent from writing trivially satisfied tests.

**Session A — test writer only** (current VS Code window):
```
Read prd.md and write tests for cart.py. Stop after writing tests — do not implement.
```

**Session B — implementer only** (new VS Code window, `File → New Window`):
```
I have a cart.py stub with empty functions. Here are the tests I need to pass:
[paste tests from Session A]
Implement cart.py so all tests pass.
```

Run both outputs together:
```bash
uv run pytest test_cart.py -v
```

- Tests pass trivially without real logic → Session A wrote weak tests
- Tests fail → Session A found a real gap in the spec

---

## Reset & redo

Run these from inside `python/` to wipe the lab back to the starting state.

**Full reset** — restores stub and PRD, removes Claude-generated files:

```bash
cp original/cart.py cart.py && cp original/prd.md prd.md && rm -f test_cart.py
```

**Redo green only** — keeps `test_cart.py` from last run, resets implementation only:

```bash
cp original/cart.py cart.py
uv run pytest test_cart.py -v
# Expected: 5 failed — ready to ask Claude to implement again
```

**Peek at the solution** — if you're stuck and want to see a working implementation:

```bash
cp solution/cart.py cart.py
uv run pytest solution/test_cart.py -v
# Expected: 5 passed
cp original/cart.py cart.py   # reset stub when done
```
