---
title: "Laptops Die, Dotfiles Live Forever: Chezmoi for PDE"
date: null
description: ""
summary: ""
showReadingTime: true
draft: true
preview: feature.jpg
lastmod: 2025-09-07T22:19:34.579Z
slug: ""
tags: []
keywords: []
series: []
type: posts
fmContentType: posts
---
<!-- cspell:ignore chezmoi Primagen Ashkan Forouzani Jaykul Choco -->

It's time to upgrade your laptop. Or maybe someone spilled coffee on it during a
meeting. That someone could have been you but I'm not here to judge. Maybe it's
the day before the big demo and your laptop wont start. Either way you're in a
situation where you may need to start from square one.

![One eternity later...](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHRnOHA0aXg0ZXB4NTJjOTB4bDI2aTUwbTN1bW9tMGg1b3diNzMyMiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/IxLeSDtUaZRmSiyCTf/giphy.gif)

Think about how long it took to set everything up. Did you install everything
you needed? Did your apps get configured? Imagine the last time you used
someone elses machine and how awkward it was to navigate. The question to
ask is: how can I avoid and deal with this? You take control.

## Personal Development Environment

Your Personal Development Environment, aka PDE, was a phrase I first heard
during a Primagen video. While he may have been referring to it from a *nix
perspective, I immediately understood what he was talking about. It goes beyond
your Integrated Development Environment (IDE), and it refers to all the bits
that surround it. From how you manage your windows, to how you launch your apps,
or get notifications.

## The Optimization Journey

### Muscle Memory

What makes an expert? 10,000 hours is one rule of thumb made popular. But it's
not 10k hours of just watching, it's 10k hours of doing and practicing. For many
engineers/developers/etc. it means building up a repertoire of muscle memory. In
the beginning it's learning about the shortcuts, and then making them part of
your daily life. Eventually the out of the box experience slows you down and
you move on to breaking the rules and creating your own.

A silly example is the CapsLock` key. Few use it (well at least I never did) but
the key is in a prime location - don't get me started on keyboards. Did you know
you can remap keys? One of the first key remaps I made was to turn the
`CapsLock` key into a `Ctrl` key.

### Optimizing 🧠 to 💻

As you start to become more senior you begin to recognize patterns to problems
that you're tasked to solve. At a certain point the speed between the answer in
your head and your ability to get it into the computer becomes the bottleneck.
This is when you start to look at what's slowing you down.

- Have a certain operation that requires you to click on a GUI? Find a way to
  write a script.
- Run a certain command in your IDE frequently, but you have to search for it
  each time? Create a key binding.
- Need to keep certain pieces of information handy? Update your prompt.
- Need to notify yourself of your next meeting, but the standard pop up breaks
  your flow? Write a custom notifier that shows in your window/shell/prompt.
  Maybe make a light on your desk flash. (see my other ADHD posts)

All of these things have a common theme. They require us to build or implement
tools into our flows. The problem is that we are now creating bespoke solutions
and we need to insure them. So how do we keep our beautiful, hand crafted,
cerebral cortex to computer tools safe? We back them up.

## Dotfiles

So what are dotfiles? In the Linux world dotfiles are often how you configure
applications for a user. The files typically start with `.` which in the *nix
world results in them being "hidden". It's such a common pattern that over the
last few years I've noticed that even Windows apps have begun to do the same.

Prior to being a Windows Admin I was actually a Unix Admin (technically Linux
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

That was until I came across Chezmoi, which I discovered via Jaykul.

Chezmoi was the first that really supported cross platform in a way that I felt
was serious. It offered templating which meant that I could tweak the configs
based on the system. Then I discovered that it also supported the ability to run
scripts at different phases.

### Scripting

This was the first thing that really made me stop and investigate. Those fonts I
needed? Choco install. Modules I always use?

### External Sources

I mentioned earlier that after my old script, I would still need to clone
additional repositories. Well Chezmoi offers that ability to define those in a
file and have them update as part of it's update.

## Getting Started

So now I'm convinced you that you need to go and save and configure your
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

---

Photo by
[Ashkan Forouzani](https://unsplash.com/@ashkfor121?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
on
[Unsplash](https://unsplash.com/photos/black-flat-screen-computer-monitor-zJsJV5CBGNE?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

[Create a new repository]: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository
