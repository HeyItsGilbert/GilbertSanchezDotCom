---
title: "My Terminal: WezTerm"
date: 2023-07-23T19:58:05.544Z
description: ""
summary: ""
draft: true
lastmod: 2023-07-23T20:11:10.814Z
slug: ""
tags: []
preview: feature.png
keywords: <failed to process>
type: posts
---

This post (first in the series) is long overdue and is a series of findings I've
had over time. This is likely only a snapshot of what continues to evolve, but
I'm hoping that someone finds this useful (or more likely, helps me remember).
In this post I'll cover my terminal settings and how I configure them.

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

## WezTerm: Cross Platform & Flexible

[WezTerm](https://wezfurlong.org/wezterm/) was written by Wez Furlong. He's a
former Meta employee and created tools like Watchman and EdenFS. Hands down one
of the smartest and humblest engineers I've had the privelege of interacting
with. If you're looking for a mentor, Wez offers mentoring at his
[patreon](https://www.patreon.com/WezFurlong).

WezTerm is written in Rust which is gaining popularity lately. It's configuration
is based in LUA which unlocks a ton of possibilitie. It's use of a single config
file helps me meet all three of [my goals](#my-goals).