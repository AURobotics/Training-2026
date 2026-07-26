#import "@preview/nth:1.0.1": *
#import "report.typ": brand-palette, pause-page-counting, resume-page-counting

#let cover-page(title: "Document Title", subtitle: "Subtitle", topic: "Topic", publish_date: datetime.today()) = {
  pause-page-counting()
  set page(
    header: none,
    footer: none,
    background: rect(width: 100%, height: 100%, fill: brand-palette.background, stroke: none),
  )
  
  align(center + horizon)[
    #image("aur_white_fg_transparent_bg.svg", width: 70%)
    
    
    #text(size: 40pt, fill: brand-palette.white, font: "Nasalization")[#title]

    #text(size: 25pt, fill: brand-palette.white, font: "Nasalization")[#subtitle]

    #text(size: 18pt, fill: brand-palette.offwhite, font: "Nasalization")[#topic]
  ]
  align(bottom + left)[
  #if type(publish_date) == datetime {
      text(size: 12pt, fill: brand-palette.offwhite)[Published: #publish_date.display("[weekday]") #nth(publish_date.day()), #publish_date.display("[month repr:long] [year]")]
    } else if type(publish_date) == str {
      text(size: 12pt, fill: brand-palette.offwhite)[Published: #publish_date]
    }
  ]
  pagebreak()
  resume-page-counting()
}