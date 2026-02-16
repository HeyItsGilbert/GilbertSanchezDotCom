---
# Trigger - when should this workflow run?
on:
  workflow_run:
    workflows: ["Monthly SEO Metrics"]
    types: [completed]
    branches:
      - "main"
  workflow_dispatch:  # Manual trigger for testing

# Permissions - what can this workflow access?
permissions:
  contents: read
  #issues: write

# Outputs - what APIs and tools can the AI use?
safe-outputs:
  create-issue:
    max: 1

---

# Monthly SEO Review & Recommendations

Analyze the monthly SEO metrics collected by the "Monthly SEO Metrics" workflow and create a comprehensive issue with actionable recommendations for improving search visibility and site performance.

## Instructions

### 1. Load and Parse SEO Data

Locate the most recent month's SEO data in the `seo-metrics/` directory:
- Find the latest monthly folder (format: `YYYY-MM/`)
- Read these JSON files:
  - `google-search-console.json` - Search performance data from Google
  - `bing-webmaster.json` - Search performance data from Bing
  - `umami-analytics.json` - Site analytics and engagement metrics

Also load the previous month's data for trend comparison.

### 2. Perform Comprehensive Analysis

Analyze the following dimensions and identify trends:

**Search Performance:**
- Total clicks, impressions, average CTR, average position across both search engines
- Month-over-month changes in key metrics (calculate % change)
- Top performing queries (high CTR, good positions) 
- Underperforming queries (high impressions but low clicks, poor CTR, declining positions)
- New queries that appeared this month vs last month

**Content Performance:**
- Top performing pages by traffic and engagement
- Pages with declining traffic compared to last month
- Pages with high bounce rates or low engagement time
- Content gaps: queries ranking 11-20 that could be improved to reach page 1

**Technical SEO Signals:**
- Average position trends (improving or declining)
- CTR by position (compare to industry benchmarks: position 1 ≈ 30%, position 2 ≈ 15%, position 3 ≈ 10%)
- Visitor engagement: bounce rate, average session time, pages per visit

**Competitive Insights:**
- Identify queries where the site ranks in positions 4-10 (opportunity to reach top 3)
- Look for queries with >1000 impressions but <2% CTR (potential for optimization)

### 3. Generate Prioritized Recommendations

Create specific, actionable recommendations in these categories:

**Quick Wins (High Impact, Low Effort):**
- Pages ranking 4-10 that could reach top 3 with optimization
- High-impression, low-CTR queries needing better titles/descriptions
- Existing popular content that could target additional related keywords

**Content Opportunities:**
- New content to create based on queries with high impressions but poor rankings
- Existing content to expand or update based on declining performance
- Internal linking opportunities between related high-performing pages

**Technical Improvements:**
- Pages with concerning engagement metrics (high bounce, low time)
- Mobile usability issues if indicated by device-specific performance drops
- Site speed concerns if reflected in engagement metrics

**Strategic Priorities:**
- Long-term keyword opportunities based on consistent query volume
- Content clusters to develop around successful topics
- Seasonal trends to prepare for based on historical patterns

### 4. Create the Issue

Generate a well-structured GitHub issue with:

**Title:** `📊 SEO Review: [Month YYYY] - [Key Trend/Finding]`

**Body structure:**

```markdown
# Monthly SEO Review: [Month YYYY]

## 📈 Executive Summary

[2-3 sentences highlighting the most important findings, major trends, and overall performance]

## Key Metrics

| Metric | This Month | Last Month | Change |
|--------|------------|------------|--------|
| Total Clicks (Google) | X | Y | +/-Z% |
| Total Impressions (Google) | X | Y | +/-Z% |
| Avg CTR (Google) | X% | Y% | +/-Z% |
| Avg Position (Google) | X | Y | +/-Z |
| Pageviews (Umami) | X | Y | +/-Z% |
| Unique Visitors | X | Y | +/-Z% |
| Avg Session Time | Xs | Ys | +/-Zs |

## 🎯 Top Performing Content

[List 3-5 pages with best performance and why they're succeeding]

## ⚠️ Areas of Concern

[List 2-4 specific issues that need attention]

## 💡 Recommendations

### Quick Wins (This Week)
1. **[Specific action]** - [Why and expected impact]
2. **[Specific action]** - [Why and expected impact]
3. **[Specific action]** - [Why and expected impact]

### Content Improvements (This Month)
1. **[Specific action]** - [Why and expected impact]
2. **[Specific action]** - [Why and expected impact]

### Strategic Priorities (This Quarter)
1. **[Specific action]** - [Why and expected impact]
2. **[Specific action]** - [Why and expected impact]

## 📊 Notable Query Trends

**Rising Queries:**
- [Query] - X clicks, Y impressions, position Z

**Declining Queries:**
- [Query] - X clicks, Y impressions, position Z

**Opportunity Queries (High Impressions, Low CTR):**
- [Query] - X impressions, Y% CTR, position Z

## 🔍 Next Month Focus

[2-3 specific goals or areas to monitor for next month]

---

*Generated from data in `seo-metrics/[YYYY-MM]/`*
```

**Labels:** Add labels `seo`, `analytics`, `monthly-review`

### 5. Quality Standards

- All percentages should be rounded to 1 decimal place
- All recommendations must be specific (include page URLs, query text, specific numbers)
- Prioritize recommendations by expected impact vs effort
- Include specific position and CTR numbers in findings
- Compare actual CTRs to expected CTRs by position to identify meta description issues
- Identify at least 3 quick wins and 3 strategic priorities
- Ensure the tone is constructive and actionable, not just reporting numbers

### 6. Error Handling

If data files are missing or incomplete:
- Create an issue noting the data problem and what's available
- Provide whatever analysis is possible with available data
- Tag the issue with `data-issue` label

## Notes

- Run `gh aw compile` to generate the GitHub Actions workflow
- See https://github.github.com/gh-aw/ for complete configuration options and tools documentation
