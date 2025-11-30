---
description: 'Audit and update this blog post. The blog covers various topics mostly focusing on PowerShell and terminal usage.'
tools: ['edit', 'search', 'usages', 'openSimpleBrowser', 'fetch', 'githubRepo', 'marp-team.marp-vscode/exportMarp', 'extensions']
---
Audit and update this blog post. The blog covers various topics mostly focusing on PowerShell and terminal usage.

CONTEXT:
- Blog content spans multiple technical topics and time periods
- Current year is 2025
- Local blog repository is at D:\GilbertSanchezDotCom\
- Various repositories may be available locally for reference

IMPORTANT: THIS TASK REQUIRES NUANCE

Updating old blog posts is not a mechanical find-and-replace operation. These posts are historical documents that capture:
- What was true at the time they were written
- The author's voice and communication style
- The context of the technical ecosystem at that moment
- Teaching approaches that may have been intentionally simplified for the audience

Exercise judgment throughout. When in doubt:
- Preserve the original rather than "improving" it
- Fix actual problems (broken links, wrong info) not stylistic preferences
- Ask yourself: "Does this change make the post more accurate/useful, or just different?"
- Remember that "old" doesn't mean "wrong" - many posts are intentionally timeless

The goal is to maintain the blog's integrity while fixing genuine issues, not to rewrite history or impose 2025 standards on older content.

CHECK AND FIX:

1. FRONTMATTER:
   - If you make any substantive changes to the post, add or update the lastmod field with today's date
   - Format: lastmod: 2025-11-01
   - Place it after the date field in the frontmatter
   - Do NOT add lastmod if you only fixed minor things like a single broken link
   - For posts: update lastmod if content changed
   - For presentations: check if PresoPublish.ps1 needs to be run
   - For projects: verify project status/links are current
   - Ensure type field matches Hugo content structure

2. LINKS:
   - For internal links, use Hugo ref/relref when possible: {{< ref "posts/other-post" >}}
   - Or use relative paths for page bundles: ../other-post/
   - Test all external links, replace dead/broken ones
   - If a blog post link NO LONGER EXISTS, check the Wayback Machine (web.archive.org) for an archived version. If found on Wayback Machine, update the link to point to the archived version
   - Update Microsoft Docs URLs if they've been reorganized
   - Fix any broken internal links or image references
   - Update any links to GitHub code if paths have changed
   - For any remote images (including Twitter/X hosted images):
   - For page bundles (posts with index.md), download images to the post's directory
   - For standalone pages, use static/images
   - Update markdown to use relative paths: ![alt](image.webp) for page bundles
     * Update the markdown to reference the local path
     * Use descriptive filenames based on the post content

3. TWITTER/X CONTENT:
   - Remove all Twitter embeds and links
   - Convert tweets to concise paraphrased statements like "Jeffrey Snover once said..."
   - Do NOT quote tweets verbatim
   - Summarize the key point being made
   - Replace Twitter profile links with Bluesky profiles when available

4. CODE EXAMPLES:
   - Leave T-SQL code blocks alone - don't change them
   - For PowerShell code blocks with commands that have more than 3 parameters, consider converting to splatting format
   - SPLATTING REQUIRES NUANCE:
     * DO convert when: 4+ parameters in a reusable example/template, part of a script where readability matters, teaching proper practices
     * DO NOT convert when: quick one-liner demo, interactive console usage, showing ad-hoc usage, would make example less clear for beginners, post's tone is casual and splatting feels overly formal, showing "quick win" commands where simplicity is the point
     * Example to convert: `$params = @{ SqlInstance = 'sql01'; Database = 'master'; ExcludeSystem = $true }; Get-DbaDatabase @params`
     * When in doubt, preserve the original format - the author chose that style for a reason
   - Verify command syntax is still valid if possible
   - Check if parameters have been renamed or deprecated
   - Remove any hardcoded credentials, server names, or sensitive paths

5. POWERSHELL SCREENSHOTS (CRITICAL):
   - Find any embedded PowerShell console screenshots (typically old blue Windows PowerShell screenshots)
   - Extract the PowerShell commands and output from these screenshots
   - Replace screenshots with the powershell-console shortcode:

   {{< powershell-console >}}
   PS C:\> Your-Command
   Output goes here
   {{< /powershell-console >}}

   - The shortcode automatically handles syntax highlighting for:
     * PS prompts (PS C:\>)
     * Commands
     * Property/value pairs (Property : Value)
     * Status keywords (Success, Failed, True, False, etc.)
     * Table headers and output
   - You can optionally specify a custom title: {{< powershell-console title="PowerShell 5.1" >}}
   - Do NOT convert regular markdown code blocks to this format
   - ONLY convert actual screenshot images to this shortcode format
   - Preserve the exact text from the screenshot including prompts, commands, and output

   TABLE ALIGNMENT IN POWERSHELL OUTPUT (CRITICAL):
   - PowerShell tables within {{< powershell-console >}} blocks MUST have properly aligned columns
   - Use monospace spacing - treat it like a grid where every character position matters
   - Process:
     * Identify all column headers (e.g., SqlInstance, JobName, LastRunDate, etc.)
     * Determine the width needed for each column based on the longest value
     * Add consistent spacing (typically 2 spaces minimum) between columns
     * Ensure header separator lines (----) match the column header width
     * Align all data rows to match the column positions

   Example of PROPER alignment:
```
   SqlInstance  JobName                                    LastRunDate               LastRunOutcome  IsEnabled
   -----------  -------                                    -----------               --------------  ---------
   MSSQLSERVER  DatabaseIntegrityCheck - USER_DATABASES    2017/04/13 12:00:00 AM    Failed          True
   MSSQLSERVER  DatabaseBackup - USER_DATABASES - FULL     2017/03/27 12:00:00 AM    Failed          True
```

   Example of IMPROPER alignment (DO NOT DO THIS):
```
   SqlInstance JobName              LastRunDate      LastRunOutcome IsEnabled
   ----------- -------              -----------      -------------- ---------
   MSSQLSERVER MSSQLSERVER 2017/04/13 12:00:00 AM Failed         True
```

   - The smaller font size (text-xs) and tighter spacing make proper alignment critical
   - Misaligned columns will look cramped and unprofessional
   - Take time to ensure each column vertically aligns under its header
   - HOW TO CHECK: After fixing, visually scan down each column - you should be able to draw a straight vertical line through each column from header to the last data row

6. TECHNICAL ACCURACY:
   - Update "coming soon" or "beta" references if those features have now shipped
   - Note any workarounds for bugs that have since been fixed
   - Flag any security practices that have evolved
   - Leave version numbers and statistics exactly as written - they're historical facts
   - DO NOT update download counts, command counts, or version-specific announcements
   - These posts document what was true at that moment in time
   - Use judgment: "how things work" = update if needed; "what happened in [year]" = leave it
7. HUGO SHORTCODES:
   - Verify all shortcodes render correctly
   - Test the shortcode exists in your layouts/shortcodes
   - Check for other custom shortcodes used (like the removed {{< tweet >}})
   - Ensure shortcode syntax uses {{< >}} for HTML or {{% %}} for Markdown processing
8. THEME ELEMENTS:
   - Verify Blowfish shortcodes still work (check themes/blowfish/layouts/shortcodes/)
   - Check if theme-specific frontmatter fields are still valid
   - Ensure featured images follow Blowfish conventions
   - Test appearance settings (showDate, showAuthor, etc.)
9. PRESENTATIONS:
   - If updating presentation content, note that PresoPublish.ps1 must be run
   - Check if Marp directives are still valid
   - Verify presentation links in posts still work
   - Test both HTML and PDF versions if changed

PRESERVE:
- Original writing style and voice
- All T-SQL code blocks exactly as-is
- Working code (don't modernize just for syntax preferences)
- Historical context and perspective
- Post structure and flow

BEFORE WRITING:
Did you make any actual content changes? (links, code, text, images, frontmatter)
- YES → Write the file with a summary
- NO → Report "No changes needed" and stop

DO NOT write the file if you only changed:
- Line endings (CRLF ↔ LF)
- Whitespace or trailing spaces
- Nothing at all

DO NOT add lastmod to frontmatter if you made zero content changes.

VALIDATION (Add this section):
After making changes, ALWAYS:
1. Run `./bin/hugo/hugo` to verify the build succeeds
2. Start dev server: `./bin/hugo/hugo server --port 1313`
3. Manually check affected pages at http://localhost:1313
4. Run `markdownlint content/` to check markdown quality

OUTPUT:
- **If you made ZERO content changes, do NOT write the file. Just report "No changes needed - post is already in good shape."**
- Updated markdown file with changes (only if you actually changed content)
- Brief summary of what you changed and why
- Note if you added/updated lastmod in the frontmatter
- Note any PowerShell screenshots you found and converted to shortcode format
- Note any code examples converted to splatting format
- List any issues you couldn't fix automatically

NOTES:
- Do not make backups unless you need them for something, source control handles this.
- If you remove someone's twitter link, check if they have a Bluesky profile and link that instead. If not, try to figure out their blog and link that instead.
- When commands have been renamed or deprecated, try to identify the current equivalent.
- Do not expand shortlinks.