---
title: Sharing Your Custom PSScriptAnalyzer Rules
date: 2024-09-07T22:57:34.000Z
description: Learn how using a simple "proxy" module, will allow you to use custom PSScriptAnalyzer rules in all your repositories
summary: Learn how using a simple "proxy" module, will allow you to use custom PSScriptAnalyzer rules in all your repositories!
showReadingTime: true
draft: false
preview: feature.jpeg
lastmod: 2024-09-08T16:55:20.864Z
slug: sharing-custom-psscriptanalyzer-rules
tags:
  - DevEx
  - PowerShell
  - Linting
keywords:
  - PowerShell
  - PSScriptAnalyzer
series: []
type: posts
fmContentType: posts
featureAlt: Public Domain art showing an angel.
coverCaption: Probably what PSScriptAnalyzer looks like when pointing out all my mistakes. [Source](https://www.cosmos.so/e/627080146)
---

So you've written some
[custom PSScriptAnalyzer rules](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/create-custom-rule?view=ps-modules)
for your team/org/company. You've even put them into a module for easy sharing
and you want to use that on all your projects. But how can have them run on
different repositories?

## Problem: Including Rules That Aren't... Included?

You can include
[Custom Rules](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer?view=ps-modules#custom-rules)
in your PSScriptAnalyzer Setting by pointing to the module folder or the
PowerShell module (aka `.psm1`) file. That's fine if the file or module are part
of that repository, but what happens if it's a module that could be anywhere?

PowerShell data files (aka `.psd1`) don't allow running commands within them.
That means that your PSScriptAnalyzer settings file can't dynamically determine
where to find your rules. So how do you find where your `AwesomeRulesModule` is
installed? How can you avoid hardcoding a specific path especially when modules
can live in many different places.

## Creating a Proxy Module

We need a module file that can live alongside your code repository that can
determine where the module actually is, and then export the rules for
PSScriptAnalyzer.

So we can create a file called `PSScriptAnalyzerRules.psm1` in our repository.
This can be anywhere (and named anything really) because we'll need to
explicitly point to it in our settings. Let's assume it's in the root of the
repository.

We'll need to do the following:

1. Import the module so that the functions (e.g., rules) are available.
2. Re-export the functions as if they were local
3. Try to avoid hardcoding specific rules/etc.

Here we import the module, making it's function available and using the
`-PassThru` flag to capture the output. With the rules imported, we now need to
re-export them. Since our rules were exported as Commands, we can use the
`ExportedCommands` property. The property is a hashtable, so we'll want to only
return the name of the commands which are the keys.

```powershell {title=PSScriptAnalyzerRules.psm1}
$rules = Import-Module -Name 'AwesomeRulesModule' -PassThru
Export-ModuleMember -Function @($rules.ExportedCommands.Keys)
```

And that's it. Two lines of magic to use custom rules that can come from
anywhere. You could easily add local rules or multiple modules.

## Update Your PSScriptAnalyzerSettings

So following the standard Microsoft advice, you can now point to your custom
rule path.

```powershell {title=PSScriptAnalyzerSettings.psd1}
@{
    CustomRulePath      = @(
        '.\PSScriptAnalyzerRules.psm1'
    )

    IncludeDefaultRules = $true

    IncludeRules        = @(
        # Default rules
        'PSAvoidDefaultValueForMandatoryParameter'
        'PSAvoidDefaultValueSwitchParameter'

        # Custom rules
        'Measure-*'
    )
}
```

In my experience most Custom Rules use the `Measure` verb, but make sure that
applies for your rules.

## Telling VSCode to Use Your PSScriptAnalyzer Settings

If your `PSScriptAnalyzerSettings.psd1` lives in the root of your repository,
you should be good to go. If not, you'll need to tell VSCode where to find it.
You can look for the "PowerShell › Script Analysis: Settings Path" setting or
set the following json where the value is the path to your settings file.

```json
"powershell.scriptAnalysis.settingsPath": "PSScriptAnalyzerSettings.psd1"
```
