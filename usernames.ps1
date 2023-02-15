$importedList = Get-Content -Path './ITUsers.txt'
$usernames = @()

foreach($name in $importedList){
    # parse first name and last name from list
    $fname = $name.Split(",")[1].trim()
    $lname = $name.Split(",")[0].trim()
    
    # Get the username of the person from AD
    $name = Get-ADUser -Filter {GivenName -eq $fname -and Surname -eq $lname} | Select Name
    $sname = Out-String -InputObject $name
    $username = $sname.Split([Environment]::NewLine)[6].trim()

    $usernames += [PSCustomObject]@{
        Username = $username
    }
}

$usernames | Out-File usernames.txt