---
name: tw-tdd
description: >
  Drives TDD in an agentic red-green loop: reads a PRD section, generates
  failing tests, implements the minimal code to pass, runs the tests, and
  fixes until green. Also supports the adversarial test-agent pattern where
  tests and implementation are intentionally written by separate agents.
  Use when user says "TDD this", "write tests first", "red-green loop",
  "implement from PRD", "adversarial tests", or "agentic TDD".
  Do NOT use if the user only wants to run existing tests.
license: MIT
metadata:
  author: TW SG Platform Team
  version: 1.0.0
  team: platform-engineering
---

# TW TDD — Agentic Loop

## The loop

```
PRD section → [RED] failing tests → [GREEN] implementation → run → fix → green
```

Repeat per PRD requirement. Never skip the red phase — a test that was never
failing proves nothing.

---

## Step 1: Read the PRD section

Ask the user to paste or point to the PRD section being implemented.
Extract:
- **Behaviour**: what the system does (inputs → outputs)
- **Acceptance criteria**: measurable conditions for done
- **Out of scope**: what this section explicitly excludes

If any are missing, ask before writing tests.

---

## Step 2: Red phase — write failing tests

Write tests that:
1. Cover the happy path from the acceptance criteria
2. Cover edge cases (empty input, boundary values, error states)
3. Assert on behaviour visible to callers — not internal state

Name each test as a sentence describing the expected behaviour:
```
✅ "returns 0 when cart is empty"
✅ "raises InsufficientStock when quantity exceeds inventory"
❌ "test_calculate"
```

**Run the tests now.** They must fail with a meaningful error (not import error
or syntax error). If they don't fail, the test is wrong — fix it before continuing.

---

## Step 3: Green phase — minimal implementation

Write the simplest code that makes every test pass.
- No gold-plating, no speculative features
- Hardcoded returns are fine in green if they make tests pass; the next red test will force real logic

**Run the tests.** If any fail, fix the implementation only — never change tests to make them pass.

---

## Step 4: Fix loop

If tests still fail after the first implementation attempt:
1. Read the failure message carefully — it tells you exactly what's wrong
2. Fix the implementation
3. Run again
4. After 3 failed attempts on the same test, stop and surface the blocker to the user

---

## Step 5: Refactor (optional)

Once green, propose one refactor if there is obvious duplication or a design smell.
- Keep tests green through the refactor
- Do not add new behaviour during refactor

---

## Adversarial test-agent pattern

Use this when you want maximum test independence.

**Agent A (test writer):** reads only the PRD — no access to implementation.
**Agent B (implementer):** reads only the tests — no access to the PRD.

This prevents the common agentic failure where one agent writes tests that are
trivially satisfied by its own implementation (the agent teaches to its own test).

To run adversarially:
1. Ask Claude to write tests from the PRD, then stop — do not implement.
2. Start a **new conversation** with only the tests visible.
3. Ask the new session to implement code that satisfies those tests.
4. Run both outputs together.

If tests pass trivially without real logic → the test agent wrote weak tests.
If implementation fails → the test agent exposed a real gap in the spec.

---

## Test pyramid — choose the right layer

| Layer | Focus | When |
|-------|-------|------|
| Unit | Single function in isolation | Business logic, algorithms, edge cases |
| Integration | Multiple components together | DB queries, API handlers, service calls |
| Contract | API shape between services | Inter-service boundaries (use Pact) |
| E2E | Full user journey | Critical happy paths only — keep few |

Default to unit. Move up only when the behaviour crosses a real boundary.

---

## Structure template (AAA)

```python
def test_<behaviour>():
    # Arrange — set up inputs and expected output

    # Act — call the unit under test
    result = ...

    # Assert — verify outcome
    assert result == expected
```

---

## Gotchas

- Mock at the boundary (DB, HTTP, filesystem) — never inside business logic.
- If there are no seams to test through, that is a design problem — surface it.
- One assertion concept per test; multiple `assert` lines are fine if they verify the same outcome.
- In Python: prefer `pytest`. In JS/TS: prefer `vitest` for new code; `jest` if already established.
- Never change a test to make it pass — change the implementation.
