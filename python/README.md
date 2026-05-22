# TDD Lab — Shopping Cart

Practice the agentic TDD loop using the `tw-tdd` skill in VS Code + Claude Code.

## Files

```
python/
├── prd.md           ← PRD to paste to Claude — the loop starts here
├── cart.py          ← stub with empty functions — your starting point
├── original/
│   ├── cart.py      ← clean stub — source of truth for reset
│   └── prd.md       ← original PRD — source of truth for reset
└── solution/
    ├── cart.py      ← complete implementation (green phase reference)
    └── test_cart.py ← tests Claude would generate (red phase reference)
```

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

## Step 2 — Run tests before (all FAIL)

The stub `cart.py` has empty functions. Run the solution tests against it to see what red looks like:

```bash
uv run pytest solution/test_cart.py -v
```

Expected output — every test FAILED:

```
FAILED solution/test_cart.py::test_total_returns_0_when_cart_is_empty
FAILED solution/test_cart.py::test_total_returns_price_times_quantity_for_single_item
FAILED solution/test_cart.py::test_total_sums_multiple_items
FAILED solution/test_cart.py::test_apply_discount_reduces_total_by_percentage
FAILED solution/test_cart.py::test_clear_removes_all_items

5 failed in 0.01s
```

This is the **red phase**. Tests exist, implementation does not.

---

## Step 3 — Trigger the TDD loop in Claude Code

Open the Claude Code chat panel in VS Code and paste:

```
TDD this from the PRD in prd.md. Use cart.py as the implementation file.
```

Claude activates `tw-tdd`, reads `prd.md`, and:
1. Writes `test_cart.py` — failing tests (red phase)
2. Implements `cart.py` — minimal code to pass (green phase)
3. Runs the fix loop if any tests still fail

---

## Step 4 — Run tests after (all PASS)

Once Claude finishes, run from the VS Code terminal:

```bash
uv run pytest test_cart.py -v
```

Expected output — every test PASSED:

```
PASSED test_cart.py::test_total_returns_0_when_cart_is_empty
PASSED test_cart.py::test_total_returns_price_times_quantity_for_single_item
PASSED test_cart.py::test_total_sums_multiple_items
PASSED test_cart.py::test_apply_discount_reduces_total_by_percentage
PASSED test_cart.py::test_clear_removes_all_items

5 passed in 0.01s
```

If any test still fails, tell Claude in the chat panel:

```
Tests still failing. Fix the implementation only — do not change the tests.
```

---

## Step 5 — Adversarial pattern (advanced)

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

**Full reset** — removes generated files, restores the clean stub:

```bash
cp original/cart.py cart.py && cp original/prd.md prd.md && rm -f test_cart.py
```

**Redo from red** — keeps `test_cart.py`, resets implementation only:

```bash
cp original/cart.py cart.py
```

Verify you are back to red:

```bash
uv run pytest test_cart.py -v
# Expected: 5 failed
```
