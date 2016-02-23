[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$projectPath,
    [Parameter(Mandatory=$True)]
    [string]$fileExtensions
)

PROCESS {
    New-Item -ItemType Directory -Force -Path $gitKeywords

    Write-Host "[1] - Setting up for $projectPath and files with $fileExtensions"
        [string]  $template         ="[filter `"rcs-keywords`"]
    smudge= .gitkeywords/rcs.smudge.ps1
    clean = .gitkeywords/rcs.clean.ps1
"
        [string]  $gitConfig        ="$projectPath\.git\config"
        [string]  $gitKeywords      ="$projectPath\.gitkeywords"
        [string]  $gitAttributes    ="$projectPath\.gitattributes"
        [string]  $gitAttributesFile=Get-Content $gitAttributes
        [string[]]$files            =@(
            "https://raw.githubusercontent.com/barbatchov/powershell-git-keywords/master/rcs.smudge.ps1"
            "https://raw.githubusercontent.com/barbatchov/powershell-git-keywords/master/rcs.clean.ps1"
        )

    Write-Host "[2] - Downloading files..."

    $files | ForEach-Object {
        [string]$filename=$_ -replace "^(.*?/)+", ""
        [string]$location="$gitKeywords\$filename"

        Write-Host "[-] - $_ to $location"
            [System.Net.WebRequest] $webRequest = [System.Net.WebRequest]::Create($_);
            [System.Net.WebResponse]$response   = $webRequest.GetResponse();
            [System.IO.Stream]      $stream     = $response.GetResponseStream();
            [System.IO.StreamReader]$reader     = New-Object System.IO.StreamReader -argumentList $stream;
            $reader.ReadToEnd() > $location
    }

    [string]$config = Get-Content -Path $gitConfig
    if ( $config -match "rcs-keywords" -eq $True ) {
        Write-Host "[3] - Already configured..."
    } else {
        Write-Host "[3] - Writing configuration..."
        Write-Host $template >> $gitConfig
    }

    Write-Host "[4] - Writing git attributes."
        if ( -not ( Test-Path $gitAttributes ) ) {
            Write-Host "[-] - Creating new git attributes."
            Set-Content -Path $gitAttributes -value ""
        }

        $fileExtensions.Split("-") | ForEach-Object {
            [string]$ext    = $_
            [bool]  $exists = $gitAttributesFile -match "\*\.$ext filter\=rcs-keywords" 
            Write-Host "[-] - $ext - $exists"
            if ( -not ( $exists ) ) {
                Write-Host "[-] - Writing $_ to $gitAttributes."
                Add-Content $gitAttributes "*.$_ filter=rcs-keywords"
            }
        }

    Write-Host "[5] - Done"
}