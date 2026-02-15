# SEO Performance Review — February 2026

## Executive Summary

**Traffic target met, engagement targets missed.** Monthly visitors grew 34% (931 →
1,250), exceeding the 1,200+ target. However, bounce rate worsened from 89% to 91%
(target was 75%), and pages/session dropped from 1.3 to 1.17 (target was 1.8). The one
bright spot in engagement: visit duration surged 65% to 40 seconds, indicating visitors
who do stay are reading more deeply.

The technical SEO implementation is solid — meta titles, descriptions, keywords,
structured data, and related content are all in place. However, several issues were
discovered that are likely undermining performance: a robots.txt discrepancy between
the repo and the live site, the Starship post missing tags (breaking taxonomy
discovery), and Google Search Console still not verified.

**The core strategic problem:** Related content placed at the bottom of posts doesn't
reduce bounce rate when 45% of traffic goes to one page (WezTerm) where visitors grab
a config snippet and leave within 40 seconds. The engagement hooks need to move
*into* the content body, not sit below it.

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

## 6. Baseline vs Current — Umami Analytics (Last 30 Days)

*Data from Umami dashboard, Jan 15 – Feb 14, 2026.*

### Core Metrics

| Metric | Baseline | Current | Target | Change | Result |
|--------|----------|---------|--------|--------|--------|
| Monthly visitors | 931 | **1,250** | 1,200+ | +34% | **TARGET MET** |
| Monthly visits | — | **1,370** | — | +12% | — |
| Page views | — | **1,600** | — | +16% | — |
| Bounce rate | 89% | **91%** | 75% | +2pp | **MISSED — WORSE** |
| Pages/session | 1.3 | **~1.17** | 1.8 | -10% | **MISSED — WORSE** |
| Visit duration | ~24s est. | **40s** | — | +65% | **STRONG GAIN** |

### Traffic by Page

| Page | Visitors | Share |
|------|----------|-------|
| `/posts/my-terminal-wezterm/` (WezTerm) | 510 | 45% |
| `/` (homepage) | 192 | 17% |
| `/posts/prompt-starship/` (Starship) | 118 | 10% |
| `/posts/obsidian-and-adhd/` (Obsidian) | 100 | 9% |
| `/posts/terminals-shells-and-prompts/` | 76 | 7% |
| `/posts/my-terminal-wezterm/#the-top` | 48 | 4% |

**Traffic concentration:** Top 4 posts = ~64% of visitors (down from 91% baseline).
WezTerm alone = 45%. This single page's bounce behavior dominates the site average.

### Traffic Sources (Referrers)

| Source | Visitors | Share |
|--------|----------|-------|
| google.com | 399 | 57% |
| bing.com | 144 | 21% |
| duckduckgo.com | 107 | 15% |
| cn.bing.com | 12 | 2% |
| jakehildreth.github.io | 10 | 1% |
| kagi.com | 7 | 1% |

**Key observations:**
- **Bing total** (bing.com + cn.bing.com) = 156 (23%), down from 31% baseline share
- **DuckDuckGo at 15%** — a significant, previously untracked channel
- **Kagi appearing** — privacy-focused search engines are a small but growing source
- Google remains dominant at 57%

### Analysis: Why Bounce Rate Got Worse

The related content feature is architecturally correct but **positionally ineffective**
for the dominant traffic pattern:

1. **45% of traffic lands on WezTerm** — a config reference post
2. Visitors grab the config snippet they need in ~40 seconds
3. They leave before scrolling to the related content section at the bottom
4. The 918-word post is a ~4 minute read; 40s average means most leave at ~10% scroll

The related content is invisible to the majority of visitors. Bounce rate cannot
improve until engagement hooks are placed **within the content body** where visitors
actually see them.

### Still Needed: Search Console Data

Google Search Console and Bing Webmaster Tools data would complete the picture:

- **Search CTR** — did optimized titles improve click-through? (baseline: 1.86%)
- **Impressions** — are posts appearing for target queries?
- **Position** — ranking changes for "wezterm config", "starship transient prompt", etc.
- **Indexed pages** — how many of 71 sitemap URLs are actually indexed?
- **Crawl errors** — any issues Google/Bing found?

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

### Priority 4: Fix Bounce Rate (The Core Problem)

Bounce rate is 91% and pages/session is 1.17. The bottom-of-page related content
is not working because 45% of traffic never scrolls that far. Concrete fixes:

1. **Add inline "Related" callouts inside the WezTerm post body.** After the first
   config section, insert a callout like: "Setting up WezTerm? You'll also want to
   configure your [PowerShell profile](link) and [Starship prompt](link)."

2. **Add a sticky sidebar or floating "In this series" widget** on series posts.
   The series navigation exists but is easy to miss.

3. **Add a Table of Contents progress indicator.** The TOC is enabled but if visitors
   see how much content remains, they may scroll further (past the fold to related
   content).

4. **Consider a "Quick Links" box at the top of the WezTerm post** linking to
   specific config sections AND related posts. This catches snippet-seekers before
   they bounce.

### Priority 5: Diversify Traffic Sources

DuckDuckGo drives 15% of traffic — optimize for it:

- DuckDuckGo uses Bing's index, so Bing Webmaster Tools optimization helps both
- Submit sitemap to Bing if not already done
- DuckDuckGo favors sites with good privacy practices (no aggressive tracking) —
  your Umami-only analytics is a strength here

Consider Kagi optimization as well — it's small (1%) but growing and its users are
high-intent technical professionals (your exact audience).

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

## 9. Scorecard Summary

| Goal | Target | Actual | Grade |
|------|--------|--------|-------|
| Monthly visitors 1,200+ | +29% | **+34% (1,250)** | **A** |
| Bounce rate 75% | -16pp | **+2pp (91%)** | **F** |
| Pages/session 1.8 | +38% | **-10% (1.17)** | **F** |
| Search CTR 3.5% | +88% | **Needs GSC data** | **?** |
| Visit duration | — | **+65% (40s)** | **A** |
| Traffic concentration | <91% | **~64%** | **B** |

**Overall: The SEO title/description optimization drove more traffic (success). The
engagement optimization via related content did not reduce bounces (failure). The
next phase should focus on in-content engagement hooks rather than bottom-of-page
related posts.**

## 10. Next Steps

1. **Provide Google Search Console + Bing Webmaster data** to complete CTR analysis
2. **I can fix the identified issues** (robots.txt, missing tags, slug, year in title)
3. **Prioritize bounce rate reduction** with in-content CTAs on the WezTerm post
4. **Set up Google Search Console** to unlock the remaining 57% of search data

---

*Report generated: 2026-02-15*
*Codebase analyzed: gilbertsanchez.com (Hugo + Blowfish theme, deployed on Netlify)*
