#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly
#import "@preview/cetz:0.3.1"
#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Task 3: Arduino],
)
#show: report-template.with(ribbon-text: "Task 3")

= Introduction

After attending the workshop and working with an Arduino microcontroller hands-on, you will have learned to:
- Use GPIO pins
- Write firmware that uses polling and loops to control logic

This task will reinforce these skills along with the following ones:
- Using analog input pins
- Using PWM output pins
- Writing interrupt handlers and using interrupts
- Using timer functions in the Arduino framework
- Using external libraries for Arduino
- More advanced state handling

= Tasks

Please use #emphasis[Tinkercad] or #emphasis[SimulIDE] to simulate and finish the tasks, or finish them using a physical implementation of the circuits.

== LED Chaser Circuit

In the workshop, you created a LED chaser circuit that had the following features:
- Implements LED chasing for 5 LEDs
- Implements chasing direction toggling using polling

Here is a refresher of what was done in the workshop.

We assembled the circuit seen in @workshop-circuit.
#align(center)[
  #figure(caption: "Circuit diagram at step 2 of the workshop")[
    #image("assets/workshop-guide-2-board.svg", width: 60%)
  ] <workshop-circuit>
]

We also wrote the firmware seen in @workshop-firmware.

Your firmware may have included more `for` loops in the main `loop()` function. This will have led to delays in polling the button press, where the Arduino would wait until the end of a full loop to read the button's state. The featured code checks for the button press between every step, which is a small improvement. One of the improvements you'll have to make is using an interrupt-based approach.

The required subtasks will be detailed in later subsections. You should implement the whole setup including all subtasks in one design and submit one deliverable containing everything required for this task.

#figure(caption: "Firmware code implemented so far")[
  ```cpp
  #define LED_COUNT 5
  #define DIRECTION_BUTTON_PIN 2
  int LEDS[LED_COUNT] = {3, 4, 5, 6, 7};
  bool is_forward = true;

  void setup() {
    for (int i = 0; i < LED_COUNT; i++) {
      pinMode(LEDS[i], OUTPUT);
    }
    pinMode(DIRECTION_BUTTON_PIN, INPUT_PULLUP);
  }
  int i = 0;  
  void loop() {
    digitalWrite(LEDS[i], HIGH);
    delay(250);
    digitalWrite(LEDS[i], LOW);
    if (digitalRead(DIRECTION_BUTTON_PIN) == LOW)
      is_forward = !is_forward;
    if (is_forward) {
      i++;
      if (i == LED_COUNT) i = 0;
    } else {
      i--;
      if (i == -1) i = LED_COUNT - 1;
    }
  }
  ```
] <workshop-firmware>


=== Potentiometer-Controlled Chasing Speed

Using a potentiometer as analog input, adjust the speed with which your firmware goes through LEDs.

#tip[Pay attention to the pin used as input for the potentiometer.]

=== Potentiometer-Controlled Brightness

Using _another_ potentiometer as analog input, adjust the brightness of the currently-lit LED using PWM or an software-based analog output.

#tip[Revise the pins used to output a voltage to the LED. You may need to use a specific type of pin to obtain accurate and consistent results.]

=== Interrupt-Based Direction Switcher
Upgrade the direction control by adding an external interrupt with the pushbutton for improved responsiveness and stability.


== Game Show Buzzer System

You are going to implement a buzzer system like the one used in IQ competition or game shows.

The system can be is characterized by the following information:
- Has a countdown `7-Segment Display` used to count down from 9 to 0
- Two contestants represented by two pushbuttons for their input are competing to hit the button first
- When the countdown timer reaches 0, a buzzer goes off until the Arduino is reset -- no player can push the button in this state, both lose
- Each player has a corresponding LED denoting a win state. When a player is first to hit the button: the player wins, their LED lights up, the game stops until the Arduino is reset


You should use interrupts and `millis()` over `digitalRead()` and `delay()`.

You should also familiarize yourself with the pinout of `7 Segment Display`s. See @seven-seg-pinout.
- The #emphasis[common anode] model requires `+5V` at the common pin and requires #emphasis[LOW] at a segment's pin to turn it #emphasis[ON].
- The #emphasis[common cathode] model requires `0V` at the common pin and #emphasis[HIGH] at a segment's pin to turn it #emphasis[ON].
You can configure the model by clicking on the component in Tinkercad.

#align(center)[
  #figure(caption: "7-Segment Display Segment Label Diagram")[
    #image("assets/7seg.svg", width: 15%)
  ] <seven-seg-pinout>
]

== Stopwatch with LCD Display

Using an LCD component in Tinkercad, build a digital stopwatch.

The following functionality should be implemented:
- Display the current minutes and seconds on an LCD
- Use a *pushbutton* to *pause* and *resume* the stopwatch
- To reset the stopwatch, perform a hard reset on the Arduino
- Add a short-beep buzzer output for acknowledged button presses

Learn how to use LCDs effectively by exploring their available libraries and documentation, see:
- https://docs.arduino.cc/learn/electronics/lcd-displays/
- https://docs.arduino.cc/libraries/liquidcrystal/

= Submission
#important(
  title: "Important: Tinkercad Links",
)[When submitting your work: use the "Send To" button in Tinkercad, then "Invite People", then copy the link for submission]
#important(title: "Important: Other Forms of Submission")[
  For submitting files, upload them first to Google Drive then share them and set them to #emphasis[Viewable by Everyone]
]
- You are required to submit via the Google Form: https://forms.gle/96Z4iVfJLaijxRtY6
- Deadline: Monday, August 10th -- 11:59 pm

= Appendix
This appendix contains pinouts and firmware programming references for different microcontrollers for people who will implement the circuit physically. This appendix is not meant to be comprehensive, but to provide a wide array of comparable and similar properties so you can identify what to look for in your microcontroller or your setup.

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
    #image("assets/uno-pinout.svg", width: 50%)
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
    #image("assets/nano-pinout.pdf", width: 45%)
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
    #image("assets/mega-pinout.pdf", width: 45%)
  ]
]


== ESP32 Boards
Arduino IDE setup guide for ESP32 boards:\
https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html

== Common USB-to-Serial drivers:

- FTDI Drivers (FT232 series): #link("https://ftdichip.com/drivers/vcp-drivers/", "FTDI Downloads")
- Silicon Labs Drivers (CP210x series): #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "CP210x Downloads")
- WCH Drivers `CH340X`/`CH341X`: #link("https://www.wch-ic.com/downloads/CH341SER_ZIP.html", "CH341SER Downloads")