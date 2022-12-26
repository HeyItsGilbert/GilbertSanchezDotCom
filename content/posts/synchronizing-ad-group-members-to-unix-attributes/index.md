+++
date = 2015-09-30T17:30:58Z
description = "Easily synchronize unix group members (in AD) with the current AD group members."
summary = "Easily synchronize unix group members (in AD) with the current AD group members."
draft = false
slug = "synchronizing-ad-group-members-to-unix-attributes"
tags = ["PowerShell", "Active Directory"]
title = "Synchronizing AD Group Members to Unix Attributes"
+++


Auditors are sticklers (as they're meant to be). They, like many of us in the IT world, want clean data. So what happens when you grant a user unix access via AD but don't clean it up?

# What
A disabled AD account with unix access cannot login, but would still show up in our reports. This made for a lot of questions from auditors which equals sad sysadmins.

# How
I decided to solve this using by using our AD groups. As part of our term process we remove the termed employee from any group they were a part of (distribution and security). So, for us, the source of truth was AD.

# Prerequisites
* Powershell
* Quest Powershell Modules
* Scheduling mechanism (Task, etc.)

# Complete Code
```powershell
$groups = Get-QADGroup -SearchRoot "company.com/UnixGroups"
foreach ($group in $groups) {
  # Get Members
  $members =  Get-QADGroupMember $group -Type 'user' -Indirect
  # Check if no members
  if($members.Count -gt 0) {
    # Blank arrays
    [array]$dn = @()
    [array]$sam = @()
    # Loop through each
    foreach ($member in $members) {
      $user = Get-QADUser $member -IncludedProperties uidNumber
      # Add unix attributes if missing.
      if (!$user.uidNumber) {
          $ypDomain = Get-QADObject -Identity "cn=company,cn=ypservers,cn=ypserv30,cn=RpcServices,cn=system,dc=company,dc=com" -IncludedProperties msSFU30MaxUidNumber
          $uid = $ypDomain.msSFU30MaxUidNumber
          $maxUidNumber = $uid + 1
          Set-QADUser -Identity $user -ObjectAttributes @{
              msSFU30NisDomain='company';
              uidNumber=$uid;
              loginShell='/bin/bash';
              unixHomeDirectory="/home/$Identity";
              gidNumber='100';
            }
          # Update upDomain
          $ypDomain | Set-QADObject -objectAttributes @{msSFU30MaxUidNumber = $maxUidNumber}
      }
      # Add to array of users
      $sam += $user.SamAccountName
      $dn += $user.DN
    }
    # Add to group unix attributes
    Set-QADGroup $group -ObjectAttributes @{msSFU30PosixMember=$DN;memberUid=$sam}
  }
}
```

At some point I'll rewrite this to not use the Quest modules because less dependancies are better.

