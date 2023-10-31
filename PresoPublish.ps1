$presos = Get-ChildItem -Directory .\content\presentations
$presos | ForEach-Object -ThrottleLimit 5 -Parallel {
  #Action that will run in Parallel. Reference the current object via $PSItem and bring in outside variables with $USING:varname
  # Grab the preso file in the dir
  $markdown = Get-ChildItem $_ -Filter *.md
  $name = $_.BaseName
  
  # Get the Preso HTML
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path $_ -ChildPath "$($name).html") --allow-local-files
  # Get the Preso PDF
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path $_ -ChildPath "$($name).pdf") --allow-local-files
  # Get the Preso PPTX
  npx @marp-team/marp-cli@latest $markdown.FullName -o (Join-Path $_ -ChildPath "$($name).pptx") --allow-local-files 
}