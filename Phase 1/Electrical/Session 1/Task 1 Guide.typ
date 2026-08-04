#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: [Task 1: Electronics & Simulation\ TRAINEE GUIDE])
// #show: report-template.with(ribbon-text: "Task 1", foreground_watermark: watermark_text(
//   content: "INTERNAL USE ONLY",
//   gaps: 1.25pt,
//   opacity: 40%,
// ))
#show: report-template.with(ribbon-text: "Task 1 | GUIDE")

= Introduction

After watching #link("https://youtu.be/wwTRPQ_a-CM", "Session 1"), you should be able to use #emphasis[Tinkercad] to design basic electronic circuits that perform certain functions.

The task evaluates and refreshes basic circuit analysis and design principles and guidelines.

// Grading is done on a point system out of 10 points. Each subtask accumulates positive or negative points according to set guidelines, and an optional multiplier system can be applied to accumulated points.

= Deliverables

== Logic Gates with Transistors
=== Requirement
Implement the AND gate and OR gate using transistors. Use push buttons as inputs to test the gates.

_For simulation purposes, you may use DIP switches instead of push buttons._

=== Trainee Guide

#align(center)[#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  figure(
    image("assets/task1-1and-tinkercad.svg", width: 100%),
    caption: [AND gate Tinkercad design],
  ),
  figure(
    image("assets/task1-1and-schem.svg", width: 100%),
    caption: [AND gate circuit schematic],
  ),
)]

#align(center)[#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  figure(
    image("assets/task1-1or-tinkercad.svg", width: 100%),
    caption: [OR gate Tinkercad design],
  ),
  figure(
    image("assets/task1-1or-schem.svg", width: 100%),
    caption: [OR gate circuit schematic],
  ),
)]

// === Grading Guide
// Points:
// - Using breadboard: +2pt
// - Using power rails: +2pt
// - Avoiding floating input error: +3pt
// - Using reasonable resistance and supply values: +3pt
// Multipliers:
// - Base multiplier: +0.5#sym.times
// - LED changes output according to changing input: +0.1#sym.times point multiplier
// - Correct truth table achieved: +0.4#sym.times point multiplier

== Automatic Night Light
=== Requirement
Design and implement an automatic night light using an LDR and an NPN transistor.

*Explanation*

The LED should remain OFF in bright light.
The LED should turn ON automatically in the dark.
Explain how the transistor works as a switch and how the LDR affects the circuit.

=== Trainee Guide
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    figure(
      image("assets/task1-2-tinkercad.svg", width: 100%),
      caption: [Tinkercad design],
    ),
    figure(
      image("assets/task1-2-schem.svg"),
      caption: [Circuit schematic],
    ),
  )
]


== Blinking LED Circuit

=== Requirement
Design and implement a blinking LED circuit using any method of your choice.

#tip[You may use an IC that was mentioned in the session. If you used an online resource for help, mention it in a note or include your calculations for the timing in a note.]

=== Trainee Guide
Note that the duration for which the LED is ON or OFF are calculated as follows:
$
  T_"off" = 0.69 times C_1 times R_2\
  T_"on" = 0.69 times C_1 times (R_1 + R_2)
$
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    figure(
      image("assets/task1-3-tinkercad.svg", width: 100%),
      caption: [Tinkercad design],
    ),
    figure(
      image("assets/task1-3-schem.svg", width: 75%),
      caption: [Circuit schematic],
    ),
  )
]

== Temperature Alarm Circuit
=== Requirement
A factory owner wants to monitor the temperature of a component. Implement a circuit using a PTC thermistor
and a transistor to trigger an alarm (buzzer or similar) when the temperature exceeds a certain threshold.

#note[
  There is no actual component called PTC thermistor in Tinkercad.

  For reference: a PTC thermistor's resistance *increases* as temperature *increases*. We want the buzzer to beep when temperature *increases*.

  You have three options:

  + Use a `Potentiometer` to directly alter resistance. You should make the alarm beep when resistance is high.\ Reference: https://www.build-electronic-circuits.com/potentiometer/

  + Use Temperature Sensor `TMP36`: its voltage drop or "resistance" decreases as the reading increases. You should make the alarm turn *on* when the sensor value is *low* --- i.e when the sensor resistance is *high*.

  + If you prefer to, you can use something other than Tinkercad to submit the task.
]

=== Trainee Guide
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    figure(
      image("assets/task1-4-tinkercad.svg", width: 100%),
      caption: [Tinkercad design],
    ),
    figure(
      image("assets/task1-4-schem.svg", width: 100%),
      caption: [Circuit schematic],
    ),
  )
]
