#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase II],
  topic: [Handout & Task for Session 3: PCB Design I],
)

#show: report-template.with(
  ribbon-text: "Session 3 | HANDOUT & TASK",
  foreground_watermark: watermark_text(
    content: "AUR",
    gaps: 1.75pt,
    size: 150pt,
    opacity: 15%,
  ),
)

= Session 3 Handout: PCB Fundamentals

This reference covers the core concepts, manufacturing rules, and software workflows introduced in *Session 3: PCB Design I*.

== 1. Physical Anatomy of a PCB

A standard two-layer Printed Circuit Board (FR-4) consists of 2 primary layers laminated together:

1. Copper layer
2. Plastic/Fiberglass


== 2. Component Packages: THT vs. SMD

#table(
  columns: (1.2fr, 1fr, 2fr),
  align: (left, left, left),
  table.header([*Category*], [*Mounting*], [*Best Use & Characteristics*]),
  [*Through-Hole (THT)*], [Leads pass through drilled PCB holes], [Connectors, power switches, bulky capacitors, beginner hand-soldering.],
  [*Surface-Mount (SMD)*], [Soldered directly onto surface pads], [Compact footprint, standard for automated assembly.],
)

*Common SMD Size Codes (Imperial):*
- `1206` & `0805`: Large, very easy to hand-solder. Recommended for beginners.
- `0603` & `0402`: Standard for dense modern electronics; requires fine tweezers and magnification.

== 3. Core Routing & Placement Rules

+ *Trace Angles:* Never route at $90 degree$ sharp angles. Use two $45 degree$ bends or smooth curves. Sharp corners cause acid traps during etching and create high-frequency impedance discontinuities.
+ *Ground Plane (Copper Pour):* Always pour a solid Ground polygon on both top and bottom layers. Its primary function is to act as a reference to GND (0v). This lowers ground impedance, improves heat dissipation, and minimizes return loop inductance. Copper areas have other applications, but for now, it's used as GND.

+ *Trace Widths:*
  It depends on whether you are fabricating the board yourself or it's being sent to a special factory to be fabricated.
  - In case you are fabricating it yourself, tracks should be no narrower than 1 mm; clearance also should be no narrower than 1 mm. (Clearance is the distance between the track and another track/copper area around it).
  These instructions are made to help overcome fabrication errors.
  You will use these instructions (or more width) in the training period unless instructed otherwise.
  
  - In case it's being sent to a factory, tracks can be as narrow as 0.254 mm, as well as clearance.

== 4. EasyEDA Essential Shortcuts

- *W:* Start Wire (Schematic) or Track (PCB)
- *Spacebar:* Rotate component or change track routing angle
- *N:* Place Net Label / Net Flag
- *Shift + B:* Rebuild all Copper Pours (Polygon Planes)
- *Ctrl + S:* Save to cloud / local workspace

#v(1cm)
---
#v(1cm)

= Tasks & Requirements

You will design a fully functional *5V Regulated Power Supply & 555 Timer LED Blinker* board in *EasyEDA (Standard Edition)*.
For this submission, all components must be through-hole; do not use SMD components.

== Milestone 1: Schematic Capture

Create a new EasyEDA project and draw the schematic:
- *Input Section:* Your input is a 12V supply through a 2-pin screw terminal block (Pitch $5.08"mm"$) with a `1N4007` reverse-polarity protection diode.
- *Regulator Section:* `LM7805` linear regulator (TO-220 package) plus a power-on LED indicator ($1"k"Omega$ resistor).
- *555 Oscillator Section:* `NE555P` (DIP-8) in astable multivibrator mode configured for $approx 1 - 2"Hz"$ oscillation, driving an output signal LED.

#tip[Always use *Net Labels* (e.g., `VCC`, `GND`, `555_OUT`) to keep schematic wires organized and readable.]

== Milestone 2: PCB Layout & Constraints

Convert your schematic to PCB (`Design -> Convert to PCB`) and meet the following layout rules:

1. *Board Dimensions:* Maximum $50"mm" times 50"mm"$ with four $3"mm"$ M3 mounting holes in the corners. (Research how to add mounting holes and why we use them.)
2. *Component Placement:* Connectors on board edges, and silkscreen labels facing the same direction. (Silkscreen is added and edited on the top silkscreen layer.)

3. *Trace Widths:*
  - Tracks: $>= ($1"mm") \ 
4. *Grounding:* Add a *Copper Area* (GND) on Bottom layer.
5. *Verification:* Run the *Design Rule Check (DRC)* and resolve every issue until you get *0 DRC Errors*.(Research DRC rules and how to edit and test them.)

#important[Check that every component has a valid physical footprint assigned in the library before starting PCB routing.]

#v(0.4cm)

== Task 2: Low-Side DC Motor Driver Module

In this task, you will design a low-side MOSFET/transistor driver module. This circuit enables a low-voltage logic signal ($3.3"V" / 5"V"$ from a microcontroller or 555 timer) to safely drive and speed-control (via PWM) a higher-voltage inductive load ($9"V" - 12"V"$ DC motor).

=== 1. Schematic Specifications

- *Logic Input:* 3-pin male header connector (`VCC_LOGIC`, `PWM_IN`, `GND`).
- *Power Input:* 2-pin screw terminal block ($5.08"mm"$ pitch) for the motor supply (`VMOT`, `GND_PWR`).
- *Switching Transistor:* Logic-level N-Channel MOSFET (`IRLZ44N` in a TO-220 package) or NPN Darlington transistor (`TIP120`).
- *Gate Protection:*
  - A $100 Omega$ series resistor connected to the Gate/Base to prevent inrush current ringing.
  - A $10 "k"Omega$ pull-down resistor to GND to keep the MOSFET reliably OFF when the input is disconnected or floating.
- *Inductive Clamping (Flyback):* `1N4007` (or `1N5819` Schottky) diode placed in reverse-parallel across the motor output terminals to absorb inductive back-EMF voltage spikes.
- *Motor Output:* 2-pin screw terminal block ($5.08"mm"$ pitch) for connecting the external DC motor.
- *Indicators:*
  - Power LED (Red) on the `VMOT` rail with a $1 "k"Omega$ series resistor. (LED + Resistor are in parallel)

#tip[A motor is an *inductive load*. When switched off rapidly, the collapsing magnetic field produces a high-voltage spike (back-EMF) that will destroy the transistor if the flyback diode is missing.]

=== 2. PCB Layout Constraints

- *Loop Area:* Place the flyback diode physically as close as possible to the motor terminal pads to minimize the high-current switching loop area.
- *Trace Widths:*
  - Logic/Gate signal traces: ($1"mm"$).
  - High-current motor supply and drain traces (`VMOT`, Drain-to-Terminal, `GND` return): ($1.5"mm"$).
- *Copper Pour:* Create a solid GND copper pour on the bottom layer.
- *Silkscreen:* Clearly label connector pinouts (`VMOT`, `GND`, `PWM`, `M+`, `M-`) on the Top Silkscreen layer.

#important[Before finalizing, run the *Design Rule Check (DRC)* (`Design -> DRC`). Your layout must show *0 DRC Errors*.]
== Submission Guidelines

Submit your deliverables through the portal before the deadline:

- EasyEDA public shared project link. (Make sure anyone who has the link can view both schematic and PCB.)

#v(0.5cm)

*Submission Link:* #link("https://forms.gle/N4b1k7SUswPUnz8q8")[Google Form Submission] \
*Deadline:* Sunday, 11:59 PM