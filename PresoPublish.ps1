[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# Directories
$RepoRoot   = $PSScriptRoot
$SlidesDir  = Join-Path $RepoRoot 'static/slides'
$ContentDir = Join-Path $RepoRoot 'content/presentations'

# Theme CSS search order: repo root, then sibling summit2026 dir
$ThemeSearchPaths = @(
    $RepoRoot,
    (Join-Path $RepoRoot '../summit2026')
)

# Source asset search order: directories that may contain a matching <PresentationName>/
# subdirectory with the original slide images.
$AssetSourcePaths = @(
    (Join-Path $RepoRoot '../summit2026')
)

# Require global marp (faster than npx re-download each run)
if (-not (Get-Command marp -ErrorAction SilentlyContinue)) {
    throw "marp CLI not found. Install with: npm i -g @marp-team/marp-cli"
}

if (-not (Test-Path $SlidesDir)) {
    New-Item -ItemType Directory -Path $SlidesDir | Out-Null
}

# Parse YAML front matter into a hashtable (simple key: value pairs only)
function Get-FrontMatter {
    param([string] $FilePath)
    $fm = @{}
    $lines = Get-Content $FilePath
    $inFm = $false
    foreach ($line in $lines) {
        if (-not $inFm -and $line -eq '---') { $inFm = $true; continue }
        if ($inFm -and $line -eq '---') { break }
        if ($inFm -and $line -match '^(\w+):\s*(.+)$') {
            $fm[$Matches[1]] = $Matches[2].Trim().Trim('"').Trim("'")
        }
    }
    $fm
}

# Find a theme CSS file by name across search paths
function Find-ThemeCss {
    param([string] $ThemeName)
    foreach ($dir in $ThemeSearchPaths) {
        $css = Join-Path $dir "$ThemeName.css"
        if (Test-Path $css) { return $css }
    }
    $null
}

# Copy locally-referenced images from the markdown into the output dir
function Copy-DeckAssets {
    param([string] $MarkdownPath, [string] $OutputDir)
    $mdDir  = Split-Path $MarkdownPath -Parent
    $content = Get-Content $MarkdownPath -Raw

    $refs  = [regex]::Matches($content, '!\[.*?\]\(([^)]+)\)') |
                 ForEach-Object { $_.Groups[1].Value }
    $refs += [regex]::Matches($content, '<img[^>]+src=[''"]([^''"]+)[''"]',
                 [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) |
                 ForEach-Object { $_.Groups[1].Value }

    foreach ($ref in ($refs | Where-Object { $_ -and $_ -notmatch '^https?://' })) {
        $src = Join-Path $mdDir $ref | Resolve-Path -ErrorAction SilentlyContinue
        if ($src -and (Test-Path $src)) {
            Copy-Item $src (Join-Path $OutputDir (Split-Path $src -Leaf)) -Force
        }
    }
}

# Copy images referenced via url() in a theme CSS into the output dir.
# Chromium resolves CSS relative URLs against the HTML file's location,
# so theme assets must sit alongside the built HTML in static/slides/.
function Copy-ThemeAssets {
    param([string] $CssPath, [string] $OutputDir)
    $cssDir  = Split-Path $CssPath -Parent
    $content = Get-Content $CssPath -Raw

    $refs = [regex]::Matches($content, "url\(['""]?([^)'""]+)['""]?\)") |
                ForEach-Object { $_.Groups[1].Value }

    foreach ($ref in ($refs | Where-Object { $_ -and $_ -notmatch '^https?://' -and $_ -notmatch "^'" })) {
        $src = Join-Path $cssDir $ref | Resolve-Path -ErrorAction SilentlyContinue
        if ($src -and (Test-Path $src)) {
            $dest = Join-Path $OutputDir (Split-Path $src -Leaf)
            if (-not (Test-Path $dest)) {
                Copy-Item $src $dest -Force
                Write-Host "  [theme asset] $(Split-Path $src -Leaf)" -ForegroundColor DarkGray
            }
        }
    }
}

# Pull slide images into the content dir from an external source directory so
# marp can find them via relative paths. Searches $AssetSourcePaths for a
# subdirectory whose name matches the presentation dir (e.g. summit2026/Burnout/).
# Skips files that are already present — re-run is safe.
function Copy-SourceAssets {
    param([string] $DirName, [string] $DestDir)
    $imageExts = @('.png', '.jpg', '.jpeg', '.svg', '.gif', '.webp')
    foreach ($base in $AssetSourcePaths) {
        $src = Join-Path $base $DirName
        if (Test-Path $src) {
            Get-ChildItem $src -File | Where-Object { $_.Extension -in $imageExts } |
                ForEach-Object {
                    $dest = Join-Path $DestDir $_.Name
                    if (-not (Test-Path $dest)) {
                        Copy-Item $_.FullName $dest -Force
                        Write-Host "  [source] $($_.Name)" -ForegroundColor DarkGray
                    }
                }
            return
        }
    }
}

# Build a temporary CSS where every local url() reference is rewritten to an
# absolute file:// path. Marp injects the theme as an inline <style> block in
# the temp HTML it feeds to Chromium for PDF/PPTX export. Chromium resolves
# relative url() paths against the temp file's directory (not the CSS source),
# so relative paths silently break. Absolute paths survive the move.
function New-AbsoluteThemeCss {
    param([string] $CssPath)
    $cssDir  = Split-Path $CssPath -Parent
    $content = Get-Content $CssPath -Raw

    # Remove @import 'base' — marpit resolves this internally before building the
    # HTML, so the base styles are already inlined by the time Chromium renders.
    # Keeping the directive causes a file-not-found lookup against the temp CSS
    # directory (where base.css doesn't exist), triggering a spurious warning.
    $patched = $content -replace "(?m)^\s*@import\s+'base'\s*;.*$", ''

    $patched = [regex]::Replace($patched, "url\(['""]?([^)'""]+)['""]?\)", {
        param($m)
        $ref = $m.Groups[1].Value
        if ($ref -match '^https?://' -or $ref -match '^data:') { return $m.Value }
        $abs = Join-Path $cssDir $ref | Resolve-Path -ErrorAction SilentlyContinue
        if ($abs) {
            $forward = $abs.Path.Replace('\', '/')
            return "url('file:///$forward')"
        }
        return $m.Value
    })

    $tempPath = [IO.Path]::ChangeExtension([IO.Path]::GetTempFileName(), '.css')
    $patched | Out-File -Encoding utf8 -FilePath $tempPath -NoNewline:$false
    return $tempPath
}

# Process each presentation directory
Get-ChildItem -Directory $ContentDir | ForEach-Object {
    $dir      = $_
    $markdown = Get-ChildItem $dir -Filter *.md | Select-Object -First 1
    if (-not $markdown) { Write-Warning "No .md file in $($dir.FullName) — skipping"; return }

    $fm = Get-FrontMatter $markdown.FullName

    # Derive output base name from the slideshow front matter param so the
    # filename always matches what Hugo expects (e.g. stop-hand-rolling-chocolate)
    $baseName = if ($fm['slideshow']) {
        [IO.Path]::GetFileNameWithoutExtension($fm['slideshow'])
    } else {
        $dir.BaseName
    }

    # Resolve --theme-set args for custom themes.
    # Built-in marp themes (default, gaia, uncover) need no --theme-set arg.
    $css      = $null
    $tempCss  = $null
    $themeArgs = @()
    if ($fm['theme']) {
        $css = Find-ThemeCss $fm['theme']
        if ($css) {
            # For HTML: use the original CSS — images are resolved from static/slides/
            # For PDF/PPTX/image: use a patched CSS with absolute file:// paths so
            # Chromium can resolve url() refs from whatever temp dir it renders from.
            $tempCss   = New-AbsoluteThemeCss $css
            $themeArgs = @('--theme-set', $css)
            Write-Host "  Theme: $($fm['theme']) -> $css" -ForegroundColor DarkGray
        } else {
            Write-Verbose "Theme '$($fm['theme'])' not found as CSS — assuming built-in marp theme"
        }
    }

    Write-Host "Building: $baseName" -ForegroundColor Cyan

    Copy-SourceAssets -DirName $dir.BaseName -DestDir $dir.FullName
    Copy-DeckAssets  -MarkdownPath $markdown.FullName -OutputDir $SlidesDir
    if ($css) { Copy-ThemeAssets -CssPath $css -OutputDir $SlidesDir }

    # HTML — relative url() paths work because images sit alongside the output HTML
    & marp $markdown.FullName @themeArgs --no-stdin `
        -o (Join-Path $SlidesDir "$baseName.html")

    # PDF, PPTX, image — use patched CSS with absolute paths for Chromium
    $absThemeArgs = if ($tempCss) { @('--theme-set', $tempCss) } else { @() }

    & marp $markdown.FullName @absThemeArgs --no-stdin --allow-local-files `
        -o (Join-Path $SlidesDir "$baseName.pdf")

    & marp $markdown.FullName @absThemeArgs --no-stdin --allow-local-files `
        -o (Join-Path $SlidesDir "$baseName.pptx")

    # First-slide feature image (marp supports png/jpeg only; convert manually for WebP)
    & marp $markdown.FullName @absThemeArgs --no-stdin --allow-local-files `
        --image png -o (Join-Path $dir.FullName 'feature.png')

    if ($tempCss -and (Test-Path $tempCss)) { Remove-Item $tempCss -Force }

    # Remove assets from the page bundle that would cause Hugo to time out:
    #   - GIFs: Hugo cannot handle large animated GIFs (animation frames exhaust memory/time)
    #   - Files over 500 KB: Hugo image processing is slow on large source files
    # Images that survive this pass are kept so they render on the Hugo presentation page.
    # All images are already in static/slides/ for the HTML slideshow regardless.
    $MaxBundleKB = 500
    Get-ChildItem $dir.FullName -File | Where-Object {
        $_.Name -notin @('index.md', 'feature.png') -and
        ($_.Extension -eq '.gif' -or ($_.Length / 1KB) -gt $MaxBundleKB)
    } | ForEach-Object {
        Write-Host "  [trim] $($_.Name) ($([math]::Round($_.Length/1KB))KB)" -ForegroundColor DarkGray
        Remove-Item $_.FullName -Force
    }
}
