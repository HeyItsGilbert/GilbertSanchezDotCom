// Pure, importable helpers for the `publish-report` safe-output job in
// .github/workflows/SEOReport.md. Kept out of the inline actions/github-script
// block so they can be unit tested with `bun test` and reused if the workflow
// is ever invoked manually.

import fs from "node:fs";
import path from "node:path";

const FILENAME_PATTERN = /^SEO-REVIEW-(\d{4}-\d{2})\.md$/;

/**
 * Builds the expected report filename for a given month.
 * @param {string} month - e.g. "2026-07"
 * @returns {string}
 */
export function reportFilename(month) {
  return `SEO-REVIEW-${month}.md`;
}

/**
 * Extracts the "YYYY-MM" month from a report filename.
 * @param {string} filename - e.g. "SEO-REVIEW-2026-07.md"
 * @returns {string}
 */
export function monthFromFilename(filename) {
  const match = FILENAME_PATTERN.exec(filename);
  if (!match) {
    throw new Error(`Cannot determine month from report filename: ${filename}`);
  }
  return match[1];
}

/**
 * Whether a report for the given month has already been published.
 * @param {string} reportsDir - directory containing SEO-REVIEW-*.md files
 * @param {string} month - e.g. "2026-07"
 * @returns {boolean}
 */
export function reportAlreadyExists(reportsDir, month) {
  const filePath = path.join(reportsDir, reportFilename(month));
  return fs.existsSync(filePath);
}

/**
 * Writes a report file, creating reportsDir if it doesn't exist.
 * @param {string} reportsDir - directory to write into
 * @param {string} filename - e.g. "SEO-REVIEW-2026-07.md"
 * @param {string} content - full markdown report body
 * @returns {string} the path the report was written to
 */
export function writeReport(reportsDir, filename, content) {
  fs.mkdirSync(reportsDir, { recursive: true });
  const filePath = path.join(reportsDir, filename);
  fs.writeFileSync(filePath, content, "utf8");
  return filePath;
}
