$importedList = Get-Content -Path './test.txt'
$migrations = @()

foreach($username in $importedList){

    $FSPath = "\\Fileshare2\Staff-FacultyFiles\$username"
    $ODEMail = "$username@babson.edu"

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