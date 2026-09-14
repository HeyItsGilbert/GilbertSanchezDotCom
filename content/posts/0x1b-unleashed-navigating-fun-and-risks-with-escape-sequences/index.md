---
title: "0x1B Unleashed: Navigating Fun & Risks with Escape Sequences"
date: 2023-11-05T00:00:07.246Z
description: Color your console? Yes! Arbitrary code execution? Uh oh... yes.
summary: Color your console? Yes! Arbitrary code execution? Uh oh... yes.
draft: true
lastmod: 2026-04-18T00:52:49.715Z
slug: escape-code-unleashed
tags:
  - PowerShell
  - WezTerm
preview: feature.png
keywords:
  - escape sequence
  - shell
  - terminal-series
type: posts
series:
  - Terminals, Shells, and Prompts
series_order: 4
---

This is the fourth post in my series about Shells and Terminals.

This post like so many is long overdue. But on the positive side this could not come at a better time.
The AI revolution is here and the TUI is seeing a resurgence. So how do these programs works? How does
an agent draw a cute little robot or show a chat? Clickable links? How does vscode know what command
you just ran? It all starts with escape codes.

## Escape Codes

If we take a look at terminals in their first incarnations.

```powershell
$([char]27)   # PowerShell 5 Compatible
`e            # PowerShell 7
```

## Make it Beautiful

## Shell Integrations

There are many terminals that have created or look for special escape sequences. They can be a signal
to your terminal that they can render something functionally new beyond just color.

### Last Command Status

Have you ever noticed how newer version of VSCode can tell when your last command failed? This isn't
unique to vscode.

```powershell
# Have we actually run anything?
if ($global:shellIntegrationGlobals.lastCommand) {
  $exitCode = $global:shellIntegrationGlobals.getExitCode.Invoke($lastCommandStatus)
  $commandFinished = "$([char]27)]133;D;$exitCode$([char]7)"
} else {
  # No command, just means `eD
  $commandFinished = "$([char]27)]133;D$([char]7)"
}
```

## Dark Side

## Example

This is code originally written by mdgrs and modified by myself because I wanted WezTerm support.

```powershell
$function:global:Prompt = {
    $lastCommandStatus = $?

    if ($global:shellIntegrationGlobals.lastCommand) {
      $exitCode = $global:shellIntegrationGlobals.getExitCode.Invoke($lastCommandStatus)
      $commandFinished = "$([char]27)]133;D;$exitCode$([char]7)"
    } else {
      $commandFinished = "$([char]27)]133;D$([char]7)"
    }

    $currentLocation = $ExecutionContext.SessionState.Path.CurrentLocation
    switch ($global:shellIntegrationGlobals.terminalProgram) {
      'WindowsTerminal' { $setWorkingDirectory = "$([char]27)]9;9;`"$currentLocation`"$([char]7)" }
      'ITerm2' { $setWorkingDirectory = "$([char]27)]1337;CurrentDir=$currentLocation$([char]7)" }
      'WezTerm' {
        $provider_path = $currentLocation.ProviderPath -replace "\\", "/"
        $setWorkingDirectory = "$([char]27)]7;file://${env:COMPUTERNAME}/${provider_path}$([char]27)\"
      }
    }

    $promptStarted = "$([char]27)]133;A$([char]7)"
    $commandStarted = "$([char]27)]133;B$([char]7)"
    $prompt = $global:shellIntegrationGlobals.originalPrompt.Invoke()

    $commandFinished + $promptStarted + $setWorkingDirectory + $prompt + $commandStarted
}
```