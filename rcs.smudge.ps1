param([string]$inputFile)

$gitLog=git log --pretty=format:'%H|%aN|%aE|%aD' -- $inputFile
$gitLogArray=$gitLog.Split("|")

$gitLog.Split("|").GetEnumerator() | ForEach-Object {
    $line = $_ 
    Write-Host $line
}

$gitFile=$inputFile -replace "(?:.*\\)+(.*?)`$", "`$1"
$gitSource=$inputFile -replace "(.*\\)+.*?`$", "`$1"
$gitHash=$gitLogArray[0]
$gitAuthor=$gitLogArray[1]
$gitEmail=$gitLogArray[2]
$gitDate=$gitLogArray[3]

$lookupTable       = @{
"[`$]Id[`$]"       = "`$Id $gitFile | $gitDate`$"
"[`$]Date[`$]"     = "`$Date $gitDate`$"
"[`$]Author[`$]"   = "`$Author $gitAuthor <$gitEmail>`$"
"[`$]Source[`$]"   = "`$Source $gitSource`$"
"[`$]File[`$]"     = "`$File $gitFile`$"
"[`$]Revision[`$]" = "`$Revision $gitHash`$"
}

$original_file    = $inputFile
$destination_file = "tmpfile"

Get-Content -Path $original_file | ForEach-Object { 
    $line = $_
    $lookupTable.GetEnumerator() | ForEach-Object {
        if ($line -match $_.Key)
        {
            $line = $line -replace $_.Key, $_.Value
        }
    }
   $line
} | Set-Content -Path $destination_file

CAT $destination_file > $original_file

Remove-Item $destination_file -force