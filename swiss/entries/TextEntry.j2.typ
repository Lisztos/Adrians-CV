{% if ", " in entry and "(" in entry and entry.count("(") >= 3 %}
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5cm,
  row-gutter: 0.22cm,
{% for item in entry.split(", ") %}
{% set parts = item.split(" (") %}
  grid(
    columns: (1fr, auto),
    [#text(size: 8.8pt, weight: "semibold", fill: c-dark)[{{ parts[0] }}]],
    [#text(size: 8.4pt, fill: c-muted)[{{ parts[1] | replace(")", "") }}]],
  ),
{% endfor %}
)
{% else %}
#text(size: 8.8pt, fill: c-body)[{{ entry }}]
{% endif %}
