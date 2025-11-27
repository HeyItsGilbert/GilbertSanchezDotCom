---
title: "Efficient Disasters: Remove-Item In the Pipeline"
date: 2023-01-31T03:29:44.653Z
description: I walk through my most painful mistake of 2022. Using Remove-Item in a Pipeline can be efficient, but it can also be a disaster.
summary: I walk through my most painful mistake of 2022. Using Remove-Item in a Pipeline can be efficient, but it can also be a disaster.
draft: false
lastmod: 2025-11-27T16:42:59.583Z
slug: efficient-disasters-remove-item-pipeline
tags:
  - PowerShell
  - Chocolatey
preview: feature.webp
type: posts
keywords:
  - powershell
  - remove-item
  - delete
  - disaster
  - chocolatey
  - pwsh
---

Today's post was about one of my major mistakes last year. I'm hoping ya'll can
learn from it.

___tl;dr be extra careful with Remove-Item. Also, catching all errors can mask
problems___

{{< alert >}}
Remember: Disasters are often just a series of small mistakes.
{{< /alert >}}

At work I found a package that was failing on a sizeable portion of our fleet.
When I dug into it I realized the package was using `Get-ChocolateyUnzip` to
unzip to a directory. The problem was that the directory was for a program that
was in use and the unzip command would fail.

___Mistake #1___: Instead of finding the package owner and convincing them to
use a proper install format (e.g. msi/x) I decided I could be clever.

This pattern of attempting to overwrite in-use files is common mistake for those
who aren't familiar with Windows. When a file is opened, Windows locks it to
ensure you don't have conflicting writes. This means that nothing can change
them while they're being used. One approach is to prompt the user to stop the
app/service using them, but that doesn't work when it's a package manager
working behind the scenes. An alternative approach is to move the files.

## FileLocks and Moves

___Move!?!___ Yes. An overwrite is really just a delete and create on Windows. But a
move is considered valid because the system understands that it needs to follow
the file while the application is still running.

While moving solves the issue of writing the new version to disk, it does leave
us with a new problem. We need to clean up the files from the existing version,
and those are likely still file locked.

In comes our primary antogonist, `Remove-Item`. We know it can be dangerous to
use programatically but sometimes it's necessary. One common mistake is to pass
it the recurse flag, which can be disastrous if the path is not explicit.
Another reason we don't want to use `Remove-Item -Recurse` on this folder
because it'll fail on the first file lock.

To avoid letting Remove-Item blindly remove files, we will first get a list of
files with `Get-ChildItem`. This returns a series of objects which represent
the files, including the full path, name, permissions, etc. These objects are
`System.IO.FileInfo` type and have been around since the early days of
PowerShell.

## System.IO.FileInfo, Current Object, and PS5.1

Now with a list of files we can iterate and attempt to `Remove-Item`. We also
expect some files to be locked, so we need to catch Remove-Item errors so that
we can try to remove them with another method.

```powershell
$oldFiles = Get-ChildItem -Recurse $oldPath
$oldFiles | ForEach-Object {
  try {
    $filename = $_.FullName
    Remove-Item $_ -Force -ErrorAction Stop
  } catch {
    # Code to clean up on reboot
  }
}
```

What about `$filename`? So in the catch code block we need to convert the object
to a single string. Having been bit by a bad `Remove-Item` command in the past I
wanted a property that was fully qualified (full path).

___Mistake #2___: The goal was to actually use `$filename` with the
`Remove-Item` but it was missed during development.

But guess what? This is valid PowerShell. This should work because we're passing
the full object…

___Mistake #3___: Unlike PowerShell 7, `Remove-Item` in PowerShell 5.1 uses the
name property.

So this means if we're trying to remove foo.exe it would essentially be doing
`Remove-Item foo.exe` instead of `Remove-Item C:\tools\foo\foo.exe`. ___Mistake
#4___: Because we were expecting locked files that were going to throw, we were
capturing the errors (instead of just specific errors).

## Why didn't this show up in testing?

I prefer PowerShell 7 as my daily driver. That's what I default to in VSCode
which is where I write most of my code. Because of my paranoia around
`Remove-Item` I tested regularly on my machine.

{{< alert >}}
Let this be a reminder that "my machine" will not always match prod!
{{</ alert >}}

One scenario I didn't account for was the difference between package versions. I
was testing version A to C when the issue was actually limited to going from B
to C.

___Mistake #5___: Going from A to C on my machine, I didn't see any
folders getting removed. When checking the second removal method the $filename
variable was used further giving me a false sense of confidence.

Once this was landed the fleet was monitored to look for any errors. The problem
is that we only monitor our specific environment and this package was used by
many.

___Mistake #6___: Not having a good way to track packages being rolled out
across different environments.

## Takeaways

While this resulted in pain outside of my group, I am still responsible for not
accounting for other environments/use cases. Like I mentioned at the top, a
disaster is rarely a single large event and more a series of smaller ones. If
you're curious about how we recovered, you can check out [Force Reinstalling Many Choco Packages]({{<ref "force-reinstalling-choco-packages">}}).

Let's go over each mistake and call out some alternatives that could have saved
us all this headache.

### Mistakes

> Instead of finding the package owner and convincing them to use a proper
> install format (e.g. msi/x) I decided I could be clever.

I should have found the package owner and figured out how to use a better
install format. This would help them level up their skills and possibly call out
some environments I failed to account for. _Note to self: You're not that
clever!_ :laughing:

> The goal was to actually use `$filename` with the `Remove-Item` but it was
> missed during development.

This one is tough. You could rely on static analysis, but because the variable
was used later it wouldn't show up. I could write a linter that looks for
`Remove-Item $_` and throw a warning for myself.

> Unlike PowerShell 7, `Remove-Item` in PowerShell 5.1 uses the name property.

When working on code that will be executed in Windows PowerShell, make sure
you're testing in that version!

> Because we were expecting locked files that were going to throw, we were
> capturing the errors (instead of just specific errors).

As hinted, we should really be looking for a specific error. Capturing all
errors is prone to mask problems. I highly recommend Kevin Marquette's article: [PowerShell: Everything you wanted to know about
exceptions
](https://powershellexplained.com/2017-04-10-Powershell-exceptions-everything-you-ever-wanted-to-know/).

> Going from A to C on my machine, I didn't see any folders getting removed.

> Not having a good way to track packages being rolled out across different
> environments.

I think both of those really are solved by having better data on what packages
are being used and where. Had I known that B was actually in use, I could have
tested for that scenario.

---

I literally saw this coming since I was cautious about using `Remove-Item` and
still stepped on this land mine. By sharing my mistakes I hope that you come to
realize that no one is perfect, or at least you had a good laugh!

Thanks to [Steven Judd](https://twitter.com/stevenjudd) for reviewing this post!
If only I had you review my PR…

Photo by <a href="https://unsplash.com/de/@sigmund?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Sigmund</a> on <a href="https://unsplash.com/photos/jZXZvw2CdqY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  