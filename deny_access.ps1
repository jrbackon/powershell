# import the list of IT Users
$importedList = Get-Content -Path './usernames.txt'
$log = @()

foreach($username in $importedList){
    # append the username to the U: drive fileshare path
    $path = "\\Fileshare2\Staff-FacultyFiles\$username"

    # getting the acl for the given fileshare
    $Acl = Get-Acl -Path $path
    # get the length of the ACL before modifying
    $length = $Acl.length
    # finding all ACEs where the user is directly referenced
    $Ace = $Acl.Access | Where-Object {($_.IdentityReference -eq "BABSON\$username") -and -not ($_.IsInherited)}
    Write-Output "Removing permissions for $username."
    # removing the ACEs from above
    $Acl.RemoveAccessRule($Ace)

    # Set the new acl for the U: drive folder
    Set-Acl -Path $path -AclObject $Acl
    # check the length of the new ACL and make sure if it smaller
    if $Acl.length < $length {
        Write-Output "Permissions for $username successfully changed."
        $problem = "False"
    }
    else {
        Write-Output "There was a problem. Please check permissions for $username."
        $problem = "True"
    }
    
    $log += [PSCustomObject]@{
        user = $username
        problem = $problem
        acl = $acl
    }
}

$log | Export-Csv UDrive_changelog.csv -NoTypeInformation