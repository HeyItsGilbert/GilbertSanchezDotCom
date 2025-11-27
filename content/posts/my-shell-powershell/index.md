---
title: "PowerShell Profile Setup Guide: Optimization & Starship Integration"
date: 2023-10-08T16:15:02.506Z
description: Complete PowerShell profile configuration guide. Learn how to optimize your $Profile, integrate Starship prompt, add custom functions, and improve startup performance.
summary: In this third post of the series I go over my PowerShell profile.
draft: false
lastmod: 2025-11-27T16:42:50.115Z
slug: my-shell-powershell
tags:
  - PowerShell
preview: feature.webp
keywords:
  - powershell
  - powershell profile
  - starship
  - shell configuration
  - psreadline
type: posts
series:
  - Terminals, Shells, and Prompts
series_order: 3
---

This is the third post in this series. You can see the first post explaining
[Terminals, Shells & Prompts]({{< ref "terminals-shells-and-prompts" >}}). In
this post I'll be covering my specific PowerShell profile settings.

If your interested in my terminal, check out [My Terminal: WezTerm]({{< ref "my-terminal" >}}).

You can see the latest copy of my config files here: {{< icon "github" >}}
[HeyItsGilbert/dotfiles](https://github.com/HeyItsGilbert/dotfiles)

## My goals

These are my overall goals with my particular setup.

1. Configs that I can sync between computers of any OS.
2. Allow flexibility to add machine/environment specific options (e.g. work).
3. Allow ability to swap any component when I see the next new shiny thing.

## PowerShell for every system!

Surprise! Or not. Unless you stumbled on this page randomly, you probably found
this through my various PowerShell social networking posts. I love PowerShell.
I love working with Objects, I love how easy it is to learn and teach, and how
easy it is to call more advanced .Net methods. After writing a lot of bad bash
scripts and even worse sed/awk commands, I'll use PowerShell as much as I can
get away with it.

I take great pride at work for being known as the PowerShell person. I was
recently tagged at work with:

> cc Gilbert who is a known powershell lover

I'll be going over my profile which at first glance may seem complex, but I'll
slowly talk through each portion. If you feel like copying it, feel free to take
what works for you. See something you think I could improve? Tell me! I love to
iterate and improve on my shell experience.

## My Profile

A lot of inspiration for my profile structure and how I optimized it came from
Steve Lee's
[Optimizing your $Profile](https://devblogs.microsoft.com/powershell/optimizing-your-profile/).
You can see the latest version of [my profile on my GitHub](https://github.com/HeyItsGilbert/dotfiles/blob/main/.config/Microsoft.Powershell_profile.ps1).

Here is a high level overview of how my Profile is laid out.

- Variables (single global variable)
- Attempt to load WorkFunctions if it exists.
- Functions
  - Alias and helper functions
  - `Initialize-Profile` function
  - `prompt` function
- Safely load starship

Below I'll walk through each of these.

### Work Functions

One of the patterns you'll notice is that I always leave a way to add work
specific configs. Here I check if a file in the same directory called
`WorkFunctions.ps1` exists and if it does load it.

```powershell
# Load work functions
$wf = "$PSScriptRoot\WorkFunctions.ps1"
if (Test-Path $wf -ErrorAction SilentlyContinue) {
  . $wf
}
```

### Functions Over Aliases

I've noticed that loading functions is faster the executing commands such as
`Set-Alias`, and my goal is to load my profile as fast as possible. This is
especially true when we get to the sections below on prompt loading.

```powershell
# A shortcut I used in unix regularly
function ll { Get-ChildItem -Force $args }

# Still allow me to use gco alias
function Get-GitCheckout {
  [alias("gco")]
  param()
  git checkout $args
}
# Regularly used in unix, but now for Windows
function which { param($bin) Get-Command $bin }
# Another unix regular that I wanted to replicate for Windows
function Watch-Command {
  [alias('watch')]
  [CmdletBinding()]
  param (
    [Parameter()]
    [ScriptBLock]
    $Command,
    [Parameter()]
    [int]
    $Delay = 2
  )
  while ($true) {
    Clear-Host
    Write-Host ("Every {1}s: {0} `n" -F $Command.toString(), $Delay)
    $Command.Invoke()
    Start-Sleep -Seconds $Delay
  }
}
```

### `Intialize-Profile` & `prompt` Functions

This portion is almost directly lifted from Steve's post (which I highly
recommend you read). The difference is what I load in it.

What makes these two functions important is that they only execute the
initialization once and only if we are actually presented a prompt. That means
that any calls to PowerShell aren't slowed down by my prompt if no prompt ever
loads.

`Initialize-Profile` is the real important function. That's where I set all my
options for PSReadLine and import modules. These are things that we really don't
want to do in a promptless session.

I `Import-Module` some of my favorite modules. Most of them impact the prompt,
shell, and terminal. I'll spare you all the particulars of all my settings, but
I'll call out a few of my favorites.

This saves your last commands output to `$__` which is super handy.

```powershell
# Save all output, just in case! Thanks to @vexx32
$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'
```

I conditionally load @mdgrs
[ShellIntegration script](https://gist.github.com/mdgrs-mei/1599cb07ef5bc67125ebffba9c8f1e37).
This adds some escape sequces to your prompt which allows you to do things like
double click on the output in the terminal and it'll highlight appropriately.

```powershell
## Import Shell Integration Script
$si = "$PSScriptRoot\ShellIntegration.ps1"
if (Test-Path $si -ErrorAction SilentlyContinue) {
  $term_app = $env:TERM_PROGRAM
  # Let's check if its Windows terminal thanks to...
  # https://github.com/microsoft/terminal/issues/1040
  if ($null -ne $env:WT_SESSION) {
    $term_app = 'WindowsTerminal'
  }
  & $si -TerminalProgram $term_app
}
```

This uses the `ocgv_history` function (defined in the functions above) to show
my command history in Out-ConsoleGridView thanks to @AndrewPla!

```powershell
$parameters = @{
  Key = 'F7'
  BriefDescription = 'Show Matching History'
  LongDescription = 'Show Matching History using Out-ConsoleGridView'
  ScriptBlock = {
    ocgv_history -Global $false 
  }
}
Set-PSReadLineKeyHandle
```

The `prompt` function calls the Initialize-Profile if the global variable isn't
set. If we don't have starship, then I revert to an old powerline style prompt.
The old prompt code isn't pretty to look it, but honestly I rarely see it.

### Starship

So the last thing we do is load [Starship]({{< ref "my-prompt-starship" >}}). What does starship do? It overwrites
the prompt! So how do we handle this conflict?

What the prompt above does is call the `Initialize-Profile` function once.
Starship supports PreCommand by writing a `Invoke-Starship-PreCommand` function
in your profile. Now we can leverage all the work from the profile
initialization but still get our sweet Starship prompt.

```powershell
# Starship overwrites the prompt. Do this so its available on first open.
# There is a cost for this but it should be minimal.
if (Get-Command 'starship' -ErrorAction SilentlyContinue) {
  function Invoke-Starship-PreCommand {
    if ($global:profile_initialized -ne $true) {
      $global:profile_initialized = $true
      Initialize-Profile
    }
  }
  Invoke-Expression (&starship init powershell)
}
```

----

Hopefully you found something useful for your profile. If there's something you
want to see me go over in more details, let me know in the comments! Feel free
to leave feedback or questions. You can also find me on the PowerShell Discord,
or the various social networks linked below.

In my next post I'll be going over [escape codes]({{< ref "terminals-shells-and-prompts#escape-codes" >}})! There's a ton of great content
out there. Also check out [my Starship prompt configuration]({{< ref "my-prompt-starship" >}}) to see how all these pieces work together.

Shout out again to [@mdgrs](https://mdgrs.hashnode.dev/) for all the awesome
shell tools like Shell Integration, and Dynamic Titles.

Also thanks to Mr [Andrew Pla](https://twitter.com/AndrewPlaTech) for his
[`ocgv` function](https://www.youtube.com/watch?v=ciJiWQ4FHHI&t=618s).

## References

- Optimizing your $Profile https://devblogs.microsoft.com/powershell/optimizing-your-profile/
- about_Profiles https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3
- fb_powershell cookbook https://github.com/facebook/chef-cookbooks/tree/main/cookbooks/fb_powershell
- @mdgrs ShellIntegration script https://gist.github.com/mdgrs-mei/1599cb07ef5bc67125ebffba9c8f1e37
- @andrewplatech ocgv PS Readline https://www.youtube.com/watch?v=ciJiWQ4FHHI&t=618s
