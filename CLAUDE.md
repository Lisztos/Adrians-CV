# CLAUDE.md

CV pipeline: masters live as RenderCV YAML, each job application gets a small tailored
copy plus a rendered PDF. Full manual walkthrough in `README.md`; the end-to-end flow is
automated by the `tailor-cv` skill (`.claude/skills/tailor-cv/`) — invoke it whenever a
job posting URL is shared.

## Layout

| Path | What it is |
|------|-----------|
| `base.yaml` | Master CV, English, Berlin: single source of truth |
| `base-de.yaml` | German variant, Berlin (localized dates, German section titles) |
| `base-mx.yaml` | English variant, Cuernavaca/Mexico location |
| `base-ch.yaml` | Swiss master, English, Basel, photo, `engineeringclassic` design |
| `base-ch-de.yaml` | Swiss master, German (Swiss Standard German), Basel, photo |
| `photo.jpg` | CV photo used by the Swiss bases (600x800, 3:4) |
| `jobs/<company-role>.yaml` | Per-job tailored CV source (flat, committed) |
| `jobs/<company-role>-anschreiben.yaml` | Optional cover-letter source (flat, committed) |
| `jobs/<company-role>/` | Deliverables folder: final PDF(s), cover letter, application answers ONLY (committed) |
| `rendercv_output/`, `output/`, `*_output/` | Raw render output (git-ignored) |
| `venv/` | Local Python env (git-ignored) |

Pick the base by target market, then language:

- Switzerland (the main target since 2026-10): English → `base-ch.yaml`,
  German → `base-ch-de.yaml`.
- Everywhere else: English → `base.yaml`, German → `base-de.yaml`,
  LATAM/Mexico → `base-mx.yaml`. No photo, one page, `classic` design.

Content changes (new jobs, bullets, skills) go into all five bases.

## Swiss market conventions (`-ch` bases and their per-job copies only)

- Header shows Basel, Swiss phone, nationality (German, Mexican) and a photo
  (`photo.jpg` in the repo root, 600x800 portrait crop). No date of birth (user choice).
- Languages use CEFR levels: Spanish native, German C1, English C1, French B1.
- German text uses Swiss Standard German: `ss` instead of Eszett, `3’000` as thousands
  separator (type the real apostrophe U+2019; Typst renders `'` as a prime).
- English text uses British spelling.
- Keep the timeline gapless and keep the "References on request" section.
- Design: `engineeringclassic` theme (chosen 2026-10), Raleway for name/headings, Lato for
  body text (Raleway's old-style numerals misrender 3’000). No top note; page footer kept.
  Overriding one `font_family` key resets the others, so always set all five.

## Rendering

- RenderCV v2.8, Typst engine, venv-local: **always `./venv/bin/rendercv`** — there is no
  global install, and only the `[full]` extra can produce PDFs.
- Schema is pinned on line 1 of every YAML (`v2.8/schema.json`); keep it when copying.
- **Never render into `jobs/` directly.** RenderCV resolves `-o` relative to the YAML and
  always emits a `.typ` next to the PDF. Render to a scratch dir, then copy only the PDF:

  ```bash
  ./venv/bin/rendercv render jobs/<slug>.yaml -o <scratch>/<slug>
  mkdir -p jobs/<slug> && cp <scratch>/<slug>/Adrian_Sanchez_CV.pdf jobs/<slug>/
  ```

- Each YAML's `settings.render_command` disables Markdown/HTML/PNG output on purpose —
  keep those flags in per-job copies.

## Tailoring rules (hard requirements)

- **Never invent experience.** Only reorder, trim, or reword what exists in the base
  YAML. Past incident: a hallucinated "Power BI Caching" skill. If a posting's must-have
  is missing from the base, say so in the fit assessment instead of adding it.
- **Page limit.** Non-Swiss CVs: one page. Swiss CVs: two pages max, but never a stub
  second page with one or two short sections. After every render, Read the PDF and
  verify: page count, no duplicated sections (there was once a double "Languages" bug),
  sane spacing. Trim least-relevant
  bullets and tighten the summary until it fits. Never report done without this check.
- Give an honest fit assessment (strengths AND gaps) before tailoring.
- Keep the diff against the master small: headline, summary emphasis, highlight order,
  skills order. Leave `design` untouched.
- Put the job posting URL as a comment on line 2 of the per-job YAML (or note "job
  description pasted, no URL"). Older job files keep it lower in the header block; fine.

## Cover letters

- English: `jobs/<slug>/cover-letter.md`; German: `jobs/<slug>/anschreiben.md`.
- Styled PDF version: separate `jobs/<slug>-anschreiben.yaml` reusing the CV header and
  `design` block; section title = subject line (Betreff). See README for the template.
- Style (non-negotiable): **no em dashes** (they signal AI writing), natural
  human-sounding English or native Hochdeutsch, no corporate filler, ~150–250 words.

## Git

- **Everything goes on `main`** — one application per job, no per-job branches
  (decided 2026-07: job CVs are permanent coexisting artifacts).
- Commit the per-job YAML + the `jobs/<slug>/` folder together; message names the
  position, e.g. `Add tailored CV for Acme Backend Engineer`.
- **No AI co-author attribution** in commit messages (user preference).
- Committed PDFs in `jobs/<slug>/` are intentional artifacts, even though raw render
  output is git-ignored.
