#import "/Theme/report.typ": brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting, cover-page

#cover-page(title: [Training '26], subtitle: [Mechanical | Phase II], topic: "Phase II Timeline")
#show: report-template.with(ribbon-text: "Phase II - Mechanical")

Welcome to the #emphasis("AUR") training for the 2026-2027 season. You may find below the planned timeline for #emphasis("Phase 2") of the training for the #emphasis[Mechanical] track. The focus in Phase 2 will be on ground vehicles and chassis.

Please note that attending sessions is required unless a valid excuse is provided. If excused from attending any session, its task will have more weight in performance evaluations.

#table(
  columns: (auto, auto, auto),
  rows: 2cm,
  align: (left + horizon, left + horizon, center + horizon, center + horizon),
  table.header(
    [*Date*],
    [*Session*],
    [*Presence*],
  ),
  
  [Wednesday, August 26], [Session 1: Introduction to Ground Vehicles\ #text(size: 8pt, "Topics: Mechanical power transmission
")], [On-site],
  
  [Saturday, August 29], [Session 2: Ground Vehicles -- Suspension System], [On-site],
  
  [Tuesday, September 1], [Session 3: Solidworks Stress Analysis\ #text(
    size: 8pt,
    "Objectives: Learn to analyse parts and assemblies and test them before manufacturing to ensure their reliability",
  )], [Online],
  
  [Tuesday, September 8], [Session 4: Ground Vehicles -- Wheels & Motor Selection], [On-site],
  
  [Monday, September 14], [Session 5: Chassis & Frames; Data Sheets; R&D\ #text(size: 8pt, "Objectives: be familiar with all types of frames, be able to read all data sheets and extract the required data, the ability to research and test for the best component out of a couple of choices")], [On-site],
)