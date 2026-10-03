#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Task 3 Part 2: Battery Telemetry Widget")

#show: report-template.with(ribbon-text: "Task 3 - Part 2")

= Overview

- *Objective:* Extend your hybrid PySide6 + QML application by creating a telemetry battery widget (`battery.qml`). You will extend the Python backend to supply battery percentage updates and embed a second `StatusWidget` instance into `QMainWindow`.

= Task Requirements

== Backend Extension (`data.py`)
Extend your `MyData` class to maintain a simulated battery charge state:
- Add a `battery_level` property (`float`, range `0.0` to `1.0`).
- Declare a corresponding `battery_level_changed` notification signal.
- In your internal `QTimer` step function, simulate a gradual battery discharge (or oscillating charge cycle between 0% and 100%).

== Battery QML Component (`battery.qml`)
Create `battery.qml` to visually render the current battery charge state:
- Declare `required property var batteryData` at the root component.
- Bind a local property `batteryLevel` directly to `batteryData.batteryLevel`.
- *Battery Body:* Draw an outer rounded border `Rectangle` (e.g., `radius: 6`, fixed or responsive width/height).
- *Battery Tip/Nub:* Anchor a smaller rounded rectangle on the right side of the main body to visually represent the positive terminal.
- *Charge Fill Bar:*
  - Position an inner `Rectangle` flush against the left padding of the battery body.
  - Dynamically calculate its `width` as `(batteryBody.width - padding) * batteryLevel`.
  - Dynamically color the bar:
    - *Green* when `batteryLevel > 0.5`
    - *Yellow / Orange* (`#f4d03f`) when `0.2 < batteryLevel <= 0.5`
    - *Red* when `batteryLevel <= 0.2`
- *Percentage Text:* Center a `Text` element over the battery body displaying `Math.round(batteryLevel * 100) + "%"`.
- *Theme Support:* Respect `palette.window.hsvValue` to ensure borders and text maintain proper contrast in both light and dark system themes.

== Multi-Widget Window Integration (`window.py`)
- Instantiate a second `StatusWidget` inside `Window` passing `'battery.qml'` and your `MyData` instance.
- Lay out both the clock widget and the battery widget inside the central widget container (using `QVBoxLayout`).

#tip[
  You can keep inner rounded fill bars clean without overflow by setting `clip: true` on the outer container `Rectangle`, or by keeping internal margins proportional to the body's radius.
]

= Visual Reference

#align(center)[
  #image("battery.png", width: 40%)
]

= Submission

- Make sure your *GitHub repository* follows valid project structure, including a runnable *package* inside your *src* folder. #text(fill: red)[*Do not include your demonstration video*]

- Record a short video *explaining the code you wrote* — giving your approach a walk-through, and a demonstrating the output.

- Upload the video to *Google Drive* or *YouTube* and get a shareable link.

- Submit via the form: include the *GitHub repo link* and the *video link*.: https://forms.gle/3QcKWekfVKe5sbtw8

#note[
  Make sure the repo is public and the video link permissions are set to "anyone with the link can view."
]

#emphasis("Deadline: Wednesday, September 23rd -- 11:59pm")