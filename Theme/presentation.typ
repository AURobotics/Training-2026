#import "common.typ": *
#import "@preview/nth:1.0.1": *
#import "@preview/grayness:0.7.0": image-transparency

#let current-section = state("current-section", "")
#let current-subsection = state("current-subsection", "")
#let ribbon-content = state("ribbon-content", none)
#let raw-inline-highlighted = state("raw-inline-highlighted", true)

#let set-ribbon(content: none) = {
  ribbon-content.update(content)
}

#let presentation-theme(body) = {
  set page(
    paper: "presentation-16-9",
    margin: (x: 1.5cm, y: 1.5cm),
    header: context [
      #let page-num = counter(page).get().first()
      #block(width: 100%, inset: (bottom: 0.4em), stroke: (bottom: 0.5pt + brand-palette.accented_gray))[
        #grid(
          columns: (1fr, auto),
          align(left)[
            #text(size: 0.4em, fill: brand-palette.light_gray, font: "Nasalization")[
              #current-section.get() #sym.brace #current-subsection.get() #sym.brace.r
            ]
          ],
          align(right)[
            #text(size: 0.4em, fill: brand-palette.light_gray, font: "Nasalization")[
              #page-num
            ]
          ],
        )
      ]
    ],
    footer: context [
      #show link: it => text(fill: brand-palette.white)[#underline(it)]
      #show ref: it => text(fill: brand-palette.white, weight: "bold")[#underline(it)]
      #let ribbon = ribbon-content.get()
      #if ribbon != none [
        #pad(x: -1.5cm, -0.25cm)[
          #rect(fill: brand-palette.accent, width: 100% + 3cm, height: 1.5em, inset: (x: 1em, y: 0.2em), stroke: none)[
            #set text(fill: brand-palette.white, font: "DejaVu Sans")
            #place(center + horizon, dx: -1.5cm)[#ribbon]
          ]
        ]
      ]
    ],
  )
  show raw.where(block: false): it => {
    context if raw-inline-highlighted.get() {
      box(
        fill: brand-palette.pale_white,
        inset: (x: 4pt, y: 0pt),
        outset: (y: 3pt),
        radius: 3pt,
      )[#it]
    } else {
      it
    }
  }
  set text(size: 20pt)
  set par(justify: true)
  show figure.caption: set text(size: 0.6em)
  set heading(numbering: (..nums) => {
  let vals = nums.pos()
  if vals.len() == 1 {
    "Part " + numbering("I", vals.at(0))
  } else if vals.len() == 2 {
    "Section " + numbering("1", vals.at(1))
  } else {
    numbering("1.1", ..vals.slice(3))
  }
})
show ref: it => {
  let el = it.element
  if el != none and el.func() == heading {
    let target-nums = counter(heading).at(el.location())
    
    if target-nums.len() == 1 {
      // It's a Part heading
      link(el.location())[Part #numbering("I", target-nums.at(0))]
    } else {
      // It's a Section heading
      // Get the heading numbers at the *current reference's* location
      let current-nums = counter(heading).at(it.location())
      
      // Compare the Part number (first element) of both
      let same-part = current-nums.len() > 0 and current-nums.at(0) == target-nums.at(0)
      
      if same-part {
        // Same part: show just "Section 1" (or whatever number it is)
        link(el.location())[Section #target-nums.at(1)]
      } else {
        // Different part: show "Part II Section 1"
        link(el.location())[Part #numbering("I", target-nums.at(0)) Section #target-nums.at(1)]
      }
    }
  } else {
    it
  }
}
  show heading.where(level: 1): it => {
    set par(justify: false)
    current-section.update(it.body)
    let num = counter(heading).display()

    page(fill: brand-palette.white, margin: 0cm, header: none, footer: none)[
      #place(left)[
        #rect(
          fill: brand-palette.secondary,
          width: 2cm,
          height: 100%,
        )
      ]
      #place(top + right, dy: 1cm)[
        #block(width: 2cm, align(center)[
          #set text(font: "Nasalization", fill: brand-palette.background, size:  0.4em)
          #counter(page).display()
        ])
      ]
      #set text(fill: brand-palette.white)
            #place(center + horizon, image-transparency(
              path("aur_logo_light_no_bg.svg"),
              format: "svg",
              width: 40%,
              alpha: 10%,
            ))
      #align(center + horizon)[
        #block(width: 80%)[
          #text(size: 0.8em, tracking: 0.1em, fill: brand-palette.primary)[#upper(num)]
          #v(0.5em)
          #text(size: 2.5em, weight: "bold", brand-palette.secondary)[#it.body]
          #v(1em)
          #line(length: 40%, stroke: 2pt + brand-palette.offwhite)
        ]
      ]
    
    ]
  }

  show heading.where(level: 2): it => {
    set par(justify: false)
    current-subsection.update(it.body)
    let num = counter(heading).display()

    page(fill: brand-palette.white, margin: 0cm, header: none, footer: none)[
      #place(right)[
        #rect(
          fill: brand-palette.primary,
          width: 2cm,
          height: 100%,
        )
      ]
      #place(top + right, dy: 1cm)[
        #block(width: 2cm, align(center)[
          #set text(font: "Nasalization", fill: brand-palette.offwhite, size: 0.4em)
          #counter(page).display()
        ])
      ]
      #set text(fill: brand-palette.primary)
      #place(center + horizon, image-transparency(
        path("aur_logo_light_no_bg.svg"),
        format: "svg",
        width: 40%,
        alpha: 10%,
      ))
      #align(center + horizon)[
        #block(width: 80%)[
          #text(size: 0.7em, tracking: 0.15em, fill: brand-palette.primary)[#upper(num)]
          #v(0.5em)
          #text(size: 2em, weight: "semibold", fill: brand-palette.secondary)[#it.body]
          #v(0.8em)
          #line(length: 25%, stroke: 1.5pt + brand-palette.accented_gray)
        ]
      ]
    ]
  }

  show heading.where(level: 3): it => {
    set par(justify: false)
    pagebreak(weak: true)

    ribbon-content.update(none)

    grid(
      columns: (1fr, auto),
      align(left)[#text(size: 1.3em, weight: "bold", fill: brand-palette.primary)[#it.body]],
      align(right)[#image("aur_logo_light_no_bg.svg", height: 1em)],
    )
    v(-1em)
    line(length: 100%, stroke: 1.5pt + brand-palette.primary)
    v(0.5em)
  }
  show link: set text(fill: brand-palette.primary)
  show ref: set text(fill: brand-palette.primary)
  show raw: set text(
    font: "JetBrains Mono",
    ligatures: false,
    features: (calt: 0),
  )
  body
}

#let end-slide(subtitle: "", message: "") = {
  set page(
    header: none,
    footer: none,
    fill: brand-palette.secondary,
  )

  place(bottom + right)[
    #image("aur_white_fg_transparent_bg.svg", width: 15%)
  ]

  place(center + horizon, dy: -1.5em)[
    #block(width: 85%)[
      #set par(justify: false)
      #text(size: 20pt, fill: brand-palette.offwhite, font: "Nasalization")[#message]
      #v(-1em)
      #text(size: 56pt, fill: brand-palette.white, font: "Nasalization", weight: "bold")[END OF PRESENTATION]
      #v(-2em)
      #text(size: 28pt, fill: brand-palette.offwhite, font: "Nasalization")[#subtitle]
    ]
  ]
}

#let title-slide(title: "", subtitle: "", topic: "", publish_date: datetime.today()) = {
  set page(
    header: none,
    footer: none,
    fill: brand-palette.secondary,
  )

  place(bottom + right)[
    #image("aur_white_fg_transparent_bg.svg", width: 15%)
  ]

  place(center + horizon, dy: -1.5em)[
    #block(width: 85%)[
      #text(size: 20pt, fill: brand-palette.offwhite, font: "Nasalization")[#topic]
      #v(-1em)
      #text(size: 56pt, fill: brand-palette.white, font: "Nasalization", weight: "bold")[#title]
      #v(-2em)
      #text(size: 28pt, fill: brand-palette.offwhite, font: "Nasalization")[#subtitle]
    ]
  ]

  place(bottom + left)[
    #if type(publish_date) == datetime {
      text(
        size: 12pt,
        fill: brand-palette.offwhite,
      )[Published: #publish_date.display("[weekday]") #nth(publish_date.day()), #publish_date.display("[month repr:long] [year]")]
    } else if type(publish_date) == str {
      text(size: 12pt, fill: brand-palette.offwhite)[Published: #publish_date]
    }
  ]

  pagebreak()
}