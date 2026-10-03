#import "/Theme/presentation.typ": *
#show: presentation-theme
#import "@preview/codly-languages:0.1.10": codly-languages
#import "@preview/pinit:0.2.2": *

#show: codly-init.with()
#codly(
  languages: (
    python: (
      name: "",
      icon: codly-languages.python.icon,
      color: white,
    ),
    c: (
      name: "",
      icon: codly-languages.c.icon,
      color: white,
    ),
  ),
  zebra-fill: none,
  fill: white,
  number-format: none,
)

#show raw: it => {
  show regex("pin\d"): it => pin(eval(it.text.slice(3)))
  it
}

#title-slide(
  title: [OOP &\ Advanced Python],
  subtitle: "Session 3",
  topic: "Software Training | Phase 2",
)

= Object Oriented Programming <oop-part>

== Programming Paradigms

=== Procedural Programming
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    - Step-by-step instructions
    - Fulfill a specific task
    - Simple to write
    - Repetitive for complex programs
    - Must read line-by-line to understand code purpose
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
      a = 10
      b = int(input())
      print(a * b)
    ```
  ],
)


=== Functional Programming

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    - Named units of work
    - Combined to solve specific problem
    - Simple to write
    - Reusable, saves time
    - Descriptive name helps understand flow
    - In complex programs, multiple functions may still make flow difficult to trace
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
      def check(val: int) -> int:
        if val % 2 == 1:
          return shift_bit(val)
        return val

      def shift_bit(val: int) -> int:
        return val * 2

      check(int(input()))
    ```
  ],
)

=== Object Oriented Programming

Related to #emphasis[objects]. What are objects?

== Python's Data Model

=== Recall: Passing by Reference

When we passed a mutable variable to a function and modified it inside the function, the original variable was modified despite being created outside the function.

```python
def modify(var: list):
  var.append(5)

my_list = [1, 2, 3, 4]
modify(my_list)
print(my_list)
# [1, 2, 3, 4, 5]
```

This behavior is similar to passing by reference in C++. In fact, #emphasis[every] variable in Python works this way.

=== Variable Mechanics in C

Observe the following snippet:

```c
int i = 1;
i = 10;
```

What happens behind the scenes is:
- `i` gets an actual memory location, ex: `0x0080`
- A 32-bit binary representation of an integer with value 1 is placed at `0x0080`
- The value at `0x0080` changes to the 32-bit binary respresentation of 10

A variable is a #emphasis[direct alias] for a memory location.

=== Variable Mechanics in Python
Observe the following snippet:
```python
i = 1
i = 10
```

What happens behind the scenes is:
- A location in memory, ex: `0x0080`, is reserved for a _data container_ with value 1 and type `int`
- Another location in memory, ex: `0x0090`, is reserved for a _data container_ with value 10 and type `int`
- At first, `i` stores a reference to `0x0080`
- Then, `i` stores a reference to `0x0090`

=== `object` in Python

What we called a _data container_ is actually referred to by Python as `object`.

It is the basis for #emphasis[everything] in Python, including functions, modules, variables and more.

An object holds:
- Data type
- Data value (mutable or immutable)
- Unique ID (memory address in terms of C implementation)

"Variables" are just labels slapped on existing objects.

#set-ribbon(content: [Read More: https://docs.python.org/3/reference/datamodel.html])

== Implementation Extras

=== Immutable Data
In the following snippet:
```python
var = "Hello World"
var = var + "!"
```
#emphasis[Three] string objects are created:
- `"Hello World"`
- `"!"`
- `"Hello World!"`

This is three times the Python interpreter had to allocate objects and their memory.

The variable `var` starts out pointing to the first object, then ends up pointing to the third object. The original object was not modified in-place as it is #emphasis[immutable]. Mutable data's content can be modified in-place.


=== CPython Implementation Quirks

The most widely used Python interpreter is programmed in C. As a result, the underlying data structures used to store Python objects are actually C variables and structs.

Python's implementation also has a few quirks with how it manages variables and what C data types are used.

- Sometimes integers & short strings are created once, then later assignments use the same old object (interning)
- Integers are implemented with no size limit on the value (value is an array of C ints treated as digits)
- Float values are just C `double`s

== Classes & Instances

=== Definitions

*Classes* are #emphasis[blueprints] that enable us to combine #emphasis[data] & #emphasis[functions] in an organized and #emphasis[repeatable] way. You can think of classes as a complex data type. Classes also have some similarity to library namespaces in C++.

*Instances* are #emphasis[individual] real existing _objects_ made according to the class blueprint. Instances _hold the actual data_, remember their #emphasis[state], can return values with #emphasis[operations], and produce meaningful output when using their #emphasis[functions].

*Methods* are functions performed in relation to a class or object.

=== Class vs Instance -- an Analogy

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    #emphasis[Class: Car Blueprints]
    - Component descriptions
      - Engine
      - Fuel tank
      - Tires
      - Passenger seats
      - etc
    - Functionality descriptions
      - Must be refeulable
      - Must be able to move forward
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    #emphasis[Instance: Individual Cars]
    - Properties
      - Engine horsepower
      - Car model
    - State
      - Fuel level
      - Tire pressure
      - Passengers
    - Functionality
      - Push this specific car forward
      - Refuel this specific car
      - Add passengers to this specific car
  ],
)

=== Class vs Instance -- `list` Analogy
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    #emphasis[Class: `list`]
    - Component descriptions
      - Elements
    - Functionality descriptions
      - Must be iterable
      - Must be appendable
  ],
  line(angle: 90deg, length: 50%, stroke: 0.5pt + brand-palette.light_gray),
  [
    #emphasis[Instance: Individual Lists]
    ```python
    a = [1, 2, 3] # instance 1
    a.append(4) # functionality
    b = [5, 6, 7] # instance 2
    ```
  ],
)

=== Creating & Instantiating a Class

Empty class:
```python
class Cow:
    pass
    
my_cow = Cow() # instance 1
other_cow = Cow() # instance 2
print(my_cow)
print(other_cow)
# <__main__.Cow object at 0x000001863Cpin1406Fpin290>
# <__main__.Cow object at 0x000001863Cpin36E4Bpin490>
```
#pinit-highlight(1, 2)
#pinit-highlight(3, 4)

#set-ribbon(content: [Read More: https://docs.python.org/3/tutorial/classes.html#class-definition-syntax])

=== Attributes

Instances can hold modifiable data by assigning them to attributes.

```python
class Cow:
    color = "Brown"
    age = 2

my_cow = Cow()
print(my_cow.color) # "Brown"
my_cow.color = "White"
print(my_cow.color) # "White"
```

So far this is similar to dictionaries, instances and classes can be treated as a _custom mutable data type_. We will return to this similarity later.

=== Instance Attributes

Instance attributes are attributes that belong to a _specific instance_ of the class. For example, two different cows can have ages that are different in value.

Let's take an example of employees. The following code shows an `Employee` blueprint with no default attributes. We then create employees `emp1`, `emp2`. We then create an attribute `salary` and give it the value 2000 _on `emp1`_, but `emp2` has no an attribute called `salary` yet.
```python
class Employee:
  pass

emp1 = Employee()
emp2 = Employee()
emp1.salary = 2000
```
=== `__init__()`

To initialize an object with ready values, we implement the `__init__()` method and set attributes using `self.<attribute> = <value>`. We will explain what methods are and what is `self` in later slides --- see #link-ref(<instance-methods>, show-label: false).

```python
class Employee:
    def __init__(self, salary: int = 0):
        self.salary = salary

emp = Employee(salary=1_000_000) # did you know you can do this to ints?
print(emp.salary) # 1000000
```

For now: the `__init__()` method is what gets called after you create an object, it is used to apply ready initial values and do extra default setup on the instance, which  `self` refers to.

=== Instance Attributes: Recap

Attributes assigned on an instance, but not directly under a class, are called _instance_ attributes. They are unique to that instance.

Regarding `__init__()`, all attributes assigned inside the `__init__()` method for the first time and by using `self.<attribute>` are also bound to the _instance_ because the instance is passed as `self`. In the previous slide what happens behind the scenes is:\ `Employee.__init__(self=emp, salary=2000)`\ So referring to `self` is identical to referring to our instance, `emp`.

=== Class Attributes

All attributes assigned directly under the class are called _class attributes_. 

Class attributes serve as a shared storage space. They are commonly used as default values or as "meta-attributes": attributes that may store information about all objects.

Class attributes can be _read_ from the class directly or from instances too. Class attributes can only be _updated_ for the class from the class (will clarify later).

=== Class Attributes: Meta-Attribute Example

An example of a meta-attribute is a count of all instances. We can count all instances using a class attribute:
```python
class Employee:
  employees_count: int = 0
  def __init__(self, *args):
    ... # normal initialization
    Employee.employees_count += 1
    # ^ using self.__class__ is better than hard-coding "Employee" by name

emp1 = Employee()
emp2 = Employee()
print(Employee.count) # 2
```

=== Class Attributes Access Rules & Default Values

In case of accessing class attributes from instances:
- At first, instances are in a "follower" state: the attribute is still the class attribute and any changes done by a class to class attributes sync _down_ to the instances
- When modifying the attribute from the instance's context, a new copy of the attribute is created and attached only to this instance --- which now completely forgets the class attribute. Changes done to an instance attribute do not sync _up_ into the class.

In the previous example, adding a new line where we print `emp1.count` will output "2" as well.

See the next slide for an illustration of class attributes being used as default values, where they can be "shadowed" by instance attributes.


=== Class Attributes as Default Values
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    ```python
    class Employee:
        salary: int = 1_000

        def __init__(self, salary: int = 0):
            if salary:
              self.salary = salary
    ```
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    print(Employee.salary) # 1000
    me = Employee()
    print(me.salary) # 1000
    Employee.salary = 2000
    print(Employee.salary) # 2000
    print(me.salary) # 2000
    me.salary = 10_000
    print(me.salary) # 10000
    print(Employee.salary) # 2000
    new_employee = Employee()
    print(new_employee.salary) # 2000
    ```
  ],
)

#set-ribbon(content: [See also: https://youtu.be/BJ-VvGyQxho])

=== Class Attributes to Instance Attributes, an Analogy
```python
class Employee:
  salary: int = 1000 # salary in the class slot

emp = Employee()
print(emp.salary)
# - not defined in the instance
# - fallback to class slot, found

emp.salary = 1000
# - not defined in the instance slot
# - fallback to creating the attribute in the instance slot
```

=== Class-Level Declarations for Type Hinting
#[
#set text(size: 0.9em)
In many upcoming slides, you will see us _declare_ but not _assign_ a variable at the class level, then we treat these variables as instance attributes.

When you see that type of declaration, assume these attributes are _instance_ attributes. For example:
```python
class Point:
  x: int
  y: int
  def __init__(self, x, y):
    self.x = int(x)
    self.y = int(y)
```
`x` and `y` do #emphasis[not] actually exist as class attributes --- they do not exist at all, until they are assigned to the _instance_ via `self.x` & `self.y`.

This is used for *type hinting only* --- an organized reminder to ourselves of all the attributes' types.
]


=== Methods
Methods are functions that *run in relation to an object*.

Let's start with a normal function:
```python
class Cow:
    age = 1

def moo(cow: Cow):
    print(f"Mo{'o' * cow.age}!")

my_cow = Cow()
my_cow.age = 3
moo(my_cow) # "Moooo!"
```

=== Instance Methods <instance-methods>

What if we could use the instance as the scope from which we run the method, like we use the instance as the scope from which we access the attributes?

```python
class Cow:
    age = 1

    def moo(self):
        print(f"Mo{'o' * self.age}!") # notice the usage of self

my_cow = Cow()
my_cow.age = 3
my_cow.moo()  # "Moooo!", // notice how no argument is passed
```

=== Instance Methods

The last line, `my_cow.moo()`, acts like: `Cow.moo(self=my_cow)` where `Cow` is the class acting as a "scope" and `my_cow` is passed as "self".

When `my_cow` was created, Python automatically replaced all its instance methods with _bound methods_ --- versions of the methods that remember that `self` is actually `my_cow` and don't require explicitly passing `self` to instance methods.

All methods defined in a class are by default instance methods.


=== Static Methods

Static methods are methods that are independent of an instance. They can be called directly from the class, or from an instance.

- Static methods can access the class by calling its name, and can therefore use class attributes.

- Static methods are used for methods that act more like traditional functions, which makes the class a _scope_ from which you call the function. This behaves like how libraries behave, ex: `math.random()`.

=== Static Methods as Functions

What if we wanted to use classes and instances purely as scopes for functions? 

Static methods should be used for "scoping" or "grouping" functions, where an instance may not be needed. Instance methods should generally be used otherwise.

```python
import math
class Angle:

    @staticmethod
    def radians_to_degrees(val_rad: float) -> float:
        return val_rad * 180 / math.pi

print(Angle.radians_to_degrees(2)) # 114.59155902616465
```

#set-ribbon(content: [See also: https://www.youtube.com/watch?v=rq8cL2XMM5M
])

=== Static Methods as Class Actors

We could also use static methods to deal with the class: creating instances or accessing class attributes. Here is an example where we create an  `Angle` instance from a float value:

```python
import math
class Angle:
    degrees: int

    @staticmethod
    def from_radians(val_rad: float) -> Angle:
        angle = Angle()
        angle.degrees = val_rad * 180 / math.pi
        return angle
```

=== Class Methods

Class methods are an alternative to static methods that specifically need to operate on the class.

In Java, for example, it is standard to use a static method to access class attributes.

In Python, static methods that access the class are considered _fragile_ and bad practice. Python's conventions strive to:
- Create a readable distinction between pure static methods and class-acting static methods
- Avoid writing out the class name explicitly
  - In case the class name changes in the future
  - [Covered later] In case another class inherits the method and is expecting the method to act on the _child_ class not the _parent_ class

=== Class Methods: Alternative Constructors

Here is the previous static method example implemented using a class method:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    ```python
    class Angle:
        degrees: float = 0
        @classmethod
        def from_radians(cls, val_rad: float) -> Angle:
            angle = cls()
            angle.degrees = val_rad * 180 / math.pi
            return angle
    ```
  ],
  line(angle: 90deg, length: 60%, stroke: 0.5pt + brand-palette.light_gray),
  [
    Class methods prevent confusion for when you change the class name later for any reason, and (for later) they work nicely with inheritance.
    ```python
    angle = Angle.from_radians(2)
    # ^ this is an Angle INSTANCE
    ```
  ],
)

#set-ribbon(content: [See also: https://www.youtube.com/watch?v=rq8cL2XMM5M
])

=== Class Methods

Like instance methods, marking a method as a class method replaces it with a _bound method_ that automatically passes the class as the first argument.

Similar to how the instance parameter is called `self` by convention in instance methods, the class parameter in class methods is called `cls`.

Class methods should be used to avoid hard-coding the name of the class inside a static method. If you need to reference the class inside an _instance_ method, utilize `self.__class__` instead, to avoid hard-coding the name of the class as well. This will make more sense in terms of #link-ref(<inheritance>, show-label: false).

=== Extra: Decorators

`@staticmethod` and `@classmethod` are decorators that modify the arguments needed for a method.

A decorator is a function wrapper that slightly alters its behavior. Here's an example similar to how a `@staticmethod` decorator works:

```python
def auto_ten_decorator(func):
    def wrapper(*args, **kwargs):
        return func(10, *args, **kwargs) # <- HERE
    return wrapper
```

=== Extra: Decorators

```python
@auto_ten_decorator
def times(a, b):
    return a * b

print(times(6)) # 60
```

In the previous example, the `auto_ten_decorator` automatically injects `10` as the first argument in any function it's used on, making only the remaining arguments necessary.

Using it with a multiplication function turns it into a times-10 function.


=== Extra: Better Default Arguments
Since `(if salary)` in the previous snippet assumed `0` is not a valid salary, it worked fine. What if all integers were valid salaries? We can utilize Python's dynamic typing to our advantage and use `None`:

```python
class Employee:
    salary: int = 1_000
    def __init__(self, salary: int | None = None):
        if salary is not None:
            self.salary = salary
```

This gives us a clear distinction between what should be a "no-input" value, and a valid --- even if `(== False)` --- value.


=== Class-Level Constants

We can define class-level "constants", where a constant is by convention a variable whose name is all upper-case. We can use it for scoped auto-completion or inside methods:
#grid(
  columns: (1fr, auto, 1.2fr),
  gutter: 1cm,
  [
    ```python
    class Values:
        BEST = 5
        WORST = 0

        value = 0
    ```
    We can use `Values.BEST` for example, or we can use `self.__class__` to get the class in _instance methods_ without explicitly naming it.
  ],
  line(angle: 90deg, length: 50%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    def am_i_best(self) -> bool:
        return self.value == self.__class__.BEST

    @classmethod
    def print_rating(cls, value):
        if value == self.__class__.BEST:
          print("BEST")
        else:
          print("Not BEST")
    ```
  ],
)

== Basic OOP Principles

=== OOP Principles
We use OOP to provide us with the following benefits:

- Abstraction
- Encapsulation
- Inheritance
- Polymorphism

=== Abstraction

Abstraction is when code is implemented with:
- Hiding implementation details
- Exposing easy-to-understand functionality
- Automatically managing resources

The most basic form of abstraction we have used so far are functions.

As an example, the #emphasis[set] data type implements an `add()` method that automatically handles the following:
- Checks for duplicates
- Expands the set's container
- Places the new element in the last slot in the container
- Tracks the new size of the container


=== Abstraction

Logic & resource management are hidden from people using `save()`:

```python
class VideoDownloader:
    def __init__(self, url):
        self.url = url
    
    def save(self, filepath="video.mp4"):
      r = requests.get(self.url)
      with open(filepath, "wb") as f:
        f.write(r.content)
  
```

=== Encapsulation

The purpose of encapsulation is to:
- Manage access to attributes and methods
  - Private attributes & methods
  - Public attributes & methods
  - Read-only attributes, write-only attributes
- Utilize hidden information internally, expose a clean interface externally
  - _Abstraction using internal information & algorithms_


=== Encapsulation

In the following, we use multiple attributes for our abstraction of the `apply_raise` method:
#[
#set text(size: 0.9em)
```python
class Employee:
    experience: int 
    has_penalty: bool
    salary: int
    is_manager: bool
    # ^ assume __init__() exists and initializes these variables
    def apply_raise(self, other: Employee):
        if not self.is_manager:
            return
        if other.has_penalty:
            return
        other.salary *= 1 + other.experience / 10
```
]

=== Encapsulation: Private Attributes

By convention, a private attribute is an attribute whose name begins with an underscore.

"Private" attributes are not really private in Python, the IDE just hides them by default until you go looking for them.

In this example, the user would understand that `_content` is not meant for them to access, but `get_line()` is:
#[
#set text(size: 0.88em)
```python
class FileReader:
    def __init__(self, path: str):
        with open(filepath, "r") as f:
            self._content = f.readlines()

    def get_line(self, index: int = 0) -> str:
        return self._content[index]
```
]

=== Encapsulation: Getters & Setters

To control access to attributes, we use getters and setters.
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
    #emphasis[Getters:]
    ```python
    class Person:
        _name: str
        # initialized in __init__

        def get_name(self) -> str:
            return self._name

    p = Person("Adam")
    p.get_name() # Adam
    ```
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    #emphasis[Setters]
    ```python
    class Person:
        _name: str
        # initialized in __init__

        def set_name(self, name):
            self._name = name

    p = Person("John Doe")
    p.set_name("Doe John")
    ```
  ],
)

=== Encapsulation: Getters & Setters with Access Control

#[
#set text(size: 0.9em)
We may choose to implement either a setter or a getter or _both_ for any private attribute.

It depends on whether we want people to modify or read, or do both, to our attribute.

We may also add extra logic to setters and getters.

Here is an example of extra logic in the setter, and where the attribute is write-only:

```python
class User:
    def __init__(self, username, password, password_service):
        self.username = username
        self.password_service = password_service

    def set_password(self, new_password):
        self.password_service.update(username=self.username, password=new_password)

```
]

=== Encapsulation: Properties

The _Pythonic_ way of implementing getters and setters is using `@property`.
Here is an example implemented properly using properties:

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 0.8cm,
  [
    #emphasis[Class]
    ```python
    class User:
      def __init__(self, username, password, password_service):
        self._username = username
        self._password_service = password_service
    ```
  ],
  line(angle: 90deg, length: 50%, stroke: 0.5pt + brand-palette.light_gray),
  [
    #emphasis[Getters & Setters]
    ```python
      @property
      def username(self) -> str:
        return self._username

      @username.setter
      def username(self, new_username):
        self._username = new_username
    ```
  ],
)
Note: property declaration is also a getter implementation, setters use the property's name.


=== Encapsulation: Properties, Continued
#[
#set text(size: 0.9em)
```python
class User:
  # ... previous username setters and getters
  @property
  def password(self):
    raise PermissionError()

  @password.setter
  def password(self, new_password):
    self.password_service.update(username=self.username, password=new_password)
```

We must define the `@property` which acts like a getter, so if we want a write-only variable we raise an error inside it.

If we don't want the variable to be writeable and want it to be read-only, we can simply omit the setter.
]
=== Encapsulation: Using Properties

Using properties looks the same as using an ordinary attribute, but behind the scenes the property method is called.

So, using properties:\ `user.password = "new password"`\ functionally becomes the same as the old setter approach:\ `user.set_password("new password")`

Properties should behave fully like attributes. If your property does any extra background logic that can fail, raise exceptions, or use long-running operations that cause delays, consider switching to normal setters and getters or explicit methods.

=== Inheritance <inheritance>

Classes & OOP introduce an advanced feature called inheritance.

A class can inherit method definitions and attributes from its parent class, making the parent class a reusable unit that can be used with other child classes.

#emphasis[Everything in Python inherits the `object` class.]


=== Inheritance: Methods
Methods and attributes are inherited by the subclass:
```python
class A:
    def desc(self):
        print("Hello World")

class B(A):
    pass

b = B()
b.desc() # "Hello World"
```


=== Inheritance: Overriding & Precedence

Like with class attributes and instance attributes, a subclass "follows" the methods of the parent if the method exists in the parent _but not in the subclass_.

Overriding is the term used for changing this behavior. Consider the same `A` class:

```python
class C(A):
    def desc(self):
        print("Hello from C")

a = A()
c = C()
a.desc() # "Hello World"
c.desc() # "Hello from C"
```

=== Inheritance: Reducing Boilerplate
#[
#set text(size: 0.9em)
In this example, the throttle method applies to all cars using the same calculation, but each car's fuel consumption depends on its horsepower --- attribute value overridden, functionality identical:
```python
class Car:
    fuel: int
    horsepower: int
    
    def throttle(self, percent: int):
        self.fuel -= self.fuel * horsepower * percent / 100_000

class Ferrari(Car): # can use ferrari.throttle(100)
    def __init__(self, fuel: int = 60):
        self.fuel = fuel
        self.horsepower = 850
```
]


=== Inheritance: Overrides & `super()`

#[
#set text(size: 0.89em)
You may have a class `A` that implements a function, and a class `B` that's meant to _extend_ the implementation or fall back to `A`'s implementation.

Here is how that's done:
```python
class A:
  def check_even(self, value) -> bool:
    return value % 2 == 0

class B(A):
  def check_even(self, value) -> bool: # extension: checks even (mirrored) strings
    result = False
    if isinstance(value, str):
      result = value[:len(value)//2] == value[len(value)//2:]
    return result if result is True else super().check_even()
```
]

=== Inheritance: Overrides & `super()` in `__init__()`

```python
class Human:
  def __init__(self, name: str, age: int):
    self.name = name
    self.age = age

class Employee(Human):
  def __init__(self, name: str, age: int, salary: int):
    super().__init__(name, age) # calls Human.__init__(self, name, age)
    # now name and age are set
    self.salary = salary
```


=== Multiple Inheritance
#[
#set text(size: 0.9em)
Multiple inheritance is when a class subclasses multiple parent classes. The order of resolving access to attributes and methods can be assumed to be "left to right" in most cases, but the `.mro()` method on objects gives an inheritance order overview.
```python
class Person:
  name: str
  age: int
class Employee(Person):
  salary: int
class Parent(Person):
  child: Person

class EmployedParent(Parent, Employee):
  pass # has name, age, salary & child
```
]

=== Multiple Inheritance: Name Mangling

Consider this problematic code:
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
```python
class A:
  name = "A"
  def print_a(self):
    print(self.name)
class B:
  name = "B"
  def print_b(self):
    print(self.name)
```
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    class C(A, B):
      pass

    c = C()
    c.print_a() # "A"
    c.print_b() # "A"
    ```
    This happens because `.name` was inherited by `C` from `A`. When it is accessed by any method, it remains `"A"`.
  ]
)

=== Multiple Inheritance: Name Mangling

Python's solution is: name mangling. An attribute that starts with two underscores can only be used in the context of the class that it belongs to.
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
```python
class A:
  __name = "A"
  def print_a(self):
    print(self.__name)
class B:
  __name = "B"
  def print_b(self):
    print(self.__name)
```
  ],
  line(angle: 90deg, length: 60%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    class C(A, B):
      pass

    c = C()
    c.print_a() # "A"
    c.print_b() # "B"
    ```
    `B.__name` is unique to `B` only, `A.__name` is unique to `A` only. This is called name mangling.
  ]
)

=== Inheritance: Contracts

Consider the following case: you are working on a class that takes a camera object and obtains a picture frame from it. All you need to know is that a camera can give you a frame.

We call this a "contract" or "interface". A camera's contract with you is that you can access a frame from it.

Your teammate is working on implementing the camera object, he tries to use multiple different libraries and different cameras with unique characteristics and resource handling features.

How do you give him a blueprint of what *you* need?


=== Inheritance: Abstract Base Classes
#[
#set text(size: 0.9em)
Abstract base classes, or ABCs in Python, are classes that define #emphasis[abstract methods] --- methods that have a signature, but no body. You can not create an instance of an ABC, only subclass it.

Here is the ABC needed for our camera interface from the previous slide, notice the `...` used in the `@abstractmethod` method and how it doesn't do anything.

```python
from abc import ABC, abstractmethod
from .vision import Frame

class Camera(ABC):

    @abstractmethod
    def get_frame(self) -> Frame:
        ...
        #^ an Ellipsis() object, used to indicate "look for implementation elsewhere"
```
]

=== Abstract Base Classes

Abstract base classes in Python can have attributes and can have _concrete_ methods. Concrete methods are methods which have an implementation --- in contrast to abstract methods.

For a class to be truly abstract, it has to have at least one abstract method. Truly abstract classes can not be instantiated without being subclassed first and having all their abstract methods overridden by concrete implementations.

Abstract classes can implement common methods that are expected to be the same everywhere, but keep specific methods abstract for different subclasses to implement on their own.

=== Inheritance: Implementing Interfaces

To subclass and implement an ABC, you must implement all abstract methods in it.
```python
from typing import override

class Fujitsu(Camera):
  def __init__(self, camera_path):
    self._camera_device = open(camera_path)

  @override
  def get_frame(self) -> Frame:
      return self._camera_device.get_frame("rgb", 1080, 1920)
```

Use of `@override` for overrides is optional and conventional, makes code more readable.

=== Inheritance: Laying Out the Contract

Let's make a consumer function that takes a camera and saves its frame to a file:
```python
def save_frame(camera: Camera, file_name: str):
  with open(file_name, "wb+") as f:
    f.write(camera.get_frame().content)
```

Now we obviously can not pass a _direct_ instance of `Camera` since it is an abstract class, but we can pass an instance of any _subclass_ of `Camera`:
```python
my_camera = Fujitsu()
save_frame(my_camera, "nice_picture.png")
```

=== Polymorphism

Polymorphism is the principle that dictates that an object that fulfills a specific functionality can be used towards that functionality regardless of its class(es).

In other words: what matters is what you have/ can do; not who you are.

Here is an analogy:

#emphasis[Inheritance]~~~~~~~~we need a document printed. We don't care whether you use a laser printer or an inkjet printer as long as you use a printer.

#emphasis[Polymorphism]~~we need to quickly note something down. We don't care whether we use a computer program or pen and paper or print a document or send a message to ourselves. As long as we noted the thing down, we're satisfied.

=== Polymorphism in Code

```python
class RemoteControlledBoat:
  def swim_to(self, location): ...
  
class LifeGuard:
  def swim_to(self, location): ...
  
def get_water_object(swimmer, location):
  swimmer.swim_to(location) # swimmer can be a boat or a life guard
```

=== Validation: Type Checking, Inheritance, Polymorphism

The way we type-hint our functions and validate their arguments differs according to the approach we take.

Similarly, the validation techniques will shape our understanding of which approach we take in any given function.

=== Validation: Type Checking

When to use:
- Compatibility & compliance
  - Databases
  - Communications
- Specific functionality
  - Scientific calculations
  - Information on user interfaces

For example, it makes sense to use an integer as a unique ID in databases. It also doesn't make sense to make a mathematical function that takes strings.

In these cases we use strict type checking.

=== Validation: Type Checking

Type checking can utilize either the `type()` function or the `isinstance()` function.

```python
def add(a: int, b: int) -> int:
  if type(a) == int and type(b) == int:
    return a + b
  else:
    raise TypeError()
```
or
```python
def add(a: int, b: int) -> int:
  if isinstance(a, int) and isinstance(b, int):
    ...
```

=== Validation: Type Checking vs Inheritance

The `isinstance(<object>, <class>)` function checks if `<object>`'s class is a subclass of `<class>` at any point in the inheritance tree.

`isinstance()` is the function of choice for inheritance validation. So why is it encouraged over `type()` in normal type checking? Because typically subclass objects only _add_ functionality, not change existing functionality.

Sometimes we need very strict checking where we can not afford _any_ additional or changed functionality. In that case we use `type()`.

There are cases where inheritance is particularly important to check.

=== Validation: Inheritance
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
```python
class Bird:
  def fly(self):
    print("*flaps wings*")

class Duck(Bird):
  def fly(self):
    print("*quacks & flaps*")
```
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    This fails for `watch(Duck())`, which is incorrect behavior:
    ```python
      def watch_bird(bird: Bird):
        if not type(bird) == Bird:
          raise TypeError()
    ```
    Which is why we use `isinstance()`:
    ```python
    def watch_bird(bird: Bird):
      if not isinstance(bird, Bird):
        raise TypeError()
    ```
  ],
)



=== Validation: Polymorphism (Duck Typing)

Let's say we are working in catering and we have to slice cakes, pizzas and all sorts of other foods that are _sliceable_.

We could check directly if the object we receive has the method "slice", and use it instead of looking at its class.

This is called "Duck Typing" --- referring to the English saying "If it walks like a duck and quacks like a duck, then it is a duck". In our example, if the object has a method "slice", then we can assume it's sliceable.


=== Validation: Duck Typing
```python
class Cake:
  def slice(self): ...

class Pizza:
  def slice(self): ...

def cater_food(food, number_of_people):
  for i in range(number_of_people):
    food.slice()

cake = Cake()
cateer_food(cake, 10) # calls cake.slice() 10 times
```

=== Validation: Duck Typing -- Strategies

Validation in duck typing is done by directly accessing the object's attribute or method. If it doesn't exist, Python raises `AttributeError`.

As will be discussed extensively in a #link-ref(<protocols>), we can use `hasattr()` on our object to _check first_ if it has the attribute, and then gracefully return if we don't want the exception to be raised.

`hasattr()` is used like so:
```python
cake = Cake()
hasattr(cake, "slice") # True
```

=== Validation: Polymorphism vs Inheritance

What if we received a piece of paper in `cater_food()`, and paper is "sliceable" since it has a slice method, would this be intended behavior?

It would not be. As a result, in stricter programs, inheritance is preferred over duck typing. Other strategies for getting the best of both worlds will be discussed later.

Duck typing should only be used for very generic functions that are expected to be the same everywhere.

As we will discuss in #link-ref(<part-internals>), Python uses a hidden `__str__(self)` method in classes to implement a universal `str(<object>)`. This is an example of proper duck typing, as "let's produce a string representation" is a very generic and universal functionality.


== SOLID Principles

=== SOLID Principles

SOLID refers to a set of 5 _design convention_ principles used with OOP. Good code is usually SOLID-compliant code.

The principles are:
- Single Responsibility Principle
- Open/Closed Principle
- Liskov's Substitution Principle
- Interface Segregation Principle
- Dependency Inversion Principle


#set-ribbon(content: [Read more: https://simple.wikipedia.org/wiki/SOLID_(object-oriented_design)])

=== Single Responsibility Principle

The single responsibility principle states that a class should have one reason to change, or one purpose to fulfill.

A class should not be managing multiple domains of functionality at once.

=== Single Responsibility Principle

Let's design a system that tracks employee's working hours and salaries, and handles salary raises according to a company policy.

This system has 3 separate responsibilities. According to SRP, we should use 3 classes for it.

If, for example, the company decided to change the employee salary tracking requirements to add things like monthly insurance and credit we would change the employee salary tracking class. This will be the only _reason_ for which we are allowed to touch the employee salary tracking class.

This keeps other classes untouched, for example the class that tracks working hours doesn't gain any new attributes or methods.

=== Open/ Closed Principle

The principle dictates that a class should be open to extension, but closed for modification.

This means that if a class does its job well for a specific purpose, you should avoid modifying it to add extra options to that purpose.

If you want to extend the functionality, you should use subclassing instead.

=== Open/ Closed Principle

If you have a class that implements credit card payments well, and you want to implement transfer payments, you should make a different class.

Ideally, you should also make them both subclasses of an abstract class for payments in general.

=== Extra: OCP + Strategy Pattern

This principle is usually paired with a design pattern called the #link("https://www.geeksforgeeks.org/system-design/strategy-pattern-set-1/", [Strategy Design Pattern #emoji.chain]).

In the strategy pattern, the class that _chooses_ which payment method to use -- per our example -- does so by creating an instance inside of its method based on a _pre-defined list of options_ (strategies).

By creating an instance of the "strategy" instead of subclassing it, we also achieve another pattern of Composition over Inheritance.

#set-ribbon(content: [Read more: https://en.wikipedia.org/wiki/Strategy_pattern])

=== Liskov's Substitution Principle
LSP states that subclasses should be substitutable for their base classes.

This principle refers to inheritance and polymorphism and states that if done incorrectly, they lead to unexpected behavior.

One reason unexpected behavior may occur is if a class doesn't implement all of its parent methods:
```python
class A:
  def something(self): ...

class B(A):
  def something(self):
    raise NotImplementedError()
```


=== Liskov's Substitution Principle

Another reason unexpected behavior may occur is if a class has the same signature as the expected interface, but not the same overall logic.

Recall our example on sliceable foods and sliceable paper.

Another kind would be if a subclass implements the same methods, but tweaks them in an unexpected way.

Ex: `Rectangle` may have `width` & `height`, and `Square` subclasses `Rectangle`. A function `area(r: Rectangle)` returning width #sym.times height will be proper polymorphism. A function `stretch(r: Rectangle)` that alters the `height:width` ratio will be bad polymorphism.

Ex: `File` implements a `copy()` method and `Shortcut` which subclasses `File` implements `copy()`. Should `Shortcut.copy()` create a new shortcut or create a new copy of the original file? Would a function that got a group of `File`s and `Shortcut`s in one list know?


=== Interface Segregation Principle

Similar to the `NotImplementedError` problem in LSP, ISP dictates that it is always better to subclass multiple interfaces or classes than to make one base class and not implement everything when subclassing.

In other words, each simple functionality group should be split into its own abstract class.


=== Interface Segregation Principle

An `Animal` abstract class which has `walk` and `swim` as methods is not good, because not all animals can walk and/ or swim.

Therefore you should have an interface or abstract class that is `SwimmingAnimal` and `WalkingAnimal`. Since walking and swimming here refers to animals and aren't very generic, they should subclass `Animal`.

```python
class Animal(ABC):
  ...
class WalkingAnimal(Animal):
  @abstractmethod
  def walk(self): ...
```

=== Dependency Inversion Principle

Your logic implementation classes should not depend on low-level concrete classes. It should depend on an abstraction --- a contract --- so it knows _what_ is happening, not _how_ it's happening.

Let's say we have different payment methods that are created with different initial attributes:
- Online payment
  - Bank card details
- Transfer
  - Transfer reference ID
  - Transfer status
  - Amount transferred

For an order to be placed, we only need the order items, the "pay" function and the price.

=== Dependency Inversion Principle

This is the way it should look like. The payment logic is hidden from the order logic, it only cares that the order is paid for.
#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1cm,
  [
```python
class Payment(ABC):
  @abstractmethod
  def pay(self, amount): ...
class OnlinePayment(Payment):
  ... # concrete pay()
class TransferPayment(Payment):
  ... # concrete pay()
```
  ],
  line(angle: 90deg, length: 50%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    class Checkout:
      def __init__(self, items, payment_method: Payment):
        ...
      def order(self):
        price = items.price
        self.payment_method.pay(price)
    ```
  ],
)

To actually place the order, we need a menu where the collection of payment information occurs and then the payment method is created and send to the checkout menu.

=== Dependency Inversion Principle &\ Dependency Injection Pattern

What we described in the end of the previous slide is called "Dependency Injection".

The payment information collection menu injects the finalized `Payment` object into the checkout menu.

```python
items = OrderItems(input("Enter your order details: "))
card_number = input("Enter your card number: ")
cvv = int(input("Enter your CVV: "))
payment_method = OnlinePayment(card_number, cvv)

checkout = Checkout(items, payment_method)
checkout.order()
```

#set-ribbon(content: [Read more: https://en.wikipedia.org/wiki/Dependency_injection])

= Python Internals & Clean Code <part-internals>

== Overloading

=== Overloading Definition

Overloading refers to having a function that has the same name but has a different type signature for different uses. It is the second branch of polymorphism that is overlooked when dealing with Python.

For example we can have a `set_date()` method that can either take a string representation of the date and process it, or take an integer representing the current time in seconds (Unix timestamp).

In statically typed compiled languages, the compiler decides which overload to use based on the types used in arguments. Instead of the arguments morphing to suit the method as with the type of polymorphism discussed previously, the method morphs to take in the argument.

=== Overloading in Python

Python has no actual overloading capability, but it has something far more powerful.

Overloading is done by creating hint signatures, but implementing the checks yourself. You must have at least two overloads and one separate implementation.

Overloading in Python can be done in one of, or a mix of, two ways:
- Type checking
- Keyword arguments

=== Basic Overloading
```python
from typing import overload
class Database:
  _users: dict[int, User] # the key is an int ID
  @overload
  def get_user(self, user_id: int) -> User: ... # overload hint 1
  @overload
  def get_user(self, user_id: str) -> User: ... # overload hint 2
  
  def get_user(self, user_id: int | str) -> User: # implementation
    if isinstance(user_id, str):
      user_id = int(user_id)
    return self._users[user_id]
```

=== Keyword-Based Overloading
#[
#set text(size: 0.83em)
Instead of checking types, you check if an optional keyword argument was set or was `None`.

Let's start with the implementation:
```python
class Kitchen:
  # overloads go here
  def cook(self, rice: Rice | None = None, veggies: Vegetable | None = None) -> RiceMeal | VegMeal | MainCourse:
    if rice and veggies:
      return MainCourse()
    elif rice:
      return RiceMeal()
    elif veggies:
      return VegMeal()
    else:
      return ValueError("Need at least one ingredient")
```
]

=== Keyword-Based Overloading: Continued
This is what would've went in place of the overloads:
```python
@overload
  def cook(self, rice: Rice) -> RiceMeal: ...
  @overload
  def cook(self, veggies: Vegetable) -> VegMeal: ...
  @overload
  def cook(self, rice: Rice, veggies: Vegetable) -> MainCourse: ...
```

Overloading is Python is usually avoided in favor of SOLID principles like interface segregation and single-responsibility.

For a limited set of options, we can use normal inheritance or mixins. For a wide array of options, we use the strategy design pattern or a `Meal` class with class methods that cook it.


== Design Patterns

=== Why design patterns?

We briefly mentioned a few _behavioral design patterns_ in the previous slides. What are design patterns and how do they differ from design principles?

Design patterns are conventions around _concrete_ implementations that adhere to the _conceptual_ design principles.

Their purpose is to make programs efficient and easier to read and debug.

There are 3 main categories of design patterns:
- Creational
- Structural
- Behavioral

We will leave design patterns for self-study, but we'll discuss a few important ones for clean code and understanding what Python does internally.

#set-ribbon(content: [Read more: https://refactoring.guru/design-patterns/catalog])

=== Singleton Pattern

A singleton pattern is a creational pattern that ensures that a specific class is only instantiated once. Whenever an instantiation is attempted again, the first created object is returned instead.

Singletons are critical for uses where a resource can not be shared multiple times, like a database that should only have one connection or a camera device that can only be opened by the operating system once.

Singletons are used in Python all over the place. `None` is a singleton of `NoneType`, you can not instantiate `NoneType` yourself. `True` and `False` similarly with `bool`. This is why we use the operator `is` for comparison with them, not `==`, since they are created once and have the same `id()` value everywhere.

Singletons are also used by Python when you import a library. The library, or module, is imported only once per program and is re-used whenever you import it subsequently.

=== Strategy
#[
#set text(size: 0.85em)
A strategy pattern is a behavioral pattern that allows us to choose which algorithm runs our logic. We may choose between strategies that produce a similar result but deal with different inputs, or strategies that produce different results based on our needs.

```python
class Communication(ABC):
  def __init__(self, recepient):
    self.recepient = recepient
  @abstractmethod
  def send(self, message): ...
class Email(Communication):
  def send(self, message): ...
class SMS(Communication):
  def send(self, message): ...

message_scheduler.schedule_message(content, SMS(recepient), "10pm")
```
]

=== Proxy

The proxy pattern is a behavioral pattern that allows you to control access to an object's methods and attributes and perform actions before or after access.

Among many other things, it may be used to introduce #link("https://en.wikipedia.org/wiki/Thread_safety", [thread-safety #emoji.chain]) or a safe "object selector" to any class.

== Special Methods

=== Special Methods

Special methods, or _dunder_ methods in Python are methods that are specialized and are typically used with Python operations.

They are called _dunder_ methods because they container #highlight[d]ouble #highlight[under]scores in their name, like `__init__`.

We can classify these special methods into a few categories that are important for our uses:
- Arithmetic & Logic Operators
- Comparison Operators
- Collection Operators
- Conversion Methods
- Object Creation Methods & Attribute Operators

#set-ribbon(content: [Read more: https://www.pythonmorsels.com/every-dunder-method/])

=== Operators

In Python, all operators are implemented as _dunder_ methods -- except for the `is` operator which is evaluated by the interpreter directly.

When you write a string addition like `s = "Hello " + "World"`, what gets called is a an addition method under `str`, called `__add__`.

An operator is usually accessed in one  of 3 ways:
- Syntactic expression: `a + b`; `b[0]`; `b.attribute_name`
- Built-in function: `add(a, b)`; `getitem(b, 0)`; `getattr(b, "attribute_name")`
- Actual implementation, _dunder_ method: `a.__add__(b)`; `b.__getitem__(0)`; `b.__getattr_("attribute_name")`

#set-ribbon(content: [Read more: https://docs.python.org/3/library/operator.html#mapping-operators-to-functions])

=== Operators: String Multiplication

Have you ever wondered why Python strings can be multiplied by integers? Well here's a re-enactment of how:

```python
class str:
  def __mul__(self, count: int) -> str:
    result = self
    for _ in range(count):
      result += self
    return result
```

When you write `s = "Hello" * 5`, what's called is `"Hello".__mul__(5)`, which we previously established translates to `str.__mul__("Hello", 5)`.

You can go ahead and test other expression, like maybe `int.__add__(1, 1)`

=== Binary Operators 

Binary operators are operators that take #emphasis[two operands], like how addition takes two operands. Most of comparison, arithmetic and logic operators are binary operators.

A unary operator is something like the logic not `~` (inversion) operator, it flips the bits of one operand for example.

Binary operators are evaluated left to right, so the first operand is the one whose _dunder_ method is called.

When the first operand's method fails, the second operand's method is called.

For example, if `int.__add__(2, 1.5)` fails, `float.__radd__(1.5, 2)` is tried and succeeds. The reason the second one is called `__radd__` is that it's the #highlight[r]ight handed evaluation.

This is what happens when you write `2 + 1.5` behind the scenes.

=== Operator Overriding Demo

```python
class Fraction:
  def __init__(self, numerator: int, denominator: int):
    self.numerator = numerator
    self.denominator = denominator

  def __add__(self, other: Fraction) -> Fraction:
    if not isinstance(other, Fraction):
      raise NotImplementedError()
    new_num = self.num * other.denom
    new_num += other.num * self.denom
    new_denom = self.denom * other.denom
    return Fraction(new_num, new_denom)
```

=== Operator Overloading

What if we wanted to implement `<Fraction> + <int>` as well?

```python
...
def __add__(self, other: int | Fraction) -> Fraction:
  if isinstance(other, Fraction):
    ... # old functionality
  elif isinstance(other, int):
    numerator = self.numerator + self.denominator * other
    return Fraction(numerator, self.denominator)
  else:
    raise NotImplementedError()
```

=== Collections
A collection refers to a data structure that contains a group of other variables that can be accessed and may be modifiable (dicts, lists, sets) or sequential (lists, tuples, strings).

All Python collections can be checked in a polymorphism-like manner by checking against classes from `collections.abc`.

Collections can be be:
- Iterable (`Iterable` or `Collection`) --- can use `for i in my_collection`
- Sequential (`Sequence`) --- can use fast, contiguous, 0-based indexing
- Unordered (`Set`) --- like sets: non-sequential, unordered data, but iterable
- Mutable (`MutableSet` or `MutableSequence`) --- can set, modify and delete items

We can use the classes in brackets for type-hinting and checking containers passed to our functions for their features.

#set-ribbon(content: [Read more: https://docs.python.org/3/library/collections.abc.html#collections-abstract-base-classes])

=== Collection Operators

Here are a few important use cases and which method implements them:
#align(center)[#table(columns: 2,
[`if a in my_list:`], [`my_list.__contains__(a)`],
[`for a in my_list`], [`my_list.__iter__()`],
[`my_dict["my key"]`], [`my_dict.__getitem__("my key")`],
[`my_dict["my key"] = "my value"`], [`my_dict.__setitem__("my key", "my value")`],
[`len(my_list)`], [`my_list.__len__()`],
[`del my_dict["my key"]`], [`my_dict.__delitem__("my key")`],
[`reverse(my_list)`], [`my_list.__reversed__()`]
)
]

#set-ribbon(content: [Read more -- iterables & iterators: https://docs.python.org/3/library/stdtypes.html#container.__iter__])

=== Custom Collection: Permanent Dict
Let's create a dict that supports insertion and retrieval but not modification:
```python
class PermanentDict:
  def __init__(self):
    self._data = {}
  def __getitem__(self, key):
    return self._data[key]
  def __setitem__(self, key, value):
    if key not in self._data:
      self._data[key] = value
    else:
      raise TypeError("PermanentDict does not support item modification")
```


=== Conversion Methods

Converting an object to a basic data type has special methods for it too. Things like `__int__()`, `__str__()`, `__bool__()`.

This is straightforward, with only two caveats to note.

+ `__str__()` is called with `str(obj)` and f-strings, but not `print(obj)`. Directly printing actually calls a different method: `repr(obj)` or `__repr__()`, which is a string method made specifically for debugging. With `repr()` you get the internal #highlight[repr]esentation of the object.
+ `bool(obj)` calls `obj.__bool__()`, if `False`, it tries `obj.__len__()` next.

=== Object Creation & Attribute Methods

- Object lifetime: `__new__()`, `__init__()`, `__del__()`
- Object attributes: `__getattr__()`, `__setattr__()`

=== `__new__() vs __init__()`

The `__new__()` method is the method that _actually_ returns the created object. `__init__()` takes over afterwards and sets up the initial values and settings.

Overriding `__new__()` can be useful for implementing a #emphasis[Singleton] design pattern with the help of class attributes -- a pattern where only one instance of the object is allowed to exist.

=== `__new__()` for Singletons

```python
class Database:
  _instance = None
  def __new__(cls, *args, **kwargs) -> Database:
    if cls._instance is None:
      cls._instance = super().__new__(cls) # super() is the "object" class, this is how objects are created
    return cls._instance
  def __init__(self, connection = None): ...

db1 = Database()
db2 = Database() # returns the same object created by db1
id(db1) == id(db2) # True
```

=== `__del__()`

The `__del__()` method is called when an object is no longer held by any variable and is garbage-collected.

Its use is discouraged, but you can use it for cleaning up resources managed by an object.

Context managers, the special methods used for the `with` keyword, are better for resource handling but they are out of this session's scope.

The `del` keyword (usage: `del obj`) will call `__delitem__()` if it is implemented, otherwise it will _decrement the reference count by 1_ for the object. This means if only one variable was holding the object, and `del` was used on the object, it will be garbage-collected. Using `del` is also discouraged for normal objects, but may be used for things like dictionaries.

=== `__getattr__()` and `__setattr__()`

These methods are called whenever you access an attribute or method of an object using the dot notation: `obj.attribute` _and that attribute does not actually exist_.

There are two lower-level methods that #emphasis[you should almost always never touch], that always run for any attribute access: `__getattribute__` and `__setattribute__`.


=== `__getattr__()` and `__setattr__()`
```python
class A:
  def say_hello(self):
    print("Hello")

  def __getattr__(self, name):
    if "hello" in name.lower():
      print("Did you mean 'say_hello'?")

a = A()
a.say_hello() # "Hello"
a.syahello() # "Did you mean 'say_hello'?"
```

=== Advanced Example: Attribute Methods & Proxy Pattern

```python
class Communication:
  def send(self, message): ...
  def receive(self): ...
  
class _SafeCommunication:
  lock = threading.RLock()
  def __init__(self):
    self._normal_comms = Communication()
    
  def __getattr__(self, name):
    with self.lock:
      return getattr(self._normal_comms, name)

```

=== Advanced Example: Attribute Methods & Proxy Pattern:\ Type Hinting
#[
#set text(size: 0.86em)
To prepare `SafeCommunication` for importing:
```python
if typing.TYPE_CHECKING: # this is used by your IDE
  # trick your IDE into thinking they're the same thing
  # this way you get code completion
  SafeCommunication = Communication
else:
  # this is used at runtime
  # this is the actual safe implementation
  SafeCommunication = _SafeCommunication
```

```python
comms = SafeCommunication()
comms.send("Hi")
comms.receive()
```
]

== Readability & Typing


=== The `Any` Type and Casting

We established that everything in Python inherits `object`, so why do type checkers use `typing.Any` for a hint that accepts anything, rather than using `object`?

Type checkers and IDEs treat `typing.Any` as an "off" switch. Type checking will be _completely ignored_ for a variable tagged as `Any`, and no errors will be reported for any operations that may depend on the type (accessing attributes, methods, etc).

Conversely, they treat `object` as a strict requirement. An `object` parameter only has the common attributes and methods shared between _all_ classes, which is a very limited set.

You can use `typing.cast(my_obj, DifferentType)` to tell the type checker "Give me `my_obj` with permission to use it as an instance of `DifferentType` without shouting at me", regardless of whether you originally typed `my_obj` as `object` or `Any` or anything else. Despite that, we conventionally still use `Any` to indicate the most relaxed option and `object` to indicate the most strict, even if we will bypass both via a `cast()` later.

#set-ribbon(content: [Read more: https://docs.python.org/3/library/typing.html#the-any-type])

=== Protocols <protocols>

Protocols are a class exposed by the `typing` module that allow for clean polymorphism _hinting_ without subclassing an abstract base class.

A protocol `P` that has a method `m` can be used as a type hint where we expect an object which has a method `m`. The object's class does not need to be a subclass of the protocol `P` for the type hint to work.

In other words, protocols are for type hinting purposes. You should still do manual checks for polymorphism using `hasattr()` or catching `AttributeError` on failed access.

If you did some research, you may be tempted to use the `@runtime_checkable` decorator on a protocol for actual checking. Read #link("https://medium.com/@tihomir.manushev/the-runtime-protocol-trap-why-pythons-runtime-checkable-doesn-t-check-what-you-think-36735ad2a13a", [this article #emoji.chain]) for a rundown of why this isn't particularly better --- it changes your `hasattr()` usage, which may be used with more advanced checking techniques, into a more abstracted `isinstance()` usage.

#set-ribbon(content: [Read more: https://typing.python.org/en/latest/spec/protocol.html])

=== Protocols

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 0.6cm,
  [
```python
from typing import Protocol

class CanFly(Protocol):
    def fly(self) -> None: ...

class Duck(Bird):
  def fly(self): ...
  
class FlyingFish(Fish):
  def fly(self): ...
```
  ],
  line(angle: 90deg, length: 75%, stroke: 0.5pt + brand-palette.light_gray),
  [
    ```python
    def radar_identify(obj: CanFly):
      # actual check:
      if not hasattr(obj, "fly"):
        raise TypeError()
      identity = obj.__class__.__name__
      
      print(f"{identity}, you are flying in restricted airsapce. Divert or you will be shot down.")
    ```
  ],
)

#set-ribbon(content: [Read more: https://decorator-factory.codeberg.page/typing-tips/tutorial/2-using-protocols/])

=== Data Structures for Readable Code

Python has a few data structures that can make code more readable:
- `Enum` vs `Literal` --- for constant values
- `TypedDict` vs `dataclass` vs `NamedTuple` --- alternatives to dictionaries

=== Constants: Enums

Enums are a way to give names to constant values that may be non-strings.

```python
class Weekday(enum.Enum):
    MONDAY    = 1 # or enum.auto()
    TUESDAY   = 2 # or enum.auto()
    WEDNESDAY = 3 # or enum.auto()
    THURSDAY  = 4 # or enum.auto()
    FRIDAY    = 5 # or enum.auto()
    SATURDAY  = 6 # or enum.auto()
    SUNDAY    = 7 # or enum.auto()

course.set_day(Weekday.MONDAY) # Course::set_day(self, day: Weekday)
```

#set-ribbon(content: [Read more: https://docs.python.org/3/howto/enum.html])

=== Constants: Specialized Enums
Normal enums are not expected to carry a meaningful value next to their name, just a unique one.

Some enums are used as a lookup for a more unreadable "magic value", like a constant.
#grid(
  columns: (1fr, auto, 1.2fr),
  gutter: 0.5cm,
  [
`IntFlag` is an example:
```python
from enum import IntFlag

class Perm(IntFlag):
    R = 4
    W = 2
    X = 1
```
  ],
  line(angle: 90deg, length: 50%, stroke: 0.5pt + brand-palette.light_gray),
  [
    We can use:\
    `if (Perm.R | Perm.W) & input_flags`
    Which performs a logic check on `input_flags` to see if it has `Perm.R` and/ or `Perm.W`, instead of using strings then converting the present strings to integers needed for actual flags:
    ```python
    if 'R' in input_flags and 'W' in input_flags
    ```
  ],
)

=== Constants in Arguments: Literals

We don't need to use a whole class to check for a few constant values. We can use `typing.Literal`:

```python
def set_style(person, style: Literal["classic", "casual"]):
  if style == "classic":
    ...
  elif style == "casual":
    ...
  else:
    raise ValueError(f"Unexpected style provided: {style}")
```

This offers briefer hinting, but checking must still be implemented. Enums may be offer an easier type checking experience at times.

=== Data Containers
In #link-ref(<oop-part>), we mentioned how a class that only contains attributes is acting like a dictionary. After looking at type hinting and methods, we can also say that a class that primarily focuses on attributes is almost like a _typed dictionary_.

Sometimes we really just need to transfer data and ensure its validity while keeping code readability.

We will deal with the basics of how it's done in Python, but if we --- for example -- use a library like ROS2, there will be functionally similar alternatives to the specific types outlined here.

=== `NamedTuple`s

A named tuple acts as an improved dictionary and tuple hybrid that is immutable.
- Named attributes
- Lightweight, fast access
- Easy unpacking & sequential access (like tuples)
- Optional type hinting
#grid(
  columns: (1fr, auto, 1.5fr),
  gutter: 0.5cm,
  [
    Subclassed implementation with type hinting:
```python
class Point(NamedTuple):
    x: int
    y: int
```
  ],
  line(angle: 90deg, length: 40%, stroke: 0.5pt + brand-palette.light_gray),
  [
  Normal implementation:
```python
Point = namedtuple('Point', ['x', 'y'])
```
Using the named tuple:
```python
p = Point(x=10, y=100)
p[0] == p.x # True, both are 10
```
  ],
)

=== `TypedDict`s
#[
#set text(size: 0.9em)
Typed dictionaries are normal dictionaries, but when you use a typed dictionary class as a type hint in your functions, you get better completions. They also help developers keep APIs readable.

They are strictly a type hinting and code completion tool.

```python
class UserPayload(TypedDict):
  id: int
  username: str
  email: str

def get_username(user_id: int) -> str:
  trusted_dict = user_api.get_user_by_id(10)
  # ^ untyped dict that is trusted to match UserPayload
  user = typing.cast(trusted_dict, UserPayload) # tell the type checker you trsut it
  return user["username"] # type checker now trusts you that this returns str

```
]

=== Data Classes

Data classes are the most versatile and robust option available. Their features are:
- Named fields
- Optionally auto-generated fields
- An optional `__post_init__()` method for validating _contents_ of fields or generating contents for other fields
- Can be optimized by using `slots=True`
- Mutable by default, can be immutable (`frozen=True`)
- Are their own class, you can implement methods for construction, modification and validation without having inherited a `tuple` along your way.
- Are usually the bridge between communication and business logic, ex:
  - A typed dict is received from an API
  - The data class transforms the raw dictionary data into business-class fields, ex: a string phone number becomes a `PhoneNumber` object with validation and formatting options

#set-ribbon(content: [Read more: https://docs.python.org/3/library/dataclasses.html])

=== Generics

If you previously learned OOP in another language, you may have stumbled upon the concept of _generics_ or _templates_.

Generics in Python refers to the type hinting practice where a class is known to be composed of instances of other types, and the other types are declared for readability.

We often use generics passively, i.e we type a list as:\
`school: list[Student] = []`\
The `[Student]` part is the _generic_. It is *purely cosmetic*, but helps the IDE inform us that accessing `school[0]` will give us a `Student` object.

Read about how #link("https://decorator-factory.codeberg.page/typing-tips/tutorial/5-generic-classes/", [generic classes #emoji.chain]) as well as #link("https://decorator-factory.codeberg.page/typing-tips/tutorial/3-generic-functions/", [generic functions #emoji.chain]) are made so that they accept the types and provide you with hints.

== Defensive Programming

=== Mutable Attributes

Let's say our class has a list as an attribute, and we return that attribute after processing it.

What happens when the function consuming our getter decides to sort the returned list? What happens if it decides to filter the returned list for specific data it needs? In these cases it will ruin our class's attribute for the next consumer function.

This is where frozen data classes and immutable data structures shine. If you want to return _data_ that you own, make sure you return either a normal _copy_ or a frozen _copy_ of the data to explicitly declare that this is a separate copy from the internal attribute.

You should work defensively at the _producer_ and at the _consumer_. The _consumer_ should create their own instance whenever they filter or mutate the data for processing purposes.

Recall list comprehensions.

=== Copying Mutables


- Comprehensions (Filtered Shallow Copies) e.g.: `[item for item in self._items]`

- The `copy` Module (Shallow vs. Deep):
  - `copy.copy(obj)` creates a shallow copy, duplicating only the outer container while keeping nested mutable objects (like lists inside a dict) shared.

  - `copy.deepcopy(obj)` recursively duplicates everything down the tree. Use this when your data structures contain nested mutables that consumers might accidentally mutate.
- The `copy` module's functions work with data classes as well.

=== Error Handling Conventions

Some methods in Python are graceful: they don't raise exceptions, ex: `dict.get()`, but their return values determine your next move.

Some techniques allow for checking first, ex: (`if elem in my_list`), `hasattr()`.

Some techniques go all in, and backtrack when an exception is hit. This is referred to by "It's easier to ask forgiveness than to ask permission".

Try to unify your error handling techniques in your project. Will you return (`ResultClass | None`)s or just `ResultClass` and an optional exception? Are your #link("https://google.github.io/styleguide/pyguide.html#doc-function-raises", [exceptions documented in a docstring #emoji.chain])?

Beside error handling, do you log the errors? At which stage is the logging done? Ideally it should be at the highest level, the final consumer level. Ideally also you should use a dedicated logging library, like `loguru`.

#end-slide(subtitle: "Session 3 | Software Training", message: "Thank you for your attention")