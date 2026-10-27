---
name: tailor-cv
description: Tailor Adrian's CV to a job posting URL - assess fit, create a per-job YAML from the right base variant, render the PDF, and write a concise German or English cover letter. Use whenever a job/freelance posting URL (company career page, LinkedIn, jobs.ch, etc.) is shared.
---

# Tailor CV to Job Posting

The end-to-end pipeline used for every application in this repo. One master YAML per language/location variant; each job gets a small tailored copy in `jobs/`.

## Inputs

- Job posting URL (or pasted job description)
- Which base variant fits (default by language of posting):

| Base | Language | Location |
|------|----------|----------|
| `base-ch.yaml` | English | Basel, CH (Swiss postings, photo, 2 pages max) |
| `base-ch-de.yaml` | German | Basel, CH (Swiss postings, photo, 2 pages max) |
| `base.yaml` | English | Berlin (non-Swiss, one page) |
| `base-de.yaml` | German | Berlin (non-Swiss, one page) |
| `base-mx.yaml` | English | Cuernavaca, MX (LATAM, one page) |

## Steps

1. **Fetch and assess the posting.** Read the URL (WebFetch/Playwright). Summarize: role, must-have skills, language, remote/onsite, rate if listed. Give an honest fit assessment against the CV before tailoring — call out gaps.
2. **Create the per-job YAML:** copy the right base to `jobs/<company-or-platform>-<role-slug>.yaml`. Put the job link as a comment on line 2, right after the `$schema` line (or "job description pasted, no URL").
3. **Tailor content, never invent it.** Reorder/reword highlights to mirror the posting's keywords, trim irrelevant entries to fit: ONE page for non-Swiss CVs, TWO pages max for Swiss CVs (never a near-empty second page). Only use experience that exists in the base YAML — no invented skills or projects (past friction: hallucinated "Power BI Caching").
4. **Render to a temp dir, then copy ONLY the PDF into the job folder.** RenderCV resolves `-o` relative to the YAML file and always emits a `.typ` alongside the PDF, so never render directly into `jobs/`. Do:
   - `./venv/bin/rendercv render jobs/<slug>.yaml -o <scratchpad>/<slug>`
   - `mkdir -p jobs/<slug>/ && cp <scratchpad>/<slug>/Adrian_Sanchez_CV.pdf jobs/<slug>/`

   **Deliverables layout (strict, user-mandated 2026-07):** `jobs/<slug>/` contains ONLY the final PDF(s), the cover letter if one was requested, and written answers to application questions (e.g. `why-<company>-answer.md`) — nothing else (no `.typ`, no nested output dirs). The YAML source stays flat as `jobs/<slug>.yaml`.
5. **Verify the PDF yourself** before presenting: Read the PDF in `jobs/<slug>/`; check page count (one page, or two for Swiss CVs with no stub second page), section spacing, no duplicated sections (e.g. the past double "Languages" bug). Fix and re-render until clean.
6. **Cover letter (if asked, or offer it):** short and concise, saved in the job folder as `jobs/<slug>/cover-letter.md` (English) or `jobs/<slug>/anschreiben.md` (German). If a rendered letter PDF is produced (via a separate `-anschreiben.yaml`), copy that PDF into the same folder. Style rules (non-negotiable, from memory + past corrections):
   - No em dashes — they signal AI writing.
   - Natural, native Hochdeutsch (or natural English), human-sounding, no corporate filler.
   - Concise: ~150-250 words.
7. **Commit** the job YAML + the `jobs/<slug>/` folder (PDF + letter) with a message naming the position. Commit directly to `main` (no per-job branches, decided 2026-07). No AI co-author attribution (user preference).

## Notes

- RenderCV v2.8, Typst engine, venv-local: always `./venv/bin/rendercv`, never global.
- Schema is pinned per-file on line 1; keep it when copying.
- Raw render dirs (`output/`, `rendercv_output/`, `*_output/`) are git-ignored; the curated `jobs/<slug>/` folders ARE committed (final PDFs + letters), along with the YAMLs.
