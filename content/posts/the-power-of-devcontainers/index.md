---
title: The Power of Devcontainers
date: 2024-03-10T02:32:47.049Z
description: Quickly learn about devcontainers and how they can unlock more contributors to your projects.
summary: Quickly learn about devcontainers and how they can unlock more contributors to your projects.
showReadingTime: true
draft: false
preview: feature.jpg
lastmod: 2024-03-10T04:36:36.060Z
slug: power-devcontainers
tags: []
keywords:
  - powershell
  - programming
  - starship
  - devex
series: []
type: posts
---

Like most of my posts this is long overdue, because those who know me know I'm
a huge fan of Devcontainers. In this post I'll quickly introduce what they are,
how I use them, and why I see them as a powerful way to encourage contributors
from a variety of backgrounds.

## What is a devcontainer?

A devcontainer is a way to specify a docker container to run your project in.
These containers are spun up when you open a project and are ready to connect
via VSCode or Github Codespace. They offer a way to include build tools and
extensions that you suggest or require for your project.

This site (yes the one you're looking at now) includes a devcontainer. Why? Because
the container comes with Hugo (my content manager of choice), Vale (my prose
linter of choice), and Node pre-installed. Could I install those things
locally? Yes, but why? Why deal with the bloat on my system? No need to muddy
your paths or remember to keep your build tools up to date.

## How to get started with Devcontainers

Devcontainers begin (and usually end with) a single file:
`.devcontainer\devcontainer.json`. In this file you specify what image to use,
what features to include, ports to forward and so much more. There is a huge
list of [templates](https://containers.dev/templates) that are out there but I
usually use the universal image where I layer on tools via the features.

Here's the devcontainer file I use in this sites repo.
```json
{
  ""
summary: ""
showReadingTime: true
draft: true
preview: feature.jpg
lastmod: 2024-03-10T02:32:47.050Z
slug: power-devcontainers
tags: []
keywords:
  - powershell
  - programming
  - starship
  - devex
series: []
type: posts
---

Like most of my posts this is long overdue, because those who know me know I'm
a huge fan of Devcontainers. In this post I'll quickly introduce what they are,
how I use them, and why I see them as a powerful way to encourage contributors
from a variety of backgrounds.

## What is a devcontainer?

A devcontainer is a way to specify a docker container to run your project in.
These containers are spun up when you open a project and are ready to connect
via VSCode or Github Codespace. They offer a way to include build tools and
extensions that you suggest or require for your project.

This site (yes the one you're looking at now) includes a devcontainer. Why? Because
the container comes with Hugo (my content manager of choice), Vale (my prose
linter of choice), and Node pre-installed. Could I install those things
locally? Yes, but why? Why deal with the bloat on my system? No need to muddy
your paths or remember to keep your build tools up to date.

## How to get started with Devcontainers

Devcontainers begin (and usually end with) a single file:
`.devcontainer\devcontainer.json`. In this file you specify what image to use,
what features to include, ports to forward and so much more. There is a huge
list of [templates](https://containers.dev/templates) that are out there but I
usually use the universal image where I layer on tools via the features.

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
Node. I also include the Front Matter, Markdownlint, and MARP vscode extensions.

If you want to know more about what settings you can modify, check out the full
spec at [Development Containers](https://containers.dev/).

## Encouraging Polyglotism

A Polyglot is someone who knows several languages, and I'm using it to represent
folks who learn and are interested in a multitude of coding languages. I'm a
polyglot and while my language of choice is often PowerShell I feel just as
comfortable in Python, Ruby, or PHP. Once you begin to learn the core concepts
of programming languages it often just becomes translating the syntax to the
language your working on.

So how do devcontainers encourage polyglotism? They solve the major pain point
of new projects: build environments. Do you know what tools you need to build a
rust binary? Go? <insert JS framework of the week>? That's also assuming that
the languages has a standard build tool. What about custom ones?

New contributors have several hurdles when contributing: learn the project,
navigate the process for contribution, writing the code to meet the projects
standards, test and build. If you're lucky these are all clearly laid out in
the contribution docs but you're lucky if those exist.

What often does exist may be a short section in the readme with the specific
build tool command to execute. You're often on your own to discover how to setup
the tools.

## "What the hell is clippy?"

No, not the beloved helper of yesteryear. This question came up when I decided I
wanted to contribute to [Starship](https://starship.rs). I discovered that
someone had a semi-completed PR to add a way to distinguish PowerShell from Pwsh
via the shell indicator module. After screwing up my git branch (a branch off of
a fork... yikes) I was able to open PR
[#5478](https://github.com/starship/starship/pull/5478) when I hit one of the first
hurdles.

See Starship actually has great contributor docs. Once I read them I realized I
was missing the formatting tools. Also (kinda of crazy) was that I didn't even
have rust installed. In come devcontainers. I created a quick one that included
the rust tools and I was able to actually run the formatter as described by the
docs and ensure that everything worked as expected.

This story later repeated itself with Python, Ruby, and Go PR's. By replacing
the effort required to configure my environment with a simple json file, I
quickly was able to start contributing to repo's once thought too difficult.

## PowerShell Devcontainers

So this wouldn't be a post from Gilbert if I didn't talk about PowerShell at
least in one paragraph. So how does PowerShell play into this? One obvious thing
is you can include your build tools. You can also do things like leverage VSCode
tasks to then make taking required actions easier.

---
Photo by <a href="https://unsplash.com/@cmzw?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Mingwei Lim</a> on <a href="https://unsplash.com/photos/a-black-and-white-photo-of-a-spiral-design-K5T3UMuc114?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
