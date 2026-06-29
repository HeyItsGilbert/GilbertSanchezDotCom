---
description: Fetch a GitHub user's created repos and add/refresh project entries (with feature images) under content/projects/
argument-hint: "[github-username] (defaults to HeyItsGilbert)"
---

# Add GitHub projects to the portfolio

Add entries under `content/projects/` for repositories **created** (not forked) by
the GitHub user **${1:-HeyItsGilbert}**, including a generated `feature.webp` for each.

Work end-to-end and verify before yielding. Do not commit unless asked.

## 1. Fetch repos

- Hit the GitHub API, paginate, keep **sources only** (`fork == false`):
  `https://api.github.com/users/<USER>/repos?per_page=100&type=owner&page=N`
- Capture per repo: `name`, `description`, `created_at`, `html_url`, `language`,
  `topics`, `homepage`, `archived`.

## 2. Decide what to add

- **Skip** repos already represented in `content/projects/*/index.md` — match on
  `externalUrl` (an existing entry may live in a differently-named folder, e.g.
  `ValeAgentic/` holds `vale-agentic`).
- **Skip** non-project meta repos: `.github` and the profile repo (same name as the user).
- **Ask the user** before including questionable repos (empty/abandoned, demos,
  anything with an embarrassing name). Report what you skipped and why.

## 3. Write each entry

Create `content/projects/<RepoName>/index.md`. Folder name = repo name. Match this
frontmatter exactly (it renders as an external-link card — `render:"false"` + `externalUrl`):

```yaml
---
title: <repo name or nicer title>
date: <created_at date, YYYY-MM-DD>
externalUrl: <html_url>
summary: "<one-line summary>"
showReadingTime: false
showDateUpdated: false
_build:
  render: "false"
  list: local
lastmod: <today, YYYY-MM-DD>
type: projects
tags:
  - <Tag>
---
```

- **Summary**: use the GitHub description, fixing typos. If description is null,
  read the repo README (`/repos/<user>/<name>/readme`, base64) to ground a real
  summary — never invent one.
- **Tags**: derive from `language` + meaningful `topics`, using these category labels:
  PowerShell, AI, Obsidian, PKM, Web, Hugo, Jekyll, Marp, Presentations, RPG, Linting,
  Pester, Dotfiles, Ruby, C#, TypeScript.

## 4. Generate feature images

For every new entry (offer to also refresh existing low-res `feature.webp` placeholders
— but leave any already-good real image alone). One emblem per repo, **one cohesive set**:

- **Style** (every image): flat / semi-flat vector, clean modern developer-portfolio
  icon, single bold centered motif, generous negative space, **dark charcoal background**
  matching the site's dark "congo" theme, soft glow, **16:9**.
- **No text** in images. Add `"absolutely no text, no words, no letters"` to scene +
  composition. The model injects gibberish otherwise — regenerate any offender. Only use
  the `text` param when a short label is genuinely wanted (e.g. a monogram or year).
- **Color-code by category** so the grid scans at a glance:

  | Category | Accent |
  |---|---|
  | PowerShell tooling | console blue `#5391FE` |
  | AI | violet→magenta |
  | Obsidian / PKM | purple `#7C3AED` |
  | Web / site | teal/green |
  | Presentations | coral/orange |
  | RPG | amber/parchment |

- Each generated file is a temp PNG/JPG (often 2 variants — pick the best). The model
  is `gemini-3-pro-image-preview` via the image tool; map results to repos **by call order**.
- **Normalize to 1200×675 WebP** (cover-crop, lossy q85) and save as
  `content/projects/<RepoName>/feature.webp`. Needs Pillow (`pip install pillow`):

```python
from PIL import Image
import os
def save_feature(src, dest_dir, target=(1200, 675)):
    im = Image.open(src).convert('RGB')
    tw, th = target; sw, sh = im.size
    s = max(tw/sw, th/sh); nw, nh = round(sw*s), round(sh*s)
    im = im.resize((nw, nh), Image.LANCZOS)
    l, t = (nw-tw)//2, (nh-th)//2
    im = im.crop((l, t, l+tw, t+th))
    os.makedirs(dest_dir, exist_ok=True)
    d = os.path.join(dest_dir, 'feature.webp')
    im.save(d, 'WEBP', quality=85, method=6)
    return d
```

- Review each batch as a contact sheet before moving on.

## 5. Verify (gotchas learned the hard way)

- **Do NOT run `hugo server` (the watcher) while bulk-writing files.** It panics on the
  flurry of file events (`index out of range`) and logs false `image: unknown format`
  errors from reading half-written webp. Write everything first.
- Validate with a **one-shot build**: `./bin/hugo/hugo` — require **exit 0** and zero
  `unknown format` / `error` / `panic` lines. That proves Hugo decoded every `feature.webp`.
- Then start the server for review with: `./bin/hugo/hugo server --port 1313 --bind 0.0.0.0 --disableFastRender`
- In-browser, confirm every project card's feature image decodes (`naturalWidth > 0`);
  remember Blowfish lazy-loads, so scroll/force-load before judging "missing" images.

## 6. Report

List added / skipped / regenerated entries, any summaries grounded from READMEs, and the
verification result. Leave the work uncommitted unless the user asks otherwise.
