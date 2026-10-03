#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "Workshop 1: Python")

#show: report-template.with(ribbon-text: "Workshop 1", foreground_watermark: watermark_text(content: "INTERNAL USE ONLY", gaps: 3.5pt, opacity: 50))

= General Common Mistakes
- No error handling where explicitly required (Task 1 withdrawal, Task 4 colour setter):
- Code runs but discussion questions ignored entirely
- Copy-pasted boilerplate with no evidence of understanding (e.g. can't explain their own `__lt__`)

= Task 1
Build a `BankAccount` class with a private balance (`_balance`), a `deposit()` and `withdraw()` method, and a read-only getter `balance` property. Withdrawals below zero should raise a `ValueError` instead of silently failing.

#note(title: "Check yourself")[
  Can someone do `account._balance = 999999` from outside and break it?
]

#important(title: [Discuss])[
  Python doesn't have true private attributes — this is a convention, not a wall.
]

#important(title: [Watch for])[
  people using `@property` incorrectly, or skipping validation logic entirely.
]

== Criteria
- `__init__` sets `_balance` (accepts optional starting balance)
- `deposit()` correctly increases balance
- `withdraw()` correctly decreases balance
- `withdraw()` raises `ValueError` when amount exceeds balance (or is negative) — not a silent `return`/`print`
- `balance` implemented as a *read-only `@property`* (getter only, no setter)
- Discussion: correctly identifies that `account._balance = 999999` *works* — Python has no true privacy, single underscore is convention only (name mangling with `__balance` only discouraged, not prevented)

== Common mistakes:

- Making `balance` a plain attribute instead of a `@property` (defeats the point of the exercise)
- Using `@property` but also adding a setter without being asked (shows they didn't read "read-only")
- Validating deposits but forgetting to validate withdrawals, or vice versa
- Checking `amount < 0` for withdrawal instead of checking against `_balance` (i.e., allowing overdrafts)


= Task 2
Create a base *abstract class* called `Shape` with an `area()` method that raises `NotImplementedError`. Create `Circle`, `Rectangle`, and `Triangle` subclasses that override it. Write an independent function `total_area(shapes: list)` that works on any mix of shapes without knowing their concrete type.\
Remeber to *test type*
#note(title: "hmm?")[
  should you use `isinstance` ot `type`?
]

#important(title: [Discuss])[
  explain why `isinstance` better than `type`?
]

#caution(title: [Bonus], icon: [#sym.star])[
  Add `__str__` so printing a shape gives a readable description
]

== Criteria
- `Shape.area()` raises `NotImplementedError` (base class not meant to be instantiated directly for area use)
- `Circle`, `Rectangle`, `Triangle` each correctly override `area()` with correct formulas
- `total_area(shapes: list)` sums areas without any `if type(x) == Circle` branching — genuinely polymorphic
- Uses `isinstance()` (not `type()`) anywhere type-checking is needed, e.g. validating list contents
- Discussion: explains `isinstance` vs `type` — accepts subclasses / respects inheritance, works with ABCs and multiple inheritance, `type(x) == Shape` fails for any subclass instance
- *Bonus*: `__str__` implemented, gives a readable description (e.g. `"Circle with radius 3.0, area 28.27"`)

== Common mistakes:
- `total_area` using `isinstance` chains or a type-name dispatch table instead of just calling `.area()` on each — this misses the point of polymorphism
- Forgetting to call `super().__init__()` if `Shape.__init__` exists yet — not required until Task 4
- `__str__` returning something unhelpful (e.g. just the class name)

= Task 3
Give the `Shape` classes from Task 2 support for `+`, `==`, and `<` (compare by area) using `__add__`, `__eq__`, `__lt__`. Also implement `__repr__` for debugging.

#note(title: [hmm?])[
  what is the difference between `__str__` and `__repr__`?
]

#note(title: "Check yourself")[
  Does `sorted(list_of_shapes)` work without a `key=` argument?\
  That confirms `__lt__` is correctly wired.
]

#important(title: [Discuss])[
  mention `__hash__` briefly
]

== Criteria
- `__add__` returns a sensible result (commonly: total combined area, or a documented design choice)
- `__eq__` compares by area (with reasonable float tolerance, e.g. `math.isclose`)
- `__lt__` compares by area
- `__repr__` implemented and useful for debugging (shows class + key attributes, ideally eval-able)|4|
- `sorted(list_of_shapes)` works *without* a `key=` argument
- Discussion: confirms `sorted()` works unaided as proof `__lt__` is wired correctly
- Discussion: mentions that defining `__eq__` sets `__hash__` to `None` unless explicitly restored, making instances unhashable (can't go in a `set` or be a `dict` key)

== Common mistakes:

- Using float `==` directly in `__eq__` without tolerance
- `__add__` raising or doing something nonsensical when adding two different shape types - acceptable _if_ discussed/documented
- Forgetting `__repr__` entirely and just relying on `__str__`
- Not noticing/mentioning the `__hash__` side-effect at all

= Task 4

1. Add a *class method* `Shape.from_dict(data)` as an alternative constructor.
2. Add a *static method* `Rectangle.is_square(width, height)` that doesn't need `self` or `cls`.

#important(title: [Discuss])[
  explain why this it is a good idea
]

3. Create an `Enum` class `Colour` (RED, GREEN, BLUE, WHITE) and add a `color` instance attribute with default as WHITE and add a setter to change the colour as you wish - *you should check that the instance is of the enum class*. \
_do that in the in Shape class to affect all subclasses at once_\

#tip(title: [hint])[
  add a new input to the `__init__` in the `Shape` class with type hinting: `Colour|None` and the needed implementation, use `super.__init__()` at the begining of the subclasses for shared colour initialisation without copying the implementation
]

#note(title: [hmm?])[
  If a static method doesn't touch the class at all, ask why it's a method rather than a free function?
]

== Criteria
- `Shape.from_dict(data)` implemented as `@classmethod`, returns a correctly constructed instance.
#important(title: [Explain])[
  `return cls(colour=colour_value, **data)`
  explian the `*args` and the `**kargs`, and mention the line of code explicitly; hard for them to know on theri own
]
- `from_dict` used with `cls(...)` (not hardcoded to a specific subclass name) — matters if subclasses also use it
- `Rectangle.is_square(width, height)` implemented as `@staticmethod` (no `self`/`cls`)
- Discussion: explains why `@staticmethod` here is reasonable — it's namespaced under `Rectangle` for discoverability/organisation even though it needs no instance/class state
- `Colour` implemented as an `Enum` with `RED, GREEN, BLUE, WHITE`
- `Shape` has a `colour` instance attribute, defaulting to `Colour.WHITE`
- Colour setter validates the assigned value `isinstance(value, Colour)`, raises/rejects otherwise
- `Shape.__init__` accepts an optional `colour=None` parameter, defaults to `WHITE` if `None`
- Subclasses call `super().__init__(...)` at the start of their own `__init__` for shared colour setup
- *Bug watch:* candidate must use `super().__init__()` — flag `super.__init__()` (missing parentheses on `super`) as a real, common error
- Discussion: reflects on whether `from_dict` / `is_square` could've been plain free functions — good answers note `from_dict` benefits from `cls` for inheritance-safe construction, while `is_square` genuinely could be a free function; the value of keeping it a staticmethod is purely organisational/namespacing, not technical necessity

== Common mistakes:

- Writing `super.__init__()` instead of `super().__init__()` - this is a `TypeError`/`AttributeError` at runtime, flag explicitly as a teaching moment
- Colour setter accepting any value (e.g. a string `"red"`) instead of enforcing `isinstance(value, Colour)`
- Putting the colour setter logic in a subclass instead of centrally in `Shape` (violates "in Shape class to affect all subclasses at once")
- `from_dict` implemented as a plain `@staticmethod` instead of `@classmethod` (loses inheritance benefit — subclassing `from_dict` won't return the right type)

= Code Solution
== Task 1
```python
#---------------------------------------------------------------------------
# TASK 1 — BankAccount
#---------------------------------------------------------------------------
class BankAccount:
    """
    Encapsulation via convention, not enforcement.

    `_balance` is a single-underscore attribute: a signal to other developers
    "treat this as internal", but Python will not stop anyone from doing
    `account._balance = 999999` from outside the class. There is no true
    private attribute in Python. Real safety here comes
    from convention and code review, not a language wall.
    """

    def __init__(self, starting_balance: float = 0.0):
        if starting_balance < 0:
            raise ValueError("Starting balance cannot be negative.")
        self._balance = starting_balance

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("Deposit amount must be positive.")
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive.")
        if amount > self._balance:
            raise ValueError("Insufficient funds for this withdrawal.")
        self._balance -= amount

    @property
    def balance(self) -> float:
        """Read-only. No setter is defined on purpose."""
        return self._balance

#---------------------------------------------------------------------------
# Demo / self-check (mirrors the "Check yourself" prompts from the workshop)
#---------------------------------------------------------------------------
if __name__ == "__main__":
    account = BankAccount(100)
    account.deposit(50)
    print("Balance after deposit:", account.balance)
    try:
        account.withdraw(1000)
    except ValueError as e:
        print("Correctly raised ValueError on overdraw:", e)
    account._balance = 999999  # <- this works! Python has no true privacy.
    print("Balance after 'private' attribute was hacked:", account.balance)
    try:
        account.balance = 0  # this should fail: no setter defined
    except AttributeError as e:
        print("Correctly blocked writing to read-only property:", e)
```
== Task 3,4,5
```python
#---------------------------------------------------------------------------
# TASK 2 & 3 & 4 — Shape hierarchy
#---------------------------------------------------------------------------
import math
from enum import Enum

class Colour(Enum):
    RED = "red"
    GREEN = "green"
    BLUE = "blue"
    WHITE = "white"


class Shape:
    """
    Base class. `area()` is intentionally abstracted — subclasses MUST override it.
    """

    def __init__(self, colour: "Colour | None" = None):
        # Accept None and fall back to a sensible default.
        self.colour = colour if colour is not None else Colour.WHITE

    @abstractmethod
    def area(self) -> float:
        ...

    # --- Task 4: colour as a managed property, defined once, shared by all ---
    @property
    def colour(self) -> Colour:
        return self._colour

    @colour.setter
    def colour(self, value: Colour) -> None:
        if not isinstance(value, Colour):
            raise ValueError(f"colour must be a Colour enum member, got {value!r}")
        self._colour = value

    # --- Task 4: alternative constructor ---
    @classmethod
    def from_dict(cls, data: dict) -> "Shape":
        """
        Generic alternative constructor. Because it uses `cls(...)` rather
        than a hardcoded class name, subclasses inherit correct behaviour:
        `Circle.from_dict(...)` returns a Circle, `Rectangle.from_dict(...)`
        returns a Rectangle, etc. A @staticmethod could not do this — it has
        no way to know which class it was called on.
        """
        data = dict(data)  # shallow copy so we don't mutate caller's dict
        colour_value = data.pop("colour", None)
        if colour_value is not None and not isinstance(colour_value, Colour):
            colour_value = Colour(colour_value)  # allow e.g. "red" -> Colour.RED
        return cls(colour=colour_value, **data) # hard for them

    # --- Task 3: operator overloading ---
    def __add__(self, other: "Shape") -> float:
        """Combined area of two shapes. Returns a plain float by design —
        there's no single obvious 'shape' that should result from adding
        a Circle and a Triangle, so we return the one thing that's always
        well-defined: total area."""
        if not isinstance(other, Shape):
            return NotImplemented
        return self.area() + other.area()

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Shape):
            return NotImplemented
        return math.isclose(self.area(), other.area(), rel_tol=1e-9) # or self.area() == other.area()

    def __lt__(self, other: "Shape") -> bool:
        if not isinstance(other, Shape):
            return NotImplemented
        return self.area() < other.area()

    # Defining __eq__ sets __hash__ to None automatically, making instances
    # unhashable (can't put them in a set / use as dict keys). If you need
    # shapes to remain hashable, you must restore __hash__ explicitly.
    # We do NOT restore it here because our equality is based on a mutable-
    # derived value (area depends on mutable attributes like radius), and
    # hashing mutable-derived values is a classic bug source.
    __hash__ = None

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}(area={self.area():.2f}, colour={self.colour.name})"

    def __str__(self) -> str:
        return f"{self.__class__.__name__} (colour: {self.colour.name.title()})"


class Circle(Shape):
    def __init__(self, radius: float, colour: "Colour | None" = None):
        super().__init__(colour=colour)  # shared colour init happens here
        if radius <= 0:
            raise ValueError("radius must be positive.")
        self.radius = radius

    def area(self) -> float:
        return math.pi * self.radius ** 2

    def __str__(self) -> str:
        return f"Circle with radius {self.radius}, area {self.area():.2f}"


class Rectangle(Shape):
    def __init__(self, width: float, height: float, colour: "Colour | None" = None):
        super().__init__(colour=colour)
        if width <= 0 or height <= 0:
            raise ValueError("width and height must be positive.")
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    @staticmethod
    def is_square(width: float, height: float) -> bool:
        """
        A @staticmethod: it needs neither `self` (no specific instance)
        nor `cls` (doesn't construct or inspect the class). It's a pure
        function of its arguments.

        Why make it a staticmethod instead of a free function?
        - Purely organisational: `Rectangle.is_square(3, 3)` reads clearly
          as "a rectangle concept", and it's discoverable via the class
          (tab-completion, docs) rather than floating loose in module scope.
        - It could 100% be a plain module-level function instead — there is
          no technical requirement here. This is a good discussion point:
          static methods trade a tiny bit of namespacing convenience for
          not being "real" object-oriented behaviour at all.
        """
        return math.isclose(width, height, rel_tol=1e-9)

    def __str__(self) -> str:
        return f"Rectangle {self.width}x{self.height}, area {self.area():.2f}"


class Triangle(Shape):
    def __init__(self, base: float, height: float, colour: "Colour | None" = None):
        super().__init__(colour=colour)
        if base <= 0 or height <= 0:
            raise ValueError("base and height must be positive.")
        self.base = base
        self.height = height

    def area(self) -> float:
        return 0.5 * self.base * self.height

    def __str__(self) -> str:
        return f"Triangle with base {self.base} and height {self.height}, area {self.area():.2f}"


def total_area(shapes: list) -> float:
    """
    Works on any mix of Shape subclasses without knowing their concrete
    type — pure polymorphism. No isinstance/type branching on WHICH shape
    it is; we only ever check that it IS a Shape at all.
    """
    total = 0.0
    for shape in shapes:
        if not isinstance(shape, Shape):
            raise TypeError(f"Expected a Shape, got {type(shape).__name__}")
        total += shape.area()
    return total


#---------------------------------------------------------------------------
# Demo / self-check (mirrors the "Check yourself" prompts from the workshop)
#---------------------------------------------------------------------------
if __name__ == "__main__":
    shapes = [
        Circle(3, colour=Colour.RED),
        Rectangle(4, 5),
        Triangle(6, 2, colour=Colour.BLUE),
        Rectangle(4, 4),  # a square, for is_square demo
    ]
    for s in shapes:
        print(s, "|", repr(s))

    print("Total area (polymorphic, no type-checking each shape):", round(total_area(shapes), 2))
    print("isinstance(shapes[0], Shape):", isinstance(shapes[0], Shape))
    print("isinstance(shapes[0], Circle):", isinstance(shapes[0], Circle))

    print("\n=== Task 3: operators ===")
    c1 = Circle(2)
    c2 = Circle(2)
    r1 = Rectangle(2, 2)
    print("c1 == c2 (same area):", c1 == c2)
    print("c1 == r1 (different area, isclose False):", c1 == r1)
    print("c1 + r1 (combined area):", round(c1 + r1, 2))
    print("c1 < r1:", c1 < r1)

    sorted_shapes = sorted(shapes)  # no key= needed -> confirms __lt__ works
    print("sorted(shapes) without key= :")
    for s in sorted_shapes:
        print(" ", s)

    try:
        hash(c1)
    except TypeError as e:
        print("Shapes are unhashable (expected, since __eq__ sets __hash__ = None):", e)

    print("\n=== Task 4: classmethod / staticmethod / Enum ===")
    rect_from_dict = Rectangle.from_dict({"width": 5, "height": 5, "colour": "red"})
    print("Built via from_dict:", rect_from_dict, "| colour:", rect_from_dict.colour)

    print("Rectangle.is_square(4, 4):", Rectangle.is_square(4, 4))
    print("Rectangle.is_square(4, 5):", Rectangle.is_square(4, 5))

    circle_default_colour = Circle(1)
    print("Default colour of a new shape:", circle_default_colour.colour)
    circle_default_colour.colour = Colour.GREEN
    print("Colour after setting:", circle_default_colour.colour)
    try:
        circle_default_colour.colour = "not-a-colour"
    except ValueError as e:
        print("Correctly rejected non-Colour value:", e)
```

