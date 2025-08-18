# Gilbert Sanchez Personal Website

This is a Hugo-based static site generator project that builds Gilbert Sanchez's personal website at [gilbertsanchez.com](https://gilbertsanchez.com). The site includes blog posts, presentations, projects, and various technical content.

**ALWAYS follow these instructions first. Only fallback to additional search and context gathering if the information in these instructions is incomplete or found to be in error.**

## Working Effectively

Bootstrap, build, and test the repository with these exact commands:

```bash
# 1. Install Node.js dependencies (includes Hugo binary installation)
npm install
# Takes ~30 seconds. NEVER CANCEL. Set timeout to 60+ seconds.

# 2. Initialize Git submodules for themes
git submodule init && git submodule update  
# Takes ~30 seconds. NEVER CANCEL. Set timeout to 60+ seconds.

# 3. Build the site
./bin/hugo/hugo
# Takes ~300-500ms for basic build, ~12-15 seconds for production build with --gc --minify

# 4. Install linting tools
markdownlint-cli
# Takes ~10 seconds. Set timeout to 30+ seconds.
```

### Development Server

```bash
# Start development server with live reload
./bin/hugo/hugo server --port 1313 --bind 0.0.0.0
# Server starts in ~1 second. Accessible at http://localhost:1313
# NEVER CANCEL - let it run for development
```

### Build for Production

```bash
# Production build with minification (matches Netlify config)
./bin/hugo/hugo --gc --minify
# Takes ~12-15 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
# Note: Significantly slower than basic build due to minification and cleanup
```

## Validation

**CRITICAL VALIDATION SCENARIOS**: After making any changes, ALWAYS run these validation steps:

1. **Build Validation**: Run `./bin/hugo/hugo` and ensure zero errors in output
2. **Content Validation**: Start dev server and manually check affected pages
3. **Lint Validation**: Run `markdownlint content/` to check markdown quality  
4. **Presentation Validation**: If presentations changed, run `pwsh -c ./PresoPublish.ps1`

### Manual Testing Scenarios

- **Blog Posts**: Navigate to affected post URLs and verify content renders correctly
- **Presentations**: Check that presentation pages load and slides are accessible
- **Navigation**: Test main navigation links and ensure no broken internal links
- **Mobile View**: Check responsive design by resizing browser window
- **Search**: Use site search functionality to find content

## Common Operations

### Generating Presentations

```bash
# Generate presentation slides from Markdown (Marp CLI)
pwsh -c ./PresoPublish.ps1
# Takes ~15 seconds per presentation. NEVER CANCEL. Set timeout to 60+ seconds.
# Generates HTML, PDF, and PPTX versions in static/ directory
```

### Linting

```bash
# Lint all markdown files
markdownlint content/
# Takes ~5 seconds. Set timeout to 30+ seconds.

# Lint specific file
markdownlint content/posts/[post-name]/index.md

# Note: Vale linter is configured (vale.ini) but not installed by default
# markdownlint is the primary linting tool for this repository
```

### Adding New Content

```bash
# Create new blog post
./bin/hugo/hugo new posts/[post-name]/index.md

# Create new presentation  
./bin/hugo/hugo new presentations/[presentation-name]/index.md
```

## Known Issues and Workarounds

### Network Dependencies
- **Twitter Embeds**: Some blog posts contain `{{< tweet >}}` shortcodes that require internet access
- **Build Failure**: If builds fail with Twitter/network errors, comment out tweet embeds or use offline build
- **Production Builds**: Network dependencies may cause builds to fail in restricted environments
- **Workaround**: For network issues, temporarily remove or comment `{{< tweet >}}` shortcodes from affected posts

### External Service Dependencies  
- **Twitter API**: Required for tweet embeds to work properly
- **Remote Images**: Some posts reference external images that need network access
- **Solution**: When working offline, comment out external dependencies temporarily

### PowerShell Scripts
- **PresoPublish.ps1**: Requires PowerShell 7+ (`pwsh` command)  
- **NewPost.PSA.ps1**: Social media posting script, may fail without proper API keys

## Repository Structure

### Key Directories
```
├── .devcontainer/          # VS Code dev container config
├── .github/workflows/      # GitHub Actions (merge scheduling)
├── .vscode/               # VS Code settings and tasks
├── bin/hugo/              # Hugo binary (installed by npm)
├── config/_default/       # Hugo configuration files
├── content/               # All site content
│   ├── posts/            # Blog posts
│   ├── presentations/    # Presentation slides
│   └── projects/         # Project pages
├── layouts/              # Hugo layout templates  
├── static/               # Static assets
├── themes/blowfish/      # Theme (Git submodule)
└── public/               # Generated site (created by Hugo)
```

### Critical Files
- `config/_default/hugo.toml` - Main Hugo configuration
- `package.json` - Node.js dependencies and scripts
- `netlify.toml` - Netlify deployment configuration
- `PresoPublish.ps1` - Presentation generation script
- `vale.ini` - Vale linting configuration (Vale not installed by default)
- `.vscode/tasks.json` - VS Code build tasks

## Build Pipeline Information

### Local Development
- Use `./bin/hugo/hugo server` for live reload development
- Hugo watches for file changes automatically
- Changes to config files require server restart

### Production Deployment  
- Site deploys to Netlify automatically
- Build command: `hugo --gc --minify`
- Hugo version: 0.125.4 extended
- Deploy target: `public/` directory

### CI/CD
- GitHub Actions handles automated merging via `merge-schedule.yml`
- No continuous integration builds configured
- Deployments happen via Netlify's build system

## Theme and Customization

### Blowfish Theme
- Theme is managed as Git submodule at `themes/blowfish/`
- Theme config in `config/_default/` overrides theme defaults
- Site uses "congo" color scheme with dark appearance
- Custom background image: `joey-kyber-Mg2iKRWpiCk-unsplash.jpg`

### Content Format
- Blog posts: Markdown with frontmatter in `content/posts/[name]/index.md`
- Images: Store alongside content in post directories
- Presentations: Marp-format Markdown in `content/presentations/`

## VS Code Integration

### Available Tasks
- **Build**: `Ctrl+Shift+P` → "Tasks: Run Task" → "markdownlint" (default build task)
- **Presentations**: `Ctrl+Shift+P` → "Tasks: Run Task" → "Build all the marp artifacts"

### Extensions
- markdownlint for markdown linting
- Front Matter CMS for content management  
- Marp for presentations
- PowerShell support

## Troubleshooting

### Common Build Failures
1. **Missing theme**: Run `git submodule init && git submodule update`
2. **Missing Hugo**: Run `npm install` to download Hugo binary
3. **Network errors**: Comment out `{{< tweet >}}` shortcodes temporarily
4. **Permission errors**: Ensure proper file permissions on `bin/hugo/hugo`

### Performance Notes
- Hugo builds are extremely fast (~300ms) due to static generation
- Large image processing may slow builds slightly  
- Presentation generation is the slowest operation (~15s per presentation)

### Dependencies
- **Node.js 18+**: Required for npm and hugo-installer
- **PowerShell 7+**: Required for presentation scripts  
- **Git**: Required for theme submodule management
- **Internet**: Required for some content (Twitter embeds, remote images)

## Quick Reference Commands

```bash
# Full development setup from scratch
npm install && git submodule init && git submodule update

# Build site  
./bin/hugo/hugo

# Development server
./bin/hugo/hugo server

# Generate presentations
pwsh -c ./PresoPublish.ps1

# Lint content
markdownlint content/

# Clean build
rm -rf public/ && ./bin/hugo/hugo

# Production build
./bin/hugo/hugo --gc --minify
```

**Remember**: Always test your changes by running the build process and manually verifying the affected content in the development server before committing.