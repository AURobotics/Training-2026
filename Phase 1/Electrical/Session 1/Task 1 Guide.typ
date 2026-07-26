#import "/Theme/report.typ": (
  brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "/Theme/generic_cover.typ": cover-page

#import "@preview/calloutly:1.1.0": important, tip

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: [Task 1: Electronics & Simulation\ GUIDE])
#show: report-template.with(frame-title: "Task 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  opacity: 40%,
))

= Task Solutions

== Logic Gates with Transistors

=== Description
Implement the AND gate and OR gate using transistors. Use push buttons as inputs to test the gates.

=== Guide


== Automatic Night Light

=== Description

Design and implement an automatic night light using an LDR and an NPN transistor.

The LED should remain OFF in bright light.
The LED should turn ON automatically in the dark.
Explain how the transistor works as a switch and how the LDR affects the circuit.

=== Guide


== Blinking LED Circuit

=== Description
Design and implement a blinking LED circuit using any method of your choice.

#tip[You may use an IC that was mentioned in the session. If you used an online resource for help, mention it in a note or include your calculations for the timing in a note.]

=== Guide

== Temperature Alarm Circuit
=== Description
A factory owner wants to monitor the temperature of a component. Implement a circuit using a PTC thermistor
and a transistor to trigger an alarm (buzzer or similar) when the temperature exceeds a certain threshold.

=== Guide