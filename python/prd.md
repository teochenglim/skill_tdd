# PRD: Shopping Cart — Checkout Total

## Behaviour

A shopping cart holds items. Each item has a name, unit price, and quantity.
The cart calculates the total price of all items.

## Acceptance criteria

- `add_item(name, price, quantity)` adds an item to the cart
- `total()` returns the sum of `price × quantity` for all items
- `total()` returns `0` when the cart is empty
- `apply_discount(percent)` reduces the total by the given percentage (0–100)
- `clear()` removes all items from the cart

## Out of scope

- Persistence, user accounts, payment processing
- Negative prices or quantities (assume inputs are always valid)
