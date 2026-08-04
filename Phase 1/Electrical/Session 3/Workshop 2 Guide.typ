#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Workshop 2: Arduino\ TRAINEE'S GUIDE],
)
#show: report-template.with(ribbon-text: "Workshop 2 | GUIDE")

= Introduction

This workshop focuses on utilizing learned concepts related to microcontrollers -- and specifically the Arduino microcontrollers -- like:
- Using GPIO pins
- Using analog input pins
- Using PWM output pins
- Writing firmware that uses polling and loops to control logic


The objective is to gain fundamental experience with interactive IO with Arduino microcontrollers.

= Requirements

The workshop features a continuous main task subdivided into multiple mini-tasks. The main idea is to design and assemble an #emphasis[interactive LED chaser] circuit.

The following components will be provided to you:
-	Microcontroller Board
- 5#sym.times LEDs
-	5#sym.times $330 Omega$ Current-Limiting Resistors
-	Breadboard & Jumper Wires
- 2#sym.times $10"-"100"k"Omega$ potentiometer
- 1#sym.times pushbutton

Please use #emphasis[Arduino IDE] or #emphasis[VSCode + PlatformIO] or #emphasis[CLion + PlatformIO] to receive help if you face any issues.

What follows are the set of required features and their descriptions.

== LED chaser circuit (5 LEDs)

Create a circuit where the microcontroller will control 5 LEDs such that they light up sequentially. For a demonstration of the required sequence:

$
  circle.filled circle circle circle circle\
  circle circle.filled circle circle circle\
  circle circle circle.filled circle circle\
  circle circle circle circle.filled circle\
  circle circle circle circle circle.filled\
  circle.filled circle circle circle circle\
$

Use a time delay technique so that each LED is visibly lit when its turn comes.

#tip[It is preferred to avoid using pins 0 and 1 for output since they are used for serial communication -- which will be covered in a later session.]

== Reverse Direction Button

Add a push button to reverse the direction of the chasing LEDs, implement the listening to the button state in your code using the polling technique. The bottom should act like a _toggle switch_ and is not expected to be continuously held down for reversing the direction.

When the button is pressed, the current LED is not forgotten. We want the previous LED to light up and the direction to reverse without resetting any tracked state. This applies to switching from forward mode to reverse mode and vice versa.

#tip[Pay attention to the pin mode used for the pin connected to the button and the consequent wiring of the button.]

== Potentiometer-Controlled Chasing Speed

Using a potentiometer as analog input, adjust the speed with which your firmware goes through LEDs.

#tip[Pay attention to the pin used as input for the potentiometer.]

== Potentiometer-Controlled Brightness

Using _another_ potentiometer as analog input, adjust the brightness of the currently-lit LED using PWM or an software-based analog output.

#tip[Revise the pins used to output a voltage to the LED. You may need to use a specific type of pin to obtain accurate and consistent results.]
= Appendix
Due to us not primarily using Arduino boards, there may be a limited number of boards available for the workshop. You may find yourself provided with any of the following boards. Please take a moment ot familiarize yourself with their pinout diagram and identify what's common between them and how pin usage will differ.

*PWM Pins*\
Pins supporting PWM output will usually be marked with a \~ sign next to their pin number.

*Analog Input Pins*\
Pins that support reading an analog input will usually have a pin name that starts with the letter A -- like `A0`.

*Power Pins*
- $5"V"$ output: `5V` or `VCC`
- $3.3"V"$ output: `3V3` or `VCC`
- Ground: `GND` or `G`

All arduino boards are supported on Arduino IDE without installing extra packages.

== Arduino Uno
=== Connection
USB-B

=== Power Properties
- Power over USB: YES
- Output voltages: $3.3"V"$, $5"V"$ 
=== Pinout Diagram
#align(center)[
  #figure(caption: "Arduino Uno REV3 Pinout Diagram")[
    #image("assets/uno-pinout.svg", width: 70%)
  ]
]

== Arduino Nano
=== Connection
Mini-USB or USB-C depending on model.
=== Power Properties
- Power over USB: YES
- Output voltages: $3.3"V"$, $5"V"$ 
=== Pinout Diagram
#align(center)[
  #figure(caption: "Arduino Nano Pinout Diagram")[
    #image("assets/nano-pinout.pdf", width: 60%)
  ]
]

== Arduino Mega
=== Connection
USB-B
=== Power Properties
- Power over USB: YES
- Output voltages: $3.3"V"$, $5"V"$ 
=== Pinout Diagram
#align(center)[
  #figure(caption: "Arduino Mega 2560 REV3 Pinout Diagram")[
    #image("assets/mega-pinout.pdf", width: 60%)
  ]
]


== ESP32 Boards
ESP32 boards will likely NOT be used as they require installing additional boards on Arduino IDE and installing serial USB IC drivers. You may safely ignore this section.

If given an ESP32 board, follow your mentor's instructions for getting it working.

You may expect to receive one of the following:
- `ESP-WROOM-32 38-Pin`
- `ESP-WROOM-32 30-Pin`
- `ESP32-S3-N16R8`

Common serial-over-USB ICs and their drivers are:
- FTDI chips, ex: `iFT232-S16`. #link("https://ftdichip.com/drivers/vcp-drivers/", "Drivers").
- CP210x chips, ex: `CP2102`. #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "Drivers").

Boards either use micro-USB or USB-C for connection.

Arduino IDE setup guide for ESP32 boards:\
https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html
