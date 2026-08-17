#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Software | Phase 2], topic: "Phase 2 Timeline")
#show: report-template.with(ribbon-text: "Phase II - Software", foreground_watermark: watermark_text(
  content: "INTERNAL USE ONLY",
  gaps: 1.1pt,
  opacity: 50,
))

You may find below the planned timeline for #emphasis("Phase 2") of the training for the software tracks -- #emphasis("Software") & #emphasis("Firmware").

// Note that all mentors must participate in workshops and following members. Please fill the following availability form for #emphasis("Phase 2") workshops: https://forms.gle/p1tQajtTPcAxccQA9

#table(
  columns: (auto, 2fr, 0.5fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),
  table.header(
    [*Date*],
    [*Event*],
    table.cell(colspan: 2)[*Tasks*],
  ),

  [Thursday, August 20], [Session 1: Git & Github], table.cell(colspan: 2, fill: brand-palette.light_gray)[],

  [Saturday, August 22], [Session 2: Intro to Python], table.cell(colspan: 2)[Task 1],

  [Tuesday, August 25], [Session 3: Cleaner Python, Better Python], table.cell(colspan: 2)[Task 2],

  [Saturday, September 2], [Session 4: CLI, Linux & Conda], table.cell(colspan: 2)[Task 3],

  [Monday, September 4],
  [Workshop 1 (#emphasis("Online")): Setting Environments],
  table.cell(colspan: 2, fill: brand-palette.light_gray)[],

  [Thursday, September 7], [Workshop 2: Practicing Session 4], table.cell(colspan: 2, fill: brand-palette.light_gray)[],

  [Saturday, September 9], [Session 5: Intro to ROS2], table.cell(colspan: 2, fill: brand-palette.light_gray)[],

  [Tuesday, September 12], [Session 6: More into ROS2], table.cell(colspan: 2)[Task 4],

  [Saturday, September 16], table.cell(fill: brand-palette.light_gray)[], table.cell(colspan: 2)[Task 6],
)
