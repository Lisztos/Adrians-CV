#block(breakable: false, width: 100%, below: 0.24cm)[
  #grid(
    columns: (left-col-width, 1fr),
    column-gutter: 0cm,
    align: (top + left, top + left),
    [
      #text(size: 8.4pt, fill: c-muted)[{{ entry.date_and_location_column | trim }}]
    ],
    [
      #text(size: 9.6pt, weight: "bold", fill: c-dark)[{{ entry.institution }}]
      #v(0.14cm, weak: true)
      #text(size: 8.8pt, fill: c-body)[{{ entry.degree }} – {{ entry.area }}]
    ]
  )
]
