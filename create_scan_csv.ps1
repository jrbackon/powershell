$importedList = Get-Content -Path './college_marketing.txt'
$scans = @()

foreach($username in $importedList){

    $FSPath = "\\Fileshare2\Staff-FacultyFiles\$username"

    $scans += [PSCustomObject]@{
        FileSharePath = $FSPath
    } 
}

$scans | Export-Csv netdrive_scanlist.csv -NoTypeInformation