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
    } else if show-label and is-numbered  {
      ref(lbl)
    } else {
      link(target-loc, resolved-content)
    }
  }
}