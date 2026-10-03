#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Task 2: PySide6 Timer App")

#show: report-template.with(ribbon-text: "Task 2")

= Introduction

After watching the Qt development session, you should be able to create and manage graphical user interfaces utilizing basic PySide6 widgets, signals and slots, layouts, and timer events.

= Task — Countdown Timer App

Design and implement a PySide6 GUI application that acts as a countdown timer, transitioning seamlessly between an input view and a running timer view using state management.

== Requirements

+ *Initial State.* The program must start with a `QLineEdit` where the user enters the desired amount of time (in seconds), alongside 'Start' and 'Reset' buttons.
+ *Input Handling & Validation.* The 'Reset' button must clear the user's input (`.clear()`). The 'Start' button must validate that the user entered a valid value of seconds. If the input is valid, the timer starts.
+ *View Switching.* Once the input is validated and the user hits 'Start', a `QStackedWidget` must switch from the initial `QLineEdit` to a `QLabel` that counts down using an `MM:SS` format (e.g., `01:30`).
+ *Dynamic Button State.* When the timer starts running, the 'Start' button must switch its text to 'Pause'. If the timer is paused, it should resume when 'Start' is clicked again. The 'Reset' button should immediately stop the timer and reset the app to its initial state.
+ *Timeout Reset.* On timer finish (when the counter hits `00:00`), the `QStackedWidget` and the two control buttons must automatically reset to their original states.

#tip[
  Search about `PySide6.QtGui.QValidator` and its various subclasses, including `QIntValidator`.
]

= Suggested Template

You can optionally use the following as a template to structure your code across multiple files. This architecture uses signals to maintain complete component decoupling:

*buttons.py*
```python
from PySide6.QtWidgets import QHBoxLayout, QPushButton, QWidget
from PySide6.QtCore import Signal

class Buttons(QWidget):
    start = Signal()
    pause = Signal()
    reset = Signal()

    def __init__(self, parent: QWidget | None = None) -> None:
        ...

    @property
    def timer_paused(self) -> bool:
        ...

    @timer_paused.setter
    def timer_paused(self, state: bool) -> None:
        ...

    def _b1_clicked(self) -> None:
        ...

    def _b2_clicked(self) -> None:
        ...
```

*stack.py*
```python
from PySide6.QtWidgets import QStackedWidget, QLineEdit, QLabel, QWidget
from PySide6.QtGui import QIntValidator
from PySide6.QtCore import QTimer, Signal, Qt

class Stack(QStackedWidget):
    time_stopped = Signal(bool)
    
    def __init__(self, parent: QWidget | None = None) -> None:
        ...

    def start_counter(self) -> None:
        ...

    def _decrement(self) -> None:
        ...

    def reset(self) -> None:
        ...

    def pause(self) -> None:
        ...
```

*window.py*
```python
from PySide6.QtWidgets import QMainWindow, QWidget, QVBoxLayout
from package_name.buttons import Buttons
from package_name.stack import Stack

class Window(QMainWindow):
    def __init__(self) -> None:
        ...

    def _switch_buttons(self, state: bool) -> None:
        ...
```

*\_\_init\_\_.py*
```python
from PySide6.QtWidgets import QApplication
from package_name.window import Window

def main() -> None:
    ...
```

= Submission

- Make sure your *GitHub repository* follows valid project structure, including a runnable *package* inside your *src* folder. #text(fill: red)[*Do not include your demonstration video*]

- Record a short video *explaining the code you wrote* — giving your approach a walk-through, and a demonstrating the output.

- Upload the video to *Google Drive* or *YouTube* and get a shareable link.

- Submit via the form: include the *GitHub repo link* and the *video link*.: https://forms.gle/ocTnKZ8Jyt8BxPit8

#note[
  Make sure the repo is public and the video link permissions are set to "anyone with the link can view."
]

#emphasis("Deadline: Monday, September 21st -- 11:59 pm")