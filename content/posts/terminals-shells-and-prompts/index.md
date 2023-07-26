---
title: Terminals, Shells, and Prompts
date: 2023-07-18T03:52:32.786Z
description: Part one of brief walk through on how terminals, shells, and prompts interact. In later posts I will go over my settings, but this lays the foundation.
summary: Part one of brief walk through on how terminals, shells, and prompts interact. In later posts I will go over my particular settings, but this lays the foundation.
draft: false
lastmod: 2023-07-26T04:18:48.753Z
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
findings. This is likely only a snapshot of my set up, but I'm hoping that
someone finds this useful. By the end of this post you should know a bit more
about terminals, shells, prompts, escape codes, and their interactions. In the
following posts I'll show you my configuration and how you can copy the parts
you like.

## Why does this matter?

I regularly work on multiple OS's in my day to day job and I need to be able to
quickly jump between any . Context switching can cost time, and lead to
mistakes. It's also annoying when a keyboard combo works on one OS/Shell/etc.
and doesn't on another. While these don't solve all the costs of context
switching, they do make the terminal experience consistent.

## My goals

1. Configs that I can sync between computers of any OS.
2. Allow flexibility to add machine/environment specific options (e.g. work).
3. Allow ability to swap any component when I see the next new shiny thing.

## Crash Course on Terminals, etc

I want this to be as accessible as possible so I'll "briefly" explain the
different components. Also, as an engineer I have to explain all the details or
else my brain hurts. The examples given are a VERY small subset of the options
out there. I may also over simplify many concepts, feel free to let me know in
the comments.

### Terminals

The terminal is the application used to communicate and display
information for a system(s). These applications can connect to a Shell on a
local or remote machine.

Some examples are:

- [WezTerm](https://wezfurlong.org/wezterm/) ({{< icon "microsoft" >}}{{< icon "apple" >}}{{< icon "linux" >}})
- [Windows Terminal](https://aka.ms/terminal) ({{< icon "microsoft" >}})
- [ConEmu](https://conemu.github.io/) ({{< icon "microsoft" >}})
- [Terminal](https://support.apple.com/guide/terminal/welcome/mac) ({{< icon "apple" >}})
- [iTerm2](https://iterm2.com/)  ({{< icon "apple" >}})
- So many more...

### Shells

The shell is the user interface used by a terminal to interpret commands by you
the user.

Some examples are:

- PowerShell Core ({{< icon "microsoft" >}}{{< icon "apple" >}}{{< icon "linux" >}})
- Bash ({{< icon "apple" >}}{{< icon "linux" >}})
- ZSH ({{< icon "apple" >}}{{< icon "linux" >}})
- Windows PowerShell ({{< icon "microsoft" >}})
- Cmd ({{< icon "microsoft" >}})
- Fish ({{< icon "apple" >}}{{< icon "linux" >}})

### Prompt

The prompt is what your Shell returns to you and can either be a simple character
to something more complex. This will need be written to support your shell.

Some examples are:

- [Oh My Zsh](https://ohmyz.sh/) (zsh only)
- [Oh My Posh](https://ohmyposh.dev/) (many shells - written in Go)
- [Starship](https://starship.rs/) (many shells - written in Rust)

### Escape Codes

Escape codes are ways for you (or more often your prompt) to give your shell a
set of instructions. Some of these are known as "Operating System Commands".
These are often how you get "shell integration".

- [ANSI Escape Code](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [WezTerm Shell Integration](https://wezfurlong.org/wezterm/shell-integration.html)
- [iTerm2 Shell Integration](https://iterm2.com/documentation-shell-integration.html)
- [Windows Terminal Shell Integration](https://devblogs.microsoft.com/commandline/shell-integration-in-the-windows-terminal/)

### Colors: ANSI and Unicode

One way to apply colors to your terminal is to use ANSI color codes. This tells your
terminal to use a certain color. Most terminals offer a way to theme your shell
my saying the "black" actually this hue of purple. Another way is to use a
unicode character that your shell can interpret as a color. Some shells or prompts
offer easy ways to color your prompt.

- [Wikipedia: ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
- PowerShell Core offers [PSStyle](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.3#psstyle)

---

Hopefully this was informative and has helped you understand how these different
components interact. The next post in this series is [My Terminal: WezTerm]({{< ref "my-terminal" >}}).

Cover Photo by
[Philipp Katzenberger](https://unsplash.com/@fantasyflip?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
on
[Unsplash](https://unsplash.com/wallpapers/desktop/computer?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
