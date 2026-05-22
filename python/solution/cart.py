class Cart:
    def __init__(self):
        self._items = []
        self._discount = 0

    def add_item(self, name, price, quantity):
        self._items.append({"name": name, "price": price, "quantity": quantity})

    def total(self):
        subtotal = sum(item["price"] * item["quantity"] for item in self._items)
        return subtotal * (1 - self._discount / 100)

    def apply_discount(self, percent):
        self._discount = percent

    def clear(self):
        self._items = []
        self._discount = 0
