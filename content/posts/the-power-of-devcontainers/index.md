---
title: The Power of Devcontainers
date: 2024-03-11T00:29:20.951Z
description: Quickly learn about devcontainers and how they can unlock more contributors to your projects.
summary: Quickly learn about devcontainers and how they can unlock more contributors to your projects.
showReadingTime: true
draft: false
preview: feature.jpg
slug: power-devcontainers
tags:
  - Docker
  - FOSS
  - GitHub
  - Linting
  - TDD
keywords:
  - powershell
  - programming
  - starship
  - DevEx
series:
  - 10X Via DevEx
series_order: 1
type: posts
lastmod: 2024-03-31T16:43:14.292Z
---

Those who know me know I'm a huge fan of Development Containers (a.k.a. dev
containers or devcontainers). I'll quickly introduce what they are, how I use
them, and why I see them as a powerful way to encourage contributors from a
variety of backgrounds.

This will likely be one in a short series where I talk about some of my favorite
Developer Experience (DevEx) tools. You can expect posts about GitHub Actions,
and VSCode tasks in the future.

## What's a devcontainer?

A devcontainer is a way to specify a docker container to run your project in.
These containers are spun up when you open a project and are ready to connect
via VSCode or GitHub Codespaces. They offer a way to include build tools and
extensions that you suggest or require for your project.

This site (yes the one you're looking at now) includes a devcontainer. Why? Because
the container comes with Hugo (my content manager of choice), Vale (my prose
linter of choice), and Node pre-installed. Could I install those things
locally? Yes, but why. Why deal with the bloat on my system? No need to muddy
your paths or remember to keep your build tools up to date.

## How to get started with Devcontainers

Devcontainers begin and typically end with a single file:
`.devcontainer\devcontainer.json`. In this file you specify what image to use,
what features to include, ports to forward, and so much more. There's an
extensive list of templates available at
[containers.dev](https://containers.dev/templates), but personally I use the
universal image and then layer on tools via the features option.

Here's the devcontainer file I use in this sites repo.

```json
{
  "image": "mcr.microsoft.com/devcontainers/universal:2",
  "features": {
    "ghcr.io/devcontainers/features/hugo:1": {
      "extended": "true"
    },
    "ghcr.io/shinepukur/devcontainer-features/vale:1": {
      // specify here any options you would like to set for the feature
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/node:1": {}
  },
  "extensions": [
    "eliostruyf.vscode-front-matter",
    "davidanson.vscode-markdownlint",
    "marp-team.marp-vscode"
  ]
}
```

You can see how I start with the universal image and layer on Hugo, Vale, and
Node. I also include the Front Matter, Markdownlint, and MARP VSCode extensions.

If you want to learn more about what settings you can modify, check out the full
spec at [Development Containers](https://containers.dev/).

## Encouraging Polyglotism

A Polyglot is someone who knows several languages, and I'm using it to represent
folks who learn and are interested in a multitude of coding languages. I'm a
polyglot and while my language of choice is often PowerShell I feel just as
comfortable in Python, Ruby, or PHP. Once you begin to learn the core concepts
of programming languages it often becomes simply translating the syntax to the
language your working on.

So how do devcontainers encourage polyglotism? They solve the major pain point
of new projects: build environments. The build environment, before containers, was
your local machine. This meant installing and configuring any tools necessary.
Do you know what tools you need to build a rust binary? Go?
`insert JS framework of the week`? That's also assuming that the language has a
standard build tool. What about custom tools?

New contributors have several hurdles when contributing. The must become
familiar with the project, navigate the process for contribution, write the code
to meet the projects standards, build and test. If you're lucky these are all
clearly laid out in the contribution docs, but that's not often the case.

What often does exist may be a short section in the readme with the specific
build tool command to execute. You're often on your own to discover how to setup
the tools.

## "What the hell is clippy?"

This question came up when I decided I wanted to contribute to
[Starship](https://starship.rs), a rust project. I discovered that someone had a
semi-completed PR to add a way to distinguish PowerShell from Pwsh via the shell
indicator module. After screwing up my git branch (a branch off of a fork…
yikes) I was able to open PR
[#5478](https://github.com/starship/starship/pull/5478) when I hit one of the
first hurdles.

Starship has great contributor docs and once I read them I realized I was
missing the formatting tools. Also, kind of crazy, was that I didn't have rust
installed at the point where I finished writing my first draft of the PR.
**Devcontainers to the rescue!** I quickly created the devcontainer JSON that
included all the necessary rust tools. Once that turned up, I was able to
actually run the formatter as described by the docs and ensure that everything
worked as expected.

This story later repeated itself with Python, Ruby, and Go PR's. By replacing
the effort required to configure my environment with a simple JSON file, I
was quickly able to start contributing to repo's once thought too difficult.

## Local Build vs Remote Build

This is great because now I had a local build working. Upon a PR submission
the starship repo kicked off a GitHub action to ensure that the code passed
the lint as expected. Great! It also ran pinned and nightly builds across
multiple OS's. This level of coverage can easily be hit with GitHub actions.
Stay tuned because that will be my next post in this series.

## So next time...

Next time you come across a tool you're interested in but don't have the
development environment for, consider creating a quick devcontainer and
contributing. Your perspective may bring the project significant value. You may
even consider submitting the devcontainer to that project!

---

Photo by [Mingwei Lim](https://unsplash.com/@cmzw?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/a-black-and-white-photo-of-a-spiral-design-K5T3UMuc114?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash).
