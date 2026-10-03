#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase III],
  topic: [Handout & Task 1: PCB Design II],
)
#show: report-template.with(ribbon-text: "Task 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

This task focuses on utilizing learned concepts related to PCB Design & routing.

= Handout
The session introduced new concepts regarding PCB design and also new components and their applications. The session's main goal is to improve your design skills.
The session has a ready schematic for a custom STM32 board. \
This is not a dev board; we got the STM32 IC and built a circuit around it.
You don't have to understand a custom board's main elements for now, but be aware of the concepts explained.\

#v(0.5cm)

- It begins with explaining what makes a schematic clean & readable.
- Pi filters (2 capacitors, 1 inductor/ferrite bead).
- Make a rough placement for the components.
- Introduction to multilayer boards
- Differential pairs 
- Clean & efficient routing


= Multilayer boards
So far, you have worked on 2-layer boards. A 4-layer board has an extra 2 layers between the top & bottom layers. No components can be placed on the inner layers, but you can route signals on them, and if you have through-hole components, you can route them too (through-hole pins pass through all layers).\
In the session, many components needed to be connected to either 3.3v or GND, and it's not reasonable to make a track for every 3.3V/ GND pin. Therefore, we use #emphasis("Planes"). Planes are layers dedicated for an entire net, ex: 3.3V or GND. #emphasis("WHY?")\
At each pin that needs to be connected to 3.3V for example, you draw a track to just outside the pad as shown in the video, and you place a via. #emphasis("A via is a small hole that connects multiple layers together, similar to a pin of a through hole component.") \
You should select the via and edit the net name to 3.3V for example.\
#v(0.2cm)
#emphasis("How to make a plance (a complete layer for a certain net) :") \
- Go to layer settings
- Select the number of layers you want 
- For inner 1, name it GND and change type to plane instead of signal.
- For inner 2, name it 3.3v or whatever you named your power net, and also change the type.
#align(center)[
  #image("assets/4 layers.PNG")
]
= Differential pairs 
A differential pair is a method of transmitting high-speed signals using two closely placed PCB traces that carry equal and opposite voltages (positive and negative, like USB or Ethernet lines). Because the receiver measures only the difference between the two signals, any electromagnetic noise or interference picked up along the way affects both traces equally and gets automatically canceled out. When routing differential pairs on a PCB, the golden rule is to keep both traces perfectly parallel, symmetrical, and equal in length from source to destination. You must maintain consistent trace width and spacing to control differential impedance, and avoid sharp 90° bends to ensure both signals arrive at the receiver at the exact same fraction of a nanosecond.
#v(0.5cm)

= Requirements

There is only 1 task.. 

- EasyEDA Std. version will be used as the main software.\

Below is the required tasks.
#v(0.5cm)

== Route the PCB:

This link contains a schematic design for a custom STM32 board.\
https://u.easyeda.com/join?type=project&key=fd09ce7bb16a0f1c29353e8c2ad15af2&inviter=6819f4086531448dafdf0b2b2df64e1a \
Clone the project and go ahead.\
You are required to convert the schematic to PCB and do the routing as efficiently as possible.\
#emphasis("Do not work on the file directly, copy/clone the file to your projects then convert to PCB & start routing.")
#v(0.4cm)
While placing components, take care of these points:
- Use a 4-layer PCB (Signal-GND-3.3V-Signal)
- Search how to make dedicated planes 2 & 3 for GND and 3.3V in EasyEDA.
- Decoupling capacitors should be near the MCU.
- Crystal & its capacitors should be near the MCU. (Priority to Decoupling capacitors)
- USB data pins should be routed as a differential pair 
- USB ports and pins are expected to be near board outlines for easy accessibility.
- Rotate components as you see fit so tracks don't have to be long.
- Don't put vias in pads; put them just outside the pad and route the track from pin to via.
- Add 1 mounting hole per corner, M3.
- Use a 3D view for a better design

#v(1cm)

*Submission link:*   https://forms.gle/1zpbyUyAfeyxeSkf9 \
*Deadline: 14 September, Monday, 11:59 p.m* 