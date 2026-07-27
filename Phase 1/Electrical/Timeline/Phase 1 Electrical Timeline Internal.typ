#import "/Theme/report.typ": pause-page-counting, report-template, resume-page-counting, watermark_text, brand-palette, emphasis

#import "/Theme/generic_cover.typ": cover-page

#cover-page(title: [Training '26], subtitle: [Electrical | Phase 1], topic: "Phase 1 Timeline")
#show: report-template.with(ribbon-text: "Phase I - Electrical", foreground_watermark: watermark_text(content: "INTERNAL USE ONLY", gaps: 1.1pt, opacity: 50))

You may find below the planned timeline for #emphasis("Phase 1") of the training for the electrical tracks -- #emphasis("Software") & #emphasis("Hardware").

Note that all mentors must participate in workshops and following members. Please fill the following availability form for #emphasis("Phase 1") workshops: https://forms.gle/p1tQajtTPcAxccQA9

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

  [Tuesday, July 28], [Workshop 1], table.cell(rowspan: 2, rotate(-90deg, reflow: true)[Task 1]), table.cell(fill: brand-palette.light_gray)[],

  [Thursday, July 30], [Session 2: C programming], table.cell(rowspan: 2, rotate(-90deg, reflow: true)[Task 2]),
  
  [Monday, August 3], [Session 3: Arduino Basics], table.cell(fill: brand-palette.light_gray)[],

  [Tuesday, August 4], [Workshop 3], table.cell(colspan: 2, rowspan: 2, rotate(-90deg, reflow: true)[Task 3]),

  [Thursday, August 6], [Session 4: Communication Protocols],
  
  [Friday, August 7], [Workshop 4], table.cell(rowspan: 4, rotate(-90deg, reflow: true)[Task 4]), table.cell(rowspan: 2, fill: brand-palette.light_gray)[],

  [Monday, August 10], [Session 5: Sensors and Motors],

  [Tuesday, August 11], [Workshop 5], table.cell(rowspan: 2, rotate(
    -90deg,
    reflow: true,
  )[Task 5]),

  [Friday, August 14], [End of Phase 1]
)