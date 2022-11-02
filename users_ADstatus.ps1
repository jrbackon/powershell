$importedList = Get-Content -Path './test.txt'
$userResults = @()

foreach($object in $importedList)
{
    $username = $object.Split(",")[0]

    try {
        $userEnabled =  Get-ADUser $username -Properties AccountExpirationDate | Select-Object AccountExpirationDate -ExpandProperty "AccountExpirationDate"
        if($userEnabled -ne $null){
        Write-Host('User is disabled')
        $exists = $true
        $enabled = $false
        }
        else 
        {
        Write-Host('User is enabled')
        $exists = $true
        $enabled = $true
        }
    }
    catch {
        Write-Host('No user found in AD')
        $exists = $false
        $enabled = $false
    }
    
    
    $userResults += [PSCustomObject]@{
        Account = $username
        Exists = $exists
        Enabled = $enabled
    }
}

$userResults | Export-Csv UserResults.csv -NoTypeInformation

