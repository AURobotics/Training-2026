#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting,
)

#cover-page(title: [Training '26], subtitle: [Hardware | Phase 3], topic: "Phase 3 Timeline")
#show: report-template.with(ribbon-text: "Phase III - Hardware")

Welcome to the #emphasis("AUR") training for the 2026-2027 season. You may find below the planned timeline for #emphasis("Phase 3") of the training for the #emphasis("Hardware") track.

Please note that attending sessions & workshops is required unless a valid excuse is provided. If excused from attending any session, its task will have more weight in performance evaluations.


#table(
  columns: (auto, 2fr, 0.5fr, 0.5fr),
  rows: 1.5cm,
  align: (center + horizon, center + horizon, center + horizon, center + horizon),
  table.header([*Date*], [*Event*], [*Place*], [*Task*]),
  
  [Friday, September 11], [Session 1: PCB Design II], [Recorded Online], [Task 1],
  
  [Tuesday, September 15], [Session 2: PCB Fabrication & Manufacturing], [Onsite], [],
  
  [Thursday, September 17], [Session 3: Motor Drivers & ESCs], [Recorded Online], [Task 2],
  
  [Monday, September 21], [Session 4:PCB Design III], [Online live], [Task 3],
  
  [Friday, September 25], [Session 5: PCB Design IV], [Online live], [Task 4],
  
  [Saturday, September 30], [End of Phase 3],
)