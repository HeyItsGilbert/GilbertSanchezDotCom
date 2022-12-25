+++
categories = ["Citrix", "PowerShell"]
date = 2014-03-18T16:04:43Z
description = ""
draft = false
slug = "locating-empty-citrix-worker-groups"
tags = ["Citrix", "PowerShell"]
title = "Locating Empty Citrix Worker Groups"

+++


I have an environment that is currently transitioning from ~20 workergroups down to about 5. This tranisition includes moving to a "common" workergroup that will contain most of the users. As we transition groups we found that many of the older groups were deprecated and have no members. Rather than dig into the 50+ servers, we'll use a little bit of powershell magic to find the answer.

### Prerequisite
* Citrix powershell modules.
* Powershell v3 (not required but the customobject code is written in v3)

#Code

## Explanation

* First we must get all the worker groups with `Get-XAWorkerGroups`
* Then for each of those we have get all the applications with `Get-XAApplications` and save that as Count
* While we're at it we'll also get a list of all the servers (for later clean up)

## Complete Code

```powershell
get-xaworkergroup * -ComputerName ZDCSERVER.domain | Foreach {
  [pscustomobject]@{
    Name=$_.WorkerGroupName;
    Count=$(Get-XAApplication -WorkerGroupName $_.WorkerGroupName).Count;
    Servers=$(Get-XAServers -WorkerGroupName $_.WorkerGroupName);
    }
  }
```

You can save that to a variable and sort it using ```$var | ?{ $_.Count -eq "0" }```

---

Hopefully this helps you out. If you have any questions, feel free to contact me using the contact form linked at the top!

