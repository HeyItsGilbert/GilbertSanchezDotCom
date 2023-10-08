---
title: PowerShell Chef Cookbook
date: 2023-10-08T02:51:05.042Z
description: ""
summary: ""
draft: true
lastmod: 2023-10-08T02:51:27.614Z
slug: ""
tags: []
preview: feature.png
keywords: <failed to process>
type: posts
---

## PowerShell for an Enterprise?

So far I've been talking about an individual profile. But what if you wanted to
manage a System profile? What about doing that at scale?

At Meta we use Chef, and we publish several cookbooks for the community to use.
I'm proud to say that one of my major contributions was to the `fb_powershell`
cookbook.

### System Profiles

I'll spare you the long explanation of API Chef cookbooks
([learn more](https://github.com/facebook/chef-cookbooks)) but here is an
example of how you would configure this to manage the Systems profile.

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

---

## References

- Optimizing your $Profile https://devblogs.microsoft.com/powershell/optimizing-your-profile/
- about_Profiles https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3
- fb_powershell cookbook https://github.com/facebook/chef-cookbooks/tree/main/cookbooks/fb_powershell