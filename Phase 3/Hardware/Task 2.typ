#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase III],
  topic: [Task 2: Motor Driver Schematic & PCB],
)
#show: report-template.with(ribbon-text: "Task 2 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

This task focuses on component selection, schematic capture, and PCB design for a discrete H-bridge motor driver. You will select suitable power MOSFETs, gate drivers, and passive components, then layout the complete board in EasyEDA.

= Handout

#v(0.5cm)

#tip(title: "Reference Design")[
  Refer to the provided module schematic for structural guidance. Your final schematic should feature similar functional blocks: Power/Interface, Half-Bridge Gate Drivers, and the main N-Channel MOSFET H-Bridge.
]
#tip("For component selection, use Google, makers electronics, JLCPCB, and datasheets, with the assistance of AI to help you improve your design.")

= Requirements

- EasyEDA Standard version will be used as the primary software.
- The board should be no bigger than #emphasis("10 cm x 5 cm")
- Your load is a 24V motor which draws 10A.
- #emphasis("All components must be verified that they can withstand the required voltage & current passing through them ")

#v(0.2cm)

== 1. Power & Interface Stage

- *Connectors:* Include dedicated screw terminals (HB9500SS) for high-current power input and motor outputs, alongside a shrouded header for MCU control signals (PWM1, PWM2, EN).\
- The HB9500SS are bigger terminal blocks that are normally used due to higher voltages & current, which means thicker wires than normal.
- *Filtering:* Combine high-capacity bulk electrolytic storage (1000 uF) for voltage dip suppression with smaller ceramic decoupling capacitors (100 nF) close to driver power pins.

#tip(title: "Hint: Logic Protection")[
  Add pull-down resistors (e.g., 10 kohm) on all logic input pins (PWM, Enable) to prevent gates from floating during microcontroller power-up.
]

== 2. Gate Driver Stage

- *Driver Selection:* Implement dedicated half-bridge driver ICs (e.g., IR2104) (Don't use the same IC as video) to switch high-side and low-side N-channel MOSFETs safely.
#tip("Your gate driver IC should be able to power the mosfets & withstand 24v or more, always refer to datasheets for connections & ratings")
- *Bootstrap Circuitry:* Properly size the bootstrap capacitor (1 uF) and use ultrafast recovery diodes (e.g., SF16G) between +12V and VB. (If you don't understand bootstraping, do your research before applying them.)
- *Asymmetrical Gate Switching:* Place gate drive resistors in parallel with Schottky diodes (e.g., 1N5817) pointing toward the driver output.

#v(0.2cm)

== 3. H-Bridge & Protection Stage

- *MOSFET Bridge:* Select four N-channel power MOSFETs (e.g., IRLZ44N) (Don't use the same MOSFET as video) configured as a full H-bridge. Verify RDS(on), VDS breakdown rating, and gate threshold limits.
- *Flyback Diodes:* Add antiparallel fast-recovery diodes (e.g., U10A7CI) across each MOSFET to redirect inductive kickback energy from the motor windings.
- *Thermal Management:* Allocate appropriate board space for TO-220 heatsinks across all active switching devices.

#tip(title: "Hint: Thermal managment")[
  Through-hole MOSFETs have holes on the back tab; you can mount heatsinks using screws. Heat sinks are used because MOSFETs get very hot during operation, and it can help with heat distribution, as it's made of aluminum.
]

#image("assets/mosfet.PNG")


== 4. PCB Layout Rules
- *Layers:* You shall use a 2- layer layout; the 2 layers should have GND copper areas. Try to minimize the usage of the 2nd layer.
- *Vias:* Don't use vias for power traces (Motor output, input supply); vias can only be used for logic signals.
- *Trace Sizing:* Calculate trace widths for high-current paths (VCC, Motor 1, Motor 2, Power GND). Use wide traces or copper fills. Research & Calculate the required track width for each power track, and for logic tracks, use 0.254 mm tracks.

- *Gate Driver Proximity:* Place gate driver ICs, gate resistors, and bootstrap capacitors as physically close to their respective MOSFET gates as possible to minimize trace inductance.
- *Mounting:* Add M3 (Diameter = 3mm ) mounting hole in each corner of the board.

#v(1cm)

*Submission link:* https://forms.gle/ryFb5Zx83vTA5P8KA \
*Deadline: 21 September, Monday, 11:59 p.m.*