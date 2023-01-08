---
title: Using Stucco to Create Your PowerShell Module
date: 2023-01-07T18:20:55.807Z
description: Learn why Stucco is such a powerfull module template. Includes a walk through
  from creating a module to publishing to the PowerShell Gallery!
summary: Learn why Stucco is such a powerfull module template. Includes a walk through
  from creating a module to publishing to the PowerShell Gallery!
draft: false
lastmod: 2023-01-08T16:41:41.521Z
slug: stucco-create-powershell-module
tags:
  - PowerShell
  - Stucco
  - TDD
  - VSCode
  - GitHub
preview: feature.jpg
type: posts
keywords:
  - powershell
  - stucco
  - tdd
  - vscode
  - github
---

It all started one summer day… just kidding! [You can skip to the "recipe" here…](#letsdo)

It's funny that I haven't written this post before. I've done talks and have
been a huge proponent for Stucco for a few years. I think I discovered it during
one of Brandon  Olin's (aka devblackops) talk.

Reason I'm a huge fan
1. Each function/cmdlet is it's own file.
2. Includes several high quality tests out of the box.
3. It auto generates your docs via PlayPS.
4. Ready for deploying the CI tool of choices.
5. VSCode configs that make developing your code easy!

> Before using Stucco I had hand crafted my modules but bespoke code is prone
to trivial errors. This becomes even more of an issue when you work on the code
as a larger team.

## psake and PowerShellBuild

One of the things that makes Stucco extremely powerful is it's use of psake and
PowerShellBuild. psake is a build system in PowerShell and PowerShellBuild is a
set of pre-defined tasks for psake. Both of these are Brandon's projects as
well!

psake allows for easy extensibility and PowerShellBuild lays down a strong
set of foundational tasks.

## Your Entry Point

After you create your first Stucco module you'll be using the `.\build.ps1`
script for essentially all your work. The tasks are called with the `-Task`
parameter. So as you write your code and you want to test, you would just call
the same build script with the Test task and everything happens.

What's everything? Clean up previous builds, stage your files, build your
documentation, run script analyzer, test your code. If you run the Publish task
you'll get all the same steps but then you'll find your modules in the PSGallery! It's that easy.

## VSCode Tasks

With the build script being the pivotal point for you to do your work, it makes
sense that exposing those commands is critical. This was another huge feature
for me. VSCode has a concept called tasks that you can call through the Command
Palette or via Shortcuts. Stucco includes all the tasks that come from
PowerShellBuild as VSCode tasks.

What's that mean for you the developer? Write code. Hit shortcut run test. Rinse
and repeat. It makes taking on Test Driven Development (TDD) very easy.

## Enough talk! Let do! {#letsdo}

At a high level we'll be doing the following
1. [Install Stucco](#install) 
2. [Create your GitHub repo and check it out](#github)
3. [Create your Stucco module](#create)
4. [Run your Test](#test)
5. [Commit your code](#commit)
6. [Prep for PSGallery](#psgallery)
7. [Publish your module](#publish)

There are some tweaks for other repositories/CI systems but if you're goal is to
write public modules, I found this to be pretty easy.

### Install Stucco {#install}

```powershell
Install-Module Stucco
```

Honestly that could be the whole thing. Under the hood Stucco depends on all the
necessary modules so when you install Stucco it'll pull down it's requirements.

### GitHub Repository {#github}

If you don't already have a GitHub account go ahead and sign up. I'll skip on
the details since there are several articles online.

You'll want to create a new repository for your module. So click on New.

{{< figure
    src="/images/2023/01/NewRepo.png"
    alt="The new repository button on GitHub"
    caption="Click on 'New' to create a new repository"
    >}}

Once you have your repository you'll want to give a name and a description. Then
you will check it out on your machine where you have Stucco installed.

### Create Your Modules {#create}

It's as simple…

```powershell 
New-StuccoModule
```

If you follow the prompts you'll get the right files. Easy! Next you'll want to
check out the repo files and layout.

Some key ones are…
- `Build.ps1`: I mentioned this above. This is the work horse of the whole
  process.
- `Requirements.ps1`: PSDepends (which the build file loads) uses this to setup
  your environment and setup any needed files/modules.
- `psakeFile.ps1`: The psake configuration.

### Run Your First Test {#test}

You now have the "Hello World" version of the module. It can actually compile
and give you a Hello World cmdlet. That should be good enough for testing.

{{< figure
    src="/images/2023/01/VSCodeTest.png"
    alt="Select the Test task to run your test."
    caption="You have all these tasks. Lets run the Test task for now."
    >}}

You can find the task under _Terminal_ -> _Run Task_ -> ___Test___.

At this point you'll see the build output. You can see how all the dependant
tasks are executed before testing.

```powershell

```

### Commit Your Code {#commit}

I prefer to check in the initial version and add each feature in separate
commits but that's just me.

```powershell
git add .
git commit -m "Initial commit!"
git push
```

### Setup PSGallery {#psgallery}

Once you have some versions checked into your repository on GitHub, you will
eventually want to create an API key.

1. Login to [PSGallery](https://www.powershellgallery.com/)
2. Create API keys
3. Copy them to your password vault.

With your key you'll want to add it to GitHub.

1. Go to your new repo and click the Settings pane
1. You want to go to __Secrets__ and then __Actions__
2. Name it `PS_GALLERY_KEY` and paste

{{< figure
    src="/images/2023/01/GitHubSecret.png"
    alt="GitHub Actions secrets pane."
    caption="Create a 'New repository secret'"
    >}}

### Publish Your Module! {#publish}

I would recommend creating a publish workflow on GitHub. You can use mine as an
example: [publish.yaml](https://github.com/HeyItsGilbert/RPGDice/blob/main/.github/workflows/publish.yaml).

My workflow does a few convenient things
1. Uses Chrissy LeMaire's [psmodulecache][psmodulecache] to speed up the builds
2. Checks if the version is already published
3. If it's newer, it attempts to Publish with the Publish task


## Wrap Up

And that's it! You now have a module that's testable, open source, and
automatically published to the PowerShell Gallery! 

There are so many more cool details I could go over but I don't was this to run
longer then it alread is. If there was anything unclear, please let me know by
adding a comment or messaging me on the various linked social medias. I hope
this was helpful and I would love to see what you publish!

## References
- [My Stucco Presentation - Doc](https://heyitsgilbert.github.io/Presentations/Stucco.html)
- [My Stucco Presentation - Slides](https://heyitsgilbert.github.io/Presentations/StuccoSlides.html)
- [Stucco on GithHb][stucco]
- [Plaster on GitHub][plaster]
- [PowerShell Module Cache GitHub Action][psmodulecache]

[plaster]: https://github.com/PowerShellOrg/Plaster
[stucco]: https://github.com/devblackops/Stucco
[psmodulecache]: https://github.com/marketplace/actions/powershell-module-cache

Cover Photo by <a href="https://unsplash.com/@chuklanov?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Avel Chuklanov</a> on <a href="https://unsplash.com/photos/IB0VA6VdqBw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  