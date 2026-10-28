{% set is_de = (locale.language_iso_639_1 == "de") %}
#context {
  let info-content = block(spacing: 0pt)[
    #text(font: "{{ design.typography.font_family.body }}", size: 26pt, weight: "bold", fill: c-dark, top-edge: "cap-height", bottom-edge: "baseline")[{{ cv.name }}]
    #v(0.24cm)
    #text(font: "{{ design.typography.font_family.body }}", size: 11pt, weight: "semibold", fill: c-accent, top-edge: "cap-height", bottom-edge: "baseline")[{{ cv.headline }}]
    #v(0.32cm)
    #set text(size: 8.8pt, fill: c-muted, top-edge: "cap-height", bottom-edge: "baseline")
    #grid(
      columns: (auto, auto),
      column-gutter: 0.7cm,
      row-gutter: 0.26cm,
      align: (left + top, left + top),
      block(spacing: 0pt, inset: 0pt)[#text(weight: "semibold", fill: c-dark)[{% if is_de %}E-Mail:{% else %}Email:{% endif %}] #link("mailto:{{ cv.email }}")[#underline(stroke: 0.45pt + c-accent, offset: 1.5pt)[#text(fill: c-accent)[{{ cv.email | replace("@", "\\@") }}]]]],
      block(spacing: 0pt, inset: 0pt)[#text(weight: "semibold", fill: c-dark)[{% if is_de %}Telefon:{% else %}Phone:{% endif %}] #link("{{ cv.phone }}")[#underline(stroke: 0.45pt + c-accent, offset: 1.5pt)[#text(fill: c-accent)[+41 77 456 69 73]]]],
      block(spacing: 0pt, inset: 0pt)[#text(weight: "semibold", fill: c-dark)[Website:] #link("{{ cv.website }}")[#underline(stroke: 0.45pt + c-accent, offset: 1.5pt)[#text(fill: c-accent)[{{ cv.website | clean_url }}]]]],
      block(spacing: 0pt, inset: 0pt)[{% if cv.social_networks %}{% for sn in cv.social_networks %}#text(weight: "semibold", fill: c-dark)[LinkedIn:] #link("{{ sn.url }}")[#underline(stroke: 0.45pt + c-accent, offset: 1.5pt)[#text(fill: c-accent)[{{ sn.username }}]]]{% endfor %}{% endif %}],
      block(spacing: 0pt, inset: 0pt)[#text(weight: "semibold", fill: c-dark)[{% if is_de %}Standort:{% else %}Location:{% endif %}] #text(fill: c-body)[{{ cv.location }}]],
      block(spacing: 0pt, inset: 0pt)[{% if cv.custom_connections %}{% for cc in cv.custom_connections %}{% set cc_parts = cc.placeholder.split(": ") %}#text(weight: "semibold", fill: c-dark)[{{ cc_parts[0] }}:] #text(fill: c-body)[{{ cc_parts[1] | replace("/", "\\/") }}]{% endfor %}{% endif %}],
    )
  ]
  let h = measure(info-content).height
  let w = h * 0.78
  grid(
    columns: (1fr, auto),
    column-gutter: 0.6cm,
    align: (top + left, top + right),
    info-content,
{% if cv.photo %}
    box(stroke: 0.45pt + c-photo-border, image("{{ cv.photo.name }}", width: w, height: h, fit: "cover")),
{% endif %}
  )
}
#v(0.34cm)
#line(length: 100%, stroke: 1.25pt + c-accent)
#v(0.06cm)
