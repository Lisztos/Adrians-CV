---
name: tailor-cv
description: Tailor Adrian's CV to a job posting URL - assess fit, create a per-job YAML from the right base variant, render the PDF, and write a concise German or English cover letter. Use whenever a job/freelance posting URL (freelancermap, etengo, LinkedIn, etc.) is shared.
---

# Tailor CV to Job Posting

The end-to-end pipeline used for every application in this repo. One master YAML per language/location variant; each job gets a small tailored copy in `jobs/`.

## Inputs

- Job posting URL (or pasted job description)
- Which base variant fits (default by language of posting):

| Base | Language | Location |
|------|----------|----------|
| `base.yaml` | English | Berlin |
| `base-de.yaml` | German | Berlin |
| `base-mx.yaml` | English | Cuernavaca, MX |

## Steps

1. **Fetch and assess the posting.** Read the URL (WebFetch/Playwright). Summarize: role, must-have skills, language, remote/onsite, rate if listed. Give an honest fit assessment against the CV before tailoring — call out gaps.
2. **Create the per-job YAML:** copy the right base to `jobs/<company-or-platform>-<role-slug>.yaml`. Put the job link as a comment on the first line after the `$schema` line.
3. **Tailor content, never invent it.** Reorder/reword highlights to mirror the posting's keywords, trim irrelevant entries to keep ONE page. Only use experience that exists in the base YAML — no invented skills or projects (past friction: hallucinated "Power BI Caching").
4. **Render to a temp dir, then copy ONLY the PDF into the job folder.** RenderCV resolves `-o` relative to the YAML file and always emits a `.typ` alongside the PDF, so never render directly into `jobs/`. Do:
   - `./venv/bin/rendercv render jobs/<slug>.yaml -o <scratchpad>/<slug>`
   - `mkdir -p jobs/<slug>/ && cp <scratchpad>/<slug>/Adrian_Sanchez_CV.pdf jobs/<slug>/`

   **Deliverables layout (strict, user-mandated 2026-07):** `jobs/<slug>/` contains ONLY the final PDF(s) and the cover letter if one was requested — nothing else (no `.typ`, no nested output dirs). The YAML source stays flat as `jobs/<slug>.yaml`.
5. **Verify the PDF yourself** before presenting: Read the PDF in `jobs/<slug>/`; check one-page fit, section spacing, no duplicated sections (e.g. the past double "Languages" bug). Fix and re-render until clean.
6. **Cover letter (if asked, or offer it):** short and concise, saved in the job folder as `jobs/<slug>/cover-letter.md` (English) or `jobs/<slug>/anschreiben.md` (German). If a rendered letter PDF is produced (via a separate `-anschreiben.yaml`), copy that PDF into the same folder. Style rules (non-negotiable, from memory + past corrections):
   - No em dashes — they signal AI writing.
   - Natural, native Hochdeutsch (or natural English), human-sounding, no corporate filler.
   - Concise: ~150-250 words.
7. **Commit** the job YAML + the `jobs/<slug>/` folder (PDF + letter) with a message naming the position. Ask whether to use a per-job branch (the user has used per-job branches before) or commit to main. No AI co-author attribution (user preference).

## Notes

- RenderCV v2.8, Typst engine, venv-local: always `./venv/bin/rendercv`, never global.
- Schema is pinned per-file on line 1; keep it when copying.
- Raw render dirs (`output/`, `rendercv_output/`, `*_output/`) are git-ignored; the curated `jobs/<slug>/` folders ARE committed (final PDFs + letters), along with the YAMLs.
