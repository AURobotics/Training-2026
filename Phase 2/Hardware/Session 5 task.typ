#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase II],
  topic: [Task 4: Carrier board for dev boards],
)
#show: report-template.with(ribbon-text: "Task 4", foreground_watermark: watermark_text(
  content: "A U R",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

The last session introduced you to Microcontrollers & Dev boards.\
#emphasis("Dev boards:") A PCB containing a microchip or processor and the supporting hardware needed to test, program, and prototype electronic projects. Ex: Arduino UNO, ESP32 dev board, STM32 Blackpill.
These dev boards are often used on breadboards or carrier boards.\
#emphasis("Carrier boards:") A PCB that has pin headers where you insert a devboard/module/lcd or any external device.

#emphasis("Example of a carrier board:")
#image("Assets/rover.PNG", height: 45%)

= How to design a carrier board:
Since a dev board isn't a single component, you won't find the ESP32 dev board or STM32 Black Pill in the JLCPCB or LCSC search.\
You will have to search in the #emphasis("User Contributed") in the search section in EasyEDA.\
- The user-contributed parts are not verified by companies, and they often have the wrong symbols, footprints, and dimensions.
- They are to be used in extreme conditions when the part you are searching for is not available at all or when using dev boards.
When using a part from the user contributed section, a few guidelines have to be followed:
- Make sure the symbol is correct and pins are in the right order.
- Make sure the footprint has the right dimensions (even up to 0.2 mm).
- Make sure the footprint has the right pin order.
- For MCUs, make sure row spacing is correct and pin spacing is correct.
- For MCUs, make sure outer board dimensions are correct.



= Requirements

We design a carrier board in order to be used with a dev board.
A dev board is connected to the PCB with pin headers.\
For example: an ESP32 board is connected, and we need to supply it with power from an external source. So we connect a 2-pin terminal block; one pin has 3.3V and the other is GND. So we wire the 3.3V from the terminal block to the pin header corresponding to the ESP's power pin. The GND should be wired to ESP GND and it should be connected via copper area.

Before you start working, if you need some help understanding or imagining how the board is supposed to be, you might want to take a look at this carrier board:\ https://u.easyeda.com/join?type=project&key=16122de73d5d3fed0049c59fa45dd2dd&inviter=6819f4086531448dafdf0b2b2df64e1a
#tip("View schematics, PCB and 3D view")
#tip("Ignore connections in the schematics that you don't understand and work to the best of your knowledge")
- EasyEDA Std. version will be used as the main software.\
- You can use both through-hole & SMD components.
- In case you use SMD components, do not use a smaller footprint than 0805 for capacitors and resistors.
- MCU & through-hole components are to be placed on the top layer.
- Tracks, copper area & SMD components are to be placed on the bottom layer.
- #emphasis("Verify multiple times that the Dev board you have chosen matches the real dev board.")
- Measure row spacing, pin spacing, and total dimensions before starting the schematic using the measure tool.
- Choose your footprint, check pin order, convert to PCB, measure, then go back to the schematic if correct.
https://makerselectronics.com/product/esp32-wroom-32-development-boar/?srsltid=AfmBOorO4kC0LtopXvmgFX_a1JUdzQWKr0gUMOhogQAppJE0B1BVL9JF

#v(0.5cm)

#align(center)[
  #text(16pt, weight: "bold")[Task: ESP32 Single-Sided Breakout Carrier]
]

#v(1em)

== 1. Objective
Design and route a single-sided PCB (bottom layer traces only) hosting an **ESP32-WROOM-32 (38-Pin)** development module. Because this board uses a single copper layer, all traces must reach their destinations without crossing any other copper traces.

== 2. Required Bill of Materials (BOM)

#table(
  columns: (1fr, 2fr, 2fr),
  align: (center, left, left),
  table.header([*Prefix*], [*Component*], [*Package / Footprint*]),
  [U1], [ESP32-WROOM-32 DevKit (38-Pin)], [2.54mm Dual Row DIP (0.9" row span)],
  [J1], [2-Pin Screw Terminal (Main Power)], [5.08mm Pitch, 2-Pin],
  [J2], [3-Pin Header (Analog Sensor Port)], [2.54mm Male Header, 1x3],
  [J3], [4-Pin Screw Terminal (I2C Bus)], [5.08mm Pitch, 4-Pin],
  [J4], [3-Pin Header (Digital Output Port)], [2.54mm Male Header, 1x3],
)

== 3. Schematic Net Connections

To avoid crossing nets on a single layer, follow the physical pin mapping below:

=== Left Side: Analog Sensor & Power Input
Place J1 and J2 along the left board edge. Pins run top-to-bottom without crossing:

- *Analog Sensor Interface (J2 - 3-Pin Header)*:
  - `J2 Pin 1` $arrow.r$ `3.3V` (Connect to `U1 Pin 1` - 3.3V)
  - `J2 Pin 2` $arrow.r$ `ADC0` (Connect to `U1 Pin 3` - GPIO36 / ADC0)
  - `J2 Pin 3` $arrow.r$ `GND`  (Connect to `U1 Pin 14` - GND)
- *Power Input (J1 - 2-Pin Screw Terminal)*:
  - `J1 Pin 1` $arrow.r$ `GND`    (Tap from `U1 Pin 14` / shared GND track)
  - `J1 Pin 2` $arrow.r$ `Vin 5V` (Connect to `U1 Pin 19` - Vin 5V)

=== Right Side: I2C Bus & SPI / GPIO Header
Place J3 and J4 along the right board edge. Pins run top-to-bottom without crossing:

- *I2C Terminal Block (J3 - 4-Pin Screw Terminal)*:
  - `J3 Pin 1` $arrow.r$ `GND` (Connect to `U1 Pin 38` - GND)
  - `J3 Pin 2` $arrow.r$ `U1 Pin 37` (GPIO23)
  - `J3 Pin 3` $arrow.r$ `U1 Pin 36` (GPIO22 - I2C SCL)
  - `J3 Pin 4` $arrow.r$ `U1 Pin 33` (GPIO21 - I2C SDA)
- *SPI / Digital Output Header (J4 - 3-Pin Header)*:
  - `J4 Pin 1` $arrow.r$ `U1 Pin 31` (GPIO19 - SPI MISO)
  - `J4 Pin 2` $arrow.r$ `U1 Pin 30` (GPIO18 - SPI SCK)
  - `J4 Pin 3` $arrow.r$ `U1 Pin 29` (GPIO5 - SPI SS)

== 4. PCB Layout & Routing Rules

1. *Component Placement*:
   - Mount all THT footprints on the *Top Layer*.
   - Place `J1` and `J2` along the **left edge** of the PCB.
   - Place `J3` and `J4` along the **right edge** of the PCB.
   - Maintain the standard orientation: pin 1 of the ESP32 facing top-left.
2. *Routing Restrictions*:
   - **Bottom Layer Only (`B.Cu`)**: No vias, no jumpers, and no top traces allowed.
   - **Track Width**: Use `0.8 mm` for power traces (`VIN`, `3V3`, `GND`) and `0.4 mm` for signal traces.
   - **Clearance**: Minimum `0.3 mm` clearance between traces and pads.

#v(0.5cm)

*Submission link:* https://forms.gle/1swQFFYzsKdqkGVm7  \
*Deadline: Wednesday 11:59 p.m* 