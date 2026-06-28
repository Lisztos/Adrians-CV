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

Output lands in `rendercv_output/` (PDF, PNG, Markdown, HTML, and the `.typ` source).
Output is git-ignored — it's always regenerated from YAML.

## Per-job workflow

Everything stays on `main` — one file per application under `jobs/`. No branches:
job CVs are independent, permanent artifacts that coexist (a branch would only let you
see one at a time and wouldn't inherit `base.yaml` improvements).

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

4. **Render the tailored file** into its own folder so PDFs don't collide:

   ```bash
   ./venv/bin/rendercv render jobs/acme-backend-engineer.yaml -o output/acme-backend-engineer
   ```

   The final PDF: `output/acme-backend-engineer/Adrian_Sanchez_CV.pdf`.

5. **Commit the YAML** (not the PDF — it's regeneratable):

   ```bash
   git add jobs/acme-backend-engineer.yaml
   git commit -m "Tailor CV for Acme Backend Engineer"
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
| `jobs/company-role.yaml` | Per-job tailored copies (committed) |
| `rendercv_output/`, `output/` | Generated artifacts (git-ignored) |
| `venv/` | Local Python env (git-ignored) |
