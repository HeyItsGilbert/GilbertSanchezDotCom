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
# The agent job itself stays read-only; the publish-report safe-output job
# below gets its own scoped contents: write permission to commit the report.
permissions:
  contents: read

engine: copilot

# Outputs - what APIs and tools can the AI use?
# There is no built-in safe-output for "commit a file to main", so the report
# lands via a custom safe-output job: the agent hands over the finished report
# body, the job writes it to seo-metrics/reports/ and commits it directly to
# the default branch, then pings Discord so a new report doesn't go unnoticed.
safe-outputs:
  jobs:
    publish-report:
      description: "Commit the monthly SEO review report to seo-metrics/reports/ and notify Discord"
      runs-on: ubuntu-latest
      permissions:
        contents: write
      output: "SEO report published to seo-metrics/reports/ and Discord notified."
      inputs:
        filename:
          description: "Report filename, e.g. SEO-REVIEW-2026-07.md"
          required: true
          type: string
        content:
          description: "Full markdown content of the report, matching the body structure in the workflow instructions"
          required: true
          type: string
        summary:
          description: "One-sentence executive summary for the Discord notification (no newlines)"
          required: true
          type: string
      steps:
        - name: Checkout repository
          uses: actions/checkout@v4
          with:
            ref: ${{ github.event.repository.default_branch }}

        - name: Write report file
          id: write_report
          uses: actions/github-script@v8
          with:
            script: |
              const fs = require('fs');
              const path = require('path');
              const outputFile = process.env.GH_AW_AGENT_OUTPUT;
              if (!outputFile) {
                core.setFailed('No GH_AW_AGENT_OUTPUT environment variable found');
                return;
              }
              const agentOutput = JSON.parse(fs.readFileSync(outputFile, 'utf8'));
              const item = agentOutput.items.find(i => i.type === 'publish_report');
              if (!item) {
                core.setFailed('No publish_report item found in agent output');
                return;
              }
              const dir = 'seo-metrics/reports';
              fs.mkdirSync(dir, { recursive: true });
              const filePath = path.join(dir, item.filename);
              fs.writeFileSync(filePath, item.content, 'utf8');
              core.setOutput('file_path', filePath);
              core.setOutput('summary', item.summary);

        - name: Commit and push report
          env:
            FILE_PATH: ${{ steps.write_report.outputs.file_path }}
          run: |
            git config user.name "github-actions[bot]"
            git config user.email "github-actions[bot]@users.noreply.github.com"
            git add "$FILE_PATH"
            if git diff --cached --quiet; then
              echo "No changes to commit"
            else
              git commit -m "seo-metrics: add $FILE_PATH"
              git push
            fi

        - name: Notify Discord
          env:
            DISCORD_WEBHOOK: ${{ secrets.SEO_DISCORD_WEBHOOK }}
            FILE_PATH: ${{ steps.write_report.outputs.file_path }}
            SUMMARY: ${{ steps.write_report.outputs.summary }}
            REPO: ${{ github.repository }}
            DEFAULT_BRANCH: ${{ github.event.repository.default_branch }}
          run: |
            if [ -z "$DISCORD_WEBHOOK" ]; then
              echo "SEO_DISCORD_WEBHOOK secret not configured, skipping notification"
              exit 0
            fi
            FILE_URL="https://github.com/${REPO}/blob/${DEFAULT_BRANCH}/${FILE_PATH}"
            PAYLOAD=$(jq -n --arg content "📊 **Monthly SEO report published**
            ${SUMMARY}
            ${FILE_URL}" '{content: $content}')
            curl -sf -X POST "$DISCORD_WEBHOOK" -H 'Content-Type: application/json' -d "$PAYLOAD"

---

# Monthly SEO Review & Recommendations

Analyze the monthly SEO metrics collected by the "Monthly SEO Metrics" workflow and publish a comprehensive report with actionable recommendations for improving search visibility and site performance.

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

### 4. Publish the Report

Build the report body with this structure:

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

Then call the `publish-report` tool with:
- `filename`: `SEO-REVIEW-[YYYY-MM].md`, matching the month of data just analyzed (e.g. `SEO-REVIEW-2026-07.md`)
- `content`: the full report body above, with all placeholders filled in
- `summary`: one plain-text sentence capturing the headline finding, for the Discord ping (no markdown, no newlines)

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
- Use the `missing-data` tool to report exactly what's missing (e.g. which month/source)
- Still publish a report with whatever analysis is possible from the available data, noting the gap in the Executive Summary and Areas of Concern

## Notes

- Run `gh aw compile` to generate the GitHub Actions workflow
- See https://github.github.com/gh-aw/ for complete configuration options and tools documentation
- The `publish-report` job requires a `SEO_DISCORD_WEBHOOK` repository secret pointing at a Discord incoming webhook URL; if it's unset, the report still commits but the Discord notification step is skipped
