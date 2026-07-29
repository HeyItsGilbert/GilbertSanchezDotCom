# GitHub Secrets Setup

Navigate to your repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets:

| Secret Name | Value | Notes |
|-------------|-------|-------|
| `GSC_CREDENTIALS_JSON` | Contents of `gsc-credentials.json` | Full JSON, not the path |
| `GSC_SITE_URL` | `https://gilbertsanchez.com/` | Include trailing slash |
| `BING_API_KEY` | Your Bing API key | From Bing Webmaster settings |
| `BING_SITE_URL` | `https://gilbertsanchez.com/` | Must match verified site |
| `UMAMI_API_KEY` | Your Umami API key | From Umami Cloud settings |
| `UMAMI_WEBSITE_ID` | Your website ID | UUID from dashboard URL |
| `SEO_DISCORD_WEBHOOK` | Discord incoming webhook URL | Used by the `SEOReport` workflow to notify when a new monthly report is committed. Optional — if unset, the report still commits, notification is skipped. |

## Testing Locally

```bash
# Load environment variables
cp .env.example .env
# Edit .env with your values

# Install dependencies
pip install -r requirements.txt

# Run
python fetch_seo_metrics.py
```

## Running Tests

```bash
pip install -r requirements-dev.txt
pytest test_fetch_seo_metrics.py
```

## Manual Workflow Run

Go to your repo → **Actions** → **Monthly SEO Metrics** → **Run workflow**
