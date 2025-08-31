---
title: "¿No Habla Inglés?: PowerShell Localization in Practice"
date: null
description: "PowerShell localization made simple: step-by-step localization, community-driven translations, and best practices for developers."
summary: PowerShell is global, but not everyone works in English. Let’s look at how localization works, how you can add it to your modules, and how to make it easy for your community to contribute translations
showReadingTime: true
draft: true
preview: feature.png
lastmod: 2025-08-31T01:10:11.780Z
slug: no-habla-ingles-powershell-localization-practice
tags:
    - GitHub
    - PowerShell
    - VSCode
    - FOSS
keywords:
    - GitHub
    - Localization
    - PowerShell
    - FOSS
series: []
type: posts
fmContentType: posts
---

[I know localization is important...](#localization-in-powershell)

If your primary language is English, and you haven't traveled it's
easy to forget that there's an entire globe of people who don't speak
English. Maybe you've visited a neighborhood where the primary language
is different, and can remember how disorienting that can be.

I'm a first generation Mexican American, aka Chicano, who grew up in a home
where the primary language was Spanish. I only spoke Spanish until the age
of 5, where in first grade I was placed (due to classroom limits) into an
English speaking classroom. I definitely struggled that year, but thanks
to my family my brother and I quickly transitioned. (Also thank you video
games). But I'll never forget having to leave the safety of my friends
and being placed into a room where communication capabilities where

PowerShell is one of the languages that makes Localization very easy to
implement. But what is Localization (l10n)? Is that different from
Internationalization (i18n)?

## Localization in PowerShell

PowerShell luckily provides us an easy way to create a variable that contains
our text. We can simply create a PowerShell Data file (PSD1) and import it
with `Import-LocalizedData`. Let's see it in action.

In our `.\en-US\Messages.psd1`:

```powershell file=.\en-US\Messages.psd1
ConvertFrom-StringData @'
Welcome = "Welcome to the jungle!"
Goodbye = "Bye, bye, bye, lil Sebastian."
LaughError = "HAHA! Error: {0}"
'@
```

In the `.\main.ps1` script:

```powershell file=.\main.ps1
Import-LocalizedData -BindingVariable "Messages" 
Write-Host $Messages.Goodbye
```

If you run the `main.ps1` file it'll output:

```powershell
> .\main.ps1
Bye, bye, bye, lil Sebastian.
```

Great! I mean we got the expected text... but RIP lil Sebastian.

![Lil Sebastian, a tiny horse, running surrounded by clouds.](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExd3FrY2hoZGwxZDJ3ZGUwZ2k4MDkxMWpsOGRuczdpeTc0cnEycXVrZyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/8pDBtEATQlPZ9gFqXi/giphy.gif)

## Let's Support A New Language

The `Messages.psd1` contains the key and values of our text. To support a new
language you'll need to make the same file, but under a new folder. The folder
would match the new supported language. To support US Spanish you could create
`.\es-US\Messages.psd1`. The file would look like:

```powershell file=.\es-US\Messages.psd1
ConvertFrom-StringData @'
Welcome = "¡Bienvenido a la jungla!"
Goodbye = "Adiós, adiós, adiós, pequeño Sebastian."
LaughError = "¡JAJA! Error: {0}"
'@
```

{{< alert >}}
Note that the keys stay the same, but the values change.
{{< /alert >}}

## VSCode PowerShell Localization

Localization is important to me especially with how easy PowerShell makes it to
support. One challenge that I experienced was that it's often difficult to tell
what a particular localized variable says.

As part of the PS Inclusive Organization that I started with Jake Hildreth, I
decided to make an attempt at creating a VS Code extension. I was able to create
the [PowerShell Localization] extension which allows you to see values decorated
inline.

![example of PowerShell Localization extension](image.png)

You can install the extension to make it easier to see what you're code would
output.

## Community Support

So we've created 2 language files to support `en-US` (US English) and `es-US`
(US Spanish), but what about all the other languages? This is where a community
supporting program like [Crowdin] can be immensely helpful. While there are obvious
paid features, for open source software you can actually create a free project.

For end users who would like to contribute, they would submit their suggestions
on the project portal. This could go through review and then sync to your codebase.
You can see an example of that portal at [Psake translation project on Crowdin].

There are several approaches to syncing changes from Crowdin, but I'm a fan of the
GitHub Integration. You can define the English source, and where the outputted files
would be called and where to place them.

### Localizations as PSD1 vs YML

The PowerShell Data format has some limitations that can make it difficult to
use. The PSD1 format is not a format supported by Crowdin. Inside of the psd1
files, we're limited to a certain set of functions. For example,
`ConvertFrom-JSON` is not available. `ConvertFrom-StringData` is the most common
to use.

YAML is another file type supported in Crowdin. It can be read without modifying
the keys (which other formats do) making it an ideal format to use as a source.

Thanks to the `powershell-yaml` module we can `ConvertFrom-Yaml` and use our
PowerShell knowledge to generate our desired formats.

### Psake: An Example

For the Psake project I decided that it would be easier to generate the PSD1's
as part of the build process and to start with yml files. Using the psd1 file
would mean that Crowdin wouldn't be able to read it automatically and I wanted
this to be as easy for contributors and maintainers as possible.

Here is process in a graph:

{{< mermaid >}}
graph TD
    A["/l10n/en-US.yml<br/>(Source File)"] --> B["Build Script<br/>(Process l10n folder)"]
    
    %% Other l10n files
    C["/l10n/es-ES.yml"] --> B
    D["/l10n/fr-FR.yml"] --> B
    E["/l10n/de-DE.yml"] --> B
    F["...other l10n files"] --> B
    
    %% Build script outputs
    B --> G["src/en-US/Messages.psd1"]
    B --> H["src/es-ES/Messages.psd1"] 
    B --> I["src/fr-FR/Messages.psd1"]
    B --> J["src/de-DE/Messages.psd1"]
    B --> K["...other culture folders"]
    
    %% Git sync to Crowdin
    A --> L["Git Sync to Crowdin"]
    L --> M["Crowdin Project<br/>(en-US as source)"]
    
    %% Crowdin creates/updates translations
    M --> N["Crowdin creates/updates:<br/>- es-ES.yml<br/>- fr-FR.yml<br/>- de-DE.yml<br/>- ...other cultures"]
    
    %% Sync back to repo
    N --> O["Sync back to repo<br/>(Update l10n files)"]
    O --> C
    O --> D
    O --> E
    O --> F
    
    %% Styling
    classDef sourceFile fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef buildScript fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef outputFiles fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef crowdinProcess fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    
    class A sourceFile
    class B buildScript
    class G,H,I,J,K outputFiles
    class L,M,N,O crowdinProcess
{{</ mermaid >}}

1. **Source File**: `/l10n/en-US.yml` serves as the primary source for all localization strings
   ```yaml
    en-US:
     error_invalid_task_name: "Task name should not be null or empty string."
     ...
   ```

2. **Build Process**: A build script reads all YAML files in the `/l10n/` directory
3. **Output Generation**: For each language file, creates corresponding PowerShell data files in `src/{culture}/Messages.psd1`
4. **Crowdin Integration**:
   - Git sync pushes the source file (`en-US.yml`) to Crowdin
   - Crowdin uses this as the source for translation
   - Translators work on other language versions
   - Completed translations sync back to the repository as new/updated YAML files
5. **Continuous Loop**: Updated translations trigger the build process again, creating fresh PowerShell message files

This creates a complete localization pipeline where:

- Developers maintain the English source
- Build automation handles PowerShell file generation
- Crowdin manages the translation workflow
- The process repeats as translations are updated

Our `crowdin.yml` file contains the following which automatically determines the filename.

```yml file:crowdin.yml
"files": [
  {
    "source": "/l10n/en-US.yml",
    "translation": "/l10n/%locale%.yml"
  },
]
```


## Further Reading

The PowerShell docs continue to be a great resource to learn about this.

- [Import-LocalizedData] Learn Docs
- [Import-PowerShellDataFile] Learn Docs
- [about_Data_Files] Learn Docs
- [Psake translation project on Crowdin]

[Import-PowerShellDataFile]: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-powershelldatafile
[about_Data_Files]: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_data_files
[Import-LocalizedData]: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-localizeddata
[PowerShell Localization]: https://marketplace.visualstudio.com/items?itemName=PSInclusive.powershelllocalization
[Crowdin]: https://crowdin.com
[Psake translation project on Crowdin]: https://crowdin.com/project/psake
