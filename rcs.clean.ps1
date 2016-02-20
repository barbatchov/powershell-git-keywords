param([string]$inputFile)

Write-Host "`$inputFile is $inputFile"
$lookupTable          = @{
"[`$]Id.*?[`$]"       = "`$Id`$"
"[`$]Date.*?[`$]"     = "`$Date`$"
"[`$]Author.*?[`$]"   = "`$Author`$"
"[`$]Source.*?[`$]"   = "`$Source`$"
"[`$]File.*?[`$]"     = "`$File`$"
"[`$]Revision.*?[`$]" = "`$Revision`$"
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