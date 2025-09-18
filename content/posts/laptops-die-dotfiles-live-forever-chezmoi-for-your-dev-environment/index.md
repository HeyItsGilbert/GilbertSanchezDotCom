---
title: "Laptops Die, Dotfiles Live Forever: Chezmoi for PDE"
date: null
description: "Reproduce your PDE fast with Chezmoi: cross-platform dotfiles, templating, and scripts to sync, backup, and automate your development environment."
summary: ""
showReadingTime: true
draft: false
preview: feature.jpg
lastmod: 2026-09-13T22:31:18.698Z
slug: laptops-die-dotfiles-live-forever
tags:
  - FOSS
  - GitHub
  - PowerShell
keywords: []
series:
  - Terminals, Shells, and Prompts
type: posts
fmContentType: posts
---
<!-- cspell:ignore chezmoi Primagen Ashkan Forouzani Jaykul Choco chezmoidata -->

It's time to upgrade your laptop! Or maybe "someone" spilled coffee on it during
a meeting. That someone could have been you but I'm not here to judge. Maybe
it's the day before the big demo and your laptop wont start. Either way you're
in a situation where you may need to start from square one.

[Click here to skip my life story](#getting-started)

{{< figure
    src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHRnOHA0aXg0ZXB4NTJjOTB4bDI2aTUwbTN1bW9tMGg1b3diNzMyMiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/IxLeSDtUaZRmSiyCTf/giphy.gif"
    alt="One eternity later..."
    caption="If you have to do it by hand."
    >}}

Think about how long it took to set everything up. Did you install everything
you needed? Did your apps get configured the way you like them? Imagine the last
time you used someone elses machine and how awkward it was to navigate.

{{< lead >}}
The question is simple: How do I manage my personal environment?
{{< /lead >}}

## Personal Development Environment

Your Personal Development Environment, aka PDE, was a phrase I first heard
during a Primagen video. While he may have been referring to it from a *nix
perspective, I immediately understood what he was talking about. It goes beyond
your Integrated Development Environment (IDE), and it refers to all the bits
that surround it. From how you manage your windows, how you launch your apps, or
get notifications, to which keyboard shortcuts are configured. The goal is to
optimize your workflows for you with the goal of reaching
[Flow](https://garden.gilbertsanchez.com/moc/flow-moc).

## The Optimization Journey

### Muscle Memory

What makes an expert? 10,000 hours is one popular saying. But it's not 10k hours
of just watching, it's 10k hours of doing and practicing. For many
engineers/developers/etc. it means building up a repertoire of muscle memory. In
the beginning it's learning about the shortcuts, and then making them part of
your daily life. Eventually the out of the box experience slows you down and you
move on to breaking the rules and creating your own.

A silly example is the `CapsLock` key. Few use it (well at least I never did)
but that specific key is in a prime location on the keyboard (don't get me
started on keyboards - that will be a whole separate article). Did you know you
can remap keys? One of the first key remaps I made was to turn the `CapsLock`
key into a `Ctrl` key.

### Optimizing getting things from 🧠 to 💻

As you start to become more senior you begin to recognize patterns to problems
that you're tasked to solve. At a certain point the speed between the answer in
your head and your ability to get it into the computer becomes the bottleneck.
This is when you start to look at what's slowing you down.

- Do you have a certain operation that requires you to click on a GUI? Find a
  way to write a script.
- Run a certain command in your IDE frequently, but you have to search for it
  each time? Create a key binding.
- Need to keep certain pieces of information handy? Update your prompt.
- Need to notify yourself of your next meeting, but the standard pop up breaks
  your flow? Write a custom notifier that shows in your window/shell/prompt.
  Maybe make a light on your desk flash. (see my other ADHD posts)

<!-- #TODO: Link to ADHD articles -->

All of these things have a common theme. They require us to build or implement
tools into our workflows. The problem is that we're now creating bespoke
solutions and we need to ensure they continue to work. So how do we keep our
beautiful, hand crafted, "brain to computer" tools safe? We back them up and we
make sure we have a way to set them up again consistently.

## Dotfiles

So what are dotfiles? In the Linux world dotfiles are often how you configure
applications for a user. The files typically start with `.` which in the *nix
world results in them being "hidden". It's such a common pattern that over the
last few years I've noticed that even Windows apps have begun to do the same.

Prior to being a Windows engineer I was actually a Unix Admin (technically Linux
and Novell 👴) and a Network Admin. While administrating linux servers I learned
about dotfiles and how they worked. Of course as a junior I was backing these up
to a USB drive and loading them as necessary. It worked, but it was clunky.

### Dot File Syncing

While USB drives work, they're clearly not ideal. As I became more senior I
began to push more things into git, including my dotfiles. I wrote a script that
would sync the files to a folder, and then symbolically link the files. To be
honest, it was a bit of a pain, but it beat copying and pasting from a USB
drive.

My readme reminded me to install some pre-requisites (e.g. apps, fonts, etc.)
and to run a script to copy the files.

```sh
git clone git@github.com:HeyItsGilbert/dotfiles.git
mv dotfiles/*(DN) ~/
chmod +x .shell/setup.sh
. .shell/setup.sh
```

Oh yea, I also needed to remember to git clone additional tools, etc. into other
paths. So realistically this used to get me 75% of the way there.

## Chezmoi: Cross Platform & So Much More

I had seen a few other dot file syncing tools that had one or two quality of
life features, but nothing that made me feel the need to migrate an already
working process.

That was until I came across Chezmoi, which I discovered thanks to
[Jaykul](https://huddledmasses.org/).

Chezmoi was the first dotfile manager that was cross platform in a way that I
felt was serious. It offered templating which meant that I could tweak the
configs based on the system. Then I discovered that it also supported the
ability to run scripts at different phases. That opened a whole new range of
possibilities!

{{< github repo="HeyItsGilbert/DotFiles" showThumbnail=true >}}

The scripting aspect was the first thing that really made me stop and consider
migrating. Those fonts I needed before my terminal rendered correctly? That used
to be a `choco install` that I had to remember. The module I used in my standard
flow? Another manual process. But with chezmoi that's no longer necessary.

I mentioned earlier that after my old script, I would still need to clone
additional repositories. Well Chezmoi offers the ability to define those in a
file and have them update as part of it's update.

## Getting Started

So now I've convinced you that you need to go and save and configure your
dotfiles across your machines. But where do you start?

1. [Install Chezmoi](https://www.chezmoi.io/install/) using your preferred
   package manager. i.e. `choco install chezmoi`
2. [Create a new repository] called `dotfiles` on GitHub.
3. Initialize chezmoi by running `chezmoi init`
4. Add your dotfiles with `chezmoi add`.
5. When you're ready you'll change directory to the folder where the chezmoi
   source files are with `chezmoi cd`.
6. From there you can run git commands, such as configuring your remote github
   repo to sync to.
   - See the [chezmoi Quick start](https://www.chezmoi.io/quick-start/) guide

> [!TIP] `.config` becomes `dot_config`.
> 
> Files in a chezmoi dotfiles repo that use a `.` prefix are skipped. Files that
> start with a `.` but are managed are replaced with `dot_`.

### Templates

One of chezmoi's great feature is the ability to use templates. Templates can
use data that is prompted for on initial setup (i.e. e-mail address, repo
directory, etc.) and execute additional methods to modify data or run additional
code. Chezmoi templates are actually golang templates and use that syntax (plus
some extra helpers).

So for Windows I can check the OS using:

```golang
{{ if eq .chezmoi.os "windows" -}}
... code here ...
{{ end -}}
```

#### Herdr Example: Templates & Ignores

Templates can live in the path they'll eventually take (e.g.
`dot_config/powershell/profile.ps1.tmpl` becomes
`.config/powershell/profile.ps1`) but they can also be placed in a
`.chezmoitemplates` directory and used wherever needed.

For example, [herdr](https://herdr.dev/) expects it's config to live in
`%APPDATA%\herdr\config.toml` on Windows, but `~/.config/herdr/config.toml` on
the other OS's. When I placed the file in `~/.config/herdr/config.toml` the
Windows version skipped it (which may be a bug and may already be fixed). But
either way I wanted the same config file but the path to be different.

I updated my `.chezmoiignore` which tells chezmoi which files in the repo to
ignore... but this can be a template too! So the following says: if this is
Windows then you can ignore the `.config/herdr/config.toml` file, and on Linux,
you can ignore the `AppData/Roaming/herdr/config.toml`. Feels weird because
we're talking about ignore's which is like a double negative, but you should get
the idea.

```golang
{{- if eq .chezmoi.os "windows" }}
.config/herdr/config.toml
{{- else }}
AppData/Roaming/herdr/config.toml
{{- end }}
```

And in those files they just call the shared template with
`{{- template "herdr-config.toml.tmpl" . -}}`

You can see the full change in my
[herdr commit](https://github.com/HeyItsGilbert/dotfiles/commit/bfb1011b8d178db9bb867f9d9e21a6f30c6b97da).

### External Repos

My neovim config lives in another repo for "reasons" and I want to keep that
updated. Chezmoi supports fetching additional external repos (along with others)
with a `.chezmoiexternal.toml` config.

```toml
[".config/nvim"]
    type = "git-repo"
    url = "https://github.com/HeyItsGilbert/nvim"
```

But what if I need OS specific externals? [Templates](#templates) are there to
help us out.

So on Windows I use:

```toml
["./AppData/Local/nvim"]
    type = "git-repo"
    url = "https://github.com/HeyItsGilbert/nvim"
```

### Scripts: Automate Package Install

Templates and external packages area really nice, but I think the biggest
selling point is the scripting. I took a page from the
[Install Packages Declaratively](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)
section but made it Windows friendly

First I define which packages I want installed in
[.chezmoidata/packages.json](https://github.com/HeyItsGilbert/dotfiles/blob/main/.chezmoidata/packages.json)

You can see an example shape:

```json
{
  "packages": {
    "chocolatey": [
      "wezterm"
    ],
    "npm_globals": [
      "defuddle"
    ],
    "ps_modules": {
      "Psake": {
        "Prerelease": true
      }
    }
  }
}
```

There are 3 top level keys: `chocolatey`, `npm_globals`, and `ps_modules`. This
shape is arbitrary since it's just for my script. Chocolatey packages won't be
needed on non-windows and for the `ps_modules` I'll want those installed where I
can use them from `Windows PowerShell` and `PowerShell` (aka `pwsh`). That also
means I'll want to account for OS when I install the PowerShell modules.

In
[run_onchange_windows-install-packages.ps1.tmpl](https://github.com/HeyItsGilbert/dotfiles/blob/main/run_onchange_windows-install-packages.ps1.tmpl)
I can check the OS using the Chezmoi [template](#templates) and then install
appropriately.

To read in the data I can use the following method to grab a specific key.
Because the file sits in `.chezmoidata` I can easily load it.

```golang
$json = @"
{{.packages.ps_modules | toPrettyJson}}
"@
```

To see what other methods exist and examples check out the
[Use scripts to perform actions](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
page.

Photo by
[Ashkan Forouzani](https://unsplash.com/@ashkfor121?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
on
[Unsplash](https://unsplash.com/photos/black-flat-screen-computer-monitor-zJsJV5CBGNE?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

[Create a new repository]: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository
