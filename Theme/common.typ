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