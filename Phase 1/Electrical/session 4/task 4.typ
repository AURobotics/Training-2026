#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Task 4: Communication Protocols],
)
#show: report-template.with(ribbon-text: "Task 4")

= Introduction

After attending the workshop and working hands-on with inter-board communication protocols, you have learned to:
- Establish hardware and software serial links between microcontrollers.
- Configure synchronous bus interfaces using the I2C protocol (`<Wire.h>`).
- Implement non-blocking Interrupt Service Routines (`onRequest` / `onReceive`).

This task will reinforce these skills along with the following ones:
- Designing multi-node micro-controller topologies ($1 "Master" + 3 "Slaves"$).
- Master-driven telemetry routing and multi-slave bus arbitration.
- Sensor data scaling, PWM actuation, and real-time text rendering over I2C.
- Bidirectional bus telemetry feedback loops.
- Embedded data logging over the SPI protocol.

= Tasks

Please use #emphasis[SimulIDE] or #emphasis[Tinkercad Circuits] to simulate and finish the task, or implement it physically using hardware.

== Multi-Slave Distributed Control & Telemetry System

You are tasked with designing and implementing a multi-node distributed embedded system over an I2C communication bus. The network consists of *1 Master Controller* and *3 Dedicated Slave Nodes*, each performing isolated sensing, actuation, or telemetry processing tasks.

=== Bus Topology & System Architecture

The network nodes operate under specific I2C 7-bit addresses:
- *Arduino 1 (Master Controller):* System Orchestrator & Router.
- *Arduino 2 (Slave 1 - Sensor Node - Address `0x0A`):* Analog Acquisition Unit.
- *Arduino 3 (Slave 2 - Telemetry Node - Address `0x0B`):* Character LCD Display Unit.
- *Arduino 4 (Slave 3 - Actuator Node - Address `0x0C`):* PWM Bargraph Actuator Unit.

#important[Ensure all four Arduino boards share a Common Ground (`GND`) connection. Connect $4.7 "k"Omega$ or $10 "k"Omega$ pull-up resistors on both `SDA` and `SCL` lines to $5"V"$ to ensure reliable bus arbitration in simulation/hardware.]

=== Subtask A: Sensor Node (Slave 1 - Address `0x0A`)

Sample the analog input from the potentiometer connected to Pin A0, process the raw 10-bit ADC reading into an 8-bit PWM value, and transmit this scaled byte to the Master Controller upon receiving an I2C request .

=== Subtask B: Actuator Node (Slave 3 - Address `0x0C`)

Receive a target PWM byte from the Master , drive a 5-LED bargraph array according to the received value, and send the active LED count ($0-5$) back to the Master when requested .

=== Subtask C: Telemetry Display Node (Slave 2 - Address `0x0B`)

Receive a 2-byte telemetry packet `[PWM_Value, Active_LED_Count]` from the Master , and display real-time readings on a 16x2 LCD with Line 1 showing `PWM Val: [Value]` and Line 2 showing `Active LEDs: [Count]`.

=== Subtask D: Master Routing & Arbitration Logic

The *Master Controller* must manage the bus flow periodically every $100 "ms"$ without using heavy blocking code:

1. Request the PWM byte from *Slave 1 (`0x0A`)*.
2. Send the PWM byte to *Slave 3 (`0x0C`)*.
3. Request the Active LED Count byte from *Slave 3 (`0x0C`)*.
4. Forward both readings `[PWM_Value, Active_LED_Count]` to *Slave 2 (`0x0B`)*.

#tip[Keep all I2C interrupt service routines (`Wire.onRequest` and `Wire.onReceive`) extremely short. Never use `Serial.print()` or `delay()` inside an ISR!]


= Submission

#important(
  title: "Important: SimulIDE / Tinkercad Submissions",
)[When submitting your work: include both the circuit schematic file (`.simu` or Tinkercad link) and the clean C++ source code files for all 4 microcontrollers (Master, Slave 1, Slave 2, Slave 3).]

#important(title: "Important: File Hosting")[
  Upload all source files and simulation files to Google Drive, set permissions to #emphasis[Viewable by Everyone], and paste the folder link in the submission form.
]

- You are required to submit via the Google Form: https://forms.gle/RLUQqzxZtdAVvPoY8
- Deadline: Friday, August 14th -- 11:59 pm

= Appendix

== Hardware Interfacing & Bus Pins

=== I2C Hardware Bus Wiring Topology
- *Master & Slave Pins:* `SDA` (Analog Pin `A4`), `SCL` (Analog Pin `A5`) -- this applies to the Arduino Nano and Uno REV3, not the Arduino Mega. Boards may have other dedicated `SDA` and `SCL` pins.
- *Pull-Up Requirement:* $4.7 "k"Omega$ resistors tied from `SDA` and `SCL` to $5"V"$.
- *Bus Speed:* Standard Mode ($100 "kHz"$).

== Arduino Uno Pinout & Reference

All Arduino boards are supported in Arduino IDE natively without extra package installation.

=== Power Properties
- Power over USB: YES
- Output voltages: $3.3"V"$, $5"V"$ 

#align(center)[
  #figure(caption: "Arduino Uno REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/uno-pinout.svg", width: 70%)
  ]
]

=== Arduino Nano
- *Connection:* Mini-USB or USB-C (depending on model)
- *Power Properties:* Power over USB (YES), Output Voltages ($3.3"V"$, $5"V"$)

#align(center)[
  #figure(caption: "Arduino Nano Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/nano-pinout.pdf", width: 60%)
  ]
]

=== Arduino Mega
- *Connection:* USB-B
- *Power Properties:* Power over USB (YES), Output Voltages ($3.3"V"$, $5"V"$)

#align(center)[
  #figure(caption: "Arduino Mega 2560 REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/mega-pinout.pdf", width: 58%)
  ]
]

== ESP32 Boards
Arduino IDE setup guide for ESP32 boards:\
https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html

== Common USB-to-Serial drivers:

- FTDI Drivers (FT232 series): #link("https://ftdichip.com/drivers/vcp-drivers/", "FTDI Downloads")
- Silicon Labs Drivers (CP210x series): #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "CP210x Downloads")
- WCH Drivers `CH340X`/`CH341X`: #link("https://www.wch-ic.com/downloads/CH341SER_ZIP.html", "CH341SER Downloads")