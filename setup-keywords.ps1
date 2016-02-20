[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string]$projectPath,
   [Parameter(Mandatory=$True)]
   [string]$fileExtensions,
)

$webclient  =New-Object System.Net.WebClient
$files =@(
    https://raw.githubusercontent.com/barbatchov/powershell-git-keywords/master/rcs.smudge.ps1
    https://raw.githubusercontent.com/barbatchov/powershell-git-keywords/master/rcs.clean.ps1
)
$gitConfig  ="$projectPath\.git\config"
$gitKeywords="$projectPath\.gitkeywords"
$gitAttributes="$projectPath\.gitattributes"

New-Item -ItemType Directory -Force -Path $gitKeywords

$files | ForEach-Object {
    $client.DownloadFile( $_, $gitKeywords )
}

$template=@"[filter `"rcs-keywords`"]
    smudge= .gitkeywords/rcs.smudge.ps1
    clean = .gitkeywords/rcs.clean.ps1
"@

if ( Test-Path $gitAttributes -eq $False ) {
    Set-Content -Path $gitAttributes -value ""
}

$fileExtensions.Split(",") | ForEach-Object {
    Write-Host "$_" >> $gitAttributes
}

Write-Host $template >> $gitConfig