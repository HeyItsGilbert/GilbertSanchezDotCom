# Monthly SEO Review: July 2026

## 📈 Executive Summary

July held clicks roughly flat versus June (195 vs 193 on Google, +1.0%) while impressions dropped 29% and average position slipped from 8.3 to 9.7 — a classic sign of reduced search visibility on a narrower set of queries, partially offset by a 42% CTR improvement that suggests the traffic that did arrive was better-targeted. Bing told a more positive story, with clicks up 20.5% and impressions up 20.2% month-over-month. The WezTerm config content family continues to dominate both engines' traffic. Note: this month's Google Search Console pull covers only 27 of July's 31 days (fetched July 29, ahead of GSC's ~2–3 day reporting lag), so the July figures likely understate the full month slightly — treat the impression drop as a lower bound.

## Key Metrics

| Metric | This Month | Last Month | Change |
|--------|------------|------------|--------|
| Total Clicks (Google) | 195 | 193 | +1.0% |
| Total Impressions (Google) | 20,581 | 29,004 | -29.0% |
| Avg CTR (Google) | 0.9% | 0.7% | +42.4% |
| Avg Position (Google) | 9.7 | 8.3 | +1.4 (worse) |
| Total Clicks (Bing) | 53 | 44 | +20.5% |
| Total Impressions (Bing) | 2,931 | 2,439 | +20.2% |
| Pageviews (Umami) | No data | No data | — |
| Unique Visitors | No data | No data | — |

*Umami data unavailable for both July and June — outside the source's current retention window at fetch time.*

## 🎯 Top Performing Content

1. **[My Terminal: WezTerm](https://gilbertsanchez.com/posts/my-terminal-wezterm/)** — 109 clicks, 8,452 impressions, 1.3% CTR, position 8.4. The site's clear traffic anchor; over half of all Google clicks this month.
2. **[Obsidian and ADHD](https://gilbertsanchez.com/posts/obsidian-and-adhd/)** — 28 clicks, 1,499 impressions, 1.9% CTR, position 8.4. Best CTR among the top pages, though down 35% in clicks from June (see Areas of Concern).
3. **[Prompt Starship](https://gilbertsanchez.com/posts/prompt-starship/)** — 17 clicks, 2,067 impressions, position 8.4.
4. **[Terminal to TRMNL with PowerShell](https://gilbertsanchez.com/posts/terminal-to-trmnl-with-powershell/)** — 5 clicks, 1,239 impressions — high impressions relative to clicks, a CTR opportunity (see Quick Wins).
5. **[Terminals, Shells, and Prompts](https://gilbertsanchez.com/posts/terminals-shells-and-prompts/)** — 8 clicks, 1,033 impressions, position 8.9.

## ⚠️ Areas of Concern

1. **Impressions down 29% month-over-month** on Google — the biggest single swing this month. Partially explained by the 4-day-short data pull, but a 29% drop from a 4-day gap alone would be unusual (~13% expected from day-count alone), so some of this is a real visibility contraction worth watching next month with a full 31-day pull.
2. **Average position worsened from 8.3 to 9.7** — consistent with the impression drop; the site is showing up for fewer/lower-ranked queries than in June.
3. **Obsidian and ADHD clicks down 35%** (43 → 28) — the second-largest content page lost over a third of its clicks month-over-month with impressions still healthy (1,499), suggesting a ranking or SERP-feature change rather than falling demand.
4. **Homepage clicks down 40%** (5 → 3) — small absolute numbers, but the homepage should generally hold steady; worth a quick check that it's still being crawled/indexed normally.

## 💡 Recommendations

### Quick Wins (This Week)
1. **Improve meta description / title CTR on "wezterm config"** (412 impressions, 1.0% CTR, position 8.1) — expected CTR at position 8 is roughly 3–4%; this query is underperforming its ranking. A more compelling title/description on the WezTerm config page could meaningfully lift clicks without any ranking change needed.
2. **Same treatment for "transient prompt"** (177 impressions, 1.1% CTR, position 7.0) and **"gilbert sanchez"** (112 impressions, 1.8% CTR, position 9.2) — both branded/near-branded queries underperforming expected CTR for their position.
3. **Investigate the Terminal-to-TRMNL page's CTR** (1,239 impressions, 0.4% CTR) — the lowest CTR-to-impressions ratio of any top page; likely a title/description mismatch with what searchers expect.

### Content Improvements (This Month)
1. **Refresh or re-promote "Obsidian and ADHD"** — the 35% click decline with impressions still strong (1,499) points to a ranking slip rather than falling search demand; check current SERP position for its core queries and consider an update if competitors have since published fresher content.
2. **Build out the "devcontainers news" / "devcontainer news" gap** — both sit at position 14–17 with zero clicks; if this is an intentional content angle, a focused page could realistically reach page 1 given the topic already has crawl signal.
3. **Expand WezTerm PowerShell coverage** — "wezterm powershell" (73 impressions, position 6.3) and "wezterm windows config" (36 impressions, position 7.0) suggest unmet demand for Windows/PowerShell-specific WezTerm content beyond what's currently ranking.

### Strategic Priorities (This Quarter)
1. **Consolidate the WezTerm config keyword cluster** — "wezterm config," "wezterm configuration," "wezterm config examples," "best wezterm config," and "wezterm windows config" are all ranking positions 4.5–8.2 for the same underlying page; internal linking and a possible pillar-page restructure could push several of these into the top 5 simultaneously.
2. **Diagnose the Umami data gap** — Umami analytics has returned empty results for at least two consecutive months now (June and July). Since the pipeline's collection-success check (added this cycle) only validates that a file exists and is non-empty, an empty-but-technically-present Umami payload could keep passing verification silently. Worth checking Umami's API retention window/credentials directly, since engagement metrics (bounce rate, session time) are currently a blind spot in every report.
3. **Watch the impression trend into August** — with a full 31-day pull next month, confirm whether the July dip was a data-completeness artifact or a genuine visibility drop before treating it as a trend.

## 📊 Notable Query Trends

**Rising Queries (Bing, month-over-month clicks):**
- Bing overall: +20.5% clicks, +20.2% impressions — broad-based improvement, no single query dominates (max 2 clicks per query in the long tail).

**Declining Queries/Pages:**
- Obsidian and ADHD: 43 → 28 clicks (-35%)
- Homepage: 5 → 3 clicks (-40%)
- Regex/Advanced PowerShell AST Analysis, No Habla Inglés PowerShell Localization: 2 → 1 click each (-50%, small base)

**Opportunity Queries (Position 4-10, High Impressions, Low CTR):**
- wezterm config — 412 impressions, 1.0% CTR, position 8.1
- transient prompt — 177 impressions, 1.1% CTR, position 7.0
- gilbert sanchez — 112 impressions, 1.8% CTR, position 9.2
- obsidian adhd — 99 impressions, 2.0% CTR, position 5.9
- wezterm configuration — 64 impressions, 1.6% CTR, position 8.2

## 🔍 Next Month Focus

1. Confirm whether August's impression/position trend continues the July dip or reverts to June's baseline, now with a complete 31-day data pull.
2. Ship title/description updates for the top 3 CTR-opportunity queries (wezterm config, transient prompt, gilbert sanchez) and check for CTR lift in the August report.
3. Investigate the Umami empty-data gap directly with the source (credentials/retention window) so engagement metrics return to the report.

---

*Generated from data in `seo-metrics/2026-07/`. This report was produced manually (Claude, via the omp harness) in place of the automated gh-aw/Copilot pipeline, because `COPILOT_GITHUB_TOKEN` is currently returning HTTP 401 (token exhausted/expired) — see the "Monthly SEO Review & Recommendations" workflow run history. The analysis and template structure follow `.github/workflows/SEOReport.md`'s instructions exactly; only the execution engine differs for this one issue.*
