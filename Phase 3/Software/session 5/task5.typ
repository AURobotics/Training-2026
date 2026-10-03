#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)
#import "@preview/calloutly:1.1.0": important, note, tip, caution
#import "/Theme/common.typ": setup-codly
#show: setup-codly
#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Task 5: ROS 2 & GUI Integration")

#show: report-template.with(ribbon-text: "Task 5")

= Overview

You are provided with a #underline[#link("https://github.com/nada-osama-a/task")[*Skeleton Repository*]] that already contains the `battery.qml` file and its basic GUI setup. Your objective is to build the backend logic, connect the GUI to ROS 2, and implement a thread-safe emergency control system while maintaining a strict project structure.

= Task Requirements

== Battery Telemetry Integration
- The skeleton repository contains a working battery UI.
- *Your Task:* Connect this GUI to a ROS 2 `WorkerNode`. The node should receive telemetry data and update the battery percentage on the screen dynamically.

== Joy Node Implementation
- Create a new `JoyNode` responsible for reading keyboard inputs.
- It must publish movement commands to the appropriate ROS topic based on the key presses.

== Emergency Push Button
- The provided GUI already includes an Emergency Stop `QPushButton` alongside the battery.
- *Your Task:* Connect this button's `clicked` signal to your backend. When clicked, it must trigger a safe mode in the `JoyNode`.
- The robot must immediately stop and completely ignore all keyboard inputs for exactly *5 seconds*, then automatically restore control.

#tip(title: "Tip")[
  Do *NOT* use `time.sleep(5)` for the emergency mode, as it will freeze the ROS executor. Use ROS clocks (`self.get_clock().now()`) instead.
]

== Project Structure
- You must organize the project structure correctly from scratch within the skeleton repository.
- All code must be placed inside a valid Python package within the `src` folder.

= Submission
- Push your code to your *GitHub repository*.
#tip(title: "Testing")[
  A test script is provided in the skeleton repository. Make sure to run it to verify that your implementation is working correctly before you submit.
]
- Submit your GitHub repository link via the form: #link("https://forms.gle/FnP55c8aZbBRaLvy5")[https://forms.gle/FnP55c8aZbBRaLvy5]
#note[
  Make sure to push the code to *your own* personal GitHub repository, NOT the provided skeleton repo. Also, ensure your repo is public and set to "anyone with the link can view."
]
 
#emphasis("Deadline: Monday, September 28th -- 11:59pm")