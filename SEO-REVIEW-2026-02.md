# SEO Performance Review — February 2026

## Executive Summary

This report audits the SEO optimizations implemented across gilbertsanchez.com. The
technical implementation is largely solid, with meta titles, descriptions, keywords,
structured data, and related content all in place. However, several issues were
discovered that are likely undermining performance — including a robots.txt that blocks
*all* AI crawlers (including Anthropic's ClaudeBot, contrary to your stated intent), posts
missing tags that break taxonomy discovery, and an empty slug creating a malformed URL.

**Analytics gap:** The Umami dashboard at cloud.umami.is renders as a client-side
JavaScript app and cannot be scraped for metrics. You will need to manually compare
your current Umami numbers against the baseline below. Google Search Console and Bing
Webmaster Tools data should be exported directly for a full comparison.

---

## 1. Implementation Audit: What Was Done

### Phase 1 & 2 — Content & CTR Optimization

| Change | Status | Verification |
|--------|--------|-------------|
| Related content (up to 6 posts) | **Implemented** | `showRelatedContent = true`, `relatedContentLimit = 6` in params.toml. Weighted by tags (100), categories (100), series (50), authors (20), date (10). Live pages confirmed showing 4-5 related posts. |
| Optimized meta title: WezTerm | **Implemented** | `"WezTerm Config Guide: Complete Setup with Examples (2024)"` — renders correctly in `<title>` and OG tags. |
| Optimized meta title: Starship | **Implemented** | `"Starship Prompt Guide: Transient Prompts & PowerShell Setup"` — renders correctly. |
| Optimized meta title: Obsidian/ADHD | **Implemented** | `"How to Use Obsidian for ADHD: Productivity System with PowerShell"` — renders correctly. |
| Meta descriptions for top posts | **Implemented** | All three top posts have keyword-rich descriptions rendering in `<meta name="description">` and OG tags. |
| Updated lastmod timestamps | **Implemented** | All 28 posts have `lastmod` dates (most set to 2025-11-27). |
| Internal linking between top posts | **Implemented** | Series navigation links parts 1-4 of Terminals series. Hugo `ref` shortcodes used for cross-linking. |

### Phase 3 — Technical SEO

| Change | Status | Verification |
|--------|--------|-------------|
| Keywords on all 28 posts | **27/28 (96.4%)** | 1 post missing (`building-chocolatey-extension-stucco`) — but it's a **draft**, so not published. Published posts: **100% coverage**. |
| Taxonomy pages in sitemap | **Implemented** | `excludedKinds = []` in params.toml. Sitemap has 71 URLs including `/tags/*`, `/series/*` pages. |
| Custom robots.txt | **ISSUE FOUND** | See Section 3 below. |
| Search console verification | **Partial** | Bing verified (`1D144344DA7B72F8ECCED349DCDDA7FD`). Google, Yandex, Pinterest: **not configured** (commented out). |

---

## 2. On-Page SEO Audit — Live Site

All three top-traffic posts were fetched and verified:

### WezTerm Config Guide (`/posts/my-terminal-wezterm/`)
- Title tag: "WezTerm Config Guide: Complete Setup with Examples (2024) · Hey! It's Gilbert!"
- Meta description: Present, keyword-rich (WezTerm, config, Windows, Mac, Linux, PowerShell)
- Keywords: WezTerm, PowerShell
- Canonical: Correct
- JSON-LD BlogPosting: Present with datePublished, dateModified, author, wordCount (918)
- OG tags: Present (type, title, url, image)
- Breadcrumbs: Home > Blog Posts > article
- Series nav: Links to all 4 parts
- Related content: 5 related articles shown
- **Grade: A**

### Obsidian for ADHD (`/posts/obsidian-and-adhd/`)
- Title tag: "How to Use Obsidian for ADHD: Productivity System with PowerShell · Hey! It's Gilbert!"
- Meta description: Present, keyword-rich (obsidian, ADHD, periodic notes, templates, PowerShell)
- Keywords: obsidian, adhd, obsidian for adhd, productivity, note-taking, periodic notes
- Canonical: Correct
- JSON-LD BlogPosting: Present (wordCount: 1356)
- Related content: 5 related articles
- **Grade: A**

### Starship Prompt Guide (`/posts/prompt-starship/`)
- Title tag: "Starship Prompt Guide: Transient Prompts & PowerShell Setup · Hey! It's Gilbert!"
- Meta description: Present, keyword-rich
- Keywords: starship, powershell, transient prompt, starship prompt
- Canonical: Correct
- JSON-LD BlogPosting: Present (wordCount: 672)
- Related content: 4 related articles
- Tags: **EMPTY** (`tags: []`) — see Issue #2 below
- **Grade: B** (missing tags hurts taxonomy discovery)

---

## 3. Issues Found

### Issue #1 (Critical): robots.txt Blocks ALL AI Crawlers Including Anthropic

**Your stated goal:** Allow Anthropic, block OpenAI/Google-Extended.

**What's actually deployed** on the live site:
```
# Blocks ClaudeBot (Anthropic), GPTBot (OpenAI), Google-Extended,
# Amazonbot, Applebot-Extended, Bytespider, CCBot, meta-externalagent
```

**What's in the repo** (`layouts/robots.txt`):
```
User-agent: *
Allow: /

User-agent: Yandex
Crawl-delay: 2

User-agent: AhrefsBot
Crawl-delay: 5

User-agent: SemrushBot
Crawl-delay: 5
```

The repo template has **no AI bot rules at all** — it was apparently simplified at some
point. The live site still serves the older version that blocks ClaudeBot along with all
other AI crawlers, which contradicts your stated intent of allowing Anthropic.

**Impact:** If you want Anthropic's crawler to index your content (for Claude search
results, citations, etc.), the live robots.txt is actively preventing that.

**Fix:** Update `layouts/robots.txt` to explicitly match your intent, then redeploy.

### Issue #2 (Medium): Starship Post Has Empty Tags

`content/posts/my-prompt-starship/index.md` has `tags: []`.

This means:
- The post won't appear on any `/tags/*` taxonomy pages
- No tag links render on the post page for discovery
- Reduces internal linking density for this high-traffic page
- Related content algorithm has less signal to work with

**Fix:** Add relevant tags like `PowerShell`, `Starship`, `Shell`.

### Issue #3 (Low): "New Year, New Me - 2024" Has Empty Tags and Empty Slug

`content/posts/new-year,-new-me---2024/index.md`:
- `tags: []` — no taxonomy linkage
- `slug: ""` — Hugo falls back to the directory name, producing the URL
  `/posts/new-year,-new-me---2024/` which contains commas (unusual, though technically valid)

**Fix:** Set `slug: "new-year-new-me-2024"` and add appropriate tags.

### Issue #4 (Low): Draft Post Has Broken Front Matter

`content/posts/building-a-chocolatey-extension-with-stucco/index.md`:
- `keywords: <failed to process>` — malformed YAML
- `description: ""`, `summary: ""`, `tags: ""`
- `draft: true` so not published, but if you ever publish it, the front matter needs fixing

### Issue #5 (Medium): Google Search Console Not Verified

Only Bing is verified. Google verification is commented out in `config/_default/params.toml`.
Without Google Search Console:
- You can't see Google query data, CTR, impressions, or position tracking
- You can't submit sitemaps to Google directly
- You can't monitor indexing status or crawl errors
- You're missing ~69% of your search traffic data (assuming Bing is 31%)

### Issue #6 (Info): Meta Title Year Is Outdated

The WezTerm post title still says "(2024)". It's now 2026. Stale year markers can
reduce CTR as searchers may skip results that look outdated.

---

## 4. Sitemap Analysis

**Total URLs:** 71

| Category | Count | Notes |
|----------|-------|-------|
| Blog posts | ~26 published | Core content |
| Tag pages | ~29 | Good taxonomy coverage |
| Series pages | 3 | `terminals-shells-and-prompts`, `10x-via-devex`, index |
| Section indexes | 5 | home, posts, projects, presentations, series |
| Other | ~8 | Projects, presentations |

**Configuration:**
- `changefreq: daily` — appropriate for an active blog
- `priority: 0.5` — uniform priority (consider boosting top posts to 0.8+)
- All content types included (`excludedKinds = []`)

**Observation:** Taxonomy and series pages are properly included, which is good for
getting Google to crawl and index tag aggregation pages.

---

## 5. Structured Data Review

**JSON-LD BlogPosting schema** is implemented on all posts with:
- `@type: BlogPosting`
- `headline`, `datePublished`, `dateModified`
- `author` (Person, with name and URL)
- `image` array (feature images)
- `wordCount`, `articleSection`

**Missing structured data opportunities:**
- No `BreadcrumbList` schema (breadcrumbs are visual-only)
- No `FAQPage` schema for posts with Q&A patterns
- No `HowTo` schema for tutorial-style posts (WezTerm, Starship guides)
- No `WebSite` schema with `SearchAction` for sitelinks searchbox
- Home page has `WebSite` schema but no `SearchAction`

---

## 6. Baseline vs Current — Metrics You Need to Check

Since I cannot scrape the Umami dashboard (client-side JS rendering), you should
manually check these comparisons:

| Metric | Baseline | Target | Where to Check |
|--------|----------|--------|----------------|
| Monthly visitors | 931 | 1,200+ | Umami dashboard → Overview |
| Bounce rate | 89% | 75% | Umami dashboard → Overview |
| Pages/session | 1.3 | 1.8 | Umami dashboard → Overview |
| Search CTR (top query) | 1.86% | 3.5% | Google Search Console → Performance |
| Bing CTR | — | — | Bing Webmaster Tools → Search Performance |
| Top 5 traffic concentration | 91% | lower | Umami → Pages report |

### Key Questions to Answer With Your Data:

1. **Did related content reduce bounce rate?** Compare 89% baseline to current.
   If it dropped to ~80-85%, the related content is working but may need better
   placement or more compelling titles.

2. **Did optimized titles improve CTR?** Check Search Console for:
   - "wezterm config" — what's the current CTR vs 1.86% baseline?
   - "starship transient prompt" — did impressions and CTR increase?
   - "obsidian adhd" — is this query appearing at all?

3. **Did pages/session increase?** If it went from 1.3 to 1.5+, the internal linking
   and related content are driving engagement. If still ~1.3, consider more prominent
   in-content CTAs.

4. **Bing performance (31% of traffic):** Check Bing Webmaster Tools for:
   - Indexed page count (should be close to 71 sitemap URLs)
   - Top queries and CTR
   - Any crawl errors

---

## 7. Actionable Recommendations

### Priority 1: Fix robots.txt (Immediate)

Update `layouts/robots.txt` to match your intent:

```
User-agent: *
Allow: /

Sitemap: {{ .Site.BaseURL }}sitemap.xml

# Allow Anthropic
User-agent: ClaudeBot
Allow: /

# Block AI training crawlers
User-agent: GPTBot
Disallow: /

User-agent: Google-Extended
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Bytespider
Disallow: /

# Crawl delays
User-agent: Yandex
Crawl-delay: 2

User-agent: AhrefsBot
Crawl-delay: 5

User-agent: SemrushBot
Crawl-delay: 5
```

### Priority 2: Fix Content Issues (Quick Wins)

1. **Add tags to Starship post:** `tags: [PowerShell, Starship, Shell]`
2. **Fix "New Year" post:** Add `slug: "new-year-new-me-2024"` and relevant tags
3. **Update WezTerm title year:** Change "(2024)" to "(2025)" or remove the year
4. **Set up Google Search Console:** Uncomment and fill in the google verification
   field in `config/_default/params.toml`

### Priority 3: Structured Data Enhancements

1. Add `BreadcrumbList` schema to complement the visual breadcrumbs
2. Add `HowTo` schema to tutorial posts (WezTerm, Starship, PowerShell Profile)
3. Add `SearchAction` to the `WebSite` schema for sitelinks searchbox potential

### Priority 4: Content Strategy (Based on Analytics)

Once you have the current metrics:

- **If bounce rate > 80%:** Add more prominent "Read Next" CTAs within post content
  (not just at the bottom). Consider an inline related post card after the first
  major section of each post.

- **If CTR < 2.5%:** Test richer meta descriptions with specific numbers/promises:
  "Learn 5 WezTerm keybindings that save 30 minutes/week" style hooks.

- **If pages/session < 1.5:** The series navigation is good but only helps the
  terminal series. Consider creating more series (e.g., "PowerShell Deep Dives"
  grouping the AST, PSScriptAnalyzer, Chef, and localization posts).

- **If Bing indexing < 50 pages:** Manually submit sitemap in Bing Webmaster Tools
  and check for any crawl errors.

### Priority 5: Long-Tail Content Opportunities

Posts that likely underperform based on content analysis:

| Post | Issue | Opportunity |
|------|-------|-------------|
| `cidr-calculator-for-alfred` | Very niche (macOS Alfred users only) | Consider broadening to "CIDR Calculator Tools" |
| `locating-empty-citrix-worker-groups` | Legacy tech (Citrix XenApp) | Low priority unless still getting traffic |
| `synchronizing-ad-group-members-to-unix-attributes` | Niche enterprise | Add more context for broader "AD to Linux" audience |
| `force-reinstalling-choco-packages` | Good utility, short | Expand with more Chocolatey troubleshooting scenarios |
| `rac-resume-as-code` | Creative concept | Could rank for "resume as code" niche — ensure keywords target this |

---

## 8. Technical Health Check

| Element | Status | Notes |
|---------|--------|-------|
| HTTPS | OK | Enforced via Netlify |
| Canonical URLs | OK | All posts have correct `<link rel="canonical">` |
| OG tags | OK | type, title, url, image present on all checked pages |
| Twitter Cards | OK | Via Hugo internal template |
| JSON-LD | OK | BlogPosting on all posts |
| Sitemap | OK | 71 URLs, taxonomy included |
| RSS feed | OK | JSON + XML outputs configured |
| Mobile meta | OK | Viewport tag present |
| Favicon | OK | All sizes (16, 32, 180, 192, 512) |
| Image optimization | ON | `disableImageOptimization = false` |
| Hugo version | OK | 0.147.1 (current) |
| Build minification | OK | `hugo --gc --minify` |

---

## 9. Next Steps

1. **You provide current metrics** from Umami, Google Search Console, and Bing
   Webmaster Tools so we can do the actual baseline comparison
2. **I fix the identified issues** (robots.txt, missing tags, slug, year in title)
3. **We prioritize further optimizations** based on which metrics moved and which didn't

---

*Report generated: 2026-02-15*
*Codebase analyzed: gilbertsanchez.com (Hugo + Blowfish theme, deployed on Netlify)*
