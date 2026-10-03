#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Firmware | Phase 3], topic: "Task 3")
#show: report-template.with(ribbon-text: "Phase III - Firmware")

== Format and Deliverables
+ include DS1621.h in main (you are free to make DS1621.cpp or DS1621.c)
+ Choose Arduino nano as the board in you platformio.ini file.
+ All Tasks must be Tested in simulide.
+ simulation file(.sim) must be uploaded.

== Task — Custom I2C Driver for DS1621 Digital Thermometer

=== Objective:
Implement a robust, custom I2C register communication driver for the DS1621 temperature sensor featuring error status handling and multi-byte payload parsing.

=== Requirements:

+ Initialize the I2C interface and create custom wrapper functions for reading and writing that return error codes (e.g., detecting Address NACKs).

+ Configure the sensor by writing to its configuration register (0xAC) to set operational parameters (such as 1-shot mode or continuous conversion).

+ Send the "Start Convert T" command (`0xEE`) to command the sensor to begin an internal temperature conversion.


+ Implement a register read function utilizing a Repeated Start condition (`endTransmission(false)`) targeting the temperature register (`0xAA`).


+ Request and capture the 2-byte raw temperature payload from the sensor.


+ Parse the raw bytes to compute and print the final temperature value to the Serial Monitor.

+ bonus points for creating a class for DS1621