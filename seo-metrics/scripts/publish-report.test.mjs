import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import {
  monthFromFilename,
  reportAlreadyExists,
  reportFilename,
  writeReport,
} from "./publish-report.mjs";

let reportsDir;

beforeEach(() => {
  reportsDir = fs.mkdtempSync(path.join(os.tmpdir(), "seo-reports-"));
});

afterEach(() => {
  fs.rmSync(reportsDir, { recursive: true, force: true });
});

describe("reportFilename", () => {
  test("builds the SEO-REVIEW-<month>.md name", () => {
    expect(reportFilename("2026-07")).toBe("SEO-REVIEW-2026-07.md");
  });
});

describe("monthFromFilename", () => {
  test("extracts the month from a valid filename", () => {
    expect(monthFromFilename("SEO-REVIEW-2026-07.md")).toBe("2026-07");
  });

  test("throws on a filename that doesn't match the pattern", () => {
    expect(() => monthFromFilename("not-a-report.md")).toThrow();
  });
});

describe("reportAlreadyExists", () => {
  test("returns true when SEO-REVIEW-<month>.md exists in reportsDir", () => {
    fs.writeFileSync(path.join(reportsDir, "SEO-REVIEW-2026-07.md"), "# existing report");

    expect(reportAlreadyExists(reportsDir, "2026-07")).toBe(true);
  });

  test("returns false when the report doesn't exist", () => {
    expect(reportAlreadyExists(reportsDir, "2026-08")).toBe(false);
  });

  test("does not confuse a different month's report", () => {
    fs.writeFileSync(path.join(reportsDir, "SEO-REVIEW-2026-06.md"), "# june");

    expect(reportAlreadyExists(reportsDir, "2026-07")).toBe(false);
  });
});

describe("writeReport", () => {
  test("writes the expected file with the expected content", () => {
    const filePath = writeReport(reportsDir, "SEO-REVIEW-2026-09.md", "# hello world");

    expect(fs.readFileSync(filePath, "utf8")).toBe("# hello world");
    expect(filePath).toBe(path.join(reportsDir, "SEO-REVIEW-2026-09.md"));
  });

  test("creates reportsDir when it doesn't exist yet", () => {
    const nestedDir = path.join(reportsDir, "nested", "reports");
    expect(fs.existsSync(nestedDir)).toBe(false);

    writeReport(nestedDir, "SEO-REVIEW-2026-10.md", "# content");

    expect(fs.existsSync(nestedDir)).toBe(true);
    expect(fs.readFileSync(path.join(nestedDir, "SEO-REVIEW-2026-10.md"), "utf8")).toBe(
      "# content",
    );
  });
});
