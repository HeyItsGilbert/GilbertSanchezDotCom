---
title: "Beyond Regex: Advanced PowerShell Code Analysis with ASTs"
date: 2025-03-12T22:43:00.0Z
description: In this post I'll be walking through an example of a (silly) request you might see at work and show you how you can leverage AST's to update your codebase.
summary: In this post I'll be walking through an example of a (silly) request you might see at work and show you how you can leverage AST's to update your codebase.
showReadingTime: true
draft: false
preview: feature.jpeg
slug: regex-advanced-powershell-code-analysis-asts
tags:
  - Linting
  - PowerShell
  - VSCode
keywords: []
series: []
type: posts
fmContentType: posts
---

In this post I'll be walking through an example of a (silly) request you might
see at work and show you how you can leverage AST's to update your codebase.

I highly recommend the official [Creating Custom Rules] Microsoft doc as they do
an excellent good job describing what's required for a PSScriptAnalyzer rule. My
goal with this post is to help explain how I would approach and inspect the
various components.

One day at work you're given a task to remove and update code across your
repositories. That could look like a few different things.

Some examples:

- Replacing old functions with new ones
- Identify the reuse of properties that should be unique (ID's)
- Looking for code that doesn't follow your orgs style

In this post we'll start with a specific example, but keep in mind that this
could apply to all sorts of things. Before we hop into the [problem](#problem)
I'll briefly cover how to inspect an AST and a few tricks on creating
scriptblocks.

## Abstract Syntax Tree - AST

An Abstract Syntax Tree (AST) is a hierarchical representation of the structure
of source code. It breaks the code down into its syntactic components like
functions, loops, and expressions. This allows us analyze and manipulate the
code more intelligently because it can understand the context and relationships
that plain text searches or regex can't capture.

### Creating & Inspecting the AST

There are several ways to look at the AST. I'll show you 3 ways to create a
scriptblock that you can inspect.

#### Inline Scriptblock

The easiest way is to create a scriptblock which is code wrapped in `{` and `}`.
Here is an example of creating a scriptblock and reading it's AST:

```powershell
$scriptBlock = {
  New-Pizza
}
```

#### Create Scriptblock via Create Method

Sometimes you want to create a scriptblock by joining different files or
creating one from a string.

```powershell
$scriptBlock = [scriptblock]::Create('New-Pizza')
```

#### Create Scriptblock via Parser

Another way to do this is create a script block from a file.

```powershell
$Tokens = $null
$Errors = $null
$scriptBlock = [System.Management.Automation.Language.Parser]::ParseFile(
  '.\PizzaGenerator.ps1',
  [ref]$Tokens,
  [ref]$Errors
)
```

{{< alert icon="star">}}
Thanks Jordan Borean for reminding me about the ParseFile method!
{{< /alert >}}

### `.AST` Property

Each of those `$scriptblock` variables would now have a property called `AST`.
This is excellect way of inspecting how your code was parsed.

### AST Types

You can run the following to get a list of all the possible AST's to target.
This grabs the AST type and looks for all the other types in the assembly. This
filters to anything that's a subclass of the AST type.

```powershell
[System.Management.Automation.Language.Ast].Assembly.GetTypes() | Where-Object {
  $_.IsSubclassOf([System.Management.Automation.Language.Ast])
}
```

## Problem

You have to identify where people are using two parameters together that
shouldn't go together. You could fix the code to warn or throw, but maybe this
work is in preparation for a future change.

Our example:

{{< lead >}}
Find all call sites of New-Pizza and find where people are
including pineapple. Corporate has decided that they want to draw a line, but
only because the price of pineapples has skyrocketed.
{{< /lead >}}

So we want to look for code that might look like this:

```powershell {title=MainExample.ps1}
# Maybe the call is on the same line
New-Pizza -Size 'Large' -Ingredients @('Ham','Pineapple')

# Or maybe the value comes from a variable
$ingredients = @('Ham','Pineapple')
New-Pizza -Size 'Medium' -Ingredients $ingredients

# Or maybe from a splat
$splat = @{
  Size = 'Small'
  Ingredients = $ingredients
}
New-Pizza @splat
```

{{< alert >}}
For the rest of the examples you can follow along by reading the
[MainExample.ps1](#problem) file from above into `$ScriptBlock`.
{{< /alert >}}

Normally you might do a simple search to fix something like the first one. Find
all lines with `New-Pizza` and contains `Pineapple`. A simple replace would
probably not suffice but a regex could (e.g. something like
`s/(New-Pizza.*)'Pineapple'(.*)/$1$2/g`). The problem is that could never work
for the other two where the value is set on other lines or in variables.
This is where AST's can help us.

## Step One: Find The Relevant Commands

The ast type has a method called FindAll that allows to quick return a list of
all the AST's that match our search. We want to find all the command calls for
`New-Pizza`. We can then later check the parameters of each.

The [FindAll method] takes a predicate (a function that returns a true or false)
and a boolean that says whether it will search recursively.

Our predicate will take in the $Ast properties and check if they're the type of
AST we care about (`CommandAst`). Then it will use a method found on
CommandAst's called `GetCommandName()` that returns a string of what the command
name is (which would be `New-Pizza` in our example). Our predicate might look
like this:

```powershell
{
  param($Ast)
  $Ast -is [System.Management.Automation.Language.CommandAst] -and
  $Ast.GetCommandName() -eq 'New-Pizza'
}
```

All together:

```powershell
$pizzas = $scriptBlock.Ast.FindAll(
  {
    param($Ast)
    $Ast -is [System.Management.Automation.Language.CommandAst] -and
    $Ast.GetCommandName() -eq 'New-Pizza'
  },
  $false
)
```

## Step Two: Get the parameters

Looking at the results in `$pizzas` you'll find that different call sites for
the New Pizza command. I suggest looking at the different properties. Later we
will make use of the extent property (which contains the value as a string, the
line numbers, and much more.) For now we'll look at the CommandElements.

CommandElements will contain a list of all the AST's the make up the command
line. The first will be a `StringConstantExpressionAst`. How do I know that?
Because that's what `New-Pizza` is! It's a `BareWord` meaning it's a string that
isn't surrounded by quotes. This means that the rest of the items compose the
list of parameters.

`CommandParameterAst` is the type of all the parameters. In a simple example we
could simply say each item after a `CommandParameterAst` is it's value. So
`-A Apple -B Bear` would be A is the `CommandParameterAst` and the value right
after would be the value being passed. For now we'll solve that and revisit the
more complex cases (e.g. variables, switches, and splats).

So we should create a simple loop and walk down the values noting where we find
`CommandParameterAst` and grabbing the values for the item right after.

For this example let's just grab the first one and set it as `$CommandAst`. Then
we will inspect it to get the values.

```powershell
$CommandAst = $pizzas[0]
$commandElements = $CommandAst.CommandElements
# Create a hash to hold the parameter name as the key, and the value 
$parameterHash = @{}
for($i=1; $i -lt $commandElements.Count; $i++){
  # Switch on type
  switch ($commandElements[$i].GetType().Name){
    'CommandParameterAst' {
      $parameterName = $commandElements[$i].ParameterName
    }
    default {
      # Grab the string from the extent
      $value = $commandElements[$i].SafeGetValue()
      $parameterHash[$parameterName] = $value
    }
  }
}
```

So now we have the command and it's parameters.The next thing would be to find
where the value of the Ingredients property contains `Pineapple`.

```powershell
# You might want to skip any call sites where maybe the ingredients parameter isn't set.
if(-not $parametersHash.ContainsKey('Ingredients')){ continue }
# Now we want to check if the Ingredients parameter contains Pineapple
if($parametersHash['Ingredients'].Contains('Pineapple')){
  # If we're in this block then we know this call needs fixing!
}
```

## Step Four: The Extent

So we're looping through the code and we've found a block that might need to be
fixed. How do we where that is? What does that line in the code look like? This
is where the extent can help us.

```powershell
# Let's look at the CommandAST
$CommandAst.Extent
```

The extent property contains information on the script position, start/end line
and column numbers. It also contains the `Text` representation of the command.

The extent is what PSScriptAnalyzer uses to figure out what to highlight. It's
also how VSCode can highlight what text needs to be fixed.

## Step Five: Write a Rule

Taking what we learned up to this point we have enough to write a basic rule to
identify any `New-Pizza` calls with a `Pineapple` ingredient.

```powershell {title=Measure-PineappleOnPizza.ps1}
<#
.SYNOPSIS
Checks for Pineapple used with New-Pizza
.DESCRIPTION
Contaso has decided that pineapple is no longer allowed. 
.EXAMPLE
Measure-PineappleOnPizza -ScriptBlockAst $ScriptBlockAst
.INPUTS
[System.Management.Automation.Language.ScriptBlockAst]
.OUTPUTS
[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
.NOTES
None
#>
function Measure-PineappleOnPizza
{
  [CmdletBinding()]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.Language.ScriptBlockAst]
    $ScriptBlockAst
  )

Process
  {
    $results = @()
    try
    {
      # Finds all New-Pizza
      [ScriptBlock]$predicate = {
          param($Ast)
          $Ast -is [System.Management.Automation.Language.CommandAst] -and
          $Ast.GetCommandName() -eq 'New-Pizza'
      }
      [System.Management.Automation.Language.Ast[]]$pizzas  = $ScriptBlockAst.FindAll($predicate, $true)
      foreach($CommandAst in $pizzas){
        $commandElements = $CommandAst.CommandElements
        #region Gather Parameters
        # Create a hash to hold the parameter name as the key, and the value 
        $parameterHash = @{}
        for($i=1; $i -lt $commandElements.Count; $i++){
          # Switch on type
          switch ($commandElements[$i].GetType().Name){
            'CommandParameterAst' {
              $parameterName = $commandElements[$i].ParameterName
            }
            default {
              # Grab the string from the extent
              $value = $commandElements[$i].SafeGetValue()
              $parameterHash[$parameterName] = $value
            }
          }
        }
        #endregion

        # Skip any call sites where maybe the ingredients parameter isn't set.
        if(-not $parametersHash.ContainsKey('Ingredients')){ continue }
        # Now we want to check if the Ingredients parameter contains Pineapple
        if($parametersHash['Ingredients'].Contains('Pineapple')){
          # If we're in this block then we know this call needs fixing!
          $result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
              'Message' = "Didn't you get the memo? No more pineapple on pizza!"
              'Extent' = $CommandAst.Extent
              'RuleName' = $PSCmdlet.MyInvocation.InvocationName
              'Severity' = 'Information'
          }
          $results += $result
        }
      }
      return $results
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
  }
}
```

---

## Read More

This is an extremely complex topic. Don't get discouraged if it doesn't click
immediately or you're having trouble understanding. I recommend reading a few
other great posts.

- [Runspaces Simplified (as much as possible)]
- [Searching the PowerShell Abstract Syntax Tree]
- [Using the AST to Find Module Dependencies in PowerShell Functions and Scripts]
- [Learn about the PowerShell Abstract Syntax Tree (AST) - Part 2]

[Runspaces Simplified (as much as possible)]: https://blog.netnerds.net/2016/12/runspaces-simplified/
[Searching the PowerShell Abstract Syntax Tree]: https://vexx32.github.io/2018/12/20/Searching-PowerShell-Abstract-Syntax-Tree/
[Using the AST to Find Module Dependencies in PowerShell Functions and Scripts]: https://mikefrobbins.com/2019/05/17/using-the-ast-to-find-module-dependencies-in-powershell-functions-and-scripts/
[Learn about the PowerShell Abstract Syntax Tree (AST) - Part 2]: https://mikefrobbins.com/2018/10/24/learn-about-the-powershell-abstract-syntax-tree-ast-part-2/
[Creating Custom Rules]: https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/create-custom-rule?view=ps-modules
