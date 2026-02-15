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
| Package Manager    | Yarn 1.22.22                                 |
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
│   ├── presentations/   # Presentation content (Stucco)
│   └── series/          # Series taxonomy landing page
├── layouts/
│   ├── _default/_markup/  # Custom code block renderer
│   ├── partials/          # head.html, struct-data.html (JSON-LD), comments.html
│   ├── presentations/     # Custom single.html for presentation pages
│   ├── shortcodes/        # instagram.html, slideshow.html
│   └── robots.txt         # Custom robots.txt template
├── seo-metrics/         # SEO tracking data (see below)
├── static/              # Favicons, slide files (HTML/PDF/PPTX)
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
yarn serve           # Runs: hugo server -D (includes drafts)
```

### Build

```bash
hugo --gc --minify   # Production build (used by Netlify)
```

### Install Dependencies

```bash
yarn install         # Installs Node deps + Hugo via postinstall hook
```

### Creating Content

**New post:** Each post lives in its own directory under `content/posts/<slug>/index.md`. The archetype (`archetypes/default.md`) generates front matter with title, date, and `draft: true`.

```bash
hugo new posts/my-new-post/index.md
```

**Content front matter** typically includes: `title`, `date`, `draft`, `tags`, `series`, `description`, `summary`, and a hero/feature image reference.

**Image format:** Use WebP for all images. Place post-specific images alongside `index.md` in the post directory. Shared images go in `assets/images/YYYY/MM/`.

### Presentations

Presentations use Marp. Publish scripts: `PresoPublish.ps1`. Custom layout at `layouts/presentations/single.html`.

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
