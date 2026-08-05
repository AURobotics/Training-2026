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
- Inter-board *UART Serial Communication* (Master-Slave Link).
- Synchronous *I2C Interface* for external displays.
- Data forwarding and real-time text rendering.
- Common ground references and hardware serial synchronization.

The objective is to gain practical experience in transferring data streams across two microcontrollers and rendering the received information on an I2C display.

= Requirements

The workshop features a multi-node communication system subdivided into two core milestones. The main objective is to design and assemble a #emphasis[Master-Slave Serial Bridge with I2C Display] circuit.

The following components will be provided to you in *Tinkercad Circuits*:
- 2#sym.times Microcontroller Boards (Arduino Uno)
- 1#sym.times I2C LCD Display (16x2 with PCF8574 Adapter)
- Breadboard & Virtual Jumper Wires

Please use #emphasis[Tinkercad Circuits] or #emphasis[Arduino IDE] to assemble the circuit and write the C++ firmware.

What follows are the set of required features and their descriptions.

== Part 1: Arduino-to-Arduino UART Serial Bridge

Set up an asynchronous serial link between *Arduino 1 (Master)* and *Arduino 2 (Slave)*:
- Connect Master `TX` (Pin 1) $arrow.r$ Slave `RX` (Pin 0).
- Connect Master `RX` (Pin 0) $arrow.r$ Slave `TX` (Pin 1).
- Connect Master `GND` $arrow.r$ Slave `GND` (Shared Common Ground).

Configure both hardware UART interfaces at a *Baud Rate of 9600 bps*. 

Write firmware for *Arduino 1 (Master)* to read incoming text data from the computer's Serial Monitor and forward it immediately across the hardware serial line to *Arduino 2 (Slave)*.

#important[Always ensure a common GND connection between both Arduino boards. Without a shared 0V reference, signal levels will be misread, causing data corruption.]

#tip[Avoid using `delay()` inside serial reading loops to prevent hardware buffer overruns.]

== Part 2: I2C LCD Display Rendering on Slave Node

Connect the 16x2 I2C LCD Display exclusively to *Arduino 2 (Slave)*:
- LCD `SDA` $arrow.r$ Slave Analog Pin `A4`
- LCD `SCL` $arrow.r$ Slave Analog Pin `A5`
- LCD `VCC` $arrow.r$ Slave `5V`
- LCD `GND` $arrow.r$ Slave `GND`

Firmware requirements for *Arduino 2 (Slave)*:
1. Initialize the I2C LCD screen at address `0x27` (or `0x3F`) using `<Wire.h>` and `<LiquidCrystal_I2C.h>`.
2. Listen continuously on the UART `RX` pin for incoming messages sent by *Arduino 1 (Master)*.
3. Parse the incoming string and render the received text live on the I2C LCD screen.

#tip[Use `lcd.clear()` or manage cursor positioning properly before printing new serial frames to prevent overlapping old characters on the display.]

= Appendix

== Hardware Interfacing & Pinout Reference

=== UART Interface Connections
- *Data Rate:* $9600" bps"$
- *Logic Voltage:* $5"V"$
- *Wiring Topology:* Cross-connected (`TX` to `RX`, `RX` to `TX`)

=== I2C Display Connections
- *Address:* `0x27` or `0x3F`
- *Signal Lines:* `SDA` (Pin A4), `SCL` (Pin A5)

== Arduino Uno Hardware Details

=== Power & Logic Properties
- Logic Level: $5"V"$
- Output Voltages: $3.3"V"$, $5"V"$
- Common Ground: Shared `GND` pin connection required across both boards.

=== Pinout Diagram
#align(center)[
  #figure(caption: "Arduino Uno REV3 Pinout Diagram")[
   #image("/Phase 1/Electrical/session 3/assets/uno-pinout.svg", width: 70%)
  ]
]
