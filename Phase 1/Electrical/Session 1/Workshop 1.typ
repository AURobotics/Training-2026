#import "/Theme/report.typ": (
  brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text, cover-page
)

#import "@preview/calloutly:1.1.0": important, tip

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: "Workshop 1: Electronics & Simulation")
#show: report-template.with(ribbon-text: "Workshop 1")

= Introduction

This workshop focuses on implementing circuits with the following interactive components:
- switches, wires, pushbuttons
- LEDs
- resistors
- capacitors
- NPN transistors

The objective is to gain a fundamental basis in circuit analysis and DC electronic components.
= Requirements

== Logic Gates by Wiring Push Buttons
You are going to simulate an AND gate and OR gate using push buttons, wires and an LED. For each gate design, use two push buttons representing both inputs and a single LED representing the output.

You will be provided with:
- 1#sym.times breadboard
- 1#sym.times 5V source
- 2#sym.times push button
- 1#sym.times LED
- 1#sym.times $330Omega$ resistor

Use these components once to design the AND gate, then re-use the same components to design the OR gate.

== Using NPN Transistor as a Switch
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

== Soft-Start LED Circuit

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

= Appendix

#heading(level: 2, numbering: none, "9V Battery as a 5V Source")

In case you have access to a 9V battery and an `LM7805` voltage regulator, use the following configuration for obtaining a 5V source.

#align(center)[
  #figure(caption: "Regulator configuration")[
    #image("assets/regulator-configuration.svg", width: 45%)
  ]
]