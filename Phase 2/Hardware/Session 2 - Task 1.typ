#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase II],
  topic: [Task 1: Transistors  & MOSFETs],
)
#show: report-template.with(ribbon-text: "Task 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

This task focuses on utilizing learned concepts related to transistors, MOSFETs and their applications.


= Requirements

This task features multiple sub-tasks. The main idea is to design and learn how transistors operate.

Proteus will be used as the main software.

Common component names in library:
- Vsource (DC source)
- Resistor
- 2n2222 (NPN Transistor)
-  BD136 (PNP Transistor)
- LED-BIBY (LED)
- IRFZ44N (N-channel MOSFET)
- Motor
- LDR
- Relay

#v(2cm)
Below are the required tasks and their descriptions.

== LDR circuit:

Create a circuit where the transistor turns on during nighttime and turns off during daylight.


#tip[Some of you were asked about this circuit in the interviews]

#v(1cm)

== On/Off DC motor

Using a push button, turn a DC motor on/off with an NPN/MOSFET.
Make sure to use a current-limiting resistor at the base and a pull-down resistor.
#tip[Same as workshop]

#v(4cm)

== Transistor H-Bridge (Bidirectional Motor Drive)

Using 4 transistors, control a motor in both directions.
Use 2 PNP transistors for the top side and NPN for the bottom side.

#tip[NPN turn on when HIGH. PNP turn on when LOW]
#tip[use signals to turn on/off transistors.]
#image("Assets/logic flags.PNG", height: 30%)

== Relay on/off

In modern electronics, microcontrollers operate at low power levels (typically 5V or 3.3V with a few milliamperes of current). If you connect a heavy load—such as a 12V mechanical relay or an AC motor—directly to a microcontroller pin, the heavy current draw will instantly burn out the controller. To bridge this gap, you will use a 2N2222 NPN Transistor as an electronic switch. 
In this task, you will: Wire the transistor so that a small base current turns the collector-emitter path fully "ON" (Saturation mode), allowing current to flow through the relay's internal electromagnetic coil. Isolate and Drive the Load: Use the mechanical switching contacts of the energized relay to safely power a separate 12V motor.

#tip[Don't forget to add a flyback diode. *(Research why we need a flyback diode)*]

#v(1cm)

*Submission link:* https://forms.gle/x8PLuukxhy4dTpin7 \
Upload proteus files\
*Deadline: Thursday 11:59 a.m* 