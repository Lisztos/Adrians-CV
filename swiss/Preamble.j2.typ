#import "@preview/fontawesome:0.6.0": fa-icon

#let original-link = link
#let link(dest, body, ..args) = original-link(dest, body)
#let connection-with-icon(icon-name, body) = [#fa-icon(icon-name, size: 0.9em) #h(0.05cm) #body]

#let c-dark = rgb(15, 20, 25)
#let c-accent = rgb(11, 58, 79)
#let c-body = rgb(36, 48, 64)
#let c-muted = rgb(102, 112, 133)
#let c-rule = rgb(217, 222, 231)
#let c-photo-border = rgb(197, 204, 214)
#let left-col-width = 3.55cm

#set document(author: "{{ cv._plain_name }}", title: "{{ settings.pdf_title }}")
#set page(
  paper: "a4",
  margin: (top: 1.3cm, bottom: 1.0cm, left: 1.5cm, right: 1.5cm),
)
#set text(
  font: "{{ design.typography.font_family.body }}",
  size: 8.8pt,
  fill: c-body,
  lang: "{{ locale.language_iso_639_1 }}",
  hyphenate: false,
)
#set par(leading: 0.54em, spacing: 0.54em, justify: false)
#set list(
  marker: box(baseline: -1.6pt, circle(radius: 1.65pt, fill: c-accent)),
  indent: 0pt,
  body-indent: 6pt,
  spacing: 0.52em,
)
