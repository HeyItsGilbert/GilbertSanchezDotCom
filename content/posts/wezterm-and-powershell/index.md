---
title: WezTerm and PowerShell
date: 2023-07-18T03:52:32.786Z
description: A walkthrough on how I use PowerShell via WezTerm
summary: ""
draft: false
lastmod: 2023-07-22T20:56:07.105Z
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
more.

## Why does this matter?

I regularly work on multiple OS's in my day to day job so it's not unusual for
me to have a mac, linux, and windows machine running on my desk. Context switching
can cost time, and lead to mistakes. It's also annoying that a keyboard combo
works on OS/Shell/etc. and doesn't in another. While these don't solve all the
cost of context switching, they do make my terminal experience consistent.

## Dealers choice
TODO: This should make it clear that my goal is to make my profile and settings work
on any terminal. When the next hotness comes out, I want to be able to put it to
the test without starting fresh.

My overall goal is to create a profile that can easily travel between machines.
It should also be easy for me to add machine specific options

## Terminals

What is a terminal? It is the application used to communicate and display
information for a system(s). These applications can connect to a Shell on a
local or remote machine.

Some examples are:

- WezTerm ({{< icon "microsot" >}}{{< icon "apple" >}}{{< icon "falinux" >}})
- Windows Terminal ({{< icon "microsot" >}})
- ConEmu ({{< icon "microsot" >}})
- Terminal ({{< icon "apple" >}})
- iTerm ({{< icon "apple" >}})
- So many more...

## Shells

This is the user interface used by a terminal to interpret commands by you the
user.

Some examples are:

- Bash
- ZSH
- PowerShell
- Cmd
- Fish

## Prompt

The prompt is what your Shell returns to you and can either be a simple character
to something more complex.

Some examples are:

- Hand crafted
- oh-my-posh
- starship

## Escape Codes

Escape codes are ways for you (or more often your prompt) to give your shell a
set of instructions. Some of these are known as "Operating System Commands"

- ANSI Escape Code https://en.wikipedia.org/wiki/ANSI_escape_code
- WezTerm Shell Integration https://wezfurlong.org/wezterm/shell-integration.html

## Colors: ASCII, Unicode

One way to apply colors to your terminal is to use ASCII codes. This tells your
terminal to use a certain color. Most terminals offer a way to theme your shell
my saying the "black" actually this hue of purple. Another way is to use a
unicode character that your shell can interpret as a color.

# WezTerm: What it is, and why its awesome
Rust. LUA scripting means there's a lot of power available.
