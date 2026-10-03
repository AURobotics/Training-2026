#import "/Theme/report.typ": (
  brand-palette,
  cover-page,
  emphasis,
  pause-page-counting,
  report-template,
  resume-page-counting,
  watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Software | Phase III],
  topic: "Workshop: QML Analog Clock",
)

#show: report-template.with(ribbon-text: "Workshop")

= Overview

*Duration:* 2 Hours \
*Objective:* Build a hybrid PySide6 + QML real-time analog clock application that accepts user time inputs, updates an underlying Python data backend, and renders hardware-accelerated clock hands and dial ticks in QML.

#important(title: "Workshop Rules")[
  This is a practical hands-on workshop. You are expected to write modular, clean code that decouples UI rendering (QML) from data logic (Python). Follow the Mediator pattern in your main window.
]

= Architectural Requirements

Your solution must be split across a structured Python package (`workshop/`) containing the following core files:

== Data Backend (`data.py`)
- Create a `MyData` class inheriting from `QObject`.
- Expose `hours` (0–11), `mins` (0–59), and `secs` (0–59) as `@Property` fields with corresponding change notification signals (`hours_changed`, `mins_changed`, `secs_changed`).
- Implement an internal `QTimer` firing every 1000ms that automatically increments the time state.

== QML Status Bridge (`status_widget.py`)
- Subclass `QQuickWidget` to load `clock.qml`.
- Pass the `MyData` backend instance into QML using modern Qt 6 property injection (`setInitialProperties({"clockData": data_bridge})`).
- Set `resizeMode` to `SizeRootObjectToView`.

== Input Controls (`input.py`)
- Create a `QWidget` featuring three `QLineEdit` fields for Hour, Minute, and Second inputs, protected by `QIntValidator` ranges.
- Include a "Confirm" `QPushButton` that parses input text and emits a custom signal `time_entered(int, int, int)`.

== Main Window Mediator (`window.py`)
- Inherit from `QMainWindow` and assemble `StatusWidget` and `Input` inside a `QVBoxLayout`.
- Connect the `time_entered` signal from the input widget to update the `MyData` backend properties.

== Vector Clock UI (`clock.qml`)
- Declare `required property var clockData` at the root level.
- Bind local QML properties (`hours`, `minutes`, `seconds`) directly to `clockData`.
- Use a `Repeater` (model: 60) to draw tick marks and hour numbers (1–12) around the perimeter.
- Render the minute and hour hands using `QtQuick.Shapes` (`ShapePath` + `PathLine`).
- Ensure clock hands counter-rotate based on dynamic time math (`rotation: (root.hours + root.minutes / 60) * (360 / 12)`).
- Make colors adapt dynamically to Qt's system palette using `palette.window.hsvValue`.

#tip[
  Remember to set `transformOrigin: Item.Bottom` on all rotating clock hands so they pivot from the center of the clock face.
]

= Scaffolding Template

You may use the following code skeleton to guide your module layout:

*`data.py`*
```python
from PySide6.QtCore import QObject, Property, Signal, QTimer

class MyData(QObject):
    hours_changed = Signal()
    mins_changed = Signal()
    secs_changed = Signal()

    def __init__(self, parent: QObject | None = None):
        super().__init__(parent)
        ...

    @Property(int, notify= hours_changed)
    def hours(self):
        ...

    @hours.setter
    def hours(self, new: int):
        ...

    @Property(int, notify= mins_changed)
    def mins(self):
        ...

    @mins.setter
    def mins(self, new: int):
        ...

    @Property(int, notify= secs_changed)
    def secs(self):
        ...

    @secs.setter
    def secs(self, new: int):
        ...

    def _increment(self):
        ...
```

*`status_widget.py`*
```python
from PySide6.QtWidgets import QWidget
from PySide6.QtQuickWidgets import QQuickWidget
from PySide6.QtCore import QUrl, QObject
from workshop.assets import get_asset

class StatusWidget(QQuickWidget):
    def __init__(self, widget_filepath: str, 
                data_bridge: QObject | None = None,
                parent: QWidget | None = None):
        super().__init__(parent)
        ...
```
where you're allowed to use the following function in a separate file:
```python
from pathlib import Path

def get_asset(file_name: str) -> str:
    """Returns the absolute path to a resource file."""
    assets_folder = Path(__file__).parent.resolve()
    return str(assets_folder / file_name)
```

*`input.py`*
```python
from PySide6.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QLineEdit, QPushButton
from PySide6.QtCore import Qt, Signal
from PySide6.QtGui import QIntValidator

class Input(QWidget):
    time_entered = Signal(int, int, int)

    def __init__(self, parent: QWidget | None = None):
        super().__init__(parent)
        ...

    def _confirm_input(self):
        ...
```

*`window.py`*
```python
from PySide6.QtWidgets import QMainWindow, QWidget, QVBoxLayout

from workshop.data import MyData
from workshop.status_widget import StatusWidget
from workshop.input import Input

class Window(QMainWindow):
    def __init__(self):
        super().__init__()
        ...
        self.show()

    def _set_time(self, hour: int, min: int, sec: int):
        ...
```

*\_\_init\_\_.py*
```python
from PySide6.QtWidgets import QApplication
from workshop.window import Window

def main() -> None:
    print("Hello from workshop!")
    app = QApplication()
    window = Window()
    app.exec()
```