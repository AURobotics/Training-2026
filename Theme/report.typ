#import "@preview/calloutly:1.1.0": callout-style

#let brand-palette = (
  primary: rgb("#e12149"),
  secondary: rgb("#be0d2f"),
  background: rgb("#89162e"),
  gold: rgb("#ffce00"),
  white: rgb("#ffffff"),
  offwhite: rgb("#f4ecee"),
  light_gray: rgb("#b5b5b5"),
  gray: rgb("#585858"),
  black: rgb("#181818"),
)

#let show-page-number = state("show-page-number", true)
#let last-counted-page = state("last-counted-page", 1)
#let current-ribbon-text = state("ribbon-text", none)

#let pause-page-counting() = {
  context {
    last-counted-page.update(counter(page).get().first())
    show-page-number.update(false)
  }
}

#let resume-page-counting() = {
  context {
    counter(page).update(last-counted-page.get())
    show-page-number.update(true)
  }
}

#let watermark_text(content: "WATERMARK", size: 50pt, alignment: center + horizon, rotation: 45deg, gaps: 0pt, opacity: 40%) = {
  let val = calc.min(int(float(opacity) * 255), 255)
  let opacity = str(val, base: 16)
  if opacity.len() == 1 { opacity = "0" + opacity }
  return align(alignment)[
    #rotate(rotation)[
      #text(
        fill: tiling(
          size: (gaps + 1pt, gaps + 1pt),
          relative: "parent",
          align(alignment)[
            #circle(radius: 1pt, fill: rgb("000000" + opacity))
          ],
        ),
        size: size,
        weight: "bold",
      )[#content]
    ]
  ]
}

#let emphasis(content) = {
  text(content, fill: brand-palette.background, weight: "bold")
}

/// A branded report template with a header ribbon.
/// - ribbon-text (str|content): The text or block to display in the header ribbon.
/// - frame-skip-pages (array): A list of page numbers where the header should not appear.
#let report-template(ribbon-text: "Technical Report", foreground_watermark: none, background_watermark: none, frame-skip-pages: (), margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm), justify: true, body) = {
  assert(type(ribbon-text) in (str, content), message: "ribbon-text must be a string or content")
  assert(type(frame-skip-pages) == array, message: "frame-skip-pages must be an array of integers")
  
  current-ribbon-text.update(ribbon-text)
  
  show: callout-style.with(style: "quarto")
  set par(justify: justify)
  set page(
    margin: margin,
    
    background: context {
      background_watermark
    },

    foreground: context {
      foreground_watermark
      let page-num = counter(page).get().first()
      
      if not frame-skip-pages.contains(page-num) {
        let is-rtl = text.dir == rtl
        let align-edge = if is-rtl { right } else { left }
        
        let pad-edge = 1pt
        let pad-inner = 3pt
        let depth = 0.5cm
        let bleed = 1pt
        
        let header-style = (
          font: ("Nasalization",),
          fill: brand-palette.white,
          weight: "bold",
          size: 14pt,
        )
        
        let final-title = align(horizon)[
          #set text(..header-style)
          #current-ribbon-text.get()
        ]
        
        let title-block = block(
          fill: none,
          inset: (
            top: 0.65cm,
            bottom: 0.65cm,
            left: if is-rtl { pad-inner } else { pad-edge },
            right: if is-rtl { pad-edge } else { pad-inner },
          ),
          final-title,
        )
        
        let box-size = measure(title-block)
        let w = box-size.width
        let h = box-size.height
        let hex-width = h * 1.1547
        
        place(top + align-edge, dx: 0pt, dy: 0pt)[
          #box(width: w + depth, height: h)[
            
            #place(top + left)[
              #if is-rtl {
                polygon(
                  fill: brand-palette.background,
                  (w + depth + bleed, 0pt),
                  (0pt, 0pt),
                  (depth, h / 2),
                  (0pt, h),
                  (w + depth + bleed, h),
                )
              } else {
                polygon(
                  fill: brand-palette.background,
                  (-bleed, 0pt),
                  (w + depth, 0pt),
                  (w, h / 2),
                  (w + depth, h),
                  (-bleed, h),
                )
              }
            ]
            
            #place(top + left, dx: if is-rtl { depth - hex-width - 5pt } else { w + 5pt }, dy: 0pt)[
              #box(width: hex-width, height: h)[
                #polygon(
                  fill: brand-palette.primary,
                  (0%, 50%),
                  (25%, 0%),
                  (75%, 0%),
                  (100%, 50%),
                  (75%, 100%),
                  (25%, 100%),
                )
                #place(center + horizon)[
                  #box(width: 75%, height: 75%)[
                    #polygon(
                      fill: brand-palette.white,
                      (0%, 50%),
                      (25%, 0%),
                      (75%, 0%),
                      (100%, 50%),
                      (75%, 100%),
                      (25%, 100%),
                    )
                    #place(center + horizon)[
                      #box[#image("aur_logo_light_no_bg.svg", fit: "contain")]
                    ]
                  ]
                ]
              ]
            ]
            
            #place(top + align-edge)[#title-block]
          ]
        ]
      }
      if show-page-number.get() {
      place(bottom + center, dy: -10pt)[
        #text(font: "Nasalization", size: 10pt, fill: brand-palette.gray)[
          #sym.bullet Robotics is Our
          #box(baseline: -2pt)[N]/#box(baseline: 2pt)[G]ame #sym.bullet
        ]
      ]
      align(right + bottom)[
        #let h = 0.8cm
        #let hex-width = h * 1.1547
        #let ribbon-tail = 1cm
        #let depth = 0.25cm
        #let shift-right = 1cm
        #let bleed = -0.7cm
        
        #box(width: hex-width + ribbon-tail + shift-right + bleed, height: h)[
          // 1. Hexagon
          #place(left, dx: shift-right)[
            #box(width: hex-width, height: h)[
              #polygon(
                fill: brand-palette.primary,
                (0%, 50%),
                (25%, 0%),
                (75%, 0%),
                (100%, 50%),
                (75%, 100%),
                (25%, 100%),
              )
              #place(center + horizon)[
                #text(font: "Nasalization", fill: brand-palette.offwhite, weight: "bold", size: 10pt)[
                  #context counter(page).display()
                ]
              ]
            ]
          ]
          
          #place(left, dx: shift-right + hex-width - 0.1cm)[
            #polygon(
              fill: brand-palette.background,
              (0pt, 0pt),
              (depth, h / 2),
              (0pt, h),
              (0.6cm, h),
              (depth + 0.6cm, h / 2),
              (0.6cm, 0pt),
            )
          ]
        ]
      ]
      }
    },
  )
  
  show heading.where(level: 1): set text(fill: brand-palette.secondary)
  show heading.where(level: 1): set heading(numbering: none)
  set heading(numbering: (..nums) => {
    let level = nums.pos().len()
    if level > 1 {
      numbering("1.1", ..nums.pos().slice(1))
    }
  })
  show link: set text(fill: brand-palette.primary)
  show outline.entry: set text(fill: brand-palette.primary)
  show outline.entry: it => {
    show link: set text(fill: brand-palette.primary)
    it
  }
  
  body
}