#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip, warning
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase III],
  topic: [Task 3: Custom MCU Board],
)

#show: report-template.with(
  ribbon-text: "Task 3",
  foreground_watermark: watermark_text(
    content: "AUR",
    gaps: 1.75pt,
    size: 150pt,
    opacity: 15%,
  ),
)

= Tasks & Requirements

You will design a custom telemetry and controller board centered around the *STM32F446RET6 (LQFP64)* MCU in *EasyEDA*. 

Unlike standard breakout boards, this system integrates high-speed digital communications alongside an onboard high-side $+12"V"$ inductive load switching circuit.


== 1. Core MCU Architecture (STM32F446RET6)

- *Power & Decoupling:* 
  - Supply $V_(D D)$ using a $+3.3"V"$ LDO regulator fed from a USB-C.
  - Every $V_(D D)$ pin must have its own dedicated $100"nF"$ local ceramic decoupling capacitor placed as physically close to the pin as possible.
  - *Filtering:* Use a Pi-filter network (Ferrite Bead + decoupling capacitors) to maintain low noise for the power line.
  - *Core Regulator:* Check *both* $V_(C A P 1)$ and $V_(C A P 2)$ pins.

- *Clocking & USB:*
  - External $8"MHz"$ HSE Crystal oscillator with correctly calculated load capacitors ($C_L$).
  - Native USB interface (`D+`, `D-`) featuring an ESD protection array (e.g., USBLC6-2SC6). 
  #emphasis("Research its importance & application")
- *Debug & Boot Setup:*
  - 4-pin SWD debug header (`SWDIO`, `SWCLK`, `3.3V`, `GND`).
  - Hardware $B O O T 0$ configuration line tied to a $10"k"Omega$ pull-down resistor to GND with selectable jumper header.


== 2. Peripherals & Sensor Interfacing

- *High-Speed SPI Sensor (e.g., IMU):*
  - Dedicated SPI headers (`SCK`, `MISO`, `MOSI`, `CS`) plus an EXTI hardware interrupt line (`INT`).
  - An external $10"k"Omega$ pull-up resistor to $+3.3"V"$ *must* be included on the Chip Select (`CS`) line to keep the bus idle during MCU boot/reset states.
- *UART Telemetry Interface:*
  - Broken out to a 4-pin header (`TX`, `RX`, `VCC`, `GND`).
  - Add inline series damping resistors ($22 Omega - 47 Omega$) on both `TX` and `RX` signal traces.

#warning[
  You *must* consult the STM32F446xx datasheet pinout definition tables to ensure your selected UART pins are explicitly designated as *5V-Tolerant ($F T$)*.
]


== 3. The Actuator Driver Circuit (+12V High-Side Solenoid)

Design an onboard two-stage MOSFET driver controlled via a single STM32 GPIO pin (*HIGH = Solenoid ON, LOW = Solenoid OFF*).

#import "@preview/tablex:0.0.8": tablex

- *12V Power Input:* Include a heavy-duty **Barrier Terminal Block (with protective cover)** for the $+12"V"$ main power input and `GND`. (you used this terminal block earlier)
- *Stage 1 (Low-Side Drive):* Drive the Gate of an N-Channel MOSFET (e.g., 2N7002 / BSS138) directly from a $3.3"V"$ GPIO pin.
  - Include a $10"k"Omega$ Gate-to-GND pull-down resistor to guarantee the solenoid remains OFF when the MCU is resetting or unprogrammed.
- *Stage 2 (High-Side Power Switch):* The N-FET Drain pulls down the Gate of a high-power P-Channel MOSFET (switching the $+12"V"$ supply rail to the output terminal block).
  - Include a $10"k"Omega$ Gate-to-12V pull-up resistor across the P-FET to guarantee crisp turn-off.
- *Protection:* Place a high-speed Schottky flyback diode (e.g., SS34 or 1N5819) directly across the output terminal block (Cathode to switched $+12"V"$, Anode to `GND`).


== 4. PCB Layout Constraints
- *Board size:* No bigger than 50 mm x 40 mm  
- *4-Layer Board:* (Signal, +3v3, GND, Signal)
- *Bottom signal layer* is limited to 4 tracks only.
- No 12V tracks should be routed through vias.
- *Switching Loop Area:* Minimize the physical loop area formed by the P-FET, flyback diode, and solenoid terminal block to contain high $d i / d t$ inductive spikes.
- *Trace Widths:*
  - High-current $+12"V"$ power rail and switched output traces: ($1.5"mm"$).
  - Low-voltage power rails (`+3.3V`, `VBUS`): ($0.8"mm" - 1.0"mm"$).
  - General digital logic & communication lines (`SPI`, `UART`, `SWD`): ($0.25"mm" - 0.4"mm"$).
- *Silkscreen Labeling:* Label all headers clearly on the Top Silkscreen layer (`SWD`, `UART`, `SPI`, `SOLENOID_12V`, `12V_IN`, `USB`, etc...).

#important[
  Run the *Design Rule Check (DRC)* (`Design -> DRC`) before submitting. Your design must pass with *0 DRC Errors* and *0 Unrouted Nets*.
]


== Submission Guidelines

Submit your deliverables through the portal before the deadline:

*EasyEDA Public Shared Project Link* (Ensure public read permissions for Schematic and PCB layout).


#v(0.5cm)

*Submission Link:* https://forms.gle/Ck49HK7ERqQqsRy87 \
*Deadline:* Saturday, 11:59 PM