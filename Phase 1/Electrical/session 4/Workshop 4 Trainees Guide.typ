#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Workshop 4: Communication Protocols\ TRAINEE'S GUIDE],
)
#show: report-template.with(ribbon-text: "Workshop 4 | GUIDE")

= Introduction

This workshop focuses on configuring multi-controller architectures and implementing communication protocols between microcontrollers -- specifically Arduino development boards -- covering:
- Inter-board *Software Serial UART Communication* (Master-Slave Link).
- Synchronous *I2C Interface* for sensor data and actuators.
- Data command parsing and real-time output control.
- Common ground references and hardware serial synchronization.

The objective is to gain practical experience in transferring data streams across microcontrollers using hardware and software interfaces.

= Requirements

The workshop consists of two distinct multi-node communication tasks. You will design and implement a #emphasis[Software Serial Command Link] and an #emphasis[I2C Master-Slave Telemetry Link].

The following components will be provided to you in *Tinkercad Circuits* / *Hardware*:
- 2#sym.times Microcontroller Boards (Arduino Uno)
- 3#sym.times LEDs (Red, Green, Blue) or 1#sym.times RGB LED
- 1#sym.times Single LED (for PWM Telemetry Output)
- 1#sym.times Potentiometer ($10 "k"Omega$)
- 4#sym.times $220 Omega$ Current-Limiting Resistors
- Breadboard & Jumper Wires

Please use #emphasis[Arduino IDE] or #emphasis[Tinkercad Circuits]/#emphasis[Hardware] to build the circuits and write your C++ firmware.

What follows are the set of required features and their descriptions.

== Part 1: Serial Command Parser (Master-to-Slave via SoftwareSerial)

Set up an asynchronous serial link between *Arduino 1 (Master)* and *Arduino 2 (Slave)*:
- Connect Master `TX` (Pin 1) $arrow.r$ Slave `RX` (Pin 0).
- Connect Master `RX` (Pin 0) $arrow.r$ Slave `TX` (Pin 1).
- Connect Master `GND` $arrow.r$ Slave `GND` (Shared Common Ground).

The system behavior must satisfy the following logic:
1. *Arduino 1* receives a single character command (`'R'`, `'G'`, or `'B'`) from the PC Serial Monitor (`Serial`) and forwards it to Arduino 2 via Serial Communication (`TX`/`RX`).
2. *Arduino 2* receives the character over Serial (`RX`) and toggles the corresponding LED indicator:
   - `'R'` $arrow.r$ Turns ON the *Red LED* (and turns OFF others).
   - `'G'` $arrow.r$ Turns ON the *Green LED* (and turns OFF others).
   - `'B'` $arrow.r$ Turns ON the *Blue LED* (and turns OFF others).

#block(
  fill: rgb("fff8e6"),
  stroke: (left: 4pt + rgb("f59e0b")),
  inset: 10pt,
  radius: (right: 4pt),
  [
    #text(weight: "bold", fill: rgb("b45309"))[★ Bonus Challenge :] \
    Implement the inter-board communication using the `SoftwareSerial` library on custom digital pins instead of the primary hardware serial pins (`TX`/`RX`), allowing the primary `Serial` interface to remain dedicated to debugging.
  ]
)

#important[Always ensure both Arduino boards share a common `GND` connection to unify signal reference voltage.]

== Part 2: I2C Master-Slave Sensor & Actuator Interface

Establish an I2C communication bus between the two Arduinos using the `<Wire.h>` library:
- *Arduino 1 (Master):* Initiates periodic data requests.
- *Arduino 2 (Slave - Address `0x08`):* Samples local analog telemetry.

Hardware & Logical Requirements:
1. Connect a Potentiometer to Analog Pin `A0` on *Arduino 2 (Slave)*.
2. The Slave must continuously read the potentiometer, scale the 10-bit raw ADC reading ($0-1023$) to an 8-bit PWM value ($0-255$), and register an `onRequest` interrupt service routine using `Wire.onRequest()`.
3. *Arduino 1 (Master)* periodically requests $1 "byte"$ from address `0x08` using `Wire.requestFrom()`. Upon receiving the telemetry byte, it updates the brightness of an LED connected to its PWM `Pin 3` using `analogWrite()`.

#tip[In I2C interrupt handlers (`Wire.onRequest`), avoid calling blocking operations such as `delay()` or heavy `Serial.print()` calls.]

= Appendix

== Hardware Interfacing & Bus Pins

=== SoftwareSerial Interfacing (Part 1)
- *Arduino 1 (Master):* `Pin 10` (RX), `Pin 11` (TX)
- *Arduino 2 (Slave):* `Pin 10` (RX), `Pin 11` (TX)
- *Wiring Topology:* Cross-connected (`Pin 10` $arrow.r$ `Pin 11`, `Pin 11` $arrow.r$ `Pin 10`).

=== I2C Hardware Bus Interfacing (Part 2)
- *Master & Slave Pins:* `SDA` (Analog Pin `A4`), `SCL` (Analog Pin `A5`).
- *Bus Speed:* Standard Mode ($100 "kHz"$).

== Board Compatibility & Hardware Pinouts

All Arduino boards are supported in the Arduino IDE natively without extra package installation.

=== Arduino Uno
- *Connection:* USB-B
- *Power Properties:* Power over USB (YES), Output Voltages ($3.3"V"$, $5"V"$)

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
    #image("/Phase 1/Electrical/session 3/assets/mega-pinout.pdf", width: 60%)
  ]
]

=== ESP32 Boards
ESP32 boards will likely NOT be used as they require installing additional board packages in Arduino IDE and USB-to-Serial drivers. You may safely ignore this section unless instructed otherwise by your mentor.

If given an ESP32 board, common targets include:
- `ESP-WROOM-32 (38-Pin / 30-Pin)`
- `ESP32-S3-N16R8`

Common USB-to-Serial drivers:
- FTDI Drivers (`FT232` series): #link("https://ftdichip.com/drivers/vcp-drivers/", "FTDI Downloads")
- Silicon Labs Drivers (`CP210x` series): #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "CP210x Downloads")