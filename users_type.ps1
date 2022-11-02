$importedList = Get-Content -Path './test.txt'
$userResults = @()

foreach($object in $importedList)
{
    $username = $object.Split(",")[0]

    try {
        Get-ADUser $username | Select-Object DistinguishedName
    }
    catch {
        $type = 'NA'
    }
    $userResults += [PSCustomObject]@{
        Type = $type
    }
}