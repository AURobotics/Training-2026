#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase II],
  topic: [Workshop 1: Transistors  & Mosfets\ MENTOR'S GUIDE],
)
#show: report-template.with(ribbon-text: "Workshop 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

This workshop focuses on utilizing learned concepts related to transistors, MOSFETs and their applications.


= Requirements

The workshop features multiple tasks. The main idea is to design and learn how transistors operate.

Proteus will be used as the main software & if we have time on our hand we will work with real components.

Common component names in library:
- Vsource (DC source)
- Resistor
- 2n2222 (NPN Transistor)
- LED-BIBY (LED)
- IRFZ44N (N-channel MOSFET)
- Motor
- BD135 (NPN transistor for real components)

Please help trainees if they face any issues.

What follows are the set of tasks required and their descriptions.

== LDR circuit:

Create a circuit where the transistor turns on during nighttime and turns off during daylight

  #image("Assets/ldr-circuit.PNG", width: 75%)



#tip[Use Vsource instead of voltage source. If 47k ohms are too much, try decreasing the value]

#v(1cm)

== On/Off DC motor

Using a push button, turn a DC motor on/off with an NPN/MOSFET.
Make sure to use a current-limiting resistor at the base.

#image("Assets/motor control circuit.PNG", width: 70%)


== Transistor H-Bridge (Bidirectional Motor Drive)

Using 4 transistors, control a motor in both directions.
Use 2 PNP transistors for the top side and NPN for the bottom side.
- Use BD136 as your PNP transistor
- Use BD135 as your NPN transistor.
- Use 470 ohms as the base resistor.

#image("Assets/hbridge.PNG", width: 80%)

#tip[NPN turn on when HIGH. PNP turn on when LOW]
#tip[use signals to turn on/off transistors.]

== Repeat On/Off DC motor circuit with real components

Components needed:
- 12V adapter 
- 5v adapter
- BD135 NPN transistor
- 1N4007 diode (To prevent back EMF)
- Breadboard
- 470 ohm resistors
- Button
- DC motor

