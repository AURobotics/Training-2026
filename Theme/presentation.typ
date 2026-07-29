#import "/Theme/common.typ": brand-palette

#import "@preview/touying-au-community:0.2.0": *


#let presentation-template(title: "Presentation Title", subtitle: "Subtitle", author: "Author", date: datetime.today(), institution: "AU-Robotics", department: "Training", body) = {
  show: touying-au-community.with(
    aspect-ratio: "16-9",
    include-sections: true, // Default true
    include-agenda: true, // Default true
    config-colors(
      primary: brand-palette.primary,
      primary-dark: brand-palette.background,
      secondary: au-gray,
      secondary-dark: au-gray-dark,
    ),
    config-info(
      title: title,
      subtitle: subtitle,
      short-title: "E",
      short-subtitle: "E",
      author: author,
      date: date,
      institution: institution,
      department: department,
      contact: "E",
      extra: "E",
      logo: image("aur_white_fg_transparent_bg.svg"),
    ),
  )
  body
}
