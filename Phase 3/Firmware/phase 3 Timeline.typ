#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Firmware | Phase 3], topic: "Phase 3 Timeline")
#show: report-template.with(ribbon-text: "Phase III - Firmware")

You may find below the planned timeline for #emphasis("Phase 3") of the training for the #emphasis("Firmware").

The objective of this phase is to establish a strong basis in software systems.

#table(
  columns: (auto, 2fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon),
  table.header([*Date*], [*Event*], [*Tasks*]),

  [Sunday, September 13], [Session 1: Basic Architecture and Peripherals], table.cell(fill: brand-palette.light_gray)[],

  [Tuesday, September 15], [Session 2: STM32 Basics], [Task 1],
  
  [Friday, September 18], [Session 3: Drivers], [Task 2],

  [Monday, September 21], [Session 4: RTOS], [Task 3],

  [Wednesday, September 23], [Session 5: Intro to Control Systems], [Task 4],

  [Saturday, September 26], [Session 6: Control on-site], [Task 5],
)
