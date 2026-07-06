# CV Pipeline

Maintain my CV as YAML and produce per-job tailored PDFs with [RenderCV](https://rendercv.com)
(Typst engine). One master file (`base.yaml`); each tailored CV is a small copy committed to git.

## Setup (one time)

```bash
python3 -m venv venv
./venv/bin/pip install "rendercv[full]"
```

Installed: RenderCV v2.8 (Typst engine). YAML schema is pinned in each file's first line
(`$schema=...refs/tags/v2.8/schema.json`). If you upgrade RenderCV, run `rendercv new "X"`
again to diff the schema — key names change across versions.

## Variants

There are several master variants. Render each into its own output folder:

| File | Language | Location | Render command |
|------|----------|----------|----------------|
| `base.yaml` | English | Berlin, Germany | `./venv/bin/rendercv render base.yaml` |
| `base-de.yaml` | German | Berlin, Deutschland | `./venv/bin/rendercv render base-de.yaml -o rendercv_output/de` |
| `base-mx.yaml` | English | Cuernavaca, Mexico | `./venv/bin/rendercv render base-mx.yaml -o rendercv_output/mx` |

The German file sets `locale: language: german`, which localizes dates (e.g. `Okt 2023 – Mai 2026`);
its section titles are written in German since the section key *is* the displayed heading.

## Render

```bash
./venv/bin/rendercv render base.yaml
```

Output lands in `rendercv_output/`. Each file's `settings.render_command` switches off
Markdown, HTML, and PNG, so a render produces just the **PDF** plus its `.typ` source.
(Typst can't be disabled on its own, since the PDF is compiled from it.) If you ever need a
PNG for a quick visual check, set `dont_generate_png: false` in that file, or just open the
PDF. Output is git-ignored, always regenerated from YAML.

## Per-job workflow

> The end-to-end flow is automated by the **`tailor-cv` skill** (`.claude/skills/tailor-cv/`):
> paste a job posting URL and it assesses fit, creates the tailored YAML, renders, verifies
> the PDF, and drafts a cover letter. The steps below are what that skill does — do them by
> hand when tailoring manually.

Everything stays on `main` — one application per job under `jobs/`. No branches:
job CVs are independent, permanent artifacts that coexist (a branch would only let you
see one at a time and wouldn't inherit `base.yaml` improvements).

Each job has two things: a **flat YAML source** (`jobs/<slug>.yaml`) and a **deliverables
folder** (`jobs/<slug>/`) that holds only the final PDF(s) and cover letter. Both are
committed — the curated `jobs/<slug>/` PDFs are checked in even though raw render output
elsewhere is git-ignored.

1. **Copy a master** into `jobs/`, naming it `company-role.yaml`:

   ```bash
   cp base.yaml jobs/acme-backend-engineer.yaml
   ```

2. **Add the job link as a comment** at the top of the file, e.g.:

   ```yaml
   # TAILORED — Acme "Backend Engineer". English, Berlin.
   # Job posting: https://acme.example.com/jobs/backend-engineer
   ```

3. **Edit only what the posting needs.** Keep edits as a small diff against the master:
   - `cv.headline` — match the target title (e.g. `Backend Engineer`).
   - `summary` section — reorder/sharpen one sentence toward the role; don't rewrite wholesale.
   - `experience[].highlights` — reorder so the most relevant bullets lead; you may drop
     bullets that don't apply, but **do not invent or reword achievements**.
   - `skills` — surface the stack the posting asks for first.
   - `design.theme` — leave as-is unless a company expects a specific look.

4. **Render to a scratch dir, then copy only the PDF** into the job folder. RenderCV resolves
   `-o` relative to the YAML and always emits a `.typ` alongside the PDF, so never render
   straight into `jobs/`:

   ```bash
   ./venv/bin/rendercv render jobs/acme-backend-engineer.yaml -o /tmp/acme-backend-engineer
   mkdir -p jobs/acme-backend-engineer
   cp /tmp/acme-backend-engineer/Adrian_Sanchez_CV.pdf jobs/acme-backend-engineer/
   ```

   The deliverables folder `jobs/acme-backend-engineer/` should contain **only** the final
   PDF(s) and cover letter — no `.typ`, no nested render dirs.

5. **Commit the YAML source and the deliverables folder** (the PDF here is a committed artifact):

   ```bash
   git add jobs/acme-backend-engineer.yaml jobs/acme-backend-engineer/
   git commit -m "Tailor CV for Acme Backend Engineer"
   ```

## Cover letters (Anschreiben)

A tailored application can include a cover letter alongside the CV. A plain-text letter
lives in the job folder as `jobs/<slug>/cover-letter.md` (English) or
`jobs/<slug>/anschreiben.md` (German). If you also want a styled PDF that matches the CV
letterhead, write a separate `jobs/<company-role>-anschreiben.yaml` source and copy its
rendered PDF into `jobs/<slug>/` (e.g. `Adrian_Sanchez_Anschreiben.pdf`).

The `-anschreiben.yaml` is an ordinary RenderCV file that reuses the CV's header and `design` block
(so the letterhead and styling match), with the letter written as plain-text
paragraphs under a single section whose **title is the subject line (Betreff)**:

```yaml
cv:
  # ...same name / headline / location / email / website / social_networks as the CV...
  sections:
    Bewerbung als <Rolle> – Referenz <Ref-Nr.>:   # section title = Betreff
      - "<Empfänger>, z. Hd. <Ansprechpartner>"
      - "<Ort>, <Datum>"
      - "Sehr geehrte/r ...,"
      - First body paragraph as a plain string.
      - Second body paragraph...
      - "Mit freundlichen Grüßen"
      - "Adrian Sanchez"
settings:                                          # rename output away from *_CV.*
  pdf_title: Adrian Sanchez - Anschreiben
  render_command:
    pdf_path: OUTPUT_FOLDER/Adrian_Sanchez_Anschreiben.pdf
```

Render it to a scratch dir, then copy the PDF into the job's deliverables folder so it
sits next to the CV:

```bash
./venv/bin/rendercv render jobs/acme-backend-engineer-anschreiben.yaml \
  -o /tmp/acme-backend-engineer-anschreiben
cp /tmp/acme-backend-engineer-anschreiben/Adrian_Sanchez_Anschreiben.pdf \
  jobs/acme-backend-engineer/
```

## Themes

Bundled themes in v2.8: `classic`, `ember`, `engineeringclassic`, `engineeringresumes`,
`harvard`, `ink`, `moderncv`, `opal`, `sb2nov`. Set `design.theme` in the YAML.
Preview any theme without touching `base.yaml`:

```bash
printf "design:\n  theme: sb2nov\n" > /tmp/d.yaml
./venv/bin/rendercv render base.yaml --design /tmp/d.yaml -o theme_preview/sb2nov
```

## Files

| File | Purpose |
|------|---------|
| `base.yaml` | Master CV (English, Berlin) — single source of truth |
| `base-de.yaml` | German variant |
| `base-mx.yaml` | English variant, Cuernavaca/Mexico location |
| `jobs/company-role.yaml` | Per-job tailored CV source (committed, flat) |
| `jobs/company-role-anschreiben.yaml` | Optional per-job cover-letter source (committed, flat) |
| `jobs/company-role/` | Per-job deliverables folder — final PDF(s) + `cover-letter.md`/`anschreiben.md` (committed) |
| `.claude/skills/tailor-cv/` | Skill that automates the per-job workflow end to end |
| `rendercv_output/`, `output/` | Raw render output (git-ignored, always regenerated) |
| `venv/` | Local Python env (git-ignored) |
