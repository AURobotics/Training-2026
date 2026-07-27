#import "/Theme/report.typ": (
  brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "/Theme/generic_cover.typ": cover-page

#import "@preview/calloutly:1.1.0": important, tip

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Workshop 1: Electronics & Simulation\ MENTOR'S GUIDE],
)
#show: report-template.with(ribbon-text: "Workshop 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 30%,
))

= Introduction

This workshop focuses on implementing circuits with the following interactive components:
- switches, wires, pushbuttons
- LEDs
- resistors
- capacitors
- NPN transistors

The objective is to gain a fundamental basis in circuit analysis and DC electronic components.

You should familiarize yourself with this guide to be able to properly explain and aid trainees in the workshop.
= Requirements

== Logic Gates by Wiring Push Buttons

=== Task
You are going to simulate an AND gate and OR gate using push buttons, wires and an LED. For each gate design, use two push buttons representing both inputs and a single LED representing the output.

You will be provided with:
- 1#sym.times breadboard
- 1#sym.times 5V source
- 2#sym.times push button
- 1#sym.times LED
- 1#sym.times $330Omega$ resistor

Use these components once to design the AND gate, then re-use the same components to design the OR gate.

=== Guide
We're going to use the concepts of parallel and series wiring to design the circuits.

*AND Gate*
#align(center)[
  #figure(caption: "AND gate breadboard design")[
    #image("assets/and-gate-breadboard.svg", width: 50%)
  ]
  #figure(caption: "AND gate circuit schematic")[
    #image("assets/and-gate-schem.svg")
  ]
]
*OR Gate*
#align(center)[
  #figure(caption: "OR gate breadboard design")[
    #image("assets/or-gate-breadboard.svg", width: 50%)
  ]
  #figure(caption: "OR gate circuit schematic")[
    #image("assets/or-gate-schem.svg")
  ]
]

== Using NPN Transistor as a Switch

=== Task
Using a `2N2222` NPN transistor, construct the circuit shown in @npn-schem on a breadboard. The push button resembles a digital sensor giving `HIGH` or `LOW` readings.

You will be given an extra component not present in the schematic --- a $10"k"Omega$ resistor --- inform your mentor if and how you are going to use it.

#align(center)[
  #figure(caption: "Transistor switch circuit schematic")[
    #image("assets/workshop-1-npn-schematic.svg")
  ] <npn-schem>
]

To help you with assembling the circuit, see the pinout of the `2N2222` transistor from its datasheet in @npn-pinout

#align(center)[
  #figure(caption: [`2N2222` transistor pinout])[
    #image("assets/2n2222-npn.svg")
  ] <npn-pinout>
]

=== Guide
To correctly bias the transistor to work as an ON-switch, we need to apply voltage to the base terminal.

The $"R"_"B"$ resistor is used to protect the base, the $"R"_"LED"$ resistor exists to protect the LED. An extra resistor, $"R"_"PULLDOWN" = 10"k"Omega$ will need to be placed between the non-5V terminal of the push button and the ground line.

In @corrected-transistor-schem the corrected circuit schematic along with the breadboard wiring diagram in @transistor-switch-breadboard

#align(center)[
  #figure(caption: [Transistor switch circuit schematic -- corrected])[
    #image("assets/transistor-switch-schem.svg")
  ] <corrected-transistor-schem>
  #figure(caption: [Transistor switch circuit schematic -- corrected])[
    #image("assets/transistor-switch-breadboard.svg", width: 75%)
  ] <transistor-switch-breadboard>
]

== Soft-Start LED Circuit

=== Task
This part utilizes the concept of manually charging and discharging a capacitor. You are going to design and assemble a circuit that will cause an LED to gradually increase in brightness instead of turning on instantly.

You will be provided with the following additional components:
- push button
- LED
- $330Omega$ resistor
- $10"k"Omega$ resistor
- $470mu"F"$ capacitor
- NPN transistor (`2N2222`)


#tip[By varying the base voltage on a transistor, you vary the current going through its two other terminals.
  
  An uncharged capacitor will look like `GND` to connected components in the circuit. Electricity will be as happy to charge an uncharged capacitor as it is to find a short-circuit to ground.]

=== Guide

The task will require biasing the transistor using the capacitor. Since the capacitor starts uncharged, charging it will draw all current and will not leave current to enter the base directly from the supply until it reaches the supply's voltage level. As its voltage level rises, the current passed through the collector and emitter terminals of the transistor increases. After fully charging, the LED reaches full brightness before its brightness drops again as the capacitor is discharged.

Note that $"R"_"B"$ is now both a pull-down resistor and a base-protection resistor.

See @soft-start-schem and @soft-start-breadboard for the schematic and breadboard layouts.

#align(center)[
  #figure(caption: "Soft-start LED circuit schematic")[
    #image("assets/soft-start-schem.svg")
  ] <soft-start-schem>
]

#align(center)[
  #figure(caption: "Soft-start LED circuit schematic")[
    #image("assets/soft-start-breadboard.svg", width: 75%)
  ] <soft-start-breadboard>
]

= Appendix

#heading(level: 2, numbering: none, "9V Battery as a 5V Source")

In case you have access to a 9V battery and an `LM7805` voltage regulator, use the following configuration for obtaining a 5V source.

#align(center)[
  #figure(caption: "Regulator configuration")[
    #image("assets/regulator-configuration.svg", width: 45%)
  ]
]