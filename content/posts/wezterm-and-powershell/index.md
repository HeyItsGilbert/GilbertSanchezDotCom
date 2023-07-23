---
title: WezTerm and PowerShell
date: 2023-07-18T03:52:32.786Z
description: A walkthrough on how I use PowerShell via WezTerm
summary: ""
draft: false
lastmod: 2023-07-23T01:10:49.829Z
slug: ""
tags: []
preview: feature.png
keywords:
  - powershell
  - starship
  - wezterm
type: posts
---

This post is long overdue and is a series of findings I've had over time. This
is likely only a snapshot of what continues to evolve, but I'm hoping that
someone finds this useful (or more likely, helps me remember). By the end you
should know a bit more about terminals, shells, prompts, escape codes, and
more. I'll then show you how I'm set up and how you can copy the parts you like.

## Why does this matter?

I regularly work on multiple OS's in my day to day job so it's not unusual for
me to have a mac, linux, and windows machine running on my desk. Context switching
can cost time, and lead to mistakes. It's also annoying that a keyboard combo
works on OS/Shell/etc. and doesn't in another. While these don't solve all the
cost of context switching, they do make my terminal experience consistent.

## My goals

1. Configs that I can sync between computers of any OS.
2. Allow flexibility to add machine/environment specific options (e.g. work).
3. Allow ability to swap any component when I see the next new shiny thing.

## Crash Course on Terminology

I want this to be as accessible as possible so I'll "briefly" explain the
different components. Also, as an engineer I have to explain all the details or
else my brain hurts. The examples given are a VERY small subset of the options
out there. I may also over simplify many concepts, feel free to let me know in
the comments.

### Terminals

It is the application used to communicate and display
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

This is the user interface used by a terminal to interpret commands by you the
user.

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

- [Oh My Zsh](https://ohmyz.sh/)
- [Oh My Posh](https://ohmyposh.dev/)
- [Starship](https://starship.rs/)

### Escape Codes

Escape codes are ways for you (or more often your prompt) to give your shell a
set of instructions. Some of these are known as "Operating System Commands"

- ANSI Escape Code https://en.wikipedia.org/wiki/ANSI_escape_code
- WezTerm Shell Integration https://wezfurlong.org/wezterm/shell-integration.html

### Colors: ASCII, Unicode

One way to apply colors to your terminal is to use ASCII codes. This tells your
terminal to use a certain color. Most terminals offer a way to theme your shell
my saying the "black" actually this hue of purple. Another way is to use a
unicode character that your shell can interpret as a color.

## WezTerm: What it is, and why its awesome

Rust. LUA scripting means there's a lot of power available.

##
