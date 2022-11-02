$importedList = Get-Content -Path './trash-users-2022-10-20.csv'
$userResults = @()

foreach($object in $importedList)
{
    $username = $object.Split(",")[0]
    $type = ''

    try {
        $dname = Get-ADUser $username | Select-Object DistinguishedName | Out-String
        foreach($item in $dname.Split(','))
        {
            if($item -like "OU*"){
                $type += $item + ', '
            }
        }
    }
    catch {
        $type = 'NA'
    }
    $userResults += [PSCustomObject]@{
        Username = $username
        Type = $type
    }
}

$userResults | Export-Csv UserTypes.csv -NoTypeInformation