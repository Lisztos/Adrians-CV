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

## Render

```bash
./venv/bin/rendercv render base.yaml
```

Output lands in `rendercv_output/` (PDF, PNG, Markdown, HTML, and the `.typ` source).
Output is git-ignored — it's always regenerated from YAML.

## Per-job workflow

1. **Copy the master**, naming it `company-role.yaml`:

   ```bash
   cp base.yaml acme-backend-engineer.yaml
   ```

2. **Edit only what the posting needs.** Keep edits as a small diff against `base.yaml`:
   - `cv.headline` — match the target title (e.g. `Backend Engineer`).
   - `summary` section — reorder/sharpen one sentence toward the role; don't rewrite wholesale.
   - `experience[].highlights` — reorder so the most relevant bullets lead; you may drop
     bullets that don't apply, but **do not invent or reword achievements**.
   - `skills` — surface the stack the posting asks for first.
   - `design.theme` — leave as-is unless a company expects a specific look.

3. **Render the tailored file** into its own folder so PDFs don't collide:

   ```bash
   ./venv/bin/rendercv render acme-backend-engineer.yaml -o output/acme-backend-engineer
   ```

   The final PDF: `output/acme-backend-engineer/Adrian_Sanchez_CV.pdf`.

4. **Commit the YAML** (not the PDF — it's regeneratable):

   ```bash
   git add acme-backend-engineer.yaml
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
| `base.yaml` | Master CV — single source of truth |
| `company-role.yaml` | Per-job tailored copies (committed) |
| `rendercv_output/` | Generated artifacts (git-ignored) |
| `venv/` | Local Python env (git-ignored) |
