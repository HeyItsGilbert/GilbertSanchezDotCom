#!/usr/bin/env python3
"""
Tests for the pure output-verification logic in fetch_seo_metrics.py.

These exercise verify_month_output() directly against a temp-directory
fixture -- no subprocess, no network, no credentials required.
"""

from pathlib import Path

import pytest

from fetch_seo_metrics import EXPECTED_SOURCE_FILES, verify_month_output


def _write(path: Path, content: str = "{}") -> None:
    path.write_text(content)


@pytest.fixture
def month_dir(tmp_path: Path) -> Path:
    d = tmp_path / "2026-01"
    d.mkdir()
    return d


def test_all_three_present_and_non_empty(month_dir: Path):
    for filename in EXPECTED_SOURCE_FILES:
        _write(month_dir / filename)

    assert verify_month_output(month_dir) == []


def test_one_file_missing(month_dir: Path):
    _write(month_dir / "google-search-console.json")
    _write(month_dir / "umami-analytics.json")
    # bing-webmaster.json intentionally not created

    assert verify_month_output(month_dir) == ["bing-webmaster.json"]


def test_one_file_present_but_empty(month_dir: Path):
    _write(month_dir / "google-search-console.json")
    _write(month_dir / "bing-webmaster.json")
    (month_dir / "umami-analytics.json").touch()  # zero bytes

    assert verify_month_output(month_dir) == ["umami-analytics.json"]


def test_all_three_missing(month_dir: Path):
    # Directory exists but nothing was ever written into it.
    assert verify_month_output(month_dir) == list(EXPECTED_SOURCE_FILES)


def test_accepts_string_path(month_dir: Path):
    for filename in EXPECTED_SOURCE_FILES:
        _write(month_dir / filename)

    assert verify_month_output(str(month_dir)) == []
