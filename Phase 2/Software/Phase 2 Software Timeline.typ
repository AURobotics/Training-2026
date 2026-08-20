#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Software | Phase 2], topic: "Phase 2 Timeline")
#show: report-template.with(ribbon-text: "Phase II - Software")

You may find below the planned timeline for #emphasis("Phase 2") of the training for the software tracks -- #emphasis("Software") & #emphasis("Firmware").

The objective of this phase is to establish a strong basis in software systems integration and design for robotics.

#table(
  columns: (auto, 2fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon),
  table.header([*Date*], [*Event*], [*Tasks*]),
  
  [Thursday, August 20], [Session 1: Git & Github], table.cell(fill: brand-palette.light_gray)[],
  
  [Saturday, August 22], [Session 2: Intro to Python], [Task 1],
  
  [Tuesday, August 25], [Session 3: OOP, Design Principles & Clean Code], [Task 2],
  
  [Wednesday, August 26],
  [Workshop 1: Design Contribution\ & Visualizing Passage of Information],
  table.cell(fill: brand-palette.light_gray)[],
  
  [Saturday, August 29], [Session 4: CLI & Linux for Robotics], [Task 3],
  
  [Sunday, August 30],
  [#emphasis("Online") Meetings: Setup Help & Answering Questions],
  table.cell(fill: brand-palette.light_gray)[],
  
  [Monday, August 31],
  [Workshop 2: Linux for Robotics\ & Basics of Raspberry Pi],
  table.cell(fill: brand-palette.light_gray)[],
  
  [Tuesday, September 1], [Session 5: Intro to ROS2 & Conda], [Task 4],
  
  [Wednesday, September 2],
  [#emphasis("Online") Meetings: Setup Help & Answering Questions],
  table.cell(fill: brand-palette.light_gray)[],
  
  [Friday, September 4], [Session 6: ROS2 System Architecture & Simulation Basics], [Task 5],
  
  [Sunday, September 6], [Workshop 3: ROS2 Communication Systems], table.cell(fill: brand-palette.light_gray)[],
  
  [Wednesday, September 9], [End of Phase 2], table.cell(fill: brand-palette.light_gray)[],
)
