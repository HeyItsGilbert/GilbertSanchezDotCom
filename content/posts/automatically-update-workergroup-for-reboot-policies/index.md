+++
categories = ["Citrix", "PowerShell"]
date = 2014-08-10T21:41:41Z
description = ""
draft = false
slug = "automatically-update-workergroup-for-reboot-policies"
summary = "We are currently using two reboot policies that restart half of our servers (based on workergroups) on a weekly basis. Since we scale these environments up on a semi-regular basis it was becoming very annoying to add a server each time a new server was spun up. "
tags = ["Citrix", "PowerShell"]
title = "Automatically Update Workergroup for Reboot Policies"

+++


We are currently using two reboot policies that restart half of our servers (based on workergroups) on a weekly basis. Since we scale these environments up on a semi-regular basis it was becoming very annoying to add a server each time a new server was spun up. 

## Requirements
* Numbered servers *(e.g. End of server name 00, 02, etc.)*
* [Citrix Powershell SDK](http://www.citrix.com/downloads/xenapp/sdks/powershell-sdk.html)
* A mechanism to run this on a regular basis (Scheduled Task, etc.)
* A way to identify non-xenapp servers (Infrastructure like ZDC, etc.)
* Citrix XenApp policies to reboot the servers

## Script Step Through

1. Open powershell and load the citrix snapins `Add-PSSnapin Citrix*`
1. First we get all the servers in the zone. `$servers = Get-XAServer`
1. We pipe that list of server to our long where statement: `?{ $_.FolderPath -ne "Servers/Infrastructure" -AND ($_.ServerName.Substring( $_.ServerName.length - 2,2) % 2) -ne 0 }`
	* We are looking for two things:
		1) That the server isn't part of the *"Servers/Infrastructure"* **FolderPath**.
        2) That the last two characters are even.
    * We take the server name and get the last two chars `$_.ServerName.Substring( $_.ServerName.length - 2,2)`
    * We then get the modulus of that to see if we get any results. 0 meaning that it's even.
1. We then repeat for odds and assign to Sunday's workergroup.
1. Celebrate!

## Complete Script

```powershell
# Load Citrix Snapin's
Add-PSSnapin Citrix*

# Get all the XenApp Servers
$servers = Get-XAServer

# Set Saturday Reboot Workergroup
Set-XAWorkerGroup "Saturday Reboot" -ServerNames $( $servers | ?{ $_.FolderPath -ne "Servers/Infrastructure" -AND ($_.ServerName.Substring( $_.ServerName.length - 2,2) % 2) -ne 0 })

# Set Sunday Reboot Workergroup
Set-XAWorkerGroup "Sunday Reboot" -ServerNames $( $servers | ?{ $_.FolderPath -ne "Servers/Infrastructure" -AND ($_.ServerName.Substring( $_.ServerName.length - 2,2) % 2) -eq 0 } )
```

