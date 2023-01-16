+++
date = "2023-01-15T18:12:18.706Z"
description = "A quick walk through and script on force reinstalling Chocolatey apps."
summary = "A quick walk through and script on force reinstalling Chocolatey apps."
draft = false
slug = "force-reinstalling-choco-packages"
title = "Force Reinstalling Many Choco Packages"
keywords = [ "powershell", "chocolatey" ]
lastmod = "2023-01-16T19:32:06.122Z"
tags = [ "Chocolatey", "PowerShell" ]
type = "posts"
+++

Earlier last year a made a pretty nasty mistake that resulted in several
Chocolatey packages getting partially removed. I say partially because the
binary files were gone but the Chocolatey metadata was still in tact.

## Configuration Management should fix this… right?

Now normally if something gets uninstalled a configuration manager would attempt
to reinstall, but because the Chocolatey metadata still shows as installed, the
config manager would skip it. So how can we fix it?

## Chocolatey Packages.config

Chocolatey supports pointing to an XML manifest file as a source of the packages
needing to be installed. See
[Packages.config](https://docs.chocolatey.org/en-us/choco/commands/install#packages.config).
For our example we want something simple with just a package id and a version.

## Let's create our packages.config

Let's get a list of our packages in a format that's easily parsable with the
LimitOutput flag `-r`. We also only want local packages so we'll use the local
flag `-l`.

{{< alert "circle-info" >}}
The `-r` returns a list with a `|` as a delimiter.
{{< /alert >}}

```powershell
$apps = choco list -lr
```

`$apps` at this point is all our apps so we'll want to filter it down. We will
want to create a pattern match to identify our packages (if possible). In the
following example I'll search for all packages that start with `foo`.

```powershell
$regex = "^foo"
$subset = $apps | Select-String -Pattern $regex
```

You'll probably want to inspect this to make sure you have all your expected
packages.

From here you'll need to create the XML. Luckily PowerShell has the
`System.XML.XmlWriter` object. I'll spare you the gory bits (which you can see
in the complete script), but at a high level it…

1. Sets up the XML settings (indentation)
2. Creates an XML file with the settings
3. Starts creating the XML content with the `packages` element
4. Loops over each app in `$subset` and adds a `package` element
5. Ends the `packages` elements
6. Closes and writes the file

## Complete Script

I put the two variables you'll need to edit at the top. The script won't execute
anything other then creating a config file. You'll still need to ask choco to
install it.

```powershell
# Update fhe following tool for your scenario
$regex = '^YourRegExPatternHere$'
# Where you want to save your file. It should have .config extension
$XmlFilePath = "C:\tools\package_fix.config"

# Get a list of all your local (-l) choco apps in a simple to parse (-r) format 
$apps = choco list -lr

# Select a subset off apps that you want to reinstall
$subset = $apps | Select-String -Pattern $regex

# Begin building the XML
$xmlObjectsettings = New-Object System.Xml.XmlWriterSettings
$xmlObjectsettings.Indent = $true

$XmlObjectWriter = [System.XML.XmlWriter]::Create(
  $XmlFilePath,
  $xmlObjectsettings
)
$XmlObjectWriter.WriteStartDocument()
$XmlObjectWriter.WriteStartElement("packages")

# Create an XML element for each package in the subset
# Should look like: <package id="git" version="2.12.0.2" />
$subset | ForEach-Object {
  $name, $ver = $_.ToString().Split('|')
  $XmlObjectWriter.WriteStartElement("package");
  $XmlObjectWriter.WriteAttributeString("id", $name);
  $XmlObjectWriter.WriteAttributeString("version", $ver);
  $XmlObjectWriter.WriteEndElement();
}

# Close the packages element
$XmlObjectWriter.WriteEndElement()

# Finally close the XML Document
$XmlObjectWriter.WriteEndDocument()
$XmlObjectWriter.Flush()
$XmlObjectWriter.Close()

Write-Host "Now you can run: choco install -fy $XmlFilePath"
```

## Resolution

Now with the script we've created an XML file that we can point Chocolatey to.
The last output will be a command you can copy and paste to have choco do the
install.

While my example started with a need to reinstall, you could imagine a scenario
where we want to generate a set of files to install. Let me know if you think of
anything cool!

Photo by <a href="https://unsplash.com/@brett_jordan?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Brett Jordan</a> on <a href="https://unsplash.com/photos/ehKaEaZ5VuU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  