#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(
  title: [Training '26],
  subtitle: [Hardware | Phase II],
  topic: [Task 3: Buck converters],
)
#show: report-template.with(ribbon-text: "Task 1 | GUIDE", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.25pt,
  size: 110pt,
  opacity: 15%,
))

= Introduction

This task focuses on utilizing learned concepts related to buck converters and how to apply them to your designs and implement them on a PCB.

= Requirements

This task features multiple sub-tasks. 

- EasyEDA Std. version will be used as the main software.\
- Always refer to datasheets.\
- You can use both Through hole & SMD components.
- In case you use SMD components, do not use a smaller footprint than 0805 for capacitors and resistors.

Below are the required tasks and their descriptions.
#v(0.5cm)

== Buck converter 1:

Watch this video: https://youtu.be/rLHW4gU6idU?si=LMg4PMBpcdbvfbwZ \
Then recreate the circuit using EasyEDA

#v(1cm)

== Buck converter

Redesign the XL4015 buck converter (available at makers electronics)

#v(1cm)

== Buck converter 3
In this task, only the schematic is required.

Choose one of the following Buck converter ICs and build the external circuitry around it:
- LM2596
- XL4015
- XL4016
#emphasis("Notes:")\
- Follow datasheets.
- A report is required where you will include all calculations regarding inductor and capacitor value selection, minimum and maximum output voltage, and expected efficiency.
- Current ripple should stay between 0.1 & 0.3.
- Your load draws 4A.
- Your input voltage is 12V & an output of 5V should be in the output range.

#emphasis("Bonus:") Route the circuit 


#v(1cm)

*Submission link:*  https://forms.gle/WLnyeXbFe3Ygz12s6 \
*Deadline: Saturday 11:59 p.m* 