#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Firmware | Phase 3], topic: "Task 1")
#show: report-template.with(ribbon-text: "Phase III - Firmware")

== Format and Deliverables
+ All tasks must be implemented PlatformIO projects.
+ Choose ATmega32 as the board in you platformio.ini file.
+ All Tasks must be Tested in simulide.
+ simulation file(.sim) must be uploaded.

== Task 1 — Timer0 CTC Mode: Periodic LED Toggle

=== Objective:
Use Timer0 in CTC (Clear Timer on Compare Match) mode to generate a precise periodic event.

=== Requirements:

+ Configure Timer0 in CTC mode.
+ Assume the CPU clock is 8 MHz.
+ Calculate OCR0 value to generate a compare-match event every 1 ms.
+ Use the Timer0 compare-match to create a 500 ms LED toggle period without using compare-match interrupt.
+ Connect an LED to PB0.
+ The LED should continuously blink with approximately 1 second ON/OFF cycle.

== Task 2 - Timer0 Fast PWM: control LED Brightness

=== Objective:
Use Timer0 PWM to control the brightness of an LED.

=== Requirements:

+ Configure Timer0 in Fast PWM mode.
+ Generate PWM on OC0 (PB3).
+ Assume F_CPU = 8 MHz.
+ set the prescaler to 8.
+ calculate resulting frequency and write it in a comment.
+ Start with a duty cycle of 25%.
+ Gradually increase the duty cycle then return to 25%.

== Task 3 — External Interrupt INT0: LED Toggle

=== Objective:
Use an external interrupt to respond to a button press.

=== Requirements:

+ Connect an LED to PB0.
+ Connect a push button to INT0 (PD2).
+ Configure INT0 to trigger on a falling edge.
+ Enable the global interrupt system.
+ Initially, the LED should be OFF.
+ Every time the button is pressed, the INT0 ISR should toggle the LED.



