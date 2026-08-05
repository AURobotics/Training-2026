#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Workshop 4: Communication Protocols\ MENTOR'S GUIDE & SOLUTIONS],
)
#show: report-template.with(ribbon-text: "Workshop 4 | MENTOR GUIDE")

= Introduction

This workshop focuses on configuring multi-controller architectures and implementing communication protocols between microcontrollers -- specifically Arduino development boards -- covering:
- Inter-board *Software Serial UART Communication* (Master-Slave Link).
- Synchronous *I2C Interface* for sensor data and actuators.
- Data command parsing and real-time output control.
- Common ground references and hardware serial synchronization.

The objective is to gain practical experience in transferring data streams across microcontrollers using hardware and software interfaces.

= Requirements

The workshop consists of two distinct multi-node communication tasks. You will design and implement a #emphasis[Software Serial Command Link] and an #emphasis[I2C Master-Slave Telemetry Link].

The following components will be provided to you in *Tinkercad Circuits* / *Hardware*:
- 2#sym.times Microcontroller Boards (Arduino Uno)
- 3#sym.times LEDs (Red, Green, Blue) or 1#sym.times RGB LED
- 1#sym.times Single LED (for PWM Telemetry Output)
- 1#sym.times Potentiometer ($10 "k"Omega$)
- 4#sym.times $220 Omega$ Current-Limiting Resistors
- Breadboard & Jumper Wires

Please use #emphasis[Arduino IDE] or #emphasis[Tinkercad Circuits]/#emphasis[Hardware] to build the circuits and write your C++ firmware.

What follows are the set of required features and their descriptions.

== Part 1: Serial Command Parser (Master-to-Slave via SoftwareSerial)

Set up an asynchronous serial link between *Arduino 1 (Master)* and *Arduino 2 (Slave)*:
- Connect Master `TX` (Pin 1) $arrow.r$ Slave `RX` (Pin 0).
- Connect Master `RX` (Pin 0) $arrow.r$ Slave `TX` (Pin 1).
- Connect Master `GND` $arrow.r$ Slave `GND` (Shared Common Ground).

The system behavior must satisfy the following logic:
1. *Arduino 1* receives a single character command (`'R'`, `'G'`, or `'B'`) from the PC Serial Monitor (`Serial`) and forwards it to Arduino 2 via Serial Communication (`TX`/`RX`).
2. *Arduino 2* receives the character over Serial (`RX`) and toggles the corresponding LED indicator:
  - `'R'` $arrow.r$ Turns ON the *Red LED* (and turns OFF others).
  - `'G'` $arrow.r$ Turns ON the *Green LED* (and turns OFF others).
  - `'B'` $arrow.r$ Turns ON the *Blue LED* (and turns OFF others).

#block(
  fill: rgb("fff8e6"),
  stroke: (left: 4pt + rgb("f59e0b")),
  inset: 10pt,
  radius: (right: 4pt),
  [
    #text(weight: "bold", fill: rgb("b45309"))[★ Bonus Challenge :] \
    Implement the inter-board communication using the `SoftwareSerial` library on custom digital pins instead of the primary hardware serial pins (`TX`/`RX`), allowing the primary `Serial` interface to remain dedicated to debugging.
  ],
)

#important[Always ensure both Arduino boards share a common `GND` connection to unify signal reference voltage.]

== Part 2: I2C Master-Slave Sensor & Actuator Interface

Establish an I2C communication bus between the two Arduinos using the `<Wire.h>` library:
- *Arduino 1 (Master):* Initiates periodic data requests.
- *Arduino 2 (Slave - Address `0x08`):* Samples local analog telemetry.

Hardware & Logical Requirements:
1. Connect a Potentiometer to Analog Pin `A0` on *Arduino 2 (Slave)*.
2. The Slave must continuously read the potentiometer, scale the 10-bit raw ADC reading ($0-1023$) to an 8-bit PWM value ($0-255$), and register an `onRequest` interrupt service routine using `Wire.onRequest()`.
3. *Arduino 1 (Master)* periodically requests $1 "byte"$ from address `0x08` using `Wire.requestFrom()`. Upon receiving the telemetry byte, it updates the brightness of an LED connected to its PWM `Pin 3` using `analogWrite()`.

#tip[In I2C interrupt handlers (`Wire.onRequest`), avoid calling blocking operations such as `delay()` or heavy `Serial.print()` calls.]

= Solutions & Implementation Codes

== Part 1 Solutions

=== Normal Solution (Hardware Serial, `TX`/`RX`)

==== Arduino 1 (Sender / Master)

```cpp
void setup() {
  Serial.begin(9600);
}

void loop() {

  // we can hardcode R G B it is easier
  // Serial.print('r');
  //delay(1000);
  // Serial.print('g');
  //delay(1000);
  //Serial.print('b');
  //delay(1000);

  if (Serial.available() > 0) {
    char cmd = Serial.read();
    if (cmd == 'R' || cmd == 'r' || cmd == 'G' || cmd == 'g' || cmd == 'B' || cmd == 'b') {
      Serial.print(cmd);
    }
  }
}
```

==== Arduino 2 (Receiver / Slave)

```cpp
int redPin = 2;
int greenPin = 3;
int bluePin = 4;

void setup() {
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    char cmd = Serial.read();

    if (cmd == 'R' || cmd == 'r') {
      digitalWrite(redPin, HIGH);
      digitalWrite(greenPin, LOW);
      digitalWrite(bluePin, LOW);
    }
    else if (cmd == 'G' || cmd == 'g') {
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin, HIGH);
      digitalWrite(bluePin, LOW);
    }
    else if (cmd == 'B' || cmd == 'b') {
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin, LOW);
      digitalWrite(bluePin, HIGH);
    }
  }
}
```

=== Bonus Solution (`SoftwareSerial` on Custom Pins)

==== Arduino 1 (Sender / Master)

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11);

void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    char cmd = Serial.read();
    if (cmd == 'R' || cmd == 'r' || cmd == 'G' || cmd == 'g' || cmd == 'B' || cmd == 'b') {
      mySerial.print(cmd);
    }
  }
}
```

==== Arduino 2 (Receiver / Slave)

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11);

int redPin = 2;
int greenPin = 3;
int bluePin = 4;

void setup() {
  mySerial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  if (mySerial.available() > 0) {
    char cmd = mySerial.read();

    if (cmd == 'R' || cmd == 'r') {
      digitalWrite(redPin, HIGH);
      digitalWrite(greenPin, LOW);
      digitalWrite(bluePin, LOW);
    }
    else if (cmd == 'G' || cmd == 'g') {
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin, HIGH);
      digitalWrite(bluePin, LOW);
    }
    else if (cmd == 'B' || cmd == 'b') {
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin, LOW);
      digitalWrite(bluePin, HIGH);
    }
  }
}
```

== Part 2 Solutions (I2C Master-Slave)

=== Arduino 1 (Master)

```cpp
#include <Wire.h>

int led_pin = 3;

void setup() {
  Wire.begin();
  pinMode(led_pin, OUTPUT);
}

void loop() {
  Wire.requestFrom(0x08, 1);

  if (Wire.available() > 0) {
    byte val = Wire.read();
    analogWrite(led_pin, val);
  }

  delay(100);
}
```

=== Arduino 2 (Slave)

```cpp
#include <Wire.h>

int potPin = A0;
byte brightness = 0;

void setup() {
  Wire.begin(0x08);
  Wire.onRequest(sendData);
}

void loop() {
  int raw = analogRead(potPin);
  brightness = raw / 4;
  delay(20);
}

void sendData() {
  Wire.write(brightness);
}
```

= Mentors' Quick Revision & Recap

#let ref-list(entries) = {
  for (i, e) in entries.enumerate() {
    block(width: 100%, above: 0pt, below: 0pt, inset: (y: 9pt))[
      #if e.at("ctx", default: none) != none [
        #text(size: 8.5pt, weight: "bold", fill: luma(110), tracking: 0.5pt)[#upper(e.ctx)]
        #v(3pt)
      ]
      #underline(offset: 3pt, stroke: 0.6pt + luma(150))[#text(weight: "bold", size: 10.5pt)[#raw(e.fn)]]
      #v(4pt)
      #e.desc
    ]
    if i < entries.len() - 1 {
      line(length: 100%, stroke: 0.5pt + luma(210))
    }
  }
}

== Serial Functions Recap

#ref-list((
  (fn: "Serial.begin(baudrate)", desc: [Sets the data rate in bits per second (bps).]),
  (fn: "Serial.available()", desc: [Returns the number of bytes currently waiting in the receive buffer.]),
  (
    fn: "Serial.find(target, length)",
    desc: [Reads from the buffer until `target` is found, where `length` is the length of the target being searched for. Returns `true` if found and `false` otherwise. The function keeps searching until it hits the timeout set by `Serial.setTimeout()`.],
  ),
  (
    fn: "Serial.findUntil(target, terminal)",
    desc: [Searches for `target` until it is found, the `terminal` string is found, or the read times out. Returns `true` if `target` was found, `false` if not or if the terminal string was found first.],
  ),
  (fn: "Serial.read()", desc: [Reads and returns one byte at a time (returns the byte's ASCII code as an integer).]),
  (
    fn: "Serial.parseInt()",
    desc: [Returns the first valid integer received in the buffer -- extracts digits from the incoming byte stream and converts them to an integer.],
  ),
  (
    fn: "Serial.parseFloat()",
    desc: [Works like `parseInt()`, but also looks for a decimal point and extracts floating-point numbers from the byte stream.],
  ),
  (
    fn: "Serial.readBytes(buffer, length)",
    desc: [Reads raw bytes into `buffer` until it reaches `length` bytes or times out (default 1000 ms). Returns the number of bytes actually read.],
  ),
  (
    fn: "Serial.readBytesUntil(character, buffer, length)",
    desc: [Works like `readBytes()`, but stops early if it encounters `character`.],
  ),
  (
    fn: "Serial.readString()",
    desc: [Collects incoming characters into a `String` until no new characters arrive within the timeout period. Returns the resulting string.],
  ),
  (
    fn: "Serial.readStringUntil(character)",
    desc: [Works like `readString()`, but stops as soon as it encounters `character`.],
  ),
  (fn: "Serial.write()", desc: [Sends raw bytes to the buffer without converting them to human-readable text.]),
  (fn: "Serial.print()", desc: [Converts numbers, booleans, and objects into ASCII text before sending.]),
  (fn: "Serial.println()", desc: [Works like `print()`, but appends `\r\n` after the text.]),
))

== I2C (Wire.h) Functions Recap

=== General Functions

#ref-list((
  (
    fn: "Wire.available()",
    desc: [Returns the number of unread bytes currently available in the buffer, for either master or slave.],
  ),
  (
    fn: "Wire.write()",
    desc: [Writes data into the buffer created by `beginTransmission()`. Accepts a byte, a string, or an array of bytes with a specified length. Returns the number of bytes successfully written.],
  ),
  (
    fn: "Wire.read()",
    desc: [Reads one byte at a time. Its native return type is `int`, but the value can be cast to a `char` or `byte`.],
  ),
))

=== Master Functions

#ref-list((
  (
    ctx: "Initialization",
    fn: "Wire.begin()",
    desc: [Initializes the Wire library and joins the I2C bus; the device takes control of the bus clock line.],
  ),
  (
    ctx: "Master is sending data",
    fn: "Wire.beginTransmission(slave_addr)",
    desc: [Prepares an internal buffer and stores the target slave's address in it.],
  ),
  (fn: "Wire.endTransmission()", desc: [Ends the transmission and sends all queued bytes. Returns `0` on success.]),
  (
    ctx: "Master is requesting data from slave",
    fn: "Wire.requestFrom(addr, quantity)",
    desc: [Requests a specific number of bytes from a specific slave address. Returns the number of bytes actually sent by the slave.],
  ),
))

=== Slave Functions

#ref-list((
  (
    fn: "Wire.onReceive(handlerFunction)",
    desc: [Registered in `setup()`; points to a function that is called automatically whenever the master sends data (use `Wire.read()` inside it). The handler function must accept an `int` parameter.],
  ),
  (
    fn: "Wire.onRequest(handlerFunction)",
    desc: [Registered in `setup()`; points to a function that is called automatically whenever the master requests data from the slave (use `Wire.write()` inside it).],
  ),
))

#block(
  fill: rgb("fff8e6"),
  stroke: (left: 4pt + rgb("f59e0b")),
  inset: 10pt,
  radius: (right: 4pt),
  [
    In I2C, whether acting as master or slave, you cannot read more than one byte at a time. To receive multi-byte values, read the data into a `char` array first, then convert it -- using `atoi()` for integers or `atof()` for floats.
  ],
)

= Appendix

== Hardware Interfacing & Bus Pins

=== SoftwareSerial Interfacing (Part 1)

Arduino 1 (Master): Pin 10 (RX), Pin 11 (TX)

Arduino 2 (Slave): Pin 10 (RX), Pin 11 (TX)

Wiring Topology: Cross-connected (Pin 10 $arrow.r$ Pin 11, Pin 11 $arrow.r$ Pin 10).

=== I2C Hardware Bus Interfacing (Part 2)

Master & Slave Pins: SDA (Analog Pin A4), SCL (Analog Pin A5).

Bus Speed: Standard Mode (100"kHz").

== Board Compatibility & Hardware Pinouts

All Arduino boards are supported in the Arduino IDE natively without extra package installation.

=== Arduino Uno

Connection: USB-B

Power Properties: Power over USB (YES), Output Voltages (3.3"V", 5"V")

#align(center)[
  #figure(caption: "Arduino Uno REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/uno-pinout.svg", width: 70%)
  ]
]

=== Arduino Nano

Connection: Mini-USB or USB-C (depending on model)

Power Properties: Power over USB (YES), Output Voltages (3.3"V", 5"V")

#align(center)[
  #figure(caption: "Arduino Nano Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/nano-pinout.pdf", width: 60%)
  ]
]

=== Arduino Mega

Connection: USB-B

Power Properties: Power over USB (YES), Output Voltages (3.3"V", 5"V")

#align(center)[
  #figure(caption: "Arduino Mega 2560 REV3 Pinout Diagram")[
    #image("/Phase 1/Electrical/session 3/assets/mega-pinout.pdf", width: 60%)
  ]
]

=== ESP32 Boards

ESP32 boards will likely NOT be used, as they require installing additional board packages in the Arduino IDE and USB-to-Serial drivers. You may safely ignore this section unless instructed otherwise by your mentor.

If given an ESP32 board, common targets include:

- ESP-WROOM-32 (38-Pin / 30-Pin)
- ESP32-S3-N16R8

Common USB-to-Serial drivers:

- FTDI Drivers (FT232 series): #link("https://ftdichip.com/drivers/vcp-drivers/", "FTDI Downloads")
- Silicon Labs Drivers (CP210x series): #link("https://www.silabs.com/software-and-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads", "CP210x Downloads")
