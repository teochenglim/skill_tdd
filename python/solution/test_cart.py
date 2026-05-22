import pytest
from cart import Cart


def test_total_returns_0_when_cart_is_empty():
    cart = Cart()
    assert cart.total() == 0


def test_total_returns_price_times_quantity_for_single_item():
    cart = Cart()
    cart.add_item("apple", price=1.50, quantity=3)
    assert cart.total() == 4.50


def test_total_sums_multiple_items():
    cart = Cart()
    cart.add_item("apple", price=1.50, quantity=2)
    cart.add_item("bread", price=2.00, quantity=1)
    assert cart.total() == 5.00


def test_apply_discount_reduces_total_by_percentage():
    cart = Cart()
    cart.add_item("apple", price=10.00, quantity=1)
    cart.apply_discount(20)
    assert cart.total() == 8.00


def test_clear_removes_all_items():
    cart = Cart()
    cart.add_item("apple", price=1.50, quantity=2)
    cart.clear()
    assert cart.total() == 0
