#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Task 4: Communication Protocols],
)
#show: report-template.with(ribbon-text: "Task 4")

= Introduction

After attending the workshop and working hands-on with inter-board communication protocols, you have learned to:
- Establish hardware and software serial links between microcontrollers.
- Configure synchronous bus interfaces using the I2C protocol (`<Wire.h>`).
- Implement non-blocking Interrupt Service Routines (`onRequest` / `onReceive`).

This task will reinforce these skills along with the following ones:
- Designing multi-node micro-controller topologies ($1 "Master" + 3 "Slaves"$).
- Master-driven telemetry routing and multi-slave bus arbitration.
- Sensor data scaling, PWM actuation, and real-time text rendering over I2C.
- Bidirectional bus telemetry feedback loops.
- Embedded data logging over the SPI protocol.

= Tasks

Please use #emphasis[SimulIDE] or #emphasis[Tinkercad Circuits] to simulate and finish the task, or implement it physically using hardware.

== Multi-Slave Distributed Control & Telemetry System

You are tasked with designing and implementing a multi-node distributed embedded system over an I2C communication bus. The network consists of **1 Master Controller** and **3 Dedicated Slave Nodes**, each performing isolated sensing, actuation, or telemetry processing tasks.

=== Bus Topology & System Architecture

The network nodes operate under specific I2C 7-bit addresses:
- *Arduino 1 (Master Controller):* System Orchestrator & Router.
- *Arduino 2 (Slave 1 - Sensor Node - Address `0x0A`):* Analog Acquisition Unit.
- *Arduino 3 (Slave 2 - Telemetry Node - Address `0x0B`):* Character LCD Display Unit.
- *Arduino 4 (Slave 3 - Actuator Node - Address `0x0C`):* PWM Bargraph Actuator Unit.

#important[Ensure all four Arduino boards share a Common Ground (`GND`) connection. Connect $4.7 "k"Omega$ or $10 "k"Omega$ pull-up resistors on both `SDA` and `SCL` lines to $5"V"$ to ensure reliable bus arbitration in simulation/hardware.]

=== Subtask A: Sensor Node (Slave 1 - Address `0x0A`)

Sample the analog input from the potentiometer connected to Pin A0, process the raw 10-bit ADC reading into an 8-bit PWM value, and transmit this scaled byte to the Master Controller upon receiving an I2C request .

=== Subtask B: Actuator Node (Slave 3 - Address `0x0C`)

Receive a target PWM byte from the Master , drive a 5-LED bargraph array according to the received value, and send the active LED count ($0-5$) back to the Master when requested .

=== Subtask C: Telemetry Display Node (Slave 2 - Address `0x0B`)

Receive a 2-byte telemetry packet `[PWM_Value, Active_LED_Count]` from the Master , and display real-time readings on a 16x2 LCD with Line 1 showing `PWM Val: [Value]` and Line 2 showing `Active LEDs: [Count]`.

=== Subtask D: Master Routing & Arbitration Logic

The **Master Controller** must manage the bus flow periodically every $100 "ms"$ without using heavy blocking code:

1. Request the PWM byte from *Slave 1 (`0x0A`)*.
2. Send the PWM byte to *Slave 3 (`0x0C`)*.
3. Request the Active LED Count byte from *Slave 3 (`0x0C`)*.
4. Forward both readings `[PWM_Value, Active_LED_Count]` to *Slave 2 (`0x0B`)*.

#tip[Keep all I2C interrupt service routines (`Wire.onRequest` and `Wire.onReceive`) extremely short. Never use `Serial.print()` or `delay()` inside an ISR!]

= Solution

== Master Controller (Arduino 1)

Polls Slave 1 for the potentiometer reading, forwards it to Slave 3, requests back the active LED count, and routes both values to Slave 2 for display — all on a $100 "ms"$ cycle.

```cpp
#include <Wire.h>
const byte slave1_addr = 0x0A;
const byte slave2_addr = 0x0B;
const byte slave3_addr = 0x0C;
uint8_t pot_reading = 0;
uint8_t led_count = 0;
void setup()
{
  Serial.begin(9600);
  Wire.begin();
}
void loop()
{
  Wire.requestFrom(slave1_addr, (uint8_t)1);
  if (Wire.available()) {
    pot_reading = Wire.read();
  }
  Wire.beginTransmission(slave3_addr);
  Wire.write(pot_reading);
  Wire.endTransmission();
  Wire.requestFrom(slave3_addr, (uint8_t)1);
  if (Wire.available()) {
    led_count = Wire.read();
  }
  Wire.beginTransmission(slave2_addr);
  Wire.write(pot_reading);
  Wire.write(led_count);
  Wire.endTransmission();
  delay(100);
}
```

== Slave 1 — Sensor Node (Address `0x0A`)

Reads the potentiometer on `A0`, scales the 10-bit ADC value down to an 8-bit PWM value, and hands it off to the Master via `onRequest`.

```cpp
// C++ code
//
#define pot_pin A0
#include <Wire.h>
byte slave_addr1 = 0x0A;
uint8_t pot_reading;
void send_data(){
	Wire.write(pot_reading);
}
void setup()
{
  pinMode(pot_pin, INPUT);
  Wire.begin(slave_addr1);
  Wire.onRequest(send_data);
}
void loop()
{
	pot_reading = map(analogRead(pot_pin),0,1023,0,255);
  delay(50);
}
```

== Slave 2 — Telemetry Display Node (Address `0x0B`)

Receives the `[PWM_Value, Active_LED_Count]` packet from the Master via `onReceive` and renders both values on the 16x2 LCD.

```cpp
// C++ code
//
//LCD RS pin to digital pin 12
//LCD Enable pin to digital pin 11
//LCD D4 pin to digital pin 5
//LCD D5 pin to digital pin 4
//LCD D6 pin to digital pin 3
//LCD D7 pin to digital pin 2
//LCD R/W pin to GND
//LCD VSS pin to GND
//LCD VCC pin to 5V
//LCD LED+ to 5V through a 220 ohm resistor
//LCD LED- to GND
#include "Wire.h"
#include "LiquidCrystal.h"
byte slave2_addr = 0x0B;
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
volatile uint8_t pwm;
volatile uint8_t led_count;
volatile bool data_received;
void received_data(int num_bytes){
  while(Wire.available()){
  	pwm = (int)Wire.read();
    led_count = (int)Wire.read();
    data_received=true;
  }
}
void setup()
{
  Wire.begin(slave2_addr);
  Wire.onReceive(received_data);
  lcd.begin(16, 2);
}
void loop()
{
  if(data_received){
    lcd.setCursor(0,0);
    lcd.print(pwm);
    lcd.setCursor(0,1);
    lcd.print(led_count);
    data_received = false;
  }
}
```

== Slave 3 — Actuator Node (Address `0x0C`)

Receives the target PWM byte from the Master via `onReceive`, drives the 5-LED bargraph accordingly, and reports the active LED count back via `onRequest`.

```cpp
int leds_pins[5] = { 8, 9, 10, 11, 12};
byte slave_addr3 = 0x0c;
#include "Wire.h"
volatile uint8_t received_byte;
volatile uint8_t num_of_leds;

void receive_data(int){
  while(Wire.available()){
    received_byte = Wire.read();
  }
}
void send_data(){
  Wire.write(num_of_leds);
}
void setup(){
  for(int i = 0 ; i < 5 ; i++){
  	pinMode(leds_pins[i],OUTPUT);
  }
  Wire.begin(slave_addr3);
  Wire.onReceive(receive_data);
  Wire.onRequest(send_data);
}
void loop(){
	num_of_leds = map(received_byte,0,255,0,5);
	for(int i = 0 ; i < num_of_leds ; i++)
      digitalWrite(leds_pins[i],HIGH);

  	for(int i = num_of_leds  ; i < 5 ; i++)
      digitalWrite(leds_pins[i],LOW);
}
```

= Submission

#important(
  title: "Important: SimulIDE / Tinkercad Submissions",
)[When submitting your work: include both the circuit schematic file (`.simu` or Tinkercad link) and the clean C++ source code files for all 4 microcontrollers (Master, Slave 1, Slave 2, Slave 3).]

#important(title: "Important: File Hosting")[
  Upload all source files and simulation files to Google Drive, set permissions to #emphasis[Viewable by Everyone], and paste the folder link in the submission form.
]

- You are required to submit via the Google Form: https://forms.gle/RLUQqzxZtdAVvPoY8
- Deadline: Monday, August 14th -- 11:59 pm

= Appendix

== Hardware Interfacing & Bus Pins

=== I2C Hardware Bus Wiring Topology
- *Master & Slaves Standard Pins:* `SDA` (Analog Pin `A4`), `SCL` (Analog Pin `A5`).
- *Pull-Up Requirement:* $4.7 "k"Omega$ resistors tied from `SDA` and `SCL` to $5"V"$.
- *Bus Speed:* Standard Mode ($100 "kHz"$).

== Arduino Uno Pinout & Reference

All Arduino boards are supported in Arduino IDE natively without extra package installation.

=== Power Properties
- Power over USB: YES
- Output voltages: $3.3"V"$, $5"V"$

#align(center)[
  #figure(caption: "Arduino Uno REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/uno-pinout.svg", width: 70%)
  ]
]

=== Arduino Nano
- *Connection:* Mini-USB or USB-C (depending on model)
- *Power Properties:* Power over USB (YES), Output Voltages ($3.3"V"$, $5"V"$)

#align(center)[
  #figure(caption: "Arduino Nano Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/nano-pinout.pdf", width: 60%)
  ]
]

=== Arduino Mega
- *Connection:* USB-B
- *Power Properties:* Power over USB (YES), Output Voltages ($3.3"V"$, $5"V"$)

#align(center)[
  #figure(caption: "Arduino Mega 2560 REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/mega-pinout.pdf", width: 60%)
  ]
]

=== ESP32 Boards
ESP32 boards will likely NOT be used as they require installing additional board packages in Arduino IDE and USB-to-Serial drivers. You may safely ignore this section unless instructed otherwise by your mentor.

If given an ESP32 board, common targets include:
- `ESP-WROOM-32 (38-Pin / 30-Pin)`
- `ESP32-S3-N16R8`

Common USB-to-Serial drivers:
- FTDI Drivers (`FT232` series): #link("https://ftdichip.com/drivers/vcp-drivers/", "FTDI Downloads")
- Silicon Labs Drivers (`CP210x` series): #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "CP210x Downloads")
