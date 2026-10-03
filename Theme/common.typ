#let brand-palette = (
  primary: rgb("#e12149"),
  secondary: rgb("#be0d2f"),
  accent: rgb("#e45649"),
  background: rgb("#89162e"),
  gold: rgb("#ffce00"),
  dark_gold: rgb("#EEBC1D"),
  white: rgb("#ffffff"),
  offwhite: rgb("#f4ecee"),
  pale_white: rgb("#cecece"),
  accented_gray: rgb("#cfc0ca"),
  light_gray: rgb("#b5b5b5"),
  gray: rgb("#585858"),
  black: rgb("#181818"),
)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": codly-languages

#let setup-codly(body) = {
  show: codly-init.with()
  codly(languages: codly-languages)
  body
}

#let link-ref(lbl, show-label: true, show-content: true) = context {
  let matches = query(lbl)

  if matches.len() > 0 {
    let el = matches.first()
    let target-loc = el.location()

    let resolved-content = if el.has("body") {
      el.body
    } else if el.has("caption") {
      el.caption
    } else {
      el
    }

    let is-numbered = if el.has("numbering") {
      el.numbering != none
    } else {
      false
    }

    if show-label and is-numbered and show-content {
      link(target-loc, [#ref(lbl): #resolved-content])
    } else if show-label and is-numbered {
      ref(lbl)
    } else {
      link(target-loc, resolved-content)
    }
  }
}

#let emphasis(content) = {
  text(content, fill: brand-palette.background, weight: "bold")
}

#let reverse-emphasis(content) = {
  box(
    fill: rgb(brand-palette.accent),
    inset: (x: 4pt, y: 0pt),
    outset: (y: 4pt),
    radius: 2pt,
  )[#text(fill: brand-palette.white, weight: "bold")[#content]]
}

#let watermark_text(
  content: "WATERMARK",
  size: 50pt,
  alignment: center + horizon,
  rotation: 45deg,
  gaps: 0pt,
  opacity: 40%,
) = {
  let val = calc.min(int(float(opacity) * 255), 255)
  let opacity = str(val, base: 16)
  if opacity.len() == 1 { opacity = "0" + opacity }
  return pdf.artifact(kind: "watermark")[
    #align(alignment)[
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
  ]
}
