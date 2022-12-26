+++
date = 2022-08-03T14:24:39Z
description = "Learn how to add icons to your PowerShell module."
summary = "Learn how to add icons to your PowerShell module."
draft = false
slug = "powershell_module_icons"
title = "Add an Icon to Your PowerShell Module"
+++
Recently I saw Adam Bacon talking about updating his modules and I noticed how he had icons for each of them. It really adds a level of polish and it's not much work.
  
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Well now I need to go add icons. I think me from 10 years ago would slap me if they saw me not setting icons on my work.</p>&mdash; Gilbert - Señor Systems Engineer (@HeyItsGilbertS) <a href="https://twitter.com/HeyItsGilbertS/status/1548335479799435267?ref_src=twsrc%5Etfw">July 16, 2022</a></blockquote> 
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

All of my modules are based on Stucco which uses a Psake build script. That paired with the use of a github action to publish when I push changes to main means it won't be too much effort to get them updated.

At a high level I needed to:
1. Make a list of my modules 
2. Find icons for each
3. Upload the images to Github 
4. Update the PowerShell Module Metadata file (PSD1) to point to the new image.

# Finding Icons
Most of my projects are based on Creative Commons licensed work. They also typically don't have a specific icon which meant it was really up to my taste.

RPGDice for example was easy and finding a free D20 icon that I liked just took some quick searching. Google image search has a filter where you can choose which "Usage Rights" you want. This can help steer you towards safer choices. 

{{< figure src="/images/2022/12/ImageCCSearch.png" caption="Searching for Creative Commons image on Google" >}}

# Images on GitHub
I typically don't like adding binaries to my repositories. Since these icons aren't likely to change regularly then we should be OK. 

There are a few approaches to where to store these. I went with something simple like a folder called `static`. Some people like `assets` or even `images`. At the end of the day it won't matter too much. 

You'll want to upload the image. From there we want to get a link to the actual image. You can click on the image and then click the download link.
{{< figure src="/images/2022/12/GithubURI.png" caption="Where the Download button is on Github" >}}

That should give you a URL like "https://raw.githubusercontent.com/HeyItsGilbert/MazeRats/main/static/tinymaze.png". Note the raw.githubusercontent.com url. Keep that URL handy as we'll be adding it to the PSD1 metadata file.

# PowerShell Metadata Updates
Now we can open our Module PSD1 file. Inside that you'll find an attribute called `PrivateData` which should also contain a hash called `PSData`. That should be a Hash which should contain a key called `IconUri`. You can set your icon URI to the URL you had before.

Here is an example from the MazeRats module:
```powershell
# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

  PSData = @{

    # Tags applied to this module. These help with module discovery in online galleries.
    Tags = @(
      'PoshBot',
      'DND',
      'Dice',
      'Games',
      'MazeRat',
      'OSR',
      'TTRPG',
      'PSEdition_Desktop',
      'PSEdition_Core',
      'Windows',
      'Linux',
      'MacOS'
    )

    # A URL to the license for this module.
    LicenseUri = 'https://github.com/HeyItsGilbert/MazeRats/blob/master/LICENSE'

    # A URL to the main website for this project.
    ProjectUri = 'https://github.com/HeyItsGilbert/MazeRats/'

    # A URL to an icon representing this module.
    IconUri = 'https://raw.githubusercontent.com/HeyItsGilbert/MazeRats/main/static/tinymaze.png'

    # ReleaseNotes of this module
    ReleaseNotes = 'https://github.com/HeyItsGilbert/MazeRats/blob/master/CHANGELOG.md'

  } # End of PSData hashtable

} # End of PrivateData hashtable
```

I included my entire codeblock because I think there are some good notes on other items to set in `PSData`.

Rinse and repeat for the rest of your modules, and now you have some very professional looking modules.

Let me know how they turn out! Tag me on twitter/mastadon and show off your modules! Having problems, feel free to reach out.