---
title: PowerShell Chef Cookbook
date: 2023-10-15T23:52:43.895Z
description: A very brief intro to how you can use Meta's Chef cookbook to manage PowerShell
summary: A very brief intro to how you can use Meta's Chef cookbook to manage PowerShell
draft: true
lastmod: 2023-10-16T00:07:34.063Z
slug: powershell-chef-cookbook
tags:
  - Chef
  - PowerShell
  - Enterprise
preview: null
keywords:
  - Chef
  - PowerShell
  - Cookbook
type: posts
---

## PowerShell for an Enterprise?

While writing my last post I started adding most of what you're about to read.
Thanks to my wonderful group of editors (read: friends who I force into read my
terrible prose) it was suggested to make this its own thing.

In my last post I told you about managing an individual profile. But what if you
wanted to manage a System profile? What about doing that at scale? At Meta we
use Chef, and we publish several cookbooks for the community to use. I'm proud
to say that one of my major contributions was to the `fb_powershell` cookbook.

Some highlights:

- Profile management
- Module management
- Installing/Upgrading PowerShell and Windows PowerShell
- Managing telemetry on Pwsh

### System Profiles

I'll spare you the long explanation of API Chef cookbooks
([learn more](https://github.com/facebook/chef-cookbooks)), but the short
version is that you can include an API cookbook, and it won't do anything until
you set the appropriate attributes. All default settings are considered safe and
sane. Here is an example of how you would configure the `fb_powershell` cookbook
to manage the Systems profile.

```ruby
node.default['fb_powershell']['profiles']['AllUsersAllHosts'] = <<EOH
# Warning: System Profile being Managed By Chef!
function Start-SuperSpecialEnterpriseApp {
  # Business logic
  # Acquiring brownie points for performance review
}
EOH
```

### Installing/Upgrading PowerShell Modules

The cookbook also includes a custom resource called `fb_powershell_module` which
will use the `PowerShellGet` cmdlets to manage your modules. This is handy if
you want your module code to be available to your Chef runs. It also takes
advantage of Ruby's `Gem::Version` to try to upgrade to specific major/minor
versions if that's what you want. This is especially nice if you stick to
SemVer.

In this example, we would upgrade the `ContosoModule` to the latest 3.2 version.
So if you had `3.2.0` installed, but `3.2.1` was available, it would upgrade. It
wouldn't attempt to update to `3.3` or `4.0`.

```powershell
fb_powershell_module 'ContosoModule' do
  action :upgrade
  version '3.2'
end
```

### Disabling Telemetry

In PowerShell 7 the PowerShell team began to collect telemetry about the shells
usage and other stats. While I have no qualms sharing my own personal telemetry
with the team, this is almost always a non-starter with security teams. To
disable the telemetry a global variable `$env:POWERSHELL_TELEMETRY_OPTOUT` must
be set to `1`, `true`, or `yes`.

To easily do this with the cookbook you can set the following:

```ruby
node.default['fb_powershell']['disable_telemetry'] = true
```

An important note: This must be set **BEFORE** the shell starts. That means it
can't be set by the Profile. This presents some issues with non-windows
machines, and it's likely something I'll be exploring in the future.

---

## References

- [about_Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3)
- [about_Telemtry](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3)
- [fb_powershell cookbook](https://github.com/facebook/chef-cookbooks/tree/main/cookbooks/fb_powershell)