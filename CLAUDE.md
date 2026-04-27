# GilbertSanchezDotCom

Personal blog built with Hugo and the Blowfish theme, deployed via Netlify.
Site URL: https://gilbertsanchez.com/

## Tech Stack

| Component          | Details                                      |
|--------------------|----------------------------------------------|
| Static Site Gen    | Hugo (Extended) v0.141.0–0.149.x             |
| Theme              | Blowfish (git submodule, `themes/blowfish/`) |
| Hosting            | Netlify                                      |
| Comments           | Disqus (`gilbertsanchez`)                    |
| Analytics          | Umami (production only)                      |
| Presentations      | Marp (`@marp-team/marp-cli`)                 |
| Prose Linting      | Vale (config: `vale.ini`)                    |
| Package Manager    | Bun 1.3.11                                   |
| CMS                | Front Matter (VS Code extension)             |

## Repository Structure

```
.
├── archetypes/          # Hugo content templates (default.md)
├── assets/              # Source images, icons, CSS/JS (processed by Hugo Pipes)
│   ├── icons/           # Custom SVG icons (bluesky, linux, pdf, pptx, slideshow)
│   ├── images/          # Year/month organized images (WebP format)
│   └── img/             # Logo and profile images
├── config/
│   ├── _default/        # Base Hugo configuration
│   │   ├── hugo.toml        # Core settings (baseURL, taxonomies, sitemap, related)
│   │   ├── params.toml      # Theme params (appearance, layout, article options)
│   │   ├── languages.en.toml # Author info, bio, social links
│   │   ├── menus.en.toml    # Navigation menus (main + footer)
│   │   ├── markup.toml      # Goldmark + syntax highlighting config
│   │   └── module.toml      # Hugo module version constraints
│   └── production/
│       └── params.toml  # Production-only settings (Umami analytics)
├── content/
│   ├── posts/           # Blog posts (~29 entries), each in its own directory
│   ├── projects/        # Project pages (7 entries)
│   ├── presentations/   # Presentations (index.md + feature.png only — no source images)
│   └── series/          # Series taxonomy landing page
├── layouts/
│   ├── _default/_markup/  # Custom code block renderer
│   ├── partials/          # head.html, struct-data.html (JSON-LD), comments.html
│   ├── presentations/     # Custom single.html for presentation pages
│   ├── shortcodes/        # instagram.html, slideshow.html
│   └── robots.txt         # Custom robots.txt template
├── seo-metrics/         # SEO tracking data (see below)
├── static/
│   └── slides/          # Built slide files (HTML/PDF/PPTX) + slide images — committed
├── themes/blowfish/     # Theme (git submodule, do not edit directly)
├── .devcontainer/       # Dev container config (Node 18, Hugo, Vale, Go)
├── .github/             # CI workflows (merge-schedule), Dependabot config
├── .vscode/             # VS Code settings, Vale style packages
├── netlify.toml         # Netlify build config
├── package.json         # Node dependencies and scripts
├── frontmatter.json     # Front Matter CMS schema
└── vale.ini             # Vale prose linting configuration
```

## Development

### Local Server

```bash
bun run serve        # Runs: hugo server -D (includes drafts)
```

### Build

```bash
hugo --gc --minify   # Production build (used by Netlify)
```

### Install Dependencies

```bash
bun install          # Installs Node deps + Hugo via postinstall hook
```

### Creating Content

**New post:** Each post lives in its own directory under `content/posts/<slug>/index.md`. The archetype (`archetypes/default.md`) generates front matter with title, date, and `draft: true`.

```bash
hugo new posts/my-new-post/index.md
```

**Content front matter** typically includes: `title`, `date`, `draft`, `tags`, `series`, `description`, `summary`, and a hero/feature image reference.

**Image format:** Use WebP for all images. Place post-specific images alongside `index.md` in the post directory. Shared images go in `assets/images/YYYY/MM/`.

### Presentations

Presentations use Marp for slides and Hugo for the landing page. The build pipeline has two separate steps that must not be confused.

#### Adding a new presentation

1. Create a page bundle: `content/presentations/<Name>/index.md`
2. Run `PresoPublish.ps1` — it generates all slide outputs and `feature.png`
3. Commit `index.md` + `feature.png` only — **do not commit source images** (see below)

**Required front matter:**

```yaml
---
title: "Talk Title"
date: 2026-04-21T14:00:00-07:00
summary: One-sentence description.
description: One-sentence description.
tags:
  - PowerShell
type: presentations
preview: feature.png
slideshow: /slides/<OutputBaseName>.html   # must match the filename marp produces
marp: true
theme: summit-2026                         # or any built-in marp theme (default, gaia, uncover)
paginate: false
---
```

The `slideshow:` value drives the output filename. `PresoPublish.ps1` derives the base name from `[IO.Path]::GetFileNameWithoutExtension($fm['slideshow'])`, so `slideshow: /slides/my-talk.html` produces `my-talk.html/.pdf/.pptx` — use lowercase-hyphen names for multi-word titles.

#### Page bundle hygiene

Hugo processes every file in a page bundle as an image resource. Large animated GIFs and high-res PNGs will time out the Netlify build (a 13 MB GIF caused a confirmed timeout).

After building, `PresoPublish.ps1` warns about any bundle file over 500 KB (excluding `index.md` and `feature.png`). Nothing is auto-deleted — you optimize or remove flagged files manually before committing.

The threshold is `$MaxBundleKB = 500` in the main loop. Common culprits: animated GIFs (optimize with `gifsicle -O3`) and high-res PNGs (convert to WebP or downscale).

A healthy bundle looks like:
```
content/presentations/<Name>/
├── index.md           ← Hugo content + Marp source
├── feature.png        ← first-slide preview (generated by PresoPublish.ps1)
└── *.png / *.svg      ← slide images (logos, screenshots, diagrams) — keep under 500 KB each
```

All images also land in `static/slides/` for the HTML slideshow regardless of bundle state.

#### PresoPublish.ps1

Generates HTML, PDF, PPTX, and `feature.png` for every presentation in `content/presentations/`.

**Prerequisites:**
- `marp` CLI installed globally: `npm i -g @marp-team/marp-cli`
- Custom theme CSS reachable: script searches `$RepoRoot` then `$RepoRoot/../summit2026/` for `<theme>.css`
- Slide source images present in each `content/presentations/<Name>/` dir (add locally, do not commit)

**Run:**
```powershell
.\PresoPublish.ps1
```

**What it does:**
1. Parses `slideshow:` and `theme:` from each presentation's front matter
2. Copies markdown-referenced images to `static/slides/` (`Copy-DeckAssets`)
3. Copies CSS `url()` assets to `static/slides/` (`Copy-ThemeAssets`) for the HTML slideshow
4. Builds HTML to `static/slides/<name>.html` using the original theme CSS (relative `url()` paths work because images sit alongside the HTML)
5. Builds PDF, PPTX, and `feature.png` using a patched CSS (`New-AbsoluteThemeCss`) that rewrites local `url()` to absolute `file:///` paths and strips `@import 'base'` — both are required so Chromium can resolve theme assets from its temp render directory
6. Writes `feature.png` to `content/presentations/<Name>/feature.png`

**Expected warnings** (harmless):
```
[WARN] Insecure local file accessing is enabled for conversion from ...
```
This appears once per export format when `--allow-local-files` is set. Any `The local file is missing` warning means a source image is missing from the content dir.

**marp gotchas:**
- Always pass `--no-stdin` — without it marp hangs waiting for stdin
- Feature image uses `--image png` — marp only supports `png` and `jpeg`, not `webp`
- Built-in themes (`default`, `gaia`, `uncover`) need no `--theme-set`; missing CSS is treated as a built-in and logged with `Write-Verbose` only

#### Static slide outputs

All built files live in `static/slides/` and are committed:
```
static/slides/
├── <name>.html        ← interactive slideshow (served at /slides/<name>.html)
├── <name>.pdf
├── <name>.pptx
└── *.png / *.gif      ← images copied from source for the HTML slideshow
```

The presentation page embeds the HTML file via iframe using the `slideshow:` front matter param.

#### Netlify builds

Netlify runs `hugo --gc --minify` only — it does **not** run `PresoPublish.ps1`. The built slide files in `static/slides/` must be committed before merging so the deploy has them.

#### Table of contents

The presentations layout (`layouts/presentations/single.html`) suppresses the global `showTableOfContents = true` setting. Slide headings are not useful document navigation. To opt a specific presentation in, add `showTableOfContents: true` to its front matter.

## Hugo Configuration

Configuration is split across `config/_default/` files:

- **hugo.toml** - Base URL, taxonomies (`tags`, `series`), sitemap, related content weights, pagination (100 per page)
- **params.toml** - Theme appearance (dark default, congo color scheme, background homepage layout, card views), article display options, search enabled
- **languages.en.toml** - Author name, bio, social links
- **menus.en.toml** - Main and footer navigation
- **markup.toml** - Goldmark renderer, syntax highlighting settings
- **Production overrides** in `config/production/params.toml` (Umami analytics)

### Taxonomies

- `tags` - Standard tag taxonomy
- `series` - Groups related posts (e.g., "Terminals, Shells, and Prompts")

### Custom Layouts

- **`layouts/partials/head.html`** - Asset bundling with fingerprinting, analytics (Firebase, Umami), verification meta tags, social link rel tags
- **`layouts/partials/struct-data.html`** - JSON-LD structured data (WebSite, BreadcrumbList, BlogPosting schemas)
- **`layouts/partials/comments.html`** - Disqus integration
- **`layouts/_default/_markup/render-codeblock.html`** - Code blocks with optional title/caption
- **`layouts/shortcodes/slideshow.html`** - Iframe slideshow embed
- **`layouts/shortcodes/instagram.html`** - Instagram post embed
- **`layouts/robots.txt`** - Custom robots.txt (allows all crawlers, rate-limits aggressive bots)

## Deployment

Netlify handles builds automatically on push.

- **Production build:** `hugo --gc --minify` with Hugo v0.147.1
- **Deploy previews:** Include `--buildFuture --buildDrafts` flags
- **Environment:** `HUGO_ENV=production`, `HUGO_ENABLEGITINFO=true`
- **Publish directory:** `public/`

## Prose Linting (Vale)

Vale is configured in `vale.ini` with styles stored in `.vscode/styles/`. Active style bases: Vale, Microsoft, proselint, Readability.

Key rule overrides for this blog:
- First person (`I`, `we`) is intentionally used -- `Microsoft.FirstPerson` and `Microsoft.We` are disabled
- Passive voice is allowed
- Foreign terms (`e.g.`, `i.e.`) are allowed

Run Vale: `vale content/posts/my-post/index.md`

## SEO Metrics

- **Reports**: Narrative SEO review documents go in `seo-metrics/reports/` (e.g., `seo-metrics/reports/SEO-REVIEW-2026-02.md`).
- **Metrics data**: Raw metrics JSON files go in `seo-metrics/YEAR-MONTH/` (e.g., `seo-metrics/2026-02/gsc.json`). Each month gets its own subfolder.

## CI/CD

- **GitHub Actions** (`.github/workflows/merge-schedule.yml`): Automated PR squash-merge on schedule (daily at 8 AM PT) if all checks pass
- **Dependabot** (`.github/dependabot.yml`): Automated dependency updates

## Git Conventions

- **Default branch:** `main`
- **Theme submodule:** `themes/blowfish` tracks the `main` branch of `github.com/nunocoracao/blowfish.git`. Do not edit theme files directly; override via `layouts/` and `assets/`.
- **`.gitignore`** excludes: `public/`, `node_modules/`, `resources/_gen/`, `.hugo_build.lock`, `bin/`, `.unlighthouse/`

## Key Conventions for AI Assistants

1. **Never edit files inside `themes/blowfish/`** -- override in the project's `layouts/` or `assets/` directories instead.
2. **All images should be WebP format** for consistency and performance.
3. **Blog posts use page bundles** -- each post is a directory with `index.md`, not a standalone `.md` file.
4. **Front matter uses YAML** (delimited by `---`).
5. **Hugo config uses TOML** -- all config files are `.toml`.
6. **Taxonomies are `tags` and `series`** only (no `categories`).
7. **First person writing is standard** -- this is a personal blog.
8. **Dark mode is the default** appearance, with auto-switch enabled.
