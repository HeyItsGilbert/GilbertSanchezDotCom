#!/usr/bin/env python3
"""
Monthly SEO Metrics Fetcher
Pulls data from Google Search Console, Bing Webmaster Tools, and Umami Cloud.
Outputs JSON files for analysis with Claude.
"""

import os
import json
import requests
from datetime import datetime, timedelta
from pathlib import Path
from google.oauth2 import service_account
from googleapiclient.discovery import build

# -----------------------------------------------------------------------------
# Configuration (loaded from environment variables)
# -----------------------------------------------------------------------------

GSC_CREDENTIALS_PATH = os.getenv("GSC_CREDENTIALS_PATH", "./gsc-credentials.json")
GSC_SITE_URL = os.getenv("GSC_SITE_URL")

BING_API_KEY = os.getenv("BING_API_KEY")
BING_SITE_URL = os.getenv("BING_SITE_URL")

UMAMI_API_KEY = os.getenv("UMAMI_API_KEY")
UMAMI_WEBSITE_ID = os.getenv("UMAMI_WEBSITE_ID")
UMAMI_API_BASE = "https://api.umami.is/v1"

OUTPUT_DIR = os.getenv("OUTPUT_DIR", "./seo-metrics")

# -----------------------------------------------------------------------------
# Date helpers
# -----------------------------------------------------------------------------

def get_last_month_range():
    """Returns (start_date, end_date) for the previous full month."""
    today = datetime.now()
    first_of_this_month = today.replace(day=1)
    last_of_prev_month = first_of_this_month - timedelta(days=1)
    first_of_prev_month = last_of_prev_month.replace(day=1)
    return first_of_prev_month.strftime("%Y-%m-%d"), last_of_prev_month.strftime("%Y-%m-%d")


def get_last_month_timestamps():
    """Returns (start_ms, end_ms) Unix timestamps for the previous full month."""
    start_str, end_str = get_last_month_range()
    start_dt = datetime.strptime(start_str, "%Y-%m-%d")
    end_dt = datetime.strptime(end_str, "%Y-%m-%d").replace(hour=23, minute=59, second=59)
    return int(start_dt.timestamp() * 1000), int(end_dt.timestamp() * 1000)


# -----------------------------------------------------------------------------
# Google Search Console
# -----------------------------------------------------------------------------

def fetch_gsc_metrics():
    """Fetch search analytics from Google Search Console."""
    if not GSC_SITE_URL:
        print("⚠️  GSC_SITE_URL not set, skipping Google Search Console")
        return None

    if not Path(GSC_CREDENTIALS_PATH).exists():
        print(f"⚠️  Credentials file not found at {GSC_CREDENTIALS_PATH}")
        return None

    print("📊 Fetching Google Search Console data...")
    
    credentials = service_account.Credentials.from_service_account_file(
        GSC_CREDENTIALS_PATH,
        scopes=["https://www.googleapis.com/auth/webmasters.readonly"]
    )
    service = build("searchconsole", "v1", credentials=credentials)
    
    start_date, end_date = get_last_month_range()
    
    # Query-level data (top queries by impressions)
    query_request = {
        "startDate": start_date,
        "endDate": end_date,
        "dimensions": ["query"],
        "rowLimit": 100,
        "dataState": "final"
    }
    query_response = service.searchanalytics().query(
        siteUrl=GSC_SITE_URL, body=query_request
    ).execute()
    
    # Page-level data (top pages by impressions)
    page_request = {
        "startDate": start_date,
        "endDate": end_date,
        "dimensions": ["page"],
        "rowLimit": 50,
        "dataState": "final"
    }
    page_response = service.searchanalytics().query(
        siteUrl=GSC_SITE_URL, body=page_request
    ).execute()
    
    # Daily totals for trend analysis
    date_request = {
        "startDate": start_date,
        "endDate": end_date,
        "dimensions": ["date"],
        "dataState": "final"
    }
    date_response = service.searchanalytics().query(
        siteUrl=GSC_SITE_URL, body=date_request
    ).execute()
    
    return {
        "fetched_at": datetime.now().isoformat(),
        "site_url": GSC_SITE_URL,
        "period": {"start": start_date, "end": end_date},
        "metrics": {
            "top_queries": query_response.get("rows", []),
            "top_pages": page_response.get("rows", []),
            "daily_totals": date_response.get("rows", [])
        }
    }


# -----------------------------------------------------------------------------
# Bing Webmaster Tools
# -----------------------------------------------------------------------------

def fetch_bing_metrics():
    """Fetch search performance from Bing Webmaster Tools."""
    if not BING_API_KEY or not BING_SITE_URL:
        print("⚠️  BING_API_KEY or BING_SITE_URL not set, skipping Bing")
        return None

    print("📊 Fetching Bing Webmaster Tools data...")
    
    base_url = "https://ssl.bing.com/webmaster/api.svc/json"
    
    # Get query stats (returns all available data, typically last 6 months)
    query_url = f"{base_url}/GetQueryStats?apikey={BING_API_KEY}&siteUrl={BING_SITE_URL}"
    query_response = requests.get(query_url)
    query_data = query_response.json().get("d", []) if query_response.ok else []
    
    # Get page stats
    page_url = f"{base_url}/GetPageStats?apikey={BING_API_KEY}&siteUrl={BING_SITE_URL}"
    page_response = requests.get(page_url)
    page_data = page_response.json().get("d", []) if page_response.ok else []
    
    # Get rank and traffic stats (overall site metrics)
    traffic_url = f"{base_url}/GetRankAndTrafficStats?apikey={BING_API_KEY}&siteUrl={BING_SITE_URL}"
    traffic_response = requests.get(traffic_url)
    traffic_data = traffic_response.json().get("d", []) if traffic_response.ok else []
    
    # Filter to last month (Bing returns all historical data)
    start_date, end_date = get_last_month_range()
    
    def parse_bing_date(date_str):
        """Parse Bing's /Date(timestamp-offset)/ format."""
        if not date_str:
            return None
        import re
        match = re.search(r'/Date\((\d+)', date_str)
        if match:
            return datetime.fromtimestamp(int(match.group(1)) // 1000).strftime("%Y-%m-%d")
        return None
    
    def filter_by_month(records):
        """Filter records to last month."""
        filtered = []
        for r in records:
            date = parse_bing_date(r.get("Date"))
            if date and start_date <= date <= end_date:
                r["ParsedDate"] = date
                filtered.append(r)
        return filtered
    
    return {
        "fetched_at": datetime.now().isoformat(),
        "site_url": BING_SITE_URL,
        "period": {"start": start_date, "end": end_date},
        "metrics": {
            "query_stats": filter_by_month(query_data),
            "page_stats": filter_by_month(page_data),
            "traffic_stats": filter_by_month(traffic_data)
        },
        "note": "Bing positions are 10x actual (divide by 10)"
    }


# -----------------------------------------------------------------------------
# Umami Cloud
# -----------------------------------------------------------------------------

def fetch_umami_metrics():
    """Fetch analytics from Umami Cloud."""
    if not UMAMI_API_KEY or not UMAMI_WEBSITE_ID:
        print("⚠️  UMAMI_API_KEY or UMAMI_WEBSITE_ID not set, skipping Umami")
        return None

    print("📊 Fetching Umami Cloud data...")
    
    headers = {
        "Accept": "application/json",
        "x-umami-api-key": UMAMI_API_KEY
    }
    
    start_at, end_at = get_last_month_timestamps()
    start_date, end_date = get_last_month_range()
    
    # Overall stats
    stats_url = f"{UMAMI_API_BASE}/websites/{UMAMI_WEBSITE_ID}/stats"
    stats_params = {"startAt": start_at, "endAt": end_at}
    stats_response = requests.get(stats_url, headers=headers, params=stats_params)
    stats_data = stats_response.json() if stats_response.ok else {}
    
    # Top pages
    pages_url = f"{UMAMI_API_BASE}/websites/{UMAMI_WEBSITE_ID}/metrics"
    pages_params = {"startAt": start_at, "endAt": end_at, "type": "url"}
    pages_response = requests.get(pages_url, headers=headers, params=pages_params)
    pages_data = pages_response.json() if pages_response.ok else []
    
    # Referrers
    referrers_params = {"startAt": start_at, "endAt": end_at, "type": "referrer"}
    referrers_response = requests.get(pages_url, headers=headers, params=referrers_params)
    referrers_data = referrers_response.json() if referrers_response.ok else []
    
    # Browsers
    browsers_params = {"startAt": start_at, "endAt": end_at, "type": "browser"}
    browsers_response = requests.get(pages_url, headers=headers, params=browsers_params)
    browsers_data = browsers_response.json() if browsers_response.ok else []
    
    # Countries
    countries_params = {"startAt": start_at, "endAt": end_at, "type": "country"}
    countries_response = requests.get(pages_url, headers=headers, params=countries_params)
    countries_data = countries_response.json() if countries_response.ok else []
    
    # Pageviews over time
    pageviews_url = f"{UMAMI_API_BASE}/websites/{UMAMI_WEBSITE_ID}/pageviews"
    pageviews_params = {"startAt": start_at, "endAt": end_at, "unit": "day"}
    pageviews_response = requests.get(pageviews_url, headers=headers, params=pageviews_params)
    pageviews_data = pageviews_response.json() if pageviews_response.ok else {}
    
    return {
        "fetched_at": datetime.now().isoformat(),
        "website_id": UMAMI_WEBSITE_ID,
        "period": {"start": start_date, "end": end_date},
        "metrics": {
            "stats": stats_data,
            "top_pages": pages_data[:50] if isinstance(pages_data, list) else [],
            "referrers": referrers_data[:20] if isinstance(referrers_data, list) else [],
            "browsers": browsers_data if isinstance(browsers_data, list) else [],
            "countries": countries_data[:20] if isinstance(countries_data, list) else [],
            "daily_pageviews": pageviews_data
        }
    }


# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

def main():
    print(f"\n🚀 SEO Metrics Fetcher - {datetime.now().strftime('%Y-%m-%d %H:%M')}\n")
    
    start_date, end_date = get_last_month_range()
    print(f"📅 Fetching data for: {start_date} to {end_date}\n")
    
    # Create output directory
    month_dir = Path(OUTPUT_DIR) / start_date[:7]  # e.g., "2026-01"
    month_dir.mkdir(parents=True, exist_ok=True)
    
    # Fetch from each source
    results = {
        "google-search-console.json": fetch_gsc_metrics(),
        "bing-webmaster.json": fetch_bing_metrics(),
        "umami-analytics.json": fetch_umami_metrics()
    }
    
    # Save results
    for filename, data in results.items():
        if data:
            output_path = month_dir / filename
            with open(output_path, "w") as f:
                json.dump(data, f, indent=2, default=str)
            print(f"✅ Saved {output_path}")
        else:
            print(f"⏭️  Skipped {filename} (no data or not configured)")
    
    print(f"\n📁 Output directory: {month_dir}")
    print("✨ Done!\n")


def fetch_for_month(year: int, month: int):
    """Fetch metrics for a specific month."""
    from calendar import monthrange
    
    start_date = f"{year}-{month:02d}-01"
    last_day = monthrange(year, month)[1]
    end_date = f"{year}-{month:02d}-{last_day}"
    
    print(f"\n📅 Fetching data for: {start_date} to {end_date}\n")
    
    # Override the date functions temporarily
    global get_last_month_range, get_last_month_timestamps
    original_range = get_last_month_range
    original_timestamps = get_last_month_timestamps
    
    get_last_month_range = lambda: (start_date, end_date)
    
    def custom_timestamps():
        start_dt = datetime.strptime(start_date, "%Y-%m-%d")
        end_dt = datetime.strptime(end_date, "%Y-%m-%d").replace(hour=23, minute=59, second=59)
        return int(start_dt.timestamp() * 1000), int(end_dt.timestamp() * 1000)
    
    get_last_month_timestamps = custom_timestamps
    
    try:
        # Create output directory
        month_dir = Path(OUTPUT_DIR) / f"{year}-{month:02d}"
        month_dir.mkdir(parents=True, exist_ok=True)
        
        # Fetch from each source
        results = {
            "google-search-console.json": fetch_gsc_metrics(),
            "bing-webmaster.json": fetch_bing_metrics(),
            "umami-analytics.json": fetch_umami_metrics()
        }
        
        # Save results
        for filename, data in results.items():
            if data:
                output_path = month_dir / filename
                with open(output_path, "w") as f:
                    json.dump(data, f, indent=2, default=str)
                print(f"✅ Saved {output_path}")
    finally:
        # Restore original functions
        get_last_month_range = original_range
        get_last_month_timestamps = original_timestamps


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "--backfill":
        # Backfill mode: fetch last N months
        months_back = int(sys.argv[2]) if len(sys.argv) > 2 else 6
        
        print(f"🔄 Backfilling {months_back} months...\n")
        
        # Use calendar-accurate month arithmetic instead of assuming 30-day months
        base = datetime.now().replace(day=1)
        base_index = base.year * 12 + (base.month - 1)
        
        for i in range(months_back, 0, -1):
            target_index = base_index - i
            target_year = target_index // 12
            target_month = (target_index % 12) + 1
            fetch_for_month(target_year, target_month)
        
        print("\n✨ Backfill complete!\n")
    else:
        main()