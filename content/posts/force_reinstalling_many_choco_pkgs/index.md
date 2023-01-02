+++
date = 2022-10-27T21:59:01.000Z
description = "A quick walk through and script on force reinstalling Chocolatey apps."
summary = "A quick walk through and script on force reinstalling Chocolatey apps."
draft = true
slug = "force-reinstalling-choco-packages"
title = "Force Reinstalling Many Choco Packages"
keywords = [ "powershell", "chocolatey" ]
lastmod = "2023-01-02T16:11:49.213Z"
tags = [ "Chocolatey", "PowerShell" ]
type = "posts"
+++

Earlier this year a made a pretty nasty mistake that resulted in several
Chocolatey packages to get partially removed. I say partially because the binary
files were gone but the Chocolatey metadata was still in tact.

## Situation

## Problem

## Action

## Resolution

Choco supports pointing to an xml. Stuff

Our issue

```powershell
# Get a list of all your local (-l) choco apps in a simple to parse (-r) format 
$apps = choco list -lr

# Select a subset off apps that you want to reinstall
$regex = '^YourRegExPatternHere$'
$subset = $apps | Select-String -Pattern $regex

# Begin building the XML
$xmlObjectsettings = New-Object System.Xml.XmlWriterSettings
$xmlObjectsettings.Indent = $true

# Where you want to save your file. It should have .config extension
$XmlFilePath = "C:\tools\package_fix.config"
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
