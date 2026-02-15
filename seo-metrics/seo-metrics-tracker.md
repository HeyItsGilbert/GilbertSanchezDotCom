# Monthly SEO Metrics Tracker

A lightweight automation for pulling search metrics from Google Search Console, Bing Webmaster Tools, and Umami Cloud into JSON files for analysis with Claude.

---

## Data Sources Summary

| Service | Auth Method | Free Tier Limits | Data Retention |
|---------|-------------|------------------|----------------|
| Google Search Console | OAuth 2.0 (service account) | Unlimited for your sites | 16 months |
| Bing Webmaster Tools | API key | Unlimited for your sites | 6 months |
| Umami Cloud | API key | 50 calls/15 seconds | Varies by plan |

---

## One-Time Setup

### 1. Google Search Console API

**Create Service Account:**

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project (e.g., `seo-metrics`)
3. Enable the **Google Search Console API** under APIs & Services
4. Go to **Credentials** → **Create Credentials** → **Service Account**
5. Name it (e.g., `seo-tracker`), grant no roles, click Done
6. Click the service account → **Keys** → **Add Key** → **Create new key** → **JSON**
7. Save the downloaded JSON file as `gsc-credentials.json`

**Grant Access in Search Console:**

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Select your property → **Settings** → **Users and permissions**
3. Add the service account email (from the JSON file, ends in `@...iam.gserviceaccount.com`)
4. Grant **Full** permission

---

### 2. Bing Webmaster Tools API

1. Go to [Bing Webmaster Tools](https://www.bing.com/webmasters)
2. Verify your site if not already done
3. Click **Settings** (gear icon) → **API Access**
4. Accept terms if prompted
5. Click **Generate** under API Key
6. Copy and save the key

---

### 3. Umami Cloud API

1. Log into [Umami Cloud](https://cloud.umami.is)
2. Click your profile dropdown → **Settings**
3. Navigate to **API Keys** → **Create key**
4. Copy and save the key
5. Note your **Website ID** (visible in URL when viewing your site's dashboard)

---

## Environment Variables

Create a `.env` file (never commit this):

```bash
# Google Search Console
GSC_CREDENTIALS_PATH=./gsc-credentials.json
GSC_SITE_URL=https://gilbertsanchez.com/

# Bing Webmaster Tools
BING_API_KEY=your_bing_api_key_here
BING_SITE_URL=https://gilbertsanchez.com/

# Umami Cloud
UMAMI_API_KEY=your_umami_api_key_here
UMAMI_WEBSITE_ID=your_website_id_here
```

---

## Metrics Collected

### Priority 1: Search Rankings
- **GSC**: Impressions, clicks, CTR, average position by query and page
- **Bing**: Impressions, clicks, average position by query

### Priority 2: Organic Traffic
- **Umami**: Sessions, pageviews, unique visitors, bounce rate

### Priority 3: Average Position/Rankings
- **GSC**: Position trends by top queries
- **Bing**: Position trends by top queries

### Priority 4: Referral Sources
- **Umami**: Top referrers, UTM sources

### Priority 5: Page Performance
- **Umami**: Top pages by views, average time on page

---

## Output Format

Each run generates timestamped JSON files:

```
seo-metrics/
├── 2026-02/
│   ├── google-search-console.json
│   ├── bing-webmaster.json
│   └── umami-analytics.json
```

Each file includes:
- `fetched_at`: ISO timestamp
- `period`: Date range covered
- `metrics`: The actual data

---

## Using with Claude

When reviewing metrics, paste the JSON or upload files and ask:

> "Compare this month's SEO metrics to last month. Identify:
> 1. Queries where position improved but clicks didn't
> 2. Pages with high impressions but low CTR
> 3. Traffic sources worth doubling down on
> 4. Content gaps based on query patterns"

---

## Notes

- **GSC data delay**: 2-3 days behind real-time
- **Bing quirk**: Data returned in weekly buckets (Saturday dates)
- **Umami rate limit**: 50 calls/15 seconds (plenty for monthly runs)
- **Run timing**: Best to run on the 3rd of each month to capture full prior month data
