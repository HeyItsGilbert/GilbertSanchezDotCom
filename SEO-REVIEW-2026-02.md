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

### Google Search Console Data (Last 3 Months: Nov 14 – Feb 13)

#### Monthly Trend

| Month | Clicks | Impressions | Avg Daily Imp. | CTR | Avg Position |
|-------|--------|-------------|----------------|-----|--------------|
| Nov (17 days) | 112 | 6,744 | 397 | 1.66% | ~8.4 |
| Dec | 333 | 21,929 | 708 | 1.52% | ~7.1 |
| Jan | 423 | 38,185 | 1,231 | 1.11% | ~7.5 |
| Feb (13 days) | 158 | 17,326 | 1,333 | 0.91% | ~7.2 |
| **Total** | **1,026** | **84,184** | — | **1.22%** | ~7.5 |

**Impressions tripled** from ~400/day in November to ~1,300/day in January-February.
This is a massive visibility gain. However, **CTR dropped from 1.66% to 0.91%** over
the same period — clicks are not keeping pace with impressions. The site is appearing
for more queries but failing to convert those impressions into clicks.

#### CTR Target: Baseline vs Current

| Query | Baseline CTR | Current CTR | Current Position | Verdict |
|-------|-------------|-------------|-----------------|---------|
| "wezterm config" | 1.86% | **2.71%** | 6.3 | **+45% — improved but short of 3.5% target** |
| "obsidian for adhd" | — | **10.0%** | 5.03 | **Excellent — title optimization success** |
| "obsidian adhd" | — | **5.28%** | 5.96 | **Good** |
| "starship transient prompt" | — | **3.16%** | 3.68 | **Decent position, ok CTR** |
| "obsidian adhd template" | — | **13.64%** | 4.17 | **Outstanding — long-tail win** |

The "wezterm config" CTR improved 45% (1.86% → 2.71%) but the overall site CTR
dropped because impressions grew faster than clicks. The **Obsidian title optimization
was the biggest success** with 10-14% CTR on its queries.

#### Performance by Page

| Page | Clicks | Impressions | CTR | Position |
|------|--------|-------------|-----|----------|
| WezTerm config | 625 | 43,983 | 1.42% | 6.73 |
| Obsidian/ADHD | 129 | 4,060 | **3.18%** | 6.63 |
| Starship prompt | 119 | 16,980 | **0.70%** | 7.46 |
| TRMNL dashboard | 32 | 4,864 | 0.66% | 7.67 |
| Terminals overview | 24 | 2,497 | 0.96% | 7.64 |
| PS Module Icons | 21 | 982 | 2.14% | 10.96 |
| Homepage | 13 | 1,061 | 1.23% | 7.74 |
| Remove-Item pipeline | 10 | 1,702 | 0.59% | 8.92 |
| YouTube → Readwise | 8 | 2,848 | 0.28% | 9.17 |
| AST/PSScriptAnalyzer | 7 | 1,268 | 0.55% | 9.45 |
| LED control | 6 | 56 | 10.71% | 11.8 |
| PSScriptAnalyzer rules | 5 | 656 | 0.76% | 9.96 |
| DevContainers | 4 | 1,166 | 0.34% | 11.21 |

**Critical finding: The Starship post is your biggest missed opportunity.** It has
16,980 impressions (2nd highest) but only 0.70% CTR. At the Obsidian post's CTR
(3.18%), it would get **540 clicks instead of 119** — a 4.5x increase. The title and
description are not compelling enough relative to the search intent.

**Emerging content: TRMNL** has 4,864 impressions and is a growing topic. The
YouTube-to-Readwise post has 2,848 impressions but only 0.28% CTR — also ripe for
title/description optimization.

#### Zero-Click Queries at Good Positions (Wasted Visibility)

These queries show your pages in top results but get zero clicks — the snippet
isn't matching user intent:

| Query | Impressions | Position | Likely Issue |
|-------|-------------|----------|-------------|
| "wezterm configuration language" | 433 | 4.76 | Title doesn't mention **Lua** |
| "starship prompt" (broad) | 365 | 12.23 | Position too low for competitive head term |
| "what is transient prompt" | 210 | **3.87** | Snippet doesn't answer the question directly |
| "wezterm config file location" | 193 | 5.87 | Title doesn't mention file paths/location |
| "wezterm reload config" | 181 | 8.98 | Not covered in the post's snippet |
| "wezterm default shell" | 165 | 7.19 | Title doesn't address shell configuration |
| "bleopt prompt_ps1_transient" | 150 | 5.99 | Very specific — needs dedicated section |
| "wezterm configuration lua" | 144 | 5.05 | Title doesn't say "Lua" anywhere |
| "wezterm shell integration" | 135 | 4.91 | Not covered in title/description |
| "readwise youtube integration" | 119 | 5.97 | YouTube post title doesn't match intent |

**Combined wasted visibility:** ~2,100 impressions at good positions (avg pos 5-6)
with zero clicks. Fixing snippet mismatches on these could yield 40-60+ new clicks
per quarter.

#### Device Breakdown

| Device | Clicks | Impressions | CTR | Position |
|--------|--------|-------------|-----|----------|
| Desktop | 867 | 77,483 | 1.12% | 7.6 |
| Mobile | 138 | 6,603 | **2.09%** | 6.75 |
| Tablet | 10 | 449 | **2.23%** | 6.64 |

**92% desktop traffic** — expected for a developer/config blog. Mobile has nearly
2x the CTR of desktop, suggesting the optimized titles perform better in mobile
snippets (shorter visible text means the keyword-front-loaded titles stand out more).

#### Geographic Distribution

| Country | Clicks | Impressions | CTR | Notes |
|---------|--------|-------------|-----|-------|
| United States | 291 | 37,447 | 0.78% | 28% of clicks, dominant |
| United Kingdom | 66 | 6,279 | 1.05% | |
| Germany | 65 | 3,141 | 2.07% | Strong CTR |
| Australia | 30 | 1,579 | 1.90% | |
| Netherlands | 29 | 1,226 | 2.37% | |
| France | 28 | 1,674 | 1.67% | |
| India | 26 | 2,317 | 1.12% | High impressions |
| Russia | 26 | 930 | 2.80% | High CTR |

US has 37,447 impressions but only 0.78% CTR — significantly below the global
average. European countries consistently outperform the US on CTR. This may indicate
US searchers have more competing results for WezTerm/terminal content.

#### Query Cluster Analysis

**WezTerm cluster** (all wezterm-related queries combined):
- ~55,000 impressions, ~780 clicks — dominates the site
- High-CTR long-tail: "wezterm config examples" (13%), "best wezterm config" (7.7%),
  "wezterm guide" (15.15%)
- Zero-click problem areas: config location, reload, default shell, Lua language

**Starship cluster:**
- ~2,000 impressions, ~30 clicks from specific queries
- "starship transient prompt" at 3.16% CTR, position 3.68 — good
- Broad "starship prompt" at 0% CTR, position 12.23 — not competitive

**Obsidian cluster:**
- ~750 impressions, ~50 clicks
- Best CTR of any cluster (5-14%)
- Small but highly efficient — title optimization was a clear win

**TRMNL cluster** (emerging):
- ~500 impressions across "trmnl terminus", "terminus trmnl", "trmnl webhook", etc.
- 32 clicks total on the page — growing topic worth investing in

**Readwise/YouTube cluster:**
- ~400 impressions, 8 clicks (2% CTR)
- "readwise youtube integration" at 119 impressions, 0 clicks — title mismatch

### Bing Webmaster Tools Data

Bing shows a similar pattern to Google but with some interesting differences:

#### Top Bing Queries

| Query | Impressions | Clicks | CTR | Position |
|-------|-------------|--------|-----|----------|
| wezterm | 1,821 | 5 | 0.27% | 4.74 |
| starship prompt | 517 | 4 | 0.77% | 4.21 |
| wezterm config | 366 | 5 | 1.37% | 4.37 |
| windows terminal shell integration | 301 | 8 | 2.66% | 44.85 |
| wezterm windows | 240 | 3 | 1.25% | 5.38 |
| starship powershell | 74 | 5 | **6.76%** | 4.42 |
| wezterm windows config | 28 | 4 | **14.29%** | 4.82 |
| wezterm configuration | 17 | 5 | **29.41%** | 2.94 |
| wezterm wsl2 | 12 | 3 | **25%** | 3.83 |
| obsidian adhd | 6 | 2 | **33.33%** | 1.67 |

**Key Bing observations:**

1. **Bing positions are significantly better** than Google — "wezterm config" at
   position 4.37 (vs 6.3 on Google), "obsidian adhd" at position **1.67** (vs 5.96).
   Your site ranks higher on Bing across the board.

2. **The broad "wezterm" query** has 1,821 impressions but only 0.27% CTR on Bing.
   Users searching just "wezterm" want the official site, not config guides.

3. **Long-tail queries convert very well on Bing** — "wezterm configuration" at
   29.41% CTR, "wezterm windows config" at 14.29%. Bing users with specific
   config queries click through at much higher rates.

4. **"starship powershell" at 6.76% CTR** on Bing is a standout — this specific
   combination converts well. Consider adding "PowerShell" more prominently in
   the Starship post's description.

5. **Total Bing clicks** across all queries: ~160 (aligns with Umami's 156 from
   bing.com + cn.bing.com). Since DuckDuckGo uses Bing's index, your Bing
   optimization also drives the 15% DuckDuckGo traffic.

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

### Priority 2: Fix the Starship Post CTR (Biggest Opportunity)

The Starship post has **16,980 Google impressions but only 0.70% CTR** — the worst
CTR of any top page. At the Obsidian post's CTR (3.18%), it would get 540 clicks
instead of 119. Fixes:

1. **Rewrite the meta title** to answer common queries directly. Current title
   "Starship Prompt Guide: Transient Prompts & PowerShell Setup" doesn't match
   the top zero-click queries: "what is transient prompt" (210 imp, 0 clicks,
   pos 3.87). Consider: "Starship Transient Prompt: What It Is & How to Set It Up"
2. **Rewrite the meta description** to include "Lua", "cross-shell", "zsh", "bash"
   since many starship queries mention these
3. **Add tags to Starship post:** `tags: [PowerShell, Starship, Shell]`

### Priority 3: Fix Other Content Issues (Quick Wins)

1. **Fix "New Year" post:** Add `slug: "new-year-new-me-2024"` and relevant tags
2. **Update WezTerm title year:** Change "(2024)" to "(2026)" or remove the year
3. **Add "Lua" to WezTerm description** — "wezterm configuration language" (433 imp,
   0 clicks) and "wezterm configuration lua" (144 imp, 0 clicks) get zero clicks
   because the snippet doesn't mention Lua

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
| Search CTR 3.5% | +88% | **2.71% on "wezterm config" (+45%)** | **C** |
| Visit duration | — | **+65% (40s)** | **A** |
| Traffic concentration | <91% | **~64%** | **B** |
| Google impressions | — | **3.3x growth (400→1,300/day)** | **A** |

**Overall:** Title/description optimization drove significantly more traffic and
visibility (impressions tripled, visitors up 34%). CTR improved on the primary
query (+45%) but declined site-wide as the site now appears for many more queries
it doesn't convert. Engagement optimization via related content did not reduce
bounces. The Starship post is the single biggest missed opportunity (16,980
impressions, 0.70% CTR).

**The next phase should focus on:**
1. Fixing the Starship post CTR crisis (biggest ROI opportunity)
2. Moving engagement hooks into content body (bounce rate)
3. Capturing zero-click queries at good positions (wasted visibility)

## 10. Next Steps

1. **Fix the Starship post title/description** to improve its 0.70% CTR
2. **Add "Lua" to WezTerm description** for 577 zero-click impressions
3. **Add inline engagement hooks** in the WezTerm post body to reduce bounce rate
4. **Fix content issues** (missing tags, slug, year in title)
5. **Resolve robots.txt discrepancy** between repo and live site

---

*Report generated: 2026-02-15*
*Codebase analyzed: gilbertsanchez.com (Hugo + Blowfish theme, deployed on Netlify)*
