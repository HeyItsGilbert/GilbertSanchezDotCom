+++
date = 2014-02-04T06:09:16.000Z
description = "A walkthrough on making a CIDR calculator for Alfred."
draft = false
aliases = [ "/cidr-calculator-for-alfred/" ]
slug = "cidr-calculator-for-alfred"
summary = "A walkthrough on making a CIDR calculator for Alfred."
tags = [ "OSX" ]
title = "CIDR Calculator for Alfred"
keywords = [ "cidr", "networking", "alfred", "macos", "subnet calculator" ]
lastmod = "2025-11-27T16:59:34.405Z"
preview = "feature.webp"
+++


Often throughout my day to day work I find myself looking for a quick CIDR
conversion. Something that was lightweight to use and didn't require switching
around my applications. > What was the mask for a /22? How many servers can fit
on that mask?

I've been running Alfred with the Powerpack for a while and I figured this
should be a fairly straight forward process. After some seaches for a CLI tool I
came accross whatmask. I then became sorting out how to feed this to Alfred and
get useful results.

{{< figure src="/images/2018/03/VqMR3ah.webp" caption="Screenshot showing the calculator in action!" >}}

## Requirements

* [Alfred + Powerpack](http://www.alfredapp.com/)
* [homebrew](http://brew.sh/)
* [whatmask](http://www.laffeycomputer.com/whatmask.html)
* [CIDR Calculator Workflow by yours truly](http://bit.ly/MqZBnq)

### Install Pre-Requisites

I recommend installing Alfred + Powerpack and homebrew first. Using homebrew you
can install whatmask fairly easily: `brew install whatmask`.

## Explanation of Workflow

### Step 1: CIDR Calculator Workflow

Here is the php code that's actually running against whatmask. It takes all the
lines with useful information and returns them as options for Alfred.

This code uses the Workflows.php class by David Furguson
(<http://dferg.us/workflows-class/>)

```php
require('workflows.php');
$w = new Workflows();

$resultLines = array();
$returnCode = 0;
exec('/usr/local/bin/whatmask {query} | grep -v "^[ -]"', $resultLines, $returnCode);

if ($returnCode != 0)
{
 $w->result('na', 'na', "Error when looking up \"{query}\"", "Return code: $returnCode", 'icon.png', 'no');
}

foreach ($resultLines as $line)
{
 $w->result('na', $line, $line, '', 'icon.png', 'yes');
}

echo $w->toxml();
```

### Step 2: Clean Up Selection

The content of that workflow is then piped to
`echo "{query}" | sed 's/.*\: \(.*\)$/\1/g'` to return only the necessary data.

### Step 3: Print and Put in Clipboard

That then is passed to Large Type (cause why not?) and then to the clipboard
(the actual useful bit).
