#import "/Theme/report.typ": (
  brand-palette, emphasis, watermark_text, pause-page-counting, report-template, resume-page-counting, cover-page
)

#import "@preview/calloutly:1.1.0": important, tip, note

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: "Task 1: Electronics & Simulation")
// #show: report-template.with(ribbon-text: "Task 1", foreground_watermark: watermark_text(
//   content: "INTERNAL USE ONLY",
//   gaps: 1.25pt,
//   opacity: 40%,
// ))
#show: report-template.with(ribbon-text: "Task 1")

= Introduction

After watching #link("https://youtu.be/wwTRPQ_a-CM", "Session 1"), you should be able to use #emphasis[Tinkercad] to design basic electronic circuits that perform certain functions.

You are required to solve the problems by creating a #emphasis[Circuit] #box(image("assets/tinkercad-circuit-button.svg", height: 1em)) design in Tinkercad _for each deliverable separately_.

= Deliverables

== Logic Gates with Transistors
Implement the AND gate and OR gate using transistors. Use push buttons as inputs to test the gates.

_For simulation purposes, you may use DIP switches instead of push buttons._

== Automatic Night Light
Design and implement an automatic night light using an LDR and an NPN transistor.

*Requirements*

The LED should remain OFF in bright light.
The LED should turn ON automatically in the dark.
Explain how the transistor works as a switch and how the LDR affects the circuit.

== Blinking LED Circuit
Design and implement a blinking LED circuit using any method of your choice.

#tip[You may use an IC that was mentioned in the session. If you used an online resource for help, mention it in a note or include your calculations for the timing in a note.]

== Temperature Alarm Circuit
A factory owner wants to monitor the temperature of a component. Implement a circuit using a PTC thermistor
and a transistor to trigger an alarm (buzzer or similar) when the temperature exceeds a certain threshold.

#note[
There is no actual component called PTC thermistor in Tinkercad.

For reference: a PTC thermistor's resistance *increases* as temperature *increases*. We want the buzzer to beep when temperature *increases*.

You have three options:

+ Use a `Potentiometer` to directly alter resistance. You should make the alarm beep when resistance is high.\ Reference: https://www.build-electronic-circuits.com/potentiometer/

+ Use Temperature Sensor `TMP36`: its voltage drop or "resistance" decreases as the reading increases. You should make the alarm turn *on* when the sensor value is *low* --- i.e when the sensor resistance is *high*.

+ If you prefer to, you can use something other than Tinkercad to submit the task.]

= Submission

- Submit your work by sharing your Tinkercad project link

#important(title: "Important: Tinkercad Links")[When submitting your work: use the "Send To" button in Tinkercad, then "Invite People", then copy the link for submission]

- Alternatively, you may use other simulation software that you are more comfortable with
  - Supported options are: Proteus, NI Multisim, LTSpice, KiCAD, SimulIDE
  - In case you do, submit a separate file for each deliverable
  - This is only a guarantee that we will open and evaluate attempts made in any of these programs, not that they are suitable for tasks

- Alternatively, you may submit a picture or link to a short video of an actual hardware circuit implementation for each deliverable
- Upload your work via the following Google Form link: https://forms.gle/S8uL7oomXSPf4Uz9A
- Deadline: Thursday, July 30th -- 11:59 pm