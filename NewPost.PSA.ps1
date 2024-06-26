# Any *.PSA.ps1 file will be run when PSA runs.

# A good thing to do at the start of this file is to connect.

Connect-BlueSky

# If $env:AT_PROTOCOL_HANDLE or $env:AT_PROTOCOL_EMAIL is set, it will be treated as the username
# If $env:AT_PROTOCOL_APP_PASSWORD is set, it will be treated as the App Password.
# _Never_ use your actual BlueSky password

# Once we're connected, we can do anything our app password allows.

# However, you _might_ want to output some information first, so that you can see you're connected.

Get-BskyActorProfile -Actor $env:AT_PROTOCOL_HANDLE -Cache | Out-Host

# To ensure you're not going to send a skeet on every checkin, it's a good idea to ask what GitHub is up to

# There will be a variable, $GitHubEvent, that contains information about the event.


$psaModule = Get-Module PSA

$title = @('';$latest.title; $latest.Description) -join [Environment]::NewLine
$send = @{
  Text = { "PSA: $title" }
  WebCard = { @{uri=$latest.link} }
  LinkPattern = { @{
      $latest.Title=$latest.Link;
      PSA='https://github.com/StartAutomating/PSA'
  }}
}
Send-AtProto @send
return
