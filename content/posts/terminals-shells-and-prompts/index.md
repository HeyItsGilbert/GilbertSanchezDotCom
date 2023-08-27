---
title: Terminals, Shells, and Prompts
date: 2023-08-27T14:55:56.151Z
description: Part one of brief walk through on how terminals, shells, and prompts interact. In later posts I will go over my settings, but this lays the foundation.
summary: Part one of brief walk through on how terminals, shells, and prompts interact. In later posts I will go over my particular settings, but this lays the foundation.
draft: false
lastmod: 2023-08-27T14:56:33.799Z
slug: terminals-shells-and-prompts
tags:
  - PowerShell
  - WezTerm
  - iTerm
preview: feature.jpg
keywords:
  - powershell
  - shell
  - starship
  - terminal
  - wezterm
  - prompt
type: posts
---

This post, the first in this series, is long overdue and is a collection of my
findings. This is likely only a snapshot of my current set up, but I'm hoping that
someone finds this useful. By the end of this post you should know a bit more
about terminals, shells, prompts, escape codes, and their interactions. In the
following posts I'll show you my configuration and how you can copy the parts
you like.

## Why does this matter?

I regularly work on multiple OS's in my day-to-day job, and I need to be able to
quickly jump between any of them. Context switching can cost time, and lead to
mistakes. It's also annoying when a keyboard combo works on one OS/Shell/etc.
and not another. While making the terminal consistent between OS's doesn't solve
all the costs of context switching, it does make the experience more enjoyable.

## My goals

These are my overall goals with my particular setup.

1. Configs that I can sync between computers of any OS.
2. Allow flexibility to add machine/environment specific options (e.g. work).
3. Allow ability to swap any component when I see the next new shiny thing.

## Crash Course on Terminals, etc

I want this to be as accessible as possible, so I'll "briefly" explain each
component and their interactions with each other. Also, as an engineer, I have
to explain all the details or else my brain hurts. The examples given are a VERY
small subset of the options out there. I may also over simplify many concepts,
feel free to let me know in the comments.

### Terminals

The terminal is the application used to communicate and display
information for a system(s). These applications can connect to a Shell on a
local or remote machine.

Some examples are:

- [WezTerm](https://wezfurlong.org/wezterm/) ({{< icon "microsoft" >}}{{< icon "apple" >}}{{< icon "linux" >}})
- [Windows Terminal](https://aka.ms/terminal) ({{< icon "microsoft" >}})
- [ConEmu](https://conemu.github.io/) ({{< icon "microsoft" >}})
- [Terminal](https://support.apple.com/guide/terminal/welcome/mac) ({{< icon "apple" >}})
- [iTerm2](https://iterm2.com/) ({{< icon "apple" >}})
- So many more...

### Shells

The shell is the user interface used by a terminal to interpret commands from
you the user.

Some examples are:

- PowerShell ({{< icon "microsoft" >}}{{< icon "apple" >}}{{< icon "linux" >}})
- Windows PowerShell ({{< icon "microsoft" >}})
- Bash ({{< icon "apple" >}}{{< icon "linux" >}})
- ZSH ({{< icon "apple" >}}{{< icon "linux" >}})
- Cmd ({{< icon "microsoft" >}})
- Fish ({{< icon "apple" >}}{{< icon "linux" >}})

### Prompt

The prompt is what your [shell](#shells) returns to you and can either be a
simple character (e.g., `$`, `>`, etc.) or something more complex. Prompts are
typically written for a specific shell, but some do support multiple.

Some examples are:

- [Starship](https://starship.rs/) (many shells - written in Rust)
- [Oh My Zsh](https://ohmyz.sh/) (zsh only)
- [Oh My Posh](https://ohmyposh.dev/) (many shells - written in Go)

### Escape Codes

Escape codes are ways to give your shell a set of instructions. Some of these
are known as "Operating System Commands" (aka OSC codes). Often, you get "shell
integration" through the use of these codes. While it's possible to pass the codes yourself
at the terminal, it's more likely you'll include them in your prompt.

- [ANSI Escape Code](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [WezTerm Shell Integration](https://wezfurlong.org/wezterm/shell-integration.html)
- [iTerm2 Shell Integration](https://iterm2.com/documentation-shell-integration.html)
- [Windows Terminal Shell Integration](https://devblogs.microsoft.com/commandline/shell-integration-in-the-windows-terminal/)

### Colors: ANSI and Unicode

Using ANSI color codes (which are special escape codes) is a way to apply colors
to your terminal. These codes tell your terminal to use a certain color for
foreground or background. Most terminals offer a way to theme your shell by
replacing a standard color (i.e., black, bright red, etc.) with specific color
in the terminals expected format (i.e., 256-color, hex, etc.). Another way to
apply color is to use Unicode character that your shell can interpret as a
color. Some shells or prompts offer easy ways to color your prompt.

- [Wikipedia: ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
- PowerShell Core offers [PSStyle](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.3#psstyle)

---

Hopefully this was informative and has helped you understand how these different
components interact. The next post in this series is [My Terminal: WezTerm]({{< ref "my-terminal" >}}).

Cover Photo by
[Philipp Katzenberger](https://unsplash.com/@fantasyflip?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
on
[Unsplash](https://unsplash.com/wallpapers/desktop/computer?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
