# import the list of IT Users
$importedList = Get-Content -Path './ITUsers.txt'

foreach($name in $importedList){
    # parse first name and last name from list
    $fname = $name.Split(",")[1].trim()
    $lname = $name.Split(",")[0].trim()
    
    # Get the username of the person from AD
    $name = Get-ADUser -Filter {GivenName -eq $fname -and Surname -eq $lname} | Select Name
    $sname = Out-String -InputObject $name
    $username = $sname.Split([Environment]::NewLine)[6].trim()

    # append the username to the U: drive fileshare path
    $path = "\\Fileshare2\Staff-FacultyFiles\$username"

    #Create the new access control entry
    $ACE = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Deny')
    # Pull the existing ACL and add the new 'deny everyone' entry
    $Acl = Get-Acl -Path $path
    $Acl.AddAccessRule($ACE)

    # Set the new acl for the U: drive folder
    Set-Acl -Path $path -AclObject $Acl
}