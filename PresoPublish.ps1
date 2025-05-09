$presos = Get-ChildItem -Directory .\content\presentations
$outputFolder = Join-Path -Path $PSScriptRoot -ChildPath "static" -Resolve
$presos | ForEach-Object {
  #Action that will run in Parallel. Reference the current object via $PSItem and bring in outside variables with $USING:varname
  # Grab the preso file in the dir
  $markdown = Get-ChildItem $_ -Filter *.md
  $name = $_.BaseName
  $markdown
  # Create the feature image
  npx @marp-team/marp-cli@latest $markdown.FullName -o  (Join-Path -Path $_ -ChildPath "feature.png")
  # Get the Preso HTML
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path -Path $outputFolder -ChildPath "$($name).html") --allow-local-files
  # Get the Preso PDF
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path -Path $outputFolder -ChildPath "$($name).pdf") --allow-local-files
  # Get the Preso PPTX
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path -Path $outputFolder -ChildPath "$($name).pptx") --allow-local-files 
}
