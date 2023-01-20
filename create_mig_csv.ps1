$importedList = Get-Content -Path './test.txt'
$migrations = @()

foreach($name in $importedList){
    $fname = $name.Split(" ")[0]
    $lname = $name.Split(" ")[1]

    $name = Get-ADUser -Filter {GivenName -eq $fname -and Surname -eq $lname} | Select Name
    $sname = Out-String -InputObject $name
    $username = $sname.Split([Environment]::NewLine)[6]

    $mail = Get-ADUser -Filter {GivenName -eq $fname -and Surname -eq $lname} | Select UserPrincipalName
    $smail = Out-String -InputObject $mail
    $email = $smail.Split([Environment]::NewLine)[6]

    $FSPath = "\\Fileshare2\Staff-FacultyFiles\$username"
    $ODEMail = $email

    $migrations += [PSCustomObject]@{
        FileSharePath = $FSPath
        ColB = ""
        ColC = ""
        OneDriveEMail = $ODEMail
        DocumentLibrary = "Documents"
        SubFolderName = "UDrive"
    } 
}

$migrations | Export-Csv netdrive_migration.csv -NoTypeInformation