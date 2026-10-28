#block(breakable: false, width: 100%, below: 0.15cm)[
  #grid(
    columns: (left-col-width, 1fr),
    column-gutter: 0cm,
    align: (top + left, top + left),
    [
      #text(size: 8.7pt, weight: "semibold", fill: c-dark)[{{ entry.label }}]
    ],
    [
      #text(size: 8.7pt, fill: c-body)[{{ entry.details }}]
    ]
  )
]
