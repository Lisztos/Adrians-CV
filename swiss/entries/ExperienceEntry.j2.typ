#block(breakable: false, width: 100%, below: 0.38cm)[
  #grid(
    columns: (left-col-width, 1fr),
    column-gutter: 0cm,
    align: (top + left, top + left),
    [
      #text(size: 8.4pt, fill: c-muted)[{{ entry.date_and_location_column | trim }}]
    ],
    [
      #text(size: 9.7pt, weight: "bold", fill: c-dark)[{{ entry.company }}]{% if entry.location %}#text(size: 8.7pt, fill: c-muted)[ · {{ entry.location }}]{% endif %}

      #v(0.14cm, weak: true)
      #text(size: 8.9pt, weight: "semibold", fill: c-body)[{{ entry.position }}]{% if entry.summary %} #text(size: 8.2pt, fill: c-muted)[· {{ entry.summary | replace("#summary[", "") | replace("#strong[Tech-Stack:]", "Tech-Stack:") | replace("#strong[Tech Stack:]", "Tech Stack:") | replace("]", "") | trim }}]{% endif %}

      #v(0.17cm, weak: true)
{% for line in entry.highlights %}
      - {{ line }}
{% endfor %}
    ]
  )
]
