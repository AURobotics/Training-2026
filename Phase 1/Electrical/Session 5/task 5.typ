#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Task 5:Sensors & Motors],
)
#show: report-template.with(ribbon-text: "Task 5")

= Introduction

After attending the workshops on DC/Servo motors and IR/Ultrasonic sensors, you have learned the fundamentals of interfacing sensors and basic motor control.

This task moves beyond simple on/off control into **real-world embedded engineering logic**, reinforcing:
- Finite State Machine (FSM) architecture for multi-mode systems.
- Dynamic Proportional Distance Control (Adaptive Cruise Control logic).
- Active Ultrasonic Obstacle Scanning using Servo-driven radar sweeps.
- Multi-input safety interlocking mechanisms.
- Non-blocking timing architecture using `millis()` for concurrent multi-tasking.

= Tasks

Please use #emphasis[Tinkercad Circuits] or #emphasis[SimulIDE] to simulate and finish the task, or implement it physically using hardware.

== Task 1: Drive-by-Wire Mode Selector (FSM Motor Control)

Implement a multi-mode motor control architecture using an **L298N Motor Driver** and a State Machine. The robot switches between 3 distinct driving modes using input push buttons:

=== Requirements
1. **Eco Mode (Button 1):** Speed is capped at $50\%$ PWM ($approx 128$) to simulate power-saving operation.
2. **Sport Mode (Button 2):** Full speed capability ($100\%$ PWM / $255$) with rapid directional switching.
3. **Safety Reverse Mode (Interlock Safety):** The motors will **NOT** move backward unless two specific safety buttons are pressed simultaneously. If only one button is pressed, the motors remain stopped for safety.
4. Print mode switches and motor status changes to the Serial Monitor (e.g., `"MODE: Eco | Action: Moving Forward | Speed: 128"`).

== Task 2: Servo Radar Mechanism

Mount the HC-SR04 Ultrasonic sensor onto a Servo Motor to act as an active scanning head.

=== Requirements
1. Attach a Servo Motor to a PWM pin using `<Servo.h>`.
2. On command, perform a **$180$ Radar Sweep**:
   - Rotate smoothly from $0 $ (Far Right) $-->$ $90$ (Center) $-->$ $180$ (Far Left).
3. Sample distance readings at $0$, $90$, and $180$, and print the scan array to the Serial Monitor (e.g., `"Scan Results: [Right: 45cm, Center: 12cm, Left: 80cm]"`).

== Task 3: IR Surface Detection & Safety Interlock

Equip your robot with a downward-facing IR sensor for surface monitoring.

=== Requirements
1. Calibrate the IR sensor threshold to distinguish between white (safe) and black (danger zone/pit) surfaces.
2. Continuously monitor the surface.
3. When black is detected, trigger an emergency override: instantly cut power to all motors, illuminate a red warning LED, and log `"DANGER: Black Surface Detected - Emergency Stop!"`.

== Task 4: Smart Adaptive Cruise Control & Obstacle Scanning

Upgrade the obstacle detection system to use both **Adaptive Cruise Control (ACC)** and **Active Path Selection**.

=== Requirements
1. **Adaptive Speed Control:**
   - If obstacle distance $> 50 "cm"$: Move forward at full configured mode speed.
   - If obstacle distance is between $15 "cm"$ and $50 "cm"$: Dynamically reduce motor PWM proportionally as the robot gets closer ($"PWM" prop "Distance"$).
2. **Active Path Selection (Obstacle Detected $<= 15 "cm"$):**
   - Stop the motors immediately.
   - Trigger the Servo Radar Sweep (Task 2) to measure distances at Left ($180$) and Right ($0$).
   - Compare readings and automatically execute a $90$ in-place turn toward the **clearer path** (longer distance).
   - Resume forward motion.

#tip[Avoid using `delay()` inside your main control logic! Use `millis()` timing loops to ensure sensor readings and mode buttons are checked concurrently.]

== Bonus Task: Fully Autonomous Reactive Minesweeper

Combine all previous systems into a cohesive, non-blocking autonomous rover firmware.

=== System Architecture
1. Default State: Rover drives using **Task 1** selected mode while evaluating **Task 4** Adaptive Cruise Control.
2. Safety Priority 1: **Task 3 (IR Sensor)** has absolute override priority. If a black surface is detected, halt all movement regardless of ACC state.
3. Safety Priority 2: When an obstacle is blocked ($<= 15 "cm"$), execute the **Task 2** Radar Sweep, choose the clear path, turn, and log the decision matrix to the Serial Monitor.
4. Print continuous telemetry to the Serial Monitor showing: `[Current Mode | Distance | Surface State | Motor Output]`.

#important[Structure your program cleanly using functions (`readSensors()`, `updateFSM()`, `controlMotors()`) to demonstrate proper embedded software design.]


= Submission

#important(
  title: "Important: Simulation & Code Submissions",
)[When submitting your work: include both the circuit schematic/simulation file (`.simu` or Tinkercad public link) and the clean, commented C++ `.ino` source code for all tasks.]

#important(title: "Important: File Hosting")[
  Upload all source files and simulation files to Google Drive, set permissions to #emphasis[Viewable by Everyone], and paste the folder link in the submission form.
]

- You are required to submit via the Google Form: https://forms.gle/yaGYKNj1p8CcN3jw6
- Deadline: Monday, August 17th -- 11:59 pm

= Appendix

== Hardware Interfacing & Component Specifications

=== Motor Driver (L298N) Wiring Topology
- *Left Motor Control:* `IN1`, `IN2` (direction), `ENA` (PWM speed).
- *Right Motor Control:* `IN3`, `IN4` (direction), `ENB` (PWM speed).
- *Logic Voltage:* $5 "V"$ from Arduino; *Motor Power:* External battery (e.g., $9 "V"$ to $12 "V"$).

=== Sensors & Actuators Pinout
- *Servo Motor:* Signal line on a PWM-capable digital pin (e.g., Pin 9).
- *IR Sensor:* `OUT` to a digital pin; calibrate threshold via onboard potentiometer.
- *Ultrasonic Sensor (HC-SR04):* `Trig` and `Echo` on separate digital pins.
- *Push Buttons:* Connected with pull-down resistors (or using internal `INPUT_PULLUP`).