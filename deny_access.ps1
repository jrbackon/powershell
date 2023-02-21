# import the list of IT Users
$importedList = Get-Content -Path './college_marketing.txt'
$log = @()

foreach($username in $importedList){
    # append the username to the U: drive fileshare path
    $path = "\\Fileshare2\Staff-FacultyFiles\$username"

    # getting the acl for the given fileshare
    $acl = Get-Acl $path

    # storing the ACL for the user share in preparation for looping
    $accessRules = $acl.Access

    $flag = "False"
    foreach ($accessRule in $accessRules){
        if ($accessRule.IdentityReference -eq "BABSON\$username"){
            # removing the ACEs from above
            $acl.RemoveAccessRule($accessRule)
            
            # Set the new acl for the U: drive folder
            Set-Acl $path -AclObject $acl
            $flag = "True"
        }
    }

    if ($flag -eq "True"){
        Write-Output "Access for $username has been removed from the U: drive."
        $result = "Access has been removed from the U: drive."
    }
    else {
        Write-Output "No permissions for $username to remove."
        $result = "No permissions to remove."
    }

    $log += [PSCustomObject]@{
        user = $username
        result = $result
    }       
}

$log | Export-Csv UDrive_changelog.csv -NoTypeInformation