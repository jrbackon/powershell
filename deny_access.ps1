# import the list of IT Users
$importedList = Get-Content -Path './ITSD.txt'

foreach($username in $importedList){
    # append the username to the U: drive fileshare path
    $path = "\\Fileshare2\Staff-FacultyFiles\$username"

    # getting the acl for the given fileshare
    $acl = Get-Acl $path

    # finding all ACEs where the user is directly referenced
    $accessRule = $acl.Access | Where-Object {($_.IdentityReference -eq "BABSON\$username") -and -not ($_.IsInherited)}

    if ($accessRule){
        # removing the ACEs from above
        $acl.RemoveAccessRule($accessRule)

        # Set the new acl for the U: drive folder
        Set-Acl $path -AclObject $acl
        Write-Host "Access rule for $username has been removed."
        
    } else {
        Write-Host "Access rule for $username not found."
    }
}
