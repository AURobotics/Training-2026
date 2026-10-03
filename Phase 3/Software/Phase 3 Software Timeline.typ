#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Software | Phase 2], topic: "Phase 3 Timeline")
#show: report-template.with(ribbon-text: "Phase III - Software")

You may find below the planned timeline for #emphasis("Phase 3") of the training for the #emphasis("software").

The objective of this phase is to establish a strong basis in software systems.

#table(
  columns: (auto, 2fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon),
  table.header([*Date*], [*Event*], [*Tasks*]),

  [Saturday, September 12], [Session 1: Classical CV], table.cell(fill: brand-palette.light_gray)[],

  [Monday, September 14], [Workshop 1: CV Practice], 
   table.cell(fill: brand-palette.light_gray)[],
  
  [Wednesday, September 16], [Session 2: Intro to Qt], [Task 1],

  [Friday, September 18], [Session 3: qml], 
  table.cell(fill: brand-palette.light_gray)[],

  [Sunday, September 20], [Workshop 2: Qt & qml], [Task 2],

  [Tuesday, September 22], [Session 4: ML & CV], [Task 3],

  [Friday, September 25], [Session 5: Qt workflow integration], [Task 4],

  [Sunday, September 27],[Session 6: MQTT Wireless Communication], [Task 5]
)
