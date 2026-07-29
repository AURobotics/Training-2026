#import "/Theme/report.typ": (
  brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting, cover-page
)

#cover-page(title: [Training '26], subtitle: [Electrical | Phase 1], topic: "Phase 1 Timeline")
#show: report-template.with(ribbon-text: "Phase I - Electrical")

Welcome to the #emphasis("AUR") training for the 2026-2027 season. You may find below the planned timeline for #emphasis("Phase 1") of the training for the electrical tracks -- #emphasis("Software") & #emphasis("Hardware").

Please note that attending workshops is required unless a valid excuse is provided. If excused from attending any session's workshop, its task will have more weight in performance evaluations.


#table(
  columns: (auto, 2fr, 0.5fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),
  table.header(
    [*Date*],
    [*Event*],
    table.cell(colspan: 2)[*Tasks*],
  ),
  
  [Monday, July 27], [Session 1: Electronics & Simulation], table.cell(colspan: 2, fill: brand-palette.light_gray)[],
  
  [Tuesday, July 28],
  [Workshop 1],
  table.cell(rowspan: 2, rotate(-90deg, reflow: true)[Task 1]),
  table.cell(fill: brand-palette.light_gray)[],
  
  [Thursday, July 30], [Session 2: C programming], table.cell(rowspan: 2, rotate(-90deg, reflow: true)[Task 2]),
  
  [Monday, August 3], [Session 3: Arduino Basics], table.cell(fill: brand-palette.light_gray)[],
  
  [Tuesday, August 4], [Workshop 3], table.cell(colspan: 2, rowspan: 2, rotate(-90deg, reflow: true)[Task 3]),
  
  [Thursday, August 6], [Session 4: Communication Protocols],
  
  [Friday, August 7],
  [Workshop 4],
  table.cell(rowspan: 4, rotate(-90deg, reflow: true)[Task 4]),
  table.cell(rowspan: 2, fill: brand-palette.light_gray)[],
  
  [Monday, August 10], [Session 5: Sensors and Motors],
  
  [Tuesday, August 11],
  [Workshop 5],
  table.cell(rowspan: 2, rotate(
    -90deg,
    reflow: true,
  )[Task 5]),
  
  [Friday, August 14], [End of Phase 1],
)