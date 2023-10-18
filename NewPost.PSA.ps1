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

# A fairly common scenario is to perform an annoucement whenever a PR is merged.

$isMergeToMain = 
    ($gitHubEvent.head_commit.message -match "Merge Pull Request #(?<PRNumber>\d+)") -and 
    $gitHubEvent.ref -eq 'refs/heads/main'

# Diff HEAD with the previous commit
$diff = git diff --name-only HEAD^ HEAD

# Check if a file under content/ or with the .md extension has changed (added, modified, deleted)
$SourceDiff = $diff | Where-Object { $_ -match '^content/' -or $_ -match '.md$' }
$HasDiff = $SourceDiff.Length -gt 0

if ($isMergeToMain && $HasDiff) {
    $psaModule = Get-Module PSA
    $latest = Invoke-RestMethod "https://gilbertsanchez.com/index.xml" | Select-Object -First 1
    $title = @('';$latest.title; $latest.Description) -join [Environment]::NewLine
    $send = @{
        Text = { "PSA: $title" }
        WebCard = { @{uri=$_.link} }
        LinkPattern = { @{
            $_.Title= $_.Link;
            PSA='https://github.com/StartAutomating/PSA'
        }} 
    }
    Send-AtProto @send
    return
}