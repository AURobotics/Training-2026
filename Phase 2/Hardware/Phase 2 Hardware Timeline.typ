#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting,
)

#cover-page(title: [Training '26], subtitle: [Hardware | Phase 2], topic: "Phase 2 Timeline")
#show: report-template.with(ribbon-text: "Phase II - Hardware")

Welcome to the #emphasis("AUR") training for the 2026-2027 season. You may find below the planned timeline for #emphasis("Phase 2") of the training for the #emphasis("Hardware"). track.

Please note that attending sessions & workshops is required unless a valid excuse is provided. If excused from attending any session's workshop, its task will have more weight in performance evaluations.


#table(
  columns: (auto, 2fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),
  table.header([*Date*], [*Event*], [*Place*]),
  
  [Wednesday, August 19], [Session 1: Active & Passive elements], [Recorded Online],
  
  [Saturday, August 22], [Session 2: Diodes, Transistors & MOSFETs], [Onsite],
  
  [Wednesday, August 26], [Session 3: Intro to Schematics & PCB design I], [Online Live],
  
  [Sunday, August 30], [Session 4: Buck converters, Batteries & BMS, Power supplies], [Recorded Online],
  
  [Friday, September 4], [Session 5: Microcontrollers & Datasheets], [Onsite],
  
  [Thursday, August 10], [End of Phase 1],
)