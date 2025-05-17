---
title: Stucco
date: 2023-10-31T22:07:11.747Z
summary: In this presentation I go over how to start using Stucco. If you follow along in your own termial, you'll be ready to publish to the gallery!
description: In this presentation I go over how to start using Stucco. If you follow along in your own termial, you'll be ready to publish to the gallery!
lastmod: 2023-11-01T00:23:31.230Z
tags: []
type: presentations
preview: feature.png
slideshow: /slides/Stucco.html
marp: true
theme: uncover
class:
  - invert
---
<!--
For Demo I pre-logged into PSGallery & Github
Basic VM with the following configured
- Windows Terminal Preview
- Git
- VS Code w/ following Extensions
-- PowerShell Preview
-- markdownlint
-- Marp for VS Code
-->
<!-- markdownlint-disable MD026 -->

# Stucco: Start to Publish

Creating an open source module in minutes!

![bg left](https://images.unsplash.com/photo-1556156653-e5a7c69cc263?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80)

---

# Follow Along or

# Jump Ahead

You can see the slides:

- [Slides](/slides/Stucco.html)
- [One Page](/presentations/stucco/)
- [PDF](/slides/Stucco.pdf)
- [PPTX](/slides/Stucco.pptx)

---

# Quick Intro

- Gilbert Sanchez
- Señor Systems Engineer at Meta
- Writing PowerShell for the last 10ish years

---

# Agenda

1. Install Modules
2. Setup Our Github Repo
3. Create Our Module
4. Commit
5. Publish

---

# Pre-Requisites

If you want to follow along on your computer here's what you should get ready.

- Github account
- Git installed
- VS Code (Recommended)

---

# Install Stucco!

A good starting point.

```powershell
Install-Module Stucco
```

<!--
Note that it installs it's pre-requisites.
Pester included (which you may need to )
Install-Module Pester -RequiredVersion 5.3.3 -SkipPublisherCheck
-->

---

# Configure Your Github Repository

![Create a New Github Repo](./NewRepo.png)

---

# Create Repo & Check it Out

1. Pick a name, description, etc.
2. Create Repository
3. Check it out!

<!--
A few options...
git clone ...
Github's tool
-->

---

# Create Your Module

```powershell
New-StuccoModule
```

Follow the prompts

---

# Let's Examine

- Repo Layout
- `Requirements.ps1`
- `psakeFile.ps1`
- `Build.ps1`

---

# Build

```powershell
.\build.ps1 -Task Test
```

# Or in VS Code

_Terminal_ -> _Run Task_ -> ___Test___

<!--
Known issue with Windows PowerShell 
https://github.com/psake/PowerShellBuild/pull/60
-->

---

# Commit your code!

```powershell
git add .
git commit -m "Initial commit!"
git push
```

---

# Get Ready for PSGallery

1. Login to [PSGallery](https://www.powershellgallery.com/)
2. Create API keys
3. Copy

---

# Put Your API Key into Github

1. Go to your new repo
2. Settings
3. Secrets -> Actions
4. "PS_GALLERY_KEY" and paste

<!--
Look into branch protection rules
-->

---

# Time to Publish

At this point your code should be ready to publish.

- [Publish.yaml](https://github.com/HeyItsGilbert/RPGDice/blob/main/.github/workflows/publish.yaml)
- [Mkdocs.yaml](https://github.com/HeyItsGilbert/RPGDice/blob/main/.github/workflows/Mkdocs.yaml)

---

# Bonus: Test Results on PR's

1. `$PSBPreference.Test.OutputFormat = 'JUnitXml'`
2. Upload your unit tests via `upload-artifact`
3. Use `EnricoMi/publish-unit-test-result-action@v1`

See [CI.yaml](https://github.com/HeyItsGilbert/RPGDice/blob/main/.github/workflows/CI.yaml)

---

# Thank you!

<br>
<br>
<br>
<br>

Cover Photo by [Avel Chuklanov](https://unsplash.com/@chuklanov?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/IB0VA6VdqBw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
