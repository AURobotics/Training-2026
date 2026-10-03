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

You may use the following code skeleton to guide your module layout, if you wish:

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

*`__init__.py`*
```python
from PySide6.QtWidgets import QApplication
from workshop.window import Window

def main() -> None:
    print("Hello from workshop!")
    app = QApplication()
    window = Window()
    app.exec()
```


= Internal Solution
(_do not show to trainees_)

The following is a solution, but not the only possible solution:

*`data.py`*
```python
from PySide6.QtCore import QObject, Property, Signal, QTimer

class MyData(QObject):
    hours_changed = Signal()
    mins_changed = Signal()
    secs_changed = Signal()

    def __init__(self, parent: QObject | None = None):
        super().__init__(parent)

        self._hours = 0
        self._mins = 0
        self._secs = 0

        self._timer = QTimer(self)
        self._timer.setInterval(1000)
        self._timer.timeout.connect(self._increment)
        self._timer.start()

    @Property(int, notify= hours_changed)
    def hours(self):
        return self._hours

    @hours.setter
    def hours(self, new: int):
        if new >= 0 and new < 12:
            self._hours = new
            self.hours_changed.emit()


    @Property(int, notify= mins_changed)
    def mins(self):
        return self._mins

    @mins.setter
    def mins(self, new: int):
        if new >= 0 and new < 60:
            self._mins = new
            self.mins_changed.emit()

    @Property(int, notify= secs_changed)
    def secs(self):
        return self._secs

    @secs.setter
    def secs(self, new: int):
        if new >= 0 and new < 60:
            self._secs = new
            self.secs_changed.emit()

    def _increment(self):
        total = self._hours * 3600 + self._mins * 60 + self._secs
        total += 1
        self.hours = (total // 3600) % 12
        self.mins = (total // 60) % 60
        self.secs = total % 60
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

        self.setInitialProperties({"clockData": data_bridge})
        
        self.setSource(QUrl.fromLocalFile(get_asset(widget_filepath)))
        
        self.setResizeMode(QQuickWidget.ResizeMode.SizeRootObjectToView)
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

        self._hour_field = QLineEdit()
        validator1 = QIntValidator(0, 11, self._hour_field)
        self._hour_field.setValidator(validator1)
        self._hour_field.setPlaceholderText('Hour')

        self._min_field = QLineEdit()
        validator2 = QIntValidator(0, 59, self._min_field)
        self._min_field.setValidator(validator2)
        self._min_field.setPlaceholderText('Minutes')

        self._sec_field = QLineEdit()
        validator3 = QIntValidator(0, 59, self._sec_field)
        self._sec_field.setValidator(validator3)
        self._sec_field.setPlaceholderText('Second')

        self._button = QPushButton('Confirm')
        self._button.clicked.connect(self._confirm_input)

        self._h_layout = QHBoxLayout()

        for item in [self._hour_field, self._min_field, self._sec_field]:
            item.setAlignment(Qt.AlignmentFlag.AlignCenter)
            self._h_layout.addWidget(item)

        self._v_layout = QVBoxLayout(self)
        self._v_layout.addLayout(self._h_layout)
        self._v_layout.addWidget(self._button)


    def _confirm_input(self):
        if self._hour_field.text() and self._min_field.text() and self._sec_field.text():
            hour = int(self._hour_field.text())
            min = int(self._min_field.text())
            sec = int(self._sec_field.text())
            self.time_entered.emit(hour, min, sec)
            for item in [self._hour_field, self._min_field, self._sec_field]:
                item.clear()
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

        self._data = MyData(self)
        self._clock = StatusWidget('clock.qml', self._data)
        self._input = Input()
        self._input.time_entered.connect(self._set_time)

        self._container = QWidget(self)
        self._layout = QVBoxLayout(self._container)
        self._layout.addWidget(self._clock)
        self._layout.addWidget(self._input)

        self.setCentralWidget(self._container)

        self.show()

    def _set_time(self, hour: int, min: int, sec: int):
        self._data.hours = hour
        self._data.mins = min
        self._data.secs = sec
```

*`__init__.py`*
```python
from PySide6.QtWidgets import QApplication
from workshop.window import Window

def main() -> None:
    print("Hello from workshop!")
    app = QApplication()
    window = Window()
    app.exec()
```

*`clock.qml`*
```qml
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root
    width: 300
    height: 300
    color: palette.window

    required property var clockData

    property int seconds: clockData.secs
    property int minutes: clockData.mins
    property int hours: clockData.hours

    Rectangle {
        id: myCircle
        anchors.centerIn: root
        width: (parent.width > parent.height) ? parent.height : parent.width
        height: width
        radius: width / 2
        border.width: 12
        border.color: '#555555'
        color: (palette.window.hsvValue > 0.5) ? 'black' : 'white'

        Repeater {
            model: 60

            delegate: Item {
                id: tickContainer

                required property int index

                anchors.bottom: myCircle.verticalCenter
                anchors.topMargin: 16
                anchors.top: myCircle.top
                anchors.horizontalCenter: parent.horizontalCenter

                rotation: index * (360 / 60)
                transformOrigin: Item.Bottom

                Rectangle {
                    width: (parent.index % 5) ? 2 : 4
                    height: (parent.index % 5) ? 10 : 12
                    color: (palette.window.hsvValue > 0.5) ? 'white' : 'black'
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    color: (palette.window.hsvValue > 0.5) ? 'white' : 'black'
                    text: {
                        if (parent.index % 5) {
                            return '';
                        } else if (parent.index === 0) {
                            return 12;
                        } else {
                            return parent.index / 5;
                        }
                    }
                    font.pixelSize: 16
                    font.bold: true

                    anchors.topMargin: 16
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: -parent.rotation
                }
            }
        }

        Item {
            id: pointersContainer
            anchors.margins: parent.border.width
            anchors.fill: parent

            Rectangle {
                id: pointerBase
                width: parent.width * 0.05
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: (palette.window.hsvValue > 0.5) ? 'white' : 'black'
                z: 1
            }

            Rectangle {
                id: secPointer
                anchors.topMargin: parent.height * 0.03
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 4
                color: 'red'
                rotation: root.seconds * (360 / 60)
                transformOrigin: Item.Bottom
            }

            Shape {
                id: minPointer
                anchors.topMargin: parent.height * 0.1
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.04
                rotation: (root.minutes + root.seconds / 60) * (360 / 60)
                transformOrigin: Item.Bottom

                ShapePath {
                    strokeColor: 'grey'
                    strokeWidth: 1
                    fillColor: (root.palette.window.hsvValue > 0.5) ? 'white' : 'black'

                    startX: 0
                    startY: minPointer.height

                    PathLine {
                        x: minPointer.width / 2
                        y: 0
                    }
                    PathLine {
                        x: minPointer.width
                        y: minPointer.height
                    }
                    PathLine {
                        x: 0
                        y: minPointer.height
                    }
                }
            }

            Shape {
                id: hourPointer
                anchors.topMargin: parent.height * 0.3
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.04
                rotation: (root.hours + root.minutes / 60) * (360 / 12)
                transformOrigin: Item.Bottom

                ShapePath {
                    strokeColor: 'grey'
                    strokeWidth: 1
                    fillColor: (root.palette.window.hsvValue > 0.5) ? 'white' : 'black'

                    startX: 0
                    startY: hourPointer.height

                    PathLine {
                        x: hourPointer.width / 2
                        y: 0
                    }
                    PathLine {
                        x: hourPointer.width
                        y: hourPointer.height
                    }
                    PathLine {
                        x: 0
                        y: hourPointer.height
                    }
                }
            }
        }
    }
}

```