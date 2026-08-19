#import "/Theme/common.typ": setup-codly, brand-palette, link-ref
#import "/Theme/report.typ": report-template, cover-page

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Electrical | Phase I],
  topic: [Workshop 3: Communication Protocols\ SOLUTION],
)

#show: report-template.with(
  ribbon-text: "Workshop 5 | SOLUTION",
)

#import "@preview/calloutly:1.1.0": important, tip

= Introduction
This workshop focuses on implementing motor control systems and integrated sensors with the following core components:
- DC Motors & `L298N` / H-Bridge Motor Driver
- Potentiometers (Analog Speed Control)
- Direction Switches (Digital Toggle Controls)
- HC-SR04 Ultrasonic Distance Sensor
- Quadrature Optical Encoders (Interrupt-driven distance tracking)

The objective is to gain a fundamental basis in combining actuator control with sensor feedback in embedded systems (Arduino).

#important[
  The circuit for both tasks is displayed under #link-ref(<circuit-diagram>) in @circuit-diagram-fig
]

= Speed and Direction Control of DC Motors

== Task
You are going to control the rotation speed and direction of DC motors using a potentiometer and a toggle switch. The potentiometer provides an analog input mapping to PWM speed output, while the switch determines the logic states of the motor driver inputs.

You will be provided with:
- 1#sym.times Arduino Uno
- 2#sym.times DC Motors
- 1#sym.times `L298N` Motor Driver module
- 1#sym.times 10kΩ Potentiometer
- 1#sym.times SPDT Switch / Push Button (Direction Switch)
- 1#sym.times External DC Power Source / Battery Pack
- Breadboard and Jumper Wires

== Guide
We use Pulse Width Modulation (PWM) to vary the average voltage supplied to the motor driver enable pin (ENA), thereby controlling the motor speed. The direction pins (IN1, IN2) determine current flow direction through the H-bridge.

Below is the standard reference code for Task 1:
```cpp
#define DIR_SWITCH 6
#define IN1 7
#define IN2 8
#define ENA 9

bool dir = HIGH;

void setup()
{
 Serial.begin(9600);
 for(int i = 7; i < 10; i++)
 pinMode(i, OUTPUT);
 pinMode(6, INPUT);
}

void loop()
{  
 int raw_speed = analogRead(A0);
 int speed = map(raw_speed, 0, 1023, 0, 255);
 digitalWrite(IN1, dir);
 digitalWrite(IN2, !dir);
 analogWrite(ENA, speed);
 
 if(digitalRead(DIR_SWITCH) == HIGH)
 dir = HIGH;
 else
 dir = LOW;
}```

= Ultrasonic Safety Cutoff & Encoder Tracking

== Task

In this task, you will integrate an `HC-SR04` ultrasonic sensor to act as a dynamic safety cutoff mechanism, alongside a quadrature encoder to keep track of motor position and distance using hardware interrupts.

You will be provided with the following additional components:

- 1#sym.times `HC-SR04` Ultrasonic Distance Sensor
- 1#sym.times Rotary/Wheel Optical Encoder

#tip[
  Hardware interrupts, such as Pin 2 / `INT0` on the Arduino Uno, allow
  precise real-time pulse counting without missing ticks during sensor
  delays or execution loops. Ensure internal pull-ups are enabled if
  the encoder outputs are open-collector.
]

== Guide

The ultrasonic sensor emits a $10 mu"s"$ trigger pulse and measures the
time-of-flight on the echo pin. If an obstacle is detected within
20 cm, or if the ultrasonic pulse times out, the motor drive output
is set to zero.

When the path is clear, motor speed is driven based on the
potentiometer reading, while directional movement is tracked using
the encoder interrupt service routine (ISR).

Below is the complete reference code for Task 2:

```cpp
#define PA 2
#define PB 3
#define TRIG 4
#define ECHO 5
#define DIR_SWITCH 6
#define IN1 7
#define IN2 8
#define ENA 9

volatile long count = 0;
bool state = HIGH;

void encoder_isr() {
  if (digitalRead(PB) == HIGH)
    count--;
  else
    count++;
}

void setup() {
  Serial.begin(9600);

  for (int i = 7; i < 10; i++)
    pinMode(i, OUTPUT);

  pinMode(PA, INPUT_PULLUP);
  pinMode(PB, INPUT_PULLUP);
  pinMode(DIR_SWITCH, INPUT_PULLUP);

  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  attachInterrupt(
    digitalPinToInterrupt(PA),
    encoder_isr,
    RISING
  );
}

void loop() {
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);

  digitalWrite(TRIG, LOW);

  long duration = pulseIn(ECHO, HIGH, 30000);

  if (duration == 0) {
    analogWrite(ENA, 0);
    return;
  }

  float distance = (duration * 0.0343) / 2.0;
  state = digitalRead(DIR_SWITCH);

  if (distance <= 20) {
    analogWrite(ENA, 0);
  } else {
    int raw_speed = analogRead(A0);
    int speed = map(raw_speed, 0, 1023, 0, 255);

    digitalWrite(IN1, !state);
    digitalWrite(IN2, state);

    analogWrite(ENA, speed);
  }
}```

= Circuit Diagram <circuit-diagram>

#figure(caption: "Circuit diagram of both tasks")[
  #image("assets/all-circuit.svg")
] <circuit-diagram-fig>