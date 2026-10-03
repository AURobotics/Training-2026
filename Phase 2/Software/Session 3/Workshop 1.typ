#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "Workshop 1: Python")

#show: report-template.with(ribbon-text: "Workshop 1")

= Task 1
Build a `BankAccount` class with a private balance (`_balance`), a `deposit()` and `withdraw()` method, and a read-only getter `balance` property. Withdrawals below zero should raise a `ValueError` instead of silently failing.

#note(title: "Check yourself")[
  Can someone do `account._balance = 999999` from outside and break it?
  //(Discuss: Python doesn't have true private attributes — this is a convention, not a wall.)
]

//watch for: people using `@property` incorrectly, or skipping validation logic entirely.

= Task 2
Create a base *abstract class* called `Shape` with an `area()` method that raises `NotImplementedError`. Create `Circle`, `Rectangle`, and `Triangle` subclasses that override it. Write an independent function `total_area(shapes: list)` that works on any mix of shapes without knowing their concrete type.\
Remeber to *test type*
#note(title: "hmm?")[
  should you use `isinstance` ot `type`?
]
//*explain why `isinstance` better than `type`?*

#caution(title: [Bonus], icon: [#sym.star])[
  Add `__str__` so printing a shape gives a readable description
]

= Task 3
Give the `Shape` classes from Task 2 support for `+`, `==`, and `<` (compare by area) using `__add__`, `__eq__`, `__lt__`. Also implement `__repr__` for debugging.

#note(title: [hmm?])[
  what is the difference between `__str__` and `__repr__`?
]

#note(title: "Check yourself")[
  Does `sorted(list_of_shapes)` work without a `key=` argument?\
  That confirms `__lt__` is correctly wired.
]

// mention __hash__ briefly

= Task 4

1. Add a *class method* `Shape.from_dict(data)` as an alternative constructor.
2. Add a *static method* `Rectangle.is_square(width, height)` that doesn't need `self` or `cls`.
// *explain why this it is a good idea*
3. Create an `Enum` class `Colour` (RED, GREEN, BLUE, WHITE) and add a `color` instance attribute with default as WHITE and add a setter to change the colour as you wish - *you should check that the instance is of the enum class*. \
_do that in the in Shape class to affect all subclasses at once_\

#tip(title: [hint])[
  add a new input to the `__init__` in the `Shape` class with type hinting: `Colour|None` and the needed implementation, use `super.__init__()` at the begining of the subclasses for shared colour initialisation without copying the implementation
]

#note(title: [hmm?])[
  If a static method doesn't touch the class at all, ask why it's a method rather than a free function?
]

