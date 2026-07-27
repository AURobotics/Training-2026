#import "/Theme/report.typ": brand-palette, emphasis, pause-page-counting, report-template, resume-page-counting

#import "/Theme/generic_cover.typ": cover-page

#cover-page(title: [Training '26], subtitle: [Mechanical | Phase I], topic: "Phase I Timeline")
#show: report-template.with(ribbon-text: "Phase I - Mechanical")

Welcome to the #emphasis("AUR") training for the 2026-2027 season. You may find below the planned timeline for #emphasis("Phase 1") of the training for the #emphasis[Mechanical] track. Phase 1 will focus on the basics of manufacturing and marine vehicles.

Please note that attending sessions is required unless a valid excuse is provided. If excused from attending any session, its task will have more weight in performance evaluations.

#table(
  columns: (auto, auto, auto),
  rows: 1.5cm,
  align: (left + horizon, left + horizon, center + horizon, center + horizon),
  table.header(
    [*Date*],
    [*Session*],
    [*Presence*],
  ),
  
  [Wednesday, July 29], [Session 1: Introduction to Mechanical Design\ #text(size: 8pt, "Objectives: Full understanding of the design process and the stresses and their types and the forces causing them
")], [On-site],
  
  [Saturday, August 1], [Session 2: Materials & Manufacturing; Bolts & Screws\ #text(
    size: 8pt,
    "Objectives: Knowledge of the commonly used materials in the robotics field and the procedures to manufacture the desired parts from these materials")], [On-site],
  
  [Tuesday, August 4], [Session 3: Introduction to Solidworks -- 2D Sketching\ #text(
    size: 8pt,
    "Objectives: Awareness of all 2D sketch features",
  )], [Online],
  
  [Saturday, August 8], [Session 4: Introduction to Marine Vehicles\ #text(size: 8pt, "Objectives: Full understanding of the forces acting on a marine vehicle (thrust, drag, buoyancy) and the different thruster configurations")], [On-site],
  
  [Wednesday, August 12], [Session 5: Solidworks -- 3D Parts\ #text(size: 8pt, "Objectives: Gaining the ability to make any 3D complex part")], [Online],
  
  [Saturday, August 15], [Session 6: Marine Vehicles -- Sealing, Grippers, Pneumatic\ #text(size: 8pt, "Objectives: Knowledge of all sealing techniques and pneumatic system workflow")], [On-site],
  
  [Wednesday, August 19], [Session 7: Solidworks -- Assemblies\ #text(size: 8pt, "Objectives: The ability to assemble parts correctly with the correct relations")], [Online],
)